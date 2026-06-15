import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:vivocure/core/db/app_database.dart';
import 'package:vivocure/core/network/api_client.dart';
import 'package:vivocure/core/network/network_response.dart';
import 'package:vivocure/core/sync/outbox_service.dart';
import 'package:vivocure/core/sync/row_mappers.dart';

/// Device → server sync: drains the outbox in batches and applies per-op
/// results (ack / replay / conflict-adopt / reject-park) locally.
class PushService {
  PushService(this._db, this._api, this._outbox);

  final AppDatabase _db;
  final ApiClient _api;
  final OutboxService _outbox;

  /// Pushes until the outbox has no pending ops. Returns ops acked.
  Future<int> pushAll({int batchSize = 100}) async {
    await _outbox.recoverInflight();
    int acked = 0;
    while (true) {
      final List<OutboxOp> batch = await _outbox.nextBatch(limit: batchSize);
      if (batch.isEmpty) {
        return acked;
      }
      await _outbox.markInflight(batch);

      final String deviceId = await _db.deviceId();
      NetworkResponse<dynamic> response;
      try {
        response = await _api.post(
          '/sync/push',
          body: <String, dynamic>{
            'device_id': deviceId,
            'ops': batch
                .map(
                  (op) => <String, dynamic>{
                    'mutation_id': op.mutationId,
                    'entity': op.entity,
                    'entity_id': op.entityId,
                    'op': op.op,
                    'payload': jsonDecode(op.payloadJson),
                    'base_server_udt': op.baseServerUdt,
                    'client_changed_at': op.clientChangedAt,
                  },
                )
                .toList(),
          },
        );
      } catch (error) {
        // Transport failure: whole batch goes back to pending for retry.
        for (final OutboxOp op in batch) {
          await _outbox.markFailed(op, error.toString());
        }
        rethrow;
      }

      final Map<String, dynamic> data =
          (response.data as Map<String, dynamic>)['data']
              as Map<String, dynamic>;
      final List<dynamic> results =
          data['results'] as List<dynamic>? ?? <dynamic>[];
      final Map<String, Map<String, dynamic>> byMutation =
          <String, Map<String, dynamic>>{
            for (final dynamic r in results)
              (r as Map<String, dynamic>)['mutation_id'] as String: r,
          };

      for (final OutboxOp op in batch) {
        final Map<String, dynamic>? result = byMutation[op.mutationId];
        if (result == null) {
          await _outbox.markFailed(op, 'missing result in push response');
          continue;
        }
        await _applyResult(op, result);
        if (result['status'] == 'applied') {
          acked++;
        }
      }
    }
  }

  Future<void> _applyResult(OutboxOp op, Map<String, dynamic> result) async {
    final String status = (result['status'] ?? '') as String;
    final Map<String, dynamic>? serverRow =
        result['server_row'] as Map<String, dynamic>?;

    await _db.transaction(() async {
      switch (status) {
        case 'applied':
          if (serverRow != null) {
            // Adopt server truth: assigned business code, server udt, etc.
            await _upsertServerRow(op.entity, serverRow);
          }
          await _outbox.markDone(op.seq);
        case 'conflict':
          // Another device already owns this record (duplicate entity).
          // Adopt the surviving server row, drop our local duplicate, and
          // surface it in the conflict inbox.
          if (serverRow != null) {
            await _adoptSurvivor(op, serverRow);
          }
          await _recordConflict(op, result);
          await _outbox.markDone(op.seq);
        case 'rejected':
          await _recordConflict(op, result);
          await _outbox.markConflict(
            op.seq,
            (result['reason'] ?? 'rejected') as String,
          );
        default:
          await _outbox.markFailed(op, 'unknown status: $status');
      }
    });
  }

  Future<void> _upsertServerRow(String entity, Map<String, dynamic> row) async {
    switch (entity) {
      case 'doctors':
        await _db
            .into(_db.doctors)
            .insertOnConflictUpdate(doctorCompanion(row));
      case 'chemists':
        await _db
            .into(_db.chemists)
            .insertOnConflictUpdate(chemistCompanion(row));
      case 'daily_plan':
        await _db
            .into(_db.dailyPlans)
            .insertOnConflictUpdate(planCompanion(row));
      case 'dcr':
        await _db.into(_db.dcrs).insertOnConflictUpdate(dcrCompanion(row));
      default:
        debugPrint('[SYNC] Unexpected push entity: $entity');
    }
  }

  /// Replace the local (losing) record with the surviving server row and
  /// re-parent any local children/queued ops that referenced the loser.
  Future<void> _adoptSurvivor(
    OutboxOp op,
    Map<String, dynamic> survivor,
  ) async {
    final String loserId = op.entityId;
    final String survivorId = survivor['id'] as String;

    await _upsertServerRow(op.entity, survivor);
    if (loserId == survivorId) {
      return;
    }

    switch (op.entity) {
      case 'dcr':
        await (_db.delete(_db.dcrs)..where((t) => t.id.equals(loserId))).go();
      case 'daily_plan':
        await (_db.delete(
          _db.dailyPlans,
        )..where((t) => t.id.equals(loserId))).go();
        // Local DCRs that pointed at the losing plan move to the survivor.
        await (_db.update(_db.dcrs)..where((t) => t.planId.equals(loserId)))
            .write(DcrsCompanion(planId: Value(survivorId)));
        // Queued ops carrying the losing plan id are rewritten in place.
        final List<OutboxOp> queued = await (_db.select(
          _db.outboxOps,
        )..where((t) => t.state.isIn(const ['pending', 'conflict']))).get();
        for (final OutboxOp q in queued) {
          if (!q.payloadJson.contains(loserId)) continue;
          await (_db.update(
            _db.outboxOps,
          )..where((t) => t.seq.equals(q.seq))).write(
            OutboxOpsCompanion(
              payloadJson: Value(q.payloadJson.replaceAll(loserId, survivorId)),
            ),
          );
        }
      case 'doctors':
        await (_db.delete(
          _db.doctors,
        )..where((t) => t.id.equals(loserId))).go();
      case 'chemists':
        await (_db.delete(
          _db.chemists,
        )..where((t) => t.id.equals(loserId))).go();
    }
  }

  Future<void> _recordConflict(OutboxOp op, Map<String, dynamic> result) async {
    await _db
        .into(_db.syncConflicts)
        .insertOnConflictUpdate(
          SyncConflict(
            mutationId: op.mutationId,
            entity: op.entity,
            entityId: op.entityId,
            reason: result['reason'] as String?,
            clientPayloadJson: op.payloadJson,
            serverRowJson: result['server_row'] == null
                ? null
                : jsonEncode(result['server_row']),
            createdAt: DateTime.now().toUtc().toIso8601String(),
            resolved: false,
          ),
        );
  }
}
