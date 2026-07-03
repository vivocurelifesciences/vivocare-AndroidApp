import 'package:flutter/material.dart';
import 'package:vivocure/core/app_services.dart';
import 'package:vivocure/core/layout/responsive.dart';
import 'package:vivocure/core/theme/app_colors.dart';
import 'package:vivocure/core/widgets/app_page_backdrop.dart';
import 'package:vivocure/core/widgets/app_panel.dart';
import 'package:vivocure/data/repositories/execution_repository.dart';
import 'package:vivocure/data/repositories/performance_repository.dart';
import 'package:vivocure/features/execution/view/widgets/analytics_charts.dart';

/// Performance dashboard: Plans Created vs DCRs Created for EVERY admin/user,
/// month-wise (for a selected year) and year-wise. Data comes from the server
/// (the local database only holds the signed-in rep's own records), so this
/// screen needs a network connection.
class PerformanceScreen extends StatefulWidget {
  const PerformanceScreen({super.key});

  @override
  State<PerformanceScreen> createState() => _PerformanceScreenState();
}

class _PerformanceScreenState extends State<PerformanceScreen> {
  int _year = DateTime.now().year;
  int _view = 0; // 0 = month-wise, 1 = year-wise

  PerformanceData? _data;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  Future<void> _reload() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final PerformanceData data = await AppServices.performance.load(
        year: _year,
      );
      if (!mounted) {
        return;
      }
      setState(() {
        _data = data;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _loading = false;
        _error =
            'Could not load performance data. This dashboard needs an '
            'internet connection — please check your network and retry.';
      });
    }
  }

  List<int> get _years =>
      _data?.availableYears(extra: _year) ?? <int>[DateTime.now().year];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Performance')),
      body: AppPageBackdrop(
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: <Widget>[
                  _buildHeader(context),
                  const SizedBox(height: 16),
                  if (_loading)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 60),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (_error != null)
                    _buildError(context)
                  else
                    ..._buildUserCharts(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return AppPanel(
      padding: const EdgeInsets.all(20),
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: <Color>[Color(0xFFF8FBFF), Color(0xFFEAF4FF)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Performance',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Plans Created vs DCRs Created for every admin/user, month-wise '
            'and year-wise.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 16,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.end,
            children: <Widget>[
              SegmentedButton<int>(
                segments: const <ButtonSegment<int>>[
                  ButtonSegment<int>(
                    value: 0,
                    label: Text('Month-wise'),
                    icon: Icon(Icons.calendar_view_month_outlined),
                  ),
                  ButtonSegment<int>(
                    value: 1,
                    label: Text('Year-wise'),
                    icon: Icon(Icons.timeline_outlined),
                  ),
                ],
                selected: <int>{_view},
                onSelectionChanged: (Set<int> s) =>
                    setState(() => _view = s.first),
              ),
              if (_view == 0)
                SizedBox(
                  width: context.isMobile ? 130 : 160,
                  child: DropdownButtonFormField<int>(
                    key: ValueKey<String>('perf-year-${_years.join('-')}'),
                    initialValue: _year,
                    isExpanded: true,
                    decoration: const InputDecoration(labelText: 'Year'),
                    items: _years
                        .map(
                          (int y) => DropdownMenuItem<int>(
                            value: y,
                            child: Text('$y'),
                          ),
                        )
                        .toList(growable: false),
                    onChanged: (int? v) {
                      if (v == null) return;
                      setState(() => _year = v);
                      _reload();
                    },
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context) {
    return AppPanel(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Center(
        child: Column(
          children: <Widget>[
            const Icon(
              Icons.cloud_off_outlined,
              size: 44,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 12),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _reload,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildUserCharts(BuildContext context) {
    final PerformanceData data = _data!;
    if (data.users.isEmpty) {
      return const <Widget>[
        EmptyChart(message: 'No users found on the server.'),
      ];
    }
    final List<Widget> panels = <Widget>[];
    for (final UserPerformance user in data.users) {
      panels
        ..add(_UserPerformancePanel(user: user, year: _year, view: _view))
        ..add(const SizedBox(height: 16));
    }
    return panels;
  }
}

class _UserPerformancePanel extends StatelessWidget {
  const _UserPerformancePanel({
    required this.user,
    required this.year,
    required this.view,
  });

  final UserPerformance user;
  final int year;
  final int view; // 0 = month-wise, 1 = year-wise

  @override
  Widget build(BuildContext context) {
    return AppPanel(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              const CircleAvatar(
                radius: 16,
                backgroundColor: Color(0xFFEAF4FF),
                child: Icon(
                  Icons.person_outline,
                  size: 18,
                  color: AppColors.primaryBlue,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      user.name,
                      style: Theme.of(context).textTheme.titleSmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (user.employeeCode.isNotEmpty)
                      Text(
                        user.employeeCode,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const ChartLegend(
            items: <ChartLegendItem>[
              ChartLegendItem(
                color: AppColors.accentCyan,
                label: 'Plans created',
              ),
              ChartLegendItem(
                color: AppColors.accentMint,
                label: 'DCRs created',
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (view == 0) _buildMonthWise(context) else _buildYearWise(context),
        ],
      ),
    );
  }

  Widget _buildMonthWise(BuildContext context) {
    if (!user.hasMonthData) {
      return _noData(context, 'No activity recorded in $year.');
    }
    return SizedBox(
      height: 240,
      child: GroupedBarChart(
        labels: kMonthLabels,
        seriesA: user.months
            .map((MonthlyVisits m) => m.plansCreated.toDouble())
            .toList(growable: false),
        seriesB: user.months
            .map((MonthlyVisits m) => m.dcrsSubmitted.toDouble())
            .toList(growable: false),
        colorA: AppColors.accentCyan,
        colorB: AppColors.accentMint,
        nameA: 'Plans',
        nameB: 'DCRs',
        integer: true,
      ),
    );
  }

  Widget _buildYearWise(BuildContext context) {
    if (!user.hasYearData) {
      return _noData(context, 'No activity recorded yet.');
    }
    return SizedBox(
      height: 240,
      child: GroupedBarChart(
        labels: user.years
            .map((YearlyVisits y) => '${y.year}')
            .toList(growable: false),
        seriesA: user.years
            .map((YearlyVisits y) => y.plansCreated.toDouble())
            .toList(growable: false),
        seriesB: user.years
            .map((YearlyVisits y) => y.dcrsSubmitted.toDouble())
            .toList(growable: false),
        colorA: AppColors.accentCyan,
        colorB: AppColors.accentMint,
        nameA: 'Plans',
        nameB: 'DCRs',
        integer: true,
      ),
    );
  }

  Widget _noData(BuildContext context, String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: Text(message, style: Theme.of(context).textTheme.bodySmall),
      ),
    );
  }
}
