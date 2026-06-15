import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:vivocure/core/db/app_database.dart';

/// One past visit on which products were presented to a customer.
class PresentationVisit {
  const PresentationVisit({
    required this.dcrId,
    required this.shownAt,
    required this.productIds,
  });

  final String dcrId;
  final DateTime? shownAt;
  final List<String> productIds;
}

/// Permanent per-customer record of which products were presented and when.
///
/// Source of truth is the local `presentation_records` table: written
/// in-transaction when a DCR is created on this device, backfilled from
/// pulled DCRs after every sync, and never pruned — so the association
/// survives app restarts and any server-side history window.
class PresentationHistoryService {
  PresentationHistoryService(this._db);

  final AppDatabase _db;

  Future<void> recordVisit({
    required String dcrId,
    required String customerType,
    required String customerId,
    required String shownAt,
    required List<String> productIds,
  }) async {
    if (productIds.isEmpty) {
      return;
    }
    await _db
        .into(_db.presentationRecords)
        .insertOnConflictUpdate(
          PresentationRecord(
            id: dcrId,
            customerType: customerType.toLowerCase(),
            customerId: customerId,
            shownAt: shownAt,
            productIdsJson: jsonEncode(productIds),
          ),
        );
  }

  Future<void> removeVisit(String dcrId) => (_db.delete(
    _db.presentationRecords,
  )..where((t) => t.id.equals(dcrId))).go();

  /// Re-derives records from the local DCR mirror (joined to plans for the
  /// customer linkage). Run after each pull so visits recorded on other
  /// devices land here too. Upsert-only for enabled DCRs; DCRs deleted
  /// centrally (tombstones) drop their record.
  Future<void> rebuildFromLocalDcrs() async {
    final List<TypedResult> rows =
        await (_db.select(_db.dcrs).join(<Join>[
              innerJoin(
                _db.dailyPlans,
                _db.dailyPlans.id.equalsExp(_db.dcrs.planId),
              ),
            ])..where(
              _db.dcrs.productIds.isNotNull() &
                  _db.dcrs.productIds.isNotValue(''),
            ))
            .get();

    await _db.batch((Batch batch) {
      for (final TypedResult row in rows) {
        final Dcr dcr = row.readTable(_db.dcrs);
        final DailyPlan plan = row.readTable(_db.dailyPlans);
        if (!dcr.isEnabled) {
          batch.deleteWhere(
            _db.presentationRecords,
            (tbl) => tbl.id.equals(dcr.id),
          );
          continue;
        }
        final List<String> productIds = _csvIds(dcr.productIds);
        if (productIds.isEmpty) {
          continue;
        }
        batch.insert(
          _db.presentationRecords,
          PresentationRecord(
            id: dcr.id,
            customerType: plan.customerType.toLowerCase(),
            customerId: plan.customerId,
            shownAt: dcr.visitDatetime,
            productIdsJson: jsonEncode(productIds),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }

  /// Complete presentation history for a customer, most recent visit first.
  Future<List<PresentationVisit>> historyForCustomer({
    required String customerType,
    required String customerId,
    int limit = 50,
  }) async {
    final List<PresentationRecord> records =
        await (_db.select(_db.presentationRecords)
              ..where(
                (t) =>
                    t.customerType.equals(customerType.toLowerCase()) &
                    t.customerId.equals(customerId),
              )
              ..orderBy([(t) => OrderingTerm.desc(t.shownAt)])
              ..limit(limit))
            .get();
    return records
        .map(
          (PresentationRecord r) => PresentationVisit(
            dcrId: r.id,
            shownAt: DateTime.tryParse(r.shownAt),
            productIds: _jsonIds(r.productIdsJson),
          ),
        )
        .toList(growable: false);
  }

  /// Every product ever presented to this customer, de-duplicated, ordered
  /// by recency (most recently shown first).
  Future<List<String>> allShownProductIds({
    required String customerType,
    required String customerId,
  }) async {
    final List<PresentationVisit> visits = await historyForCustomer(
      customerType: customerType,
      customerId: customerId,
      limit: 500,
    );
    final List<String> ordered = <String>[];
    final Set<String> seen = <String>{};
    for (final PresentationVisit visit in visits) {
      for (final String id in visit.productIds) {
        if (seen.add(id)) {
          ordered.add(id);
        }
      }
    }
    return ordered;
  }

  static List<String> _csvIds(String? csv) => (csv ?? '')
      .split(',')
      .map((String id) => id.trim())
      .where((String id) => id.isNotEmpty)
      .toList(growable: false);

  static List<String> _jsonIds(String json) {
    try {
      return (jsonDecode(json) as List<dynamic>)
          .map((dynamic id) => id.toString())
          .toList(growable: false);
    } catch (_) {
      return const <String>[];
    }
  }
}
