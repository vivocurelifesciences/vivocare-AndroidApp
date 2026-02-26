import 'package:flutter/material.dart';
import 'package:vivocare/core/theme/app_colors.dart';
import 'package:vivocare/features/home/view_model/home_view_model.dart';

class HomeDashboard extends StatelessWidget {
  const HomeDashboard({
    super.key,
    required this.viewModel,
    this.compact = false,
  });

  final HomeViewModel viewModel;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final EdgeInsets contentPadding = EdgeInsets.fromLTRB(
      compact ? 14 : 26,
      compact ? 10 : 16,
      compact ? 14 : 26,
      18,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _WarningBanner(message: viewModel.warningMessage),
        Expanded(
          child: SingleChildScrollView(
            padding: contentPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _HeaderSection(viewModel: viewModel),
                const SizedBox(height: 20),
                LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    final bool twoColumn = constraints.maxWidth >= 860;

                    if (twoColumn) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: _TodayPlanCard(viewModel: viewModel)),
                          const SizedBox(width: 18),
                          Expanded(child: _TodayTipCard(viewModel: viewModel)),
                        ],
                      );
                    }

                    return Column(
                      children: [
                        _TodayPlanCard(viewModel: viewModel),
                        const SizedBox(height: 16),
                        _TodayTipCard(viewModel: viewModel),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _WarningBanner extends StatelessWidget {
  const _WarningBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.warningLight,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: AppColors.warning,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection({required this.viewModel});

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      runSpacing: 10,
      spacing: 18,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hi ${viewModel.userName} ${viewModel.employeeMeta}',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              viewModel.greeting,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
        Text(
          viewModel.formattedDate,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _TodayPlanCard extends StatelessWidget {
  const _TodayPlanCard({required this.viewModel});

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return _DashboardCard(
      title: "Today's Plan",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${viewModel.todayVisits}',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: AppColors.primaryBlue,
              fontWeight: FontWeight.w700,
            ),
          ),
          Container(width: 76, height: 2, color: AppColors.primaryBlue),
          const SizedBox(height: 8),
          Text(
            'Visits',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.primaryBlue,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List<Widget>.generate(
              viewModel.todayVisits,
              (_) => Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primaryBlue, width: 1.3),
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Wrap(
            runSpacing: 8,
            spacing: 18,
            children: [
              _LegendItem(
                color: AppColors.doctor,
                label: 'Doctors (${viewModel.doctorVisits})',
              ),
              _LegendItem(
                color: AppColors.chemist,
                label: 'Chemist (${viewModel.chemistVisits})',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TodayTipCard extends StatelessWidget {
  const _TodayTipCard({required this.viewModel});

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return _DashboardCard(
      title: "Today's Tip",
      child: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(
          viewModel.todaysTip,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  const _DashboardCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 14),
            child,
          ],
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
