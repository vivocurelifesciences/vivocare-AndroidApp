import 'package:drift/drift.dart';
import 'package:vivocure/core/db/app_database.dart';

/// Entity scope for execution analytics.
enum ExecEntityType { doctor, chemist }

extension ExecEntityTypeX on ExecEntityType {
  String get dbValue => this == ExecEntityType.doctor ? 'doctor' : 'chemist';
  String get label => this == ExecEntityType.doctor ? 'Doctor' : 'Chemist';
}

/// Core / Non-Core / Super-Core classification filter (doctors only; chemists
/// are uncategorized and always included).
enum ExecCategory { all, core, nonCore, superCore }

extension ExecCategoryX on ExecCategory {
  String get label => switch (this) {
    ExecCategory.all => 'All',
    ExecCategory.core => 'Core',
    ExecCategory.nonCore => 'Non-Core',
    ExecCategory.superCore => 'Super-Core',
  };
}

/// A selectable doctor/chemist for the customer filter.
class ExecCustomer {
  const ExecCustomer({required this.id, required this.name});

  final String id;
  final String name;
}

/// Support vs expected totals for one month.
class MonthlyMetric {
  const MonthlyMetric({
    required this.month,
    required this.supportValue,
    required this.expectedValue,
  });

  final int month; // 1..12
  final double supportValue;
  final double expectedValue;
}

/// Support vs expected totals for one year (year-wise trend graph).
class YearlyMetric {
  const YearlyMetric({
    required this.year,
    required this.supportValue,
    required this.expectedValue,
  });

  final int year;
  final double supportValue;
  final double expectedValue;
}

/// Plans-created vs DCRs-submitted for one month (used by the Performance
/// dashboard's per-user series).
class MonthlyVisits {
  const MonthlyVisits({
    required this.month,
    required this.plansCreated,
    required this.dcrsSubmitted,
  });

  final int month; // 1..12
  final int plansCreated;
  final int dcrsSubmitted;
}

/// Execution performance analytics computed entirely from the local
/// (offline-first) database: support vs expected value, month-wise for a year
/// and year-wise across years, filtered by entity type, category and customer.
class ExecutionRepository {
  ExecutionRepository(this._db);

  final AppDatabase _db;

  /// Years that have plan or DCR activity (descending), always including the
  /// current year so the selector is never empty.
  Future<List<int>> availableYears() async {
    final Set<int> years = <int>{DateTime.now().year};
    for (final DailyPlan p in await _db.select(_db.dailyPlans).get()) {
      final int? y = _yearOf(p.visitDate);
      if (y != null) years.add(y);
    }
    for (final Dcr d in await _db.select(_db.dcrs).get()) {
      final int? y = _yearOf(d.visitDatetime);
      if (y != null) years.add(y);
    }
    final List<int> sorted = years.toList()..sort((a, b) => b.compareTo(a));
    return sorted;
  }

  /// Month-wise Support vs Expected totals (12 entries, Jan..Dec).
  Future<List<MonthlyMetric>> load({
    required ExecEntityType entityType,
    required ExecCategory category,
    required int year,
    String? customerId,
  }) async {
    final String type = entityType.dbValue;
    final String? onlyCustomer = (customerId ?? '').trim().isEmpty
        ? null
        : customerId!.trim();

    // Doctor category lookup (chemists are uncategorized).
    final Map<String, String> doctorCategory = <String, String>{
      for (final Doctor d in await _db.select(_db.doctors).get())
        d.id: (d.category ?? '').trim(),
    };

    bool categoryMatches(String cid) {
      if (category == ExecCategory.all) return true;
      if (entityType == ExecEntityType.chemist) {
        return true; // chemists have no category — never filtered out
      }
      return _doctorMatchesCategory(doctorCategory[cid], category);
    }

    bool included(String cid) =>
        (onlyCustomer == null || cid == onlyCustomer) && categoryMatches(cid);

    // DCRs need their plan for customer type + category linkage.
    final List<DailyPlan> plans =
        await (_db.select(_db.dailyPlans)..where(
              (t) => t.customerType.equals(type) & t.isEnabled.equals(true),
            ))
            .get();
    final Map<String, DailyPlan> planById = <String, DailyPlan>{
      for (final DailyPlan p in plans) p.id: p,
    };
    final List<Dcr> dcrs = await (_db.select(
      _db.dcrs,
    )..where((t) => t.isEnabled.equals(true))).get();

    final List<double> supportPerMonth = List<double>.filled(12, 0);
    final List<double> expectedPerMonth = List<double>.filled(12, 0);
    for (final Dcr d in dcrs) {
      if (_yearOf(d.visitDatetime) != year) continue;
      final DailyPlan? plan = planById[d.planId];
      if (plan == null || plan.customerType != type) continue;
      if (!included(plan.customerId)) continue;
      final int? m = _monthOf(d.visitDatetime);
      if (m == null) continue;
      supportPerMonth[m - 1] += d.supportValue ?? 0;
      expectedPerMonth[m - 1] += d.expectedSupportValue ?? 0;
    }

    return List<MonthlyMetric>.generate(
      12,
      (int i) => MonthlyMetric(
        month: i + 1,
        supportValue: supportPerMonth[i],
        expectedValue: expectedPerMonth[i],
      ),
    );
  }

  /// Year-wise Support vs Expected totals under the same filters, for the
  /// support value trend graph. Ascending years; only years with DCR data.
  Future<List<YearlyMetric>> supportByYears({
    required ExecEntityType entityType,
    required ExecCategory category,
    String? customerId,
  }) async {
    final String type = entityType.dbValue;
    final String? onlyCustomer = (customerId ?? '').trim().isEmpty
        ? null
        : customerId!.trim();

    final Map<String, String> doctorCategory = <String, String>{
      for (final Doctor d in await _db.select(_db.doctors).get())
        d.id: (d.category ?? '').trim(),
    };

    bool included(String cid) {
      if (onlyCustomer != null && cid != onlyCustomer) return false;
      if (category == ExecCategory.all ||
          entityType == ExecEntityType.chemist) {
        return true;
      }
      return _doctorMatchesCategory(doctorCategory[cid], category);
    }

    final List<DailyPlan> plans =
        await (_db.select(_db.dailyPlans)..where(
              (t) => t.customerType.equals(type) & t.isEnabled.equals(true),
            ))
            .get();
    final Map<String, DailyPlan> planById = <String, DailyPlan>{
      for (final DailyPlan p in plans) p.id: p,
    };

    // year -> [support total, expected total]
    final Map<int, List<double>> totals = <int, List<double>>{};
    final List<Dcr> dcrs = await (_db.select(
      _db.dcrs,
    )..where((t) => t.isEnabled.equals(true))).get();
    for (final Dcr d in dcrs) {
      final int? y = _yearOf(d.visitDatetime);
      if (y == null) continue;
      final DailyPlan? plan = planById[d.planId];
      if (plan == null || plan.customerType != type) continue;
      if (!included(plan.customerId)) continue;
      final List<double> t = totals.putIfAbsent(y, () => <double>[0, 0]);
      t[0] += d.supportValue ?? 0;
      t[1] += d.expectedSupportValue ?? 0;
    }

    final List<int> years = totals.keys.toList()..sort();
    return <YearlyMetric>[
      for (final int y in years)
        YearlyMetric(
          year: y,
          supportValue: totals[y]![0],
          expectedValue: totals[y]![1],
        ),
    ];
  }

  /// Doctors/chemists available for the customer selector, filtered by
  /// category (doctors only) and sorted by name.
  Future<List<ExecCustomer>> customersFor({
    required ExecEntityType entityType,
    required ExecCategory category,
  }) async {
    final List<ExecCustomer> list = <ExecCustomer>[];
    if (entityType == ExecEntityType.doctor) {
      final List<Doctor> docs = await (_db.select(
        _db.doctors,
      )..where((t) => t.isEnabled.equals(true))).get();
      for (final Doctor d in docs) {
        if (category != ExecCategory.all &&
            !_doctorMatchesCategory(d.category, category)) {
          continue;
        }
        final String name = <String?>[d.firstName, d.middleName, d.lastName]
            .whereType<String>()
            .where((String s) => s.trim().isNotEmpty)
            .join(' ')
            .trim();
        list.add(
          ExecCustomer(id: d.id, name: name.isEmpty ? 'Unnamed doctor' : name),
        );
      }
    } else {
      final List<Chemist> chems = await (_db.select(
        _db.chemists,
      )..where((t) => t.isEnabled.equals(true))).get();
      for (final Chemist c in chems) {
        list.add(
          ExecCustomer(
            id: c.id,
            name: c.fullName.trim().isEmpty ? 'Unnamed chemist' : c.fullName,
          ),
        );
      }
    }
    list.sort(
      (ExecCustomer a, ExecCustomer b) =>
          a.name.toLowerCase().compareTo(b.name.toLowerCase()),
    );
    return list;
  }

  /// "Core" = Core only, "Super-Core" = Super-Core, "Non-Core" = Non-Core.
  static bool _doctorMatchesCategory(String? rawCategory, ExecCategory category) {
    final String cat = (rawCategory ?? '').toLowerCase();
    return switch (category) {
      ExecCategory.all => true,
      ExecCategory.superCore => cat.contains('super'),
      ExecCategory.nonCore => cat.contains('non'),
      ExecCategory.core =>
        cat.contains('core') && !cat.contains('non') && !cat.contains('super'),
    };
  }

  /// ISO date/datetime strings are 'yyyy-MM-dd...'; parse cheaply.
  static int? _yearOf(String? iso) {
    if (iso == null || iso.length < 4) return null;
    return int.tryParse(iso.substring(0, 4));
  }

  static int? _monthOf(String? iso) {
    if (iso == null || iso.length < 7) return null;
    return int.tryParse(iso.substring(5, 7));
  }
}
