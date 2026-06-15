import 'dart:convert';

import 'package:drift/drift.dart' show OrderingTerm, Value;
import 'package:flutter/material.dart';
import 'package:vivocure/core/app_services.dart';
import 'package:vivocure/core/db/app_database.dart';
import 'package:vivocure/core/widgets/app_page_backdrop.dart';

/// "Changes needing attention": parked outbox ops (rejected by the server or
/// repeatedly failing) and recorded conflict resolutions. The rep can retry
/// or discard parked changes; conflict records can be acknowledged.
class SyncInboxScreen extends StatefulWidget {
  const SyncInboxScreen({super.key});

  @override
  State<SyncInboxScreen> createState() => _SyncInboxScreenState();
}

class _SyncInboxScreenState extends State<SyncInboxScreen> {
  @override
  Widget build(BuildContext context) {
    final AppDatabase db = AppServices.db;
    return Scaffold(
      appBar: AppBar(title: const Text('Sync activity')),
      body: AppPageBackdrop(
        child: SafeArea(
          child: Center(
            // Tablet-friendly reading width.
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: _buildList(db),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildList(AppDatabase db) {
    return ListView(
      children: <Widget>[
        _sectionTitle(context, 'Changes needing attention'),
        StreamBuilder<List<OutboxOp>>(
          stream: AppServices.syncEngine.outbox.watchParked(),
          builder: (context, snapshot) {
            final List<OutboxOp> parked = snapshot.data ?? <OutboxOp>[];
            if (parked.isEmpty) {
              return const ListTile(
                dense: true,
                leading: Icon(Icons.check_circle_outline, color: Colors.green),
                title: Text('Nothing needs your attention'),
              );
            }
            return Column(
              children: parked.map((op) => _parkedTile(op)).toList(),
            );
          },
        ),
        const Divider(),
        _sectionTitle(context, 'Resolved conflicts (log)'),
        StreamBuilder<List<SyncConflict>>(
          stream:
              (db.select(db.syncConflicts)
                    ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
                    ..limit(50))
                  .watch(),
          builder: (context, snapshot) {
            final List<SyncConflict> conflicts =
                snapshot.data ?? <SyncConflict>[];
            if (conflicts.isEmpty) {
              return const ListTile(
                dense: true,
                title: Text('No conflicts recorded'),
              );
            }
            return Column(children: conflicts.map(_conflictTile).toList());
          },
        ),
      ],
    );
  }

  Widget _sectionTitle(BuildContext context, String title) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
    child: Text(title, style: Theme.of(context).textTheme.titleSmall),
  );

  Widget _parkedTile(OutboxOp op) {
    return ListTile(
      dense: true,
      leading: const Icon(Icons.error_outline, color: Colors.orange),
      title: Text('${_entityLabel(op.entity)} — ${op.op}'),
      subtitle: Text(
        op.lastError ?? 'Could not sync',
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
            tooltip: 'Retry',
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              await AppServices.syncEngine.outbox.requeue(op.seq);
              await AppServices.syncEngine.syncNow(reason: 'inbox-retry');
            },
          ),
          IconButton(
            tooltip: 'Discard change',
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _confirmDiscard(op),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDiscard(OutboxOp op) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Discard this change?'),
        content: Text(
          'Your local "${op.op}" on ${_entityLabel(op.entity)} will be '
          'removed and the server version (if any) will be restored on the '
          'next sync. This cannot be undone.',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Keep'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Discard'),
          ),
        ],
      ),
    );
    if (confirmed != true) {
      return;
    }
    await AppServices.syncEngine.outbox.discard(op.seq);
    // Re-mark the local row synced so the next pull restores server truth.
    await _restoreRowFromServer(op);
    await AppServices.syncEngine.syncNow(reason: 'inbox-discard');
  }

  /// Clears the pending flag so the next pull may overwrite the local row
  /// with server state. Offline-created rows that never reached the server
  /// are deleted outright.
  Future<void> _restoreRowFromServer(OutboxOp op) async {
    final AppDatabase db = AppServices.db;
    switch (op.entity) {
      case 'doctors':
        if (op.op == 'create') {
          await (db.delete(
            db.doctors,
          )..where((t) => t.id.equals(op.entityId))).go();
        } else {
          await (db.update(db.doctors)..where((t) => t.id.equals(op.entityId)))
              .write(const DoctorsCompanion(localStatus: Value('synced')));
        }
      case 'chemists':
        if (op.op == 'create') {
          await (db.delete(
            db.chemists,
          )..where((t) => t.id.equals(op.entityId))).go();
        } else {
          await (db.update(db.chemists)..where((t) => t.id.equals(op.entityId)))
              .write(const ChemistsCompanion(localStatus: Value('synced')));
        }
      case 'daily_plan':
        if (op.op == 'create') {
          await (db.delete(
            db.dailyPlans,
          )..where((t) => t.id.equals(op.entityId))).go();
        } else {
          await (db.update(db.dailyPlans)
                ..where((t) => t.id.equals(op.entityId)))
              .write(const DailyPlansCompanion(localStatus: Value('synced')));
        }
      case 'dcr':
        if (op.op == 'create') {
          await (db.delete(
            db.dcrs,
          )..where((t) => t.id.equals(op.entityId))).go();
          // The visit never reached the server — drop its history record too.
          await AppServices.dcrs.history.removeVisit(op.entityId);
        } else {
          await (db.update(db.dcrs)..where((t) => t.id.equals(op.entityId)))
              .write(const DcrsCompanion(localStatus: Value('synced')));
        }
    }
  }

  Widget _conflictTile(SyncConflict conflict) {
    String detail = conflict.reason ?? '';
    if (conflict.serverRowJson != null) {
      try {
        final Map<String, dynamic> row =
            jsonDecode(conflict.serverRowJson!) as Map<String, dynamic>;
        final String? code =
            (row['doctor_code'] ?? row['chemist_code']) as String?;
        if (code != null) {
          detail = '$detail · kept $code';
        }
      } catch (_) {}
    }
    return ListTile(
      dense: true,
      leading: Icon(
        conflict.reason == 'duplicate_entity'
            ? Icons.merge_type
            : Icons.info_outline,
        color: Colors.blueGrey,
      ),
      title: Text(_conflictLabel(conflict)),
      subtitle: Text(detail, maxLines: 2, overflow: TextOverflow.ellipsis),
    );
  }

  String _conflictLabel(SyncConflict conflict) {
    final String entity = _entityLabel(conflict.entity);
    switch (conflict.reason) {
      case 'duplicate_entity':
        return '$entity already existed — server copy kept';
      case 'plan_cancelled':
        return 'Plan was cancelled centrally — change not applied';
      default:
        return '$entity — ${conflict.reason ?? 'resolved'}';
    }
  }

  String _entityLabel(String entity) {
    switch (entity) {
      case 'doctors':
        return 'Doctor';
      case 'chemists':
        return 'Chemist';
      case 'daily_plan':
        return 'Daily plan';
      case 'dcr':
        return 'DCR';
      default:
        return entity;
    }
  }
}
