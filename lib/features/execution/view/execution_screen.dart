import 'package:flutter/material.dart';
import 'package:vivocure/core/app_services.dart';
import 'package:vivocure/core/layout/responsive.dart';
import 'package:vivocure/core/theme/app_colors.dart';
import 'package:vivocure/core/widgets/app_page_backdrop.dart';
import 'package:vivocure/core/widgets/app_panel.dart';
import 'package:vivocure/data/repositories/execution_repository.dart';
import 'package:vivocure/features/execution/view/widgets/analytics_charts.dart';

/// Sentinel for "all customers" in the customer dropdown.
const String _kAllCustomers = '';

/// Execution analytics: Support vs Expected value computed from local data,
/// filtered by entity type, Core/Non-Core/Super-Core category, a specific
/// doctor/chemist, year and month — viewable month-wise (within a year) or
/// year-wise (across years).
class ExecutionScreen extends StatefulWidget {
  const ExecutionScreen({super.key});

  @override
  State<ExecutionScreen> createState() => _ExecutionScreenState();
}

class _ExecutionScreenState extends State<ExecutionScreen> {
  ExecEntityType _entity = ExecEntityType.doctor;
  ExecCategory _category = ExecCategory.all;
  String _customerId = _kAllCustomers;
  int _year = DateTime.now().year;
  int _month = 0; // 0 = all months
  int _supportView = 0; // 0 = month-wise, 1 = year-wise

  List<int> _years = <int>[DateTime.now().year];
  List<ExecCustomer> _customers = const <ExecCustomer>[];
  List<MonthlyMetric>? _months;
  List<YearlyMetric> _yearly = const <YearlyMetric>[];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final List<int> years = await AppServices.execution.availableYears();
    if (!mounted) {
      return;
    }
    setState(() {
      _years = years;
      if (!years.contains(_year)) {
        _year = years.first;
      }
    });
    await _reloadCustomers();
    await _reload();
  }

  /// Refreshes the selectable doctor/chemist list for the current entity +
  /// category; drops the selection if it is no longer in the list.
  Future<void> _reloadCustomers() async {
    final List<ExecCustomer> customers = await AppServices.execution
        .customersFor(entityType: _entity, category: _category);
    if (!mounted) {
      return;
    }
    setState(() {
      _customers = customers;
      if (_customerId != _kAllCustomers &&
          !customers.any((ExecCustomer c) => c.id == _customerId)) {
        _customerId = _kAllCustomers;
      }
    });
  }

  Future<void> _reload() async {
    setState(() => _loading = true);
    final String? customerId = _customerId == _kAllCustomers
        ? null
        : _customerId;
    final List<MonthlyMetric> months = await AppServices.execution.load(
      entityType: _entity,
      category: _category,
      year: _year,
      customerId: customerId,
    );
    final List<YearlyMetric> yearly = await AppServices.execution
        .supportByYears(
          entityType: _entity,
          category: _category,
          customerId: customerId,
        );
    if (!mounted) {
      return;
    }
    setState(() {
      _months = months;
      _yearly = yearly;
      _loading = false;
    });
  }

  /// Months to display: all 12, or just the selected month.
  List<int> get _activeMonths =>
      _month == 0 ? List<int>.generate(12, (int i) => i + 1) : <int>[_month];

  String? get _selectedCustomerName {
    if (_customerId == _kAllCustomers) {
      return null;
    }
    for (final ExecCustomer c in _customers) {
      if (c.id == _customerId) {
        return c.name;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Execution')),
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
                  _buildFilters(context),
                  const SizedBox(height: 16),
                  if (_loading)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 60),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else
                    _buildSupportExpected(context),
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
            'Execution',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Support vs Expected value analytics. Pick a doctor or chemist '
            'to analyze their support value trend month-wise and year-wise.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildFilters(BuildContext context) {
    return AppPanel(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _filterLabel(context, 'Entity'),
          const SizedBox(height: 8),
          SegmentedButton<ExecEntityType>(
            segments: const <ButtonSegment<ExecEntityType>>[
              ButtonSegment<ExecEntityType>(
                value: ExecEntityType.doctor,
                label: Text('Doctor'),
                icon: Icon(Icons.medical_services_outlined),
              ),
              ButtonSegment<ExecEntityType>(
                value: ExecEntityType.chemist,
                label: Text('Chemist'),
                icon: Icon(Icons.local_pharmacy_outlined),
              ),
            ],
            selected: <ExecEntityType>{_entity},
            onSelectionChanged: (Set<ExecEntityType> s) async {
              setState(() {
                _entity = s.first;
                _customerId = _kAllCustomers;
              });
              await _reloadCustomers();
              await _reload();
            },
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.end,
            children: <Widget>[
              _dropdown<ExecCategory>(
                context,
                label: 'Category',
                value: _category,
                items: ExecCategory.values,
                itemLabel: (ExecCategory c) => c.label,
                onChanged: (ExecCategory? v) async {
                  if (v == null) return;
                  setState(() => _category = v);
                  await _reloadCustomers();
                  await _reload();
                },
              ),
              _customerDropdown(context),
              _dropdown<int>(
                context,
                label: 'Year',
                value: _year,
                items: _years,
                itemLabel: (int y) => '$y',
                onChanged: (int? v) {
                  if (v == null) return;
                  setState(() => _year = v);
                  _reload();
                },
              ),
              _dropdown<int>(
                context,
                label: 'Month',
                value: _month,
                items: <int>[0, ...List<int>.generate(12, (int i) => i + 1)],
                itemLabel: (int m) =>
                    m == 0 ? 'All months' : kMonthLabels[m - 1],
                onChanged: (int? v) {
                  if (v == null) return;
                  setState(() => _month = v);
                },
              ),
            ],
          ),
          if (_entity == ExecEntityType.chemist &&
              _category != ExecCategory.all)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                'Note: chemists are not categorized — Core/Non-Core/Super-Core '
                'applies to doctors only.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
        ],
      ),
    );
  }

  /// Doctor/chemist selector. The item list follows the entity + category
  /// filters, so the key forces a rebuild whenever those change.
  Widget _customerDropdown(BuildContext context) {
    final String allLabel = _entity == ExecEntityType.doctor
        ? 'All doctors'
        : 'All chemists';
    return SizedBox(
      width: context.isMobile ? 220 : 260,
      child: DropdownButtonFormField<String>(
        key: ValueKey<String>(
          'customer-${_entity.name}-${_category.name}-${_customers.length}',
        ),
        initialValue: _customerId,
        isExpanded: true,
        decoration: InputDecoration(labelText: _entity.label),
        items: <DropdownMenuItem<String>>[
          DropdownMenuItem<String>(
            value: _kAllCustomers,
            child: Text(allLabel),
          ),
          for (final ExecCustomer c in _customers)
            DropdownMenuItem<String>(
              value: c.id,
              child: Text(c.name, overflow: TextOverflow.ellipsis),
            ),
        ],
        onChanged: (String? v) {
          if (v == null) return;
          setState(() => _customerId = v);
          _reload();
        },
      ),
    );
  }

  /// " — Dr Name" suffix for chart titles when one customer is selected.
  String get _customerSuffix {
    final String? name = _selectedCustomerName;
    return name == null ? '' : ' — $name';
  }

  Widget _buildSupportExpected(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
          selected: <int>{_supportView},
          onSelectionChanged: (Set<int> s) =>
              setState(() => _supportView = s.first),
        ),
        const SizedBox(height: 16),
        if (_supportView == 0)
          _buildSupportMonthWise(context)
        else
          _buildSupportYearWise(context),
      ],
    );
  }

  Widget _buildSupportMonthWise(BuildContext context) {
    final List<MonthlyMetric> data = _months!;
    final bool hasData = data.any(
      (MonthlyMetric m) => m.supportValue != 0 || m.expectedValue != 0,
    );
    if (!hasData) {
      return const EmptyChart(
        message: 'No support/expected values recorded for this selection.',
      );
    }
    final List<int> months = _activeMonths;
    final List<double> support = months
        .map((int m) => data[m - 1].supportValue)
        .toList(growable: false);
    final List<double> expected = months
        .map((int m) => data[m - 1].expectedValue)
        .toList(growable: false);

    return AppPanel(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Support vs Expected Value — $_year$_customerSuffix',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 12),
          const ChartLegend(
            items: <ChartLegendItem>[
              ChartLegendItem(color: AppColors.primaryBlue, label: 'Support'),
              ChartLegendItem(color: AppColors.accentAmber, label: 'Expected'),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 280,
            child: GroupedBarChart(
              labels: months
                  .map((int m) => kMonthLabels[m - 1])
                  .toList(growable: false),
              seriesA: support,
              seriesB: expected,
              colorA: AppColors.primaryBlue,
              colorB: AppColors.accentAmber,
              nameA: 'Support',
              nameB: 'Expected',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportYearWise(BuildContext context) {
    if (_yearly.isEmpty) {
      return const EmptyChart(
        message: 'No support values recorded yet for this selection.',
      );
    }
    final List<String> labels = _yearly
        .map((YearlyMetric y) => '${y.year}')
        .toList(growable: false);
    final List<double> support = _yearly
        .map((YearlyMetric y) => y.supportValue)
        .toList(growable: false);
    final List<double> expected = _yearly
        .map((YearlyMetric y) => y.expectedValue)
        .toList(growable: false);

    return AppPanel(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Support Value Trend — Year-wise$_customerSuffix',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 4),
          Text(
            'Total support vs expected value per year (all years with data).',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          const ChartLegend(
            items: <ChartLegendItem>[
              ChartLegendItem(color: AppColors.primaryBlue, label: 'Support'),
              ChartLegendItem(color: AppColors.accentAmber, label: 'Expected'),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 280,
            child: GroupedBarChart(
              labels: labels,
              seriesA: support,
              seriesB: expected,
              colorA: AppColors.primaryBlue,
              colorB: AppColors.accentAmber,
              nameA: 'Support',
              nameB: 'Expected',
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterLabel(BuildContext context, String text) =>
      Text(text, style: Theme.of(context).textTheme.labelMedium);

  Widget _dropdown<T>(
    BuildContext context, {
    required String label,
    required T value,
    required List<T> items,
    required String Function(T) itemLabel,
    required ValueChanged<T?> onChanged,
  }) {
    return SizedBox(
      width: context.isMobile ? 150 : 180,
      child: DropdownButtonFormField<T>(
        initialValue: value,
        isExpanded: true,
        decoration: InputDecoration(labelText: label),
        items: items
            .map(
              (T item) => DropdownMenuItem<T>(
                value: item,
                child: Text(itemLabel(item)),
              ),
            )
            .toList(growable: false),
        onChanged: onChanged,
      ),
    );
  }
}
