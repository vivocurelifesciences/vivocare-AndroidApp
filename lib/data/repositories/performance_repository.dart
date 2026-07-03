import 'package:vivocure/core/network/api_client.dart';
import 'package:vivocure/core/network/network_response.dart';
import 'package:vivocure/data/repositories/execution_repository.dart';

/// Plans-created vs DCRs-submitted totals for one year.
class YearlyVisits {
  const YearlyVisits({
    required this.year,
    required this.plansCreated,
    required this.dcrsSubmitted,
  });

  final int year;
  final int plansCreated;
  final int dcrsSubmitted;
}

/// One admin/user's performance series.
class UserPerformance {
  const UserPerformance({
    required this.userId,
    required this.name,
    required this.employeeCode,
    required this.months,
    required this.years,
  });

  final String userId;
  final String name;
  final String employeeCode;
  final List<MonthlyVisits> months; // 12 entries for the requested year
  final List<YearlyVisits> years; // ascending, only years with data

  bool get hasMonthData => months.any(
    (MonthlyVisits m) => m.plansCreated != 0 || m.dcrsSubmitted != 0,
  );
  bool get hasYearData => years.isNotEmpty;
}

/// The whole performance dashboard payload for one requested year.
class PerformanceData {
  const PerformanceData({required this.year, required this.users});

  final int year;
  final List<UserPerformance> users;

  /// Every year any user has activity in (plus [extra]), descending — feeds
  /// the year selector and stays stable because the API always returns the
  /// full year-wise series.
  List<int> availableYears({required int extra}) {
    final Set<int> all = <int>{extra, DateTime.now().year};
    for (final UserPerformance u in users) {
      for (final YearlyVisits y in u.years) {
        all.add(y.year);
      }
    }
    final List<int> sorted = all.toList()..sort((a, b) => b.compareTo(a));
    return sorted;
  }
}

/// Per-user (admin) performance metrics from the backend. Unlike the other
/// analytics this is NOT computable offline — the local database only holds
/// the signed-in rep's own data — so this repository is the one analytics
/// source that needs the network.
class PerformanceRepository {
  PerformanceRepository(this._api);

  final ApiClient _api;

  Future<PerformanceData> load({required int year}) async {
    final NetworkResponse<dynamic> response = await _api.get(
      '/analytics/performance',
      queryParameters: <String, dynamic>{'year': '$year'},
    );

    final dynamic root = response.data;
    final dynamic data = root is Map<String, dynamic> ? root['data'] : null;
    final List<dynamic> rawUsers = data is Map<String, dynamic>
        ? (data['users'] as List<dynamic>? ?? const <dynamic>[])
        : const <dynamic>[];

    final List<UserPerformance> users = <UserPerformance>[];
    for (final dynamic raw in rawUsers) {
      if (raw is! Map<String, dynamic>) continue;
      users.add(
        UserPerformance(
          userId: (raw['user_id'] ?? '').toString(),
          name: (raw['name'] ?? '').toString().trim().isEmpty
              ? 'Unnamed user'
              : (raw['name'] as Object).toString(),
          employeeCode: (raw['employee_code'] ?? '').toString(),
          months: _parseMonths(raw['months']),
          years: _parseYears(raw['years']),
        ),
      );
    }
    return PerformanceData(year: year, users: users);
  }

  static int _asInt(dynamic v) => v is num ? v.toInt() : 0;

  static List<MonthlyVisits> _parseMonths(dynamic raw) {
    final List<MonthlyVisits> months = List<MonthlyVisits>.generate(
      12,
      (int i) =>
          MonthlyVisits(month: i + 1, plansCreated: 0, dcrsSubmitted: 0),
    );
    if (raw is! List<dynamic>) {
      return months;
    }
    for (final dynamic item in raw) {
      if (item is! Map<String, dynamic>) continue;
      final int m = _asInt(item['month']);
      if (m < 1 || m > 12) continue;
      months[m - 1] = MonthlyVisits(
        month: m,
        plansCreated: _asInt(item['plans_created']),
        dcrsSubmitted: _asInt(item['dcrs_submitted']),
      );
    }
    return months;
  }

  static List<YearlyVisits> _parseYears(dynamic raw) {
    if (raw is! List<dynamic>) {
      return const <YearlyVisits>[];
    }
    final List<YearlyVisits> years = <YearlyVisits>[];
    for (final dynamic item in raw) {
      if (item is! Map<String, dynamic>) continue;
      final int y = _asInt(item['year']);
      if (y <= 0) continue;
      years.add(
        YearlyVisits(
          year: y,
          plansCreated: _asInt(item['plans_created']),
          dcrsSubmitted: _asInt(item['dcrs_submitted']),
        ),
      );
    }
    years.sort((YearlyVisits a, YearlyVisits b) => a.year.compareTo(b.year));
    return years;
  }
}
