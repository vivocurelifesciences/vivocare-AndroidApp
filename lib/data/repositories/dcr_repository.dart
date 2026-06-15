import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'package:vivocure/core/db/app_database.dart';
import 'package:vivocure/core/presentation/presentation_history_service.dart';
import 'package:vivocure/core/sync/outbox_service.dart';
import 'package:vivocure/data/repositories/sync_triggers.dart';

/// Local-first DCR data access. createDcr mirrors the server-side side
/// effects (plan completed, customer support values updated) so the UI is
/// consistent offline; the server re-applies the same rules on push.
class DcrRepository {
  DcrRepository(this._db)
    : _outbox = OutboxService(_db),
      _history = PresentationHistoryService(_db);

  final AppDatabase _db;
  final OutboxService _outbox;
  final PresentationHistoryService _history;

  PresentationHistoryService get history => _history;

  /// DCRs whose visit falls on [start]..[end], inclusive by calendar date.
  ///
  /// `visit_datetime` is ISO-8601 TEXT and the formats vary ('…T00:00:00'
  /// locally, possibly with millis/timezone from the server), so the bounds
  /// compare against date-only prefixes: any 'yyyy-MM-ddT…' string sorts
  /// after its own 'yyyy-MM-dd' and before the next day's. Comparing against
  /// full DateTime.toIso8601String() values is wrong — '…T00:00:00' sorts
  /// BEFORE '…T00:00:00.000', silently dropping same-day rows.
  Future<List<Dcr>> dcrsBetween({DateTime? start, DateTime? end}) {
    final query = _db.select(_db.dcrs)..where((t) => t.isEnabled.equals(true));
    if (start != null) {
      query.where((t) => t.visitDatetime.isBiggerOrEqualValue(_dateKey(start)));
    }
    if (end != null) {
      final String endExclusive = _dateKey(
        DateTime(end.year, end.month, end.day).add(const Duration(days: 1)),
      );
      query.where((t) => t.visitDatetime.isSmallerThanValue(endExclusive));
    }
    query.orderBy([(t) => OrderingTerm.desc(t.visitDatetime)]);
    return query.get();
  }

  static String _dateKey(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';

  Stream<List<Dcr>> watchAll() =>
      (_db.select(_db.dcrs)
            ..where((t) => t.isEnabled.equals(true))
            ..orderBy([(t) => OrderingTerm.desc(t.visitDatetime)]))
          .watch();

  Future<Dcr?> getById(String id) =>
      (_db.select(_db.dcrs)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<Dcr?> getByPlanId(String planId) =>
      (_db.select(_db.dcrs)
            ..where((t) => t.planId.equals(planId) & t.isEnabled.equals(true)))
          .getSingleOrNull();

  /// Creates a DCR offline. Enforces one-DCR-per-plan locally (the server
  /// guarantees it globally) and applies the same side effects as the online
  /// create: plan → Completed, customer support values updated.
  Future<String> createDcr({
    required String planId,
    double? supportValue,
    double? expectedSupportValue,
    String? remarks,
    List<String> productIds = const <String>[],
  }) async {
    final DailyPlan? plan = await (_db.select(
      _db.dailyPlans,
    )..where((t) => t.id.equals(planId))).getSingleOrNull();
    if (plan == null) {
      throw StateError('Plan not found locally: $planId');
    }
    final Dcr? existing = await getByPlanId(planId);
    if (existing != null) {
      throw StateError('A DCR already exists for this visit');
    }

    final String id = const Uuid().v7();
    final String now = DateTime.now().toUtc().toIso8601String();
    final String visitDatetime = '${plan.visitDate}T00:00:00';
    final String productIdsCsv = productIds.join(',');

    await _db.transaction(() async {
      await _db
          .into(_db.dcrs)
          .insert(
            DcrsCompanion.insert(
              id: id,
              planId: Value(planId),
              visitDatetime: visitDatetime,
              remarks: Value(remarks),
              supportValue: Value(supportValue),
              expectedSupportValue: Value(expectedSupportValue),
              productIds: Value(productIdsCsv),
              cdt: Value(now),
              localStatus: const Value('pending_create'),
              locallyChangedAt: Value(now),
            ),
          );

      // Mirror server-side effects locally.
      await (_db.update(_db.dailyPlans)..where((t) => t.id.equals(planId)))
          .write(const DailyPlansCompanion(visitStatus: Value(2)));
      if (plan.customerType == 'doctor') {
        await (_db.update(
          _db.doctors,
        )..where((t) => t.id.equals(plan.customerId))).write(
          DoctorsCompanion(
            supportValue: Value(supportValue),
            expectedSupportValue: Value(expectedSupportValue),
          ),
        );
      } else if (plan.customerType == 'chemist') {
        await (_db.update(
          _db.chemists,
        )..where((t) => t.id.equals(plan.customerId))).write(
          ChemistsCompanion(
            supportValue: Value(supportValue),
            expectedSupportValue: Value(expectedSupportValue),
          ),
        );
      }

      await _outbox.enqueue(
        entity: 'dcr',
        entityId: id,
        op: 'create',
        payload: <String, dynamic>{
          'plan_id': planId,
          'visit_datetime': visitDatetime,
          'remarks': remarks,
          'support_value': supportValue,
          'expected_support_value': expectedSupportValue,
          'product_ids': productIdsCsv,
        },
      );

      // Permanent association: these products were presented to this customer.
      await _history.recordVisit(
        dcrId: id,
        customerType: plan.customerType,
        customerId: plan.customerId,
        shownAt: visitDatetime,
        productIds: productIds,
      );
    });
    SyncTriggers.mutated();
    return id;
  }

  Future<void> updateDcr(
    String id, {
    String? remarks,
    double? supportValue,
    double? potential,
    double? expectedSupportValue,
    List<String>? productIds,
  }) async {
    final Dcr? existing = await getById(id);
    if (existing == null) {
      throw StateError('DCR not found locally: $id');
    }
    await _db.transaction(() async {
      await (_db.update(_db.dcrs)..where((t) => t.id.equals(id))).write(
        DcrsCompanion(
          remarks: remarks != null ? Value(remarks) : const Value.absent(),
          supportValue: supportValue != null
              ? Value(supportValue)
              : const Value.absent(),
          potential: potential != null
              ? Value(potential)
              : const Value.absent(),
          expectedSupportValue: expectedSupportValue != null
              ? Value(expectedSupportValue)
              : const Value.absent(),
          productIds: productIds != null
              ? Value(productIds.join(','))
              : const Value.absent(),
          localStatus: Value(
            existing.localStatus == 'pending_create'
                ? 'pending_create'
                : 'pending_update',
          ),
          locallyChangedAt: Value(DateTime.now().toUtc().toIso8601String()),
        ),
      );
      final Dcr updated = (await getById(id))!;
      await _outbox.enqueue(
        entity: 'dcr',
        entityId: id,
        op: existing.localStatus == 'pending_create' ? 'create' : 'update',
        payload: <String, dynamic>{
          'plan_id': updated.planId,
          'visit_datetime': updated.visitDatetime,
          'remarks': updated.remarks,
          'support_value': updated.supportValue,
          'potential': updated.potential,
          'expected_support_value': updated.expectedSupportValue,
          'product_ids': updated.productIds,
        },
        baseServerUdt: existing.serverUdt,
      );

      if (productIds != null) {
        final DailyPlan? plan = await (_db.select(
          _db.dailyPlans,
        )..where((t) => t.id.equals(updated.planId ?? ''))).getSingleOrNull();
        if (plan != null) {
          await _history.recordVisit(
            dcrId: id,
            customerType: plan.customerType,
            customerId: plan.customerId,
            shownAt: updated.visitDatetime,
            productIds: productIds,
          );
        }
      }
    });
    SyncTriggers.mutated();
  }

  Future<void> deleteDcr(String id) async {
    final Dcr? existing = await getById(id);
    if (existing == null) {
      return;
    }
    await _db.transaction(() async {
      await (_db.update(_db.dcrs)..where((t) => t.id.equals(id))).write(
        const DcrsCompanion(
          isEnabled: Value(false),
          status: Value('deleted'),
          localStatus: Value('pending_delete'),
        ),
      );
      await _outbox.enqueue(
        entity: 'dcr',
        entityId: id,
        op: 'delete',
        payload: const <String, dynamic>{},
        baseServerUdt: existing.serverUdt,
      );
      if (existing.localStatus == 'pending_create') {
        await (_db.delete(_db.dcrs)..where((t) => t.id.equals(id))).go();
      }
      // A deleted visit no longer counts as "presented".
      await _history.removeVisit(id);
    });
    SyncTriggers.mutated();
  }
}
