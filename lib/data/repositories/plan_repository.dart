import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'package:vivocure/core/db/app_database.dart';
import 'package:vivocure/core/sync/outbox_service.dart';
import 'package:vivocure/data/repositories/sync_triggers.dart';

class PlanCounts {
  const PlanCounts({
    required this.total,
    required this.doctors,
    required this.chemists,
  });

  final int total;
  final int doctors;
  final int chemists;
}

/// Local-first daily-plan data access.
class PlanRepository {
  PlanRepository(this._db) : _outbox = OutboxService(_db);

  final AppDatabase _db;
  final OutboxService _outbox;

  static String dateKey(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';

  Future<List<DailyPlan>> plansForDate(DateTime date) =>
      (_db.select(_db.dailyPlans)
            ..where((t) =>
                t.visitDate.equals(dateKey(date)) & t.isEnabled.equals(true))
            ..orderBy([(t) => OrderingTerm.asc(t.cdt)]))
          .get();

  Stream<List<DailyPlan>> watchPlansForDate(DateTime date) =>
      (_db.select(_db.dailyPlans)
            ..where((t) =>
                t.visitDate.equals(dateKey(date)) & t.isEnabled.equals(true))
            ..orderBy([(t) => OrderingTerm.asc(t.cdt)]))
          .watch();

  Future<DailyPlan?> getById(String id) =>
      (_db.select(_db.dailyPlans)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<PlanCounts> todayPlanCounts() async {
    final List<DailyPlan> plans = await plansForDate(DateTime.now());
    final int doctors =
        plans.where((p) => p.customerType == 'doctor').length;
    final int chemists =
        plans.where((p) => p.customerType == 'chemist').length;
    return PlanCounts(
        total: plans.length, doctors: doctors, chemists: chemists);
  }

  /// Bulk create (mirrors POST /plans). Skips entries that already have an
  /// enabled plan for the same (date, customer) — same rule the server
  /// enforces with its unique index. Returns ids of created plans.
  Future<List<String>> createPlans({
    required DateTime visitDate,
    required List<({String customerId, String customerType})> customers,
  }) async {
    final String day = dateKey(visitDate);
    final String now = DateTime.now().toUtc().toIso8601String();
    final List<String> created = <String>[];
    await _db.transaction(() async {
      for (final customer in customers) {
        final DailyPlan? duplicate = await (_db.select(_db.dailyPlans)
              ..where((t) =>
                  t.visitDate.equals(day) &
                  t.customerId.equals(customer.customerId) &
                  t.customerType.equals(customer.customerType) &
                  t.isEnabled.equals(true)))
            .getSingleOrNull();
        if (duplicate != null) {
          continue;
        }
        final String id = const Uuid().v7();
        await _db.into(_db.dailyPlans).insert(DailyPlansCompanion.insert(
              id: id,
              visitDate: day,
              customerId: customer.customerId,
              customerType: Value(customer.customerType),
              visitStatus: const Value(1),
              cdt: Value(now),
              localStatus: const Value('pending_create'),
              locallyChangedAt: Value(now),
            ));
        await _outbox.enqueue(
          entity: 'daily_plan',
          entityId: id,
          op: 'create',
          payload: <String, dynamic>{
            'visit_date': day,
            'customer_type': customer.customerType,
            'customer_id': customer.customerId,
            'visit_status': 1,
          },
        );
        created.add(id);
      }
    });
    if (created.isNotEmpty) {
      SyncTriggers.mutated();
    }
    return created;
  }

  Future<void> markPlanStatus(String id, int visitStatus) async {
    final DailyPlan? existing = await getById(id);
    if (existing == null) {
      return;
    }
    await _db.transaction(() async {
      await (_db.update(_db.dailyPlans)..where((t) => t.id.equals(id)))
          .write(DailyPlansCompanion(
        visitStatus: Value(visitStatus),
        localStatus: Value(existing.localStatus == 'pending_create'
            ? 'pending_create'
            : 'pending_update'),
        locallyChangedAt:
            Value(DateTime.now().toUtc().toIso8601String()),
      ));
      await _outbox.enqueue(
        entity: 'daily_plan',
        entityId: id,
        op: existing.localStatus == 'pending_create' ? 'create' : 'update',
        payload: <String, dynamic>{
          'visit_date': existing.visitDate,
          'customer_type': existing.customerType,
          'customer_id': existing.customerId,
          'visit_status': visitStatus,
        },
        baseServerUdt: existing.serverUdt,
      );
    });
    SyncTriggers.mutated();
  }

  Future<void> deletePlan(String id) async {
    final DailyPlan? existing = await getById(id);
    if (existing == null) {
      return;
    }
    await _db.transaction(() async {
      await (_db.update(_db.dailyPlans)..where((t) => t.id.equals(id)))
          .write(const DailyPlansCompanion(
        isEnabled: Value(false),
        status: Value('deleted'),
        localStatus: Value('pending_delete'),
      ));
      await _outbox.enqueue(
        entity: 'daily_plan',
        entityId: id,
        op: 'delete',
        payload: const <String, dynamic>{},
        baseServerUdt: existing.serverUdt,
      );
      if (existing.localStatus == 'pending_create') {
        await (_db.delete(_db.dailyPlans)..where((t) => t.id.equals(id)))
            .go();
      }
    });
    SyncTriggers.mutated();
  }
}
