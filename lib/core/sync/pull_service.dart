import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:vivocure/core/db/app_database.dart';
import 'package:vivocure/core/network/api_client.dart';
import 'package:vivocure/core/network/network_response.dart';
import 'package:vivocure/core/sync/row_mappers.dart';

/// Entities pulled from the server, in priority order: operationally
/// important data lands first on slow connections.
const List<String> pullEntities = <String>[
  'daily_plan',
  'dcr',
  'dcr_products',
  'doctors',
  'chemists',
  'products',
  'users',
  'user_roles',
  'doctor_categories',
  'visit_status_master',
  'product_priorities',
  'customer_types',
];

const Set<String> _metadataEntities = <String>{
  'user_roles',
  'doctor_categories',
  'visit_status_master',
  'product_priorities',
  'customer_types',
};

/// Server → device delta sync. Applies pages transactionally and advances a
/// per-entity keyset cursor, so an interrupted pull resumes exactly where it
/// stopped. Tombstones (is_enabled=false) arrive as ordinary row updates.
class PullService {
  PullService(this._db, this._api);

  final AppDatabase _db;
  final ApiClient _api;

  /// Pulls one entity to completion. Returns number of rows applied.
  Future<int> pullEntity(String entity, {int limit = 500}) async {
    int applied = 0;
    while (true) {
      final SyncCursor? cursorRow = await (_db.select(_db.syncCursors)
            ..where((t) => t.entity.equals(entity)))
          .getSingleOrNull();

      final NetworkResponse<dynamic> response =
          await _api.get('/sync/pull', queryParameters: <String, dynamic>{
        'entity': entity,
        'limit': limit,
        if (cursorRow?.cursor != null) 'cursor': cursorRow!.cursor,
      });

      final Map<String, dynamic> data =
          (response.data as Map<String, dynamic>)['data']
              as Map<String, dynamic>;
      final List<dynamic> rows = data['rows'] as List<dynamic>? ?? <dynamic>[];
      final String? nextCursor = data['next_cursor'] as String?;
      final bool hasMore = data['has_more'] as bool? ?? false;

      await _db.transaction(() async {
        for (final dynamic raw in rows) {
          await _applyRow(entity, raw as Map<String, dynamic>);
        }
        await _db.into(_db.syncCursors).insertOnConflictUpdate(SyncCursor(
              entity: entity,
              cursor: nextCursor,
              lastPulledAt: DateTime.now().toUtc().toIso8601String(),
            ));
      });
      applied += rows.length;

      if (!hasMore) {
        return applied;
      }
    }
  }

  /// A pulled row only overwrites a local row that has no pending local edit;
  /// rows with pending_* status are protected — the outbox owns them until
  /// their push is acknowledged (client-wins policy).
  Future<void> _applyRow(String entity, Map<String, dynamic> row) async {
    if (_metadataEntities.contains(entity)) {
      await _applyMetadata(entity, row);
      return;
    }
    final String id = row['id'] as String;
    switch (entity) {
      case 'doctors':
        if (await _hasPendingLocal(entity, id)) return;
        await _db.into(_db.doctors).insertOnConflictUpdate(
              doctorCompanion(row),
            );
      case 'chemists':
        if (await _hasPendingLocal(entity, id)) return;
        await _db.into(_db.chemists).insertOnConflictUpdate(
              chemistCompanion(row),
            );
      case 'products':
        await _db.into(_db.products).insertOnConflictUpdate(
              productCompanion(row),
            );
        await _registerProductMedia(row);
      case 'daily_plan':
        if (await _hasPendingLocal(entity, id)) return;
        await _db.into(_db.dailyPlans).insertOnConflictUpdate(
              planCompanion(row),
            );
      case 'dcr':
        if (await _hasPendingLocal(entity, id)) return;
        await _db.into(_db.dcrs).insertOnConflictUpdate(
              dcrCompanion(row),
            );
      case 'dcr_products':
        await _db.into(_db.dcrProductRows).insertOnConflictUpdate(
              dcrProductCompanion(row),
            );
      case 'users':
        await _db.into(_db.usersLite).insertOnConflictUpdate(UsersLiteCompanion(
              id: Value(row['id'] as String),
              employeeCode: Value(row['employee_code'] as String?),
              fullName: Value(row['full_name'] as String?),
              email: Value(row['email'] as String?),
              phone: Value(row['phone'] as String?),
              roleId: Value(row['role_id'] as String?),
              serverUdt: Value(row['udt'] as String?),
            ));
      default:
        debugPrint('[SYNC] Unknown pull entity: $entity');
    }
  }

  Future<bool> _hasPendingLocal(String entity, String id) async {
    String? localStatus;
    switch (entity) {
      case 'doctors':
        localStatus = (await (_db.select(_db.doctors)
                  ..where((t) => t.id.equals(id)))
                .getSingleOrNull())
            ?.localStatus;
      case 'chemists':
        localStatus = (await (_db.select(_db.chemists)
                  ..where((t) => t.id.equals(id)))
                .getSingleOrNull())
            ?.localStatus;
      case 'daily_plan':
        localStatus = (await (_db.select(_db.dailyPlans)
                  ..where((t) => t.id.equals(id)))
                .getSingleOrNull())
            ?.localStatus;
      case 'dcr':
        localStatus = (await (_db.select(_db.dcrs)
                  ..where((t) => t.id.equals(id)))
                .getSingleOrNull())
            ?.localStatus;
    }
    return localStatus != null && localStatus != 'synced';
  }

  Future<void> _applyMetadata(String kind, Map<String, dynamic> row) async {
    final String name = (row['role_name'] ??
            row['category_name'] ??
            row['status_name'] ??
            row['priority_code'] ??
            row['type_name'] ??
            '')
        .toString();
    await _db.into(_db.metadataItems).insertOnConflictUpdate(MetadataItem(
          kind: kind,
          id: row['id'] as String,
          name: name,
          isEnabled: row['is_enabled'] as bool? ?? true,
          serverUdt: row['udt'] as String?,
        ));
  }

  Future<void> _registerProductMedia(Map<String, dynamic> row) async {
    final dynamic images = row['image_urls'];
    if (images is! List) {
      return;
    }
    for (final dynamic entry in images) {
      if (entry is! Map<String, dynamic>) continue;
      final String? objectKey = entry['object_key'] as String?;
      if (objectKey == null || objectKey.isEmpty) continue;
      final MediaCacheEntry? existing =
          await (_db.select(_db.mediaCacheEntries)
                ..where((t) => t.objectKey.equals(objectKey)))
              .getSingleOrNull();
      if (existing?.state == 'downloaded') {
        continue;
      }
      await _db.into(_db.mediaCacheEntries).insertOnConflictUpdate(
            MediaCacheEntry(
              objectKey: objectKey,
              entity: 'products',
              entityId: row['id'] as String?,
              localPath: existing?.localPath,
              state: 'pending',
              fetchedAt: existing?.fetchedAt,
            ),
          );
    }
  }
}
