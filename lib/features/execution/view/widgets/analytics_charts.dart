import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:vivocure/core/theme/app_colors.dart';
import 'package:vivocure/core/widgets/app_panel.dart';

/// Shared chart building blocks for the analytics screens (Execution,
/// My Visits): a two-series grouped bar chart, legend and empty state.

const List<String> kMonthLabels = <String>[
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

class ChartLegendItem {
  const ChartLegendItem({required this.color, required this.label});
  final Color color;
  final String label;
}

class ChartLegend extends StatelessWidget {
  const ChartLegend({super.key, required this.items});
  final List<ChartLegendItem> items;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: items
          .map(
            (ChartLegendItem item) => Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: item.color,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 6),
                Text(item.label, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          )
          .toList(growable: false),
    );
  }
}

class EmptyChart extends StatelessWidget {
  const EmptyChart({super.key, required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return AppPanel(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 20),
      child: Center(
        child: Column(
          children: <Widget>[
            const Icon(
              Icons.bar_chart_rounded,
              size: 44,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

/// Responsive, interactive grouped bar chart (two series) with tooltips and
/// X-axis labels (months, years, ...).
class GroupedBarChart extends StatelessWidget {
  const GroupedBarChart({
    super.key,
    required this.labels,
    required this.seriesA,
    required this.seriesB,
    required this.colorA,
    required this.colorB,
    required this.nameA,
    required this.nameB,
    this.integer = false,
  });

  final List<String> labels; // X-axis label per group
  final List<double> seriesA;
  final List<double> seriesB;
  final Color colorA;
  final Color colorB;
  final String nameA;
  final String nameB;
  final bool integer;

  @override
  Widget build(BuildContext context) {
    double maxVal = 0;
    for (final double v in <double>[...seriesA, ...seriesB]) {
      if (v > maxVal) maxVal = v;
    }
    final double maxY = maxVal <= 0 ? 1 : maxVal * 1.2;

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxY,
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (_) => AppColors.textPrimary,
            getTooltipItem:
                (
                  BarChartGroupData group,
                  int groupIndex,
                  BarChartRodData rod,
                  int rodIndex,
                ) {
                  final String name = rodIndex == 0 ? nameA : nameB;
                  final String value = integer
                      ? rod.toY.toInt().toString()
                      : rod.toY.toStringAsFixed(0);
                  return BarTooltipItem(
                    '${labels[groupIndex]}\n$name: $value',
                    const TextStyle(color: Colors.white, fontSize: 12),
                  );
                },
          ),
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (double value, TitleMeta meta) {
                if (value == meta.max) return const SizedBox.shrink();
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                  ),
                );
              },
            ),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              getTitlesWidget: (double value, TitleMeta meta) {
                final int i = value.toInt();
                if (i < 0 || i >= labels.length) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    labels[i],
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.textSecondary,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (double v) =>
              const FlLine(color: AppColors.border, strokeWidth: 1),
        ),
        borderData: FlBorderData(show: false),
        barGroups: List<BarChartGroupData>.generate(labels.length, (int i) {
          return BarChartGroupData(
            x: i,
            barRods: <BarChartRodData>[
              BarChartRodData(
                toY: seriesA[i],
                color: colorA,
                width: labels.length > 6 ? 6 : 14,
                borderRadius: BorderRadius.circular(3),
              ),
              BarChartRodData(
                toY: seriesB[i],
                color: colorB,
                width: labels.length > 6 ? 6 : 14,
                borderRadius: BorderRadius.circular(3),
              ),
            ],
          );
        }),
      ),
    );
  }
}
