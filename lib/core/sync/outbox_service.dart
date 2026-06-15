import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'package:vivocure/core/db/app_database.dart';

/// Records local mutations for later push. MUST be called inside the same
/// transaction as the entity write — that atomicity is the heart of outbox
/// correctness.
class OutboxService {
  OutboxService(this._db);

  final AppDatabase _db;

  /// Enqueue a mutation. For updates to a row that already has a pending op,
  /// the ops coalesce: latest full-row payload wins, earliest baseServerUdt
  /// and the original op kind (create stays create) are kept.
  Future<void> enqueue({
    required String entity,
    required String entityId,
    required String op, // create | update | delete
    required Map<String, dynamic> payload,
    String? baseServerUdt,
  }) async {
    final OutboxOp? pending =
        await (_db.select(_db.outboxOps)..where(
              (t) =>
                  t.entity.equals(entity) &
                  t.entityId.equals(entityId) &
                  t.state.isIn(const ['pending', 'conflict']),
            ))
            .getSingleOrNull();

    final String now = DateTime.now().toUtc().toIso8601String();

    if (pending != null) {
      String mergedOp = pending.op;
      if (op == 'delete') {
        if (pending.op == 'create') {
          // Created offline then deleted offline: nothing to tell the server.
          await (_db.delete(
            _db.outboxOps,
          )..where((t) => t.seq.equals(pending.seq))).go();
          return;
        }
        mergedOp = 'delete';
      }
      await (_db.update(
        _db.outboxOps,
      )..where((t) => t.seq.equals(pending.seq))).write(
        OutboxOpsCompanion(
          op: Value(mergedOp),
          payloadJson: Value(jsonEncode(payload)),
          clientChangedAt: Value(now),
          state: const Value('pending'),
          lastError: const Value(null),
        ),
      );
      return;
    }

    await _db
        .into(_db.outboxOps)
        .insert(
          OutboxOpsCompanion.insert(
            mutationId: const Uuid().v7(),
            entity: entity,
            entityId: entityId,
            op: op,
            payloadJson: jsonEncode(payload),
            baseServerUdt: Value(baseServerUdt),
            clientChangedAt: now,
          ),
        );
  }

  /// Next batch to push, strictly in enqueue order (parents precede children
  /// by construction: a DCR can't exist locally before its plan).
  Future<List<OutboxOp>> nextBatch({int limit = 100}) =>
      (_db.select(_db.outboxOps)
            ..where((t) => t.state.equals('pending'))
            ..orderBy([(t) => OrderingTerm.asc(t.seq)])
            ..limit(limit))
          .get();

  Future<void> markInflight(List<OutboxOp> ops) async {
    if (ops.isEmpty) return;
    await (_db.update(_db.outboxOps)
          ..where((t) => t.seq.isIn(ops.map((o) => o.seq))))
        .write(const OutboxOpsCompanion(state: Value('inflight')));
  }

  /// Reverts stale inflight ops (e.g. app killed mid-push) back to pending.
  /// Safe because the server push log makes re-sends idempotent.
  Future<void> recoverInflight() async {
    await (_db.update(_db.outboxOps)..where((t) => t.state.equals('inflight')))
        .write(const OutboxOpsCompanion(state: Value('pending')));
  }

  Future<void> markDone(int seq) =>
      (_db.delete(_db.outboxOps)..where((t) => t.seq.equals(seq))).go();

  Future<void> markConflict(int seq, String reason) =>
      (_db.update(_db.outboxOps)..where((t) => t.seq.equals(seq))).write(
        OutboxOpsCompanion(
          state: const Value('conflict'),
          lastError: Value(reason),
        ),
      );

  Future<void> markFailed(OutboxOp op, String error) async {
    final int attempts = op.attempts + 1;
    // After repeated failures park the op so it can't block the queue forever.
    final bool park = attempts >= 5;
    await (_db.update(_db.outboxOps)..where((t) => t.seq.equals(op.seq))).write(
      OutboxOpsCompanion(
        attempts: Value(attempts),
        lastError: Value(error),
        state: Value(park ? 'conflict' : 'pending'),
      ),
    );
  }

  /// Re-queue a parked op after the user edits/acknowledges it.
  Future<void> requeue(int seq) =>
      (_db.update(_db.outboxOps)..where((t) => t.seq.equals(seq))).write(
        const OutboxOpsCompanion(
          state: Value('pending'),
          attempts: Value(0),
          lastError: Value(null),
        ),
      );

  Future<void> discard(int seq) => markDone(seq);

  Stream<int> watchPendingCount() {
    final query = _db.selectOnly(_db.outboxOps)
      ..addColumns([_db.outboxOps.seq.count()])
      ..where(_db.outboxOps.state.isIn(const ['pending', 'inflight']));
    return query
        .map((row) => row.read(_db.outboxOps.seq.count()) ?? 0)
        .watchSingle();
  }

  Stream<List<OutboxOp>> watchParked() =>
      (_db.select(_db.outboxOps)
            ..where((t) => t.state.equals('conflict'))
            ..orderBy([(t) => OrderingTerm.asc(t.seq)]))
          .watch();
}
