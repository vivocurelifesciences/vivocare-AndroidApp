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

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double sidePanelWidth = (constraints.maxWidth * 0.30)
            .clamp(190.0, compact ? 240.0 : 280.0)
            .toDouble();

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: contentPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _HeaderSection(viewModel: viewModel, compact: compact),
                    const SizedBox(height: 20),
                    LayoutBuilder(
                      builder:
                          (
                            BuildContext context,
                            BoxConstraints contentConstraints,
                          ) {
                            final bool twoColumn =
                                contentConstraints.maxWidth >= 760;

                            if (twoColumn) {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: _TodayPlanCard(viewModel: viewModel),
                                  ),
                                  const SizedBox(width: 18),
                                  Expanded(
                                    child: _TodayTipCard(viewModel: viewModel),
                                  ),
                                ],
                              );
                            }

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
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
            SizedBox(
              width: sidePanelWidth,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  0,
                  contentPadding.top,
                  contentPadding.right,
                  contentPadding.bottom,
                ),
                child: SingleChildScrollView(
                  child: _UpcomingEventsPanel(viewModel: viewModel),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection({required this.viewModel, required this.compact});

  final HomeViewModel viewModel;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFD7E3F1),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 16 : 22,
          vertical: compact ? 14 : 18,
        ),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final bool stacked = constraints.maxWidth < 620;

            if (stacked) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _HeaderGreeting(viewModel: viewModel),
                  const SizedBox(height: 10),
                  _HeaderDate(viewModel: viewModel),
                ],
              );
            }

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _HeaderGreeting(viewModel: viewModel)),
                const SizedBox(width: 12),
                _HeaderDate(viewModel: viewModel),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _HeaderGreeting extends StatelessWidget {
  const _HeaderGreeting({required this.viewModel});

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hi ${viewModel.userName} ${viewModel.employeeMeta}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryBlueDark,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          viewModel.greeting,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryBlueDark,
          ),
        ),
      ],
    );
  }
}

class _HeaderDate extends StatelessWidget {
  const _HeaderDate({required this.viewModel});

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Text(
      viewModel.formattedDate,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
        fontSize: 13,
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w600,
      ),
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
              fontSize: 28,
              color: AppColors.primaryBlue,
              fontWeight: FontWeight.w700,
            ),
          ),
          Container(width: 76, height: 2, color: AppColors.primaryBlue),
          const SizedBox(height: 8),
          Text(
            'Visits',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontSize: 15,
              color: AppColors.primaryBlue,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (viewModel.isTodayPlanLoading) ...[
            const SizedBox(height: 10),
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ],
          if (viewModel.todayPlanErrorMessage != null) ...[
            const SizedBox(height: 8),
            Text(
              viewModel.todayPlanErrorMessage!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.error,
                fontSize: 11,
              ),
            ),
          ],
          const SizedBox(height: 18),
          // visit indicators removed: circles were previously shown here
          // per updated design request to remove round elements from home screen.
          // If needed in future, this can be replaced with a different widget.
          const SizedBox.shrink(),
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
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            viewModel.todaysTip,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
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
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 14),
            child,
          ],
        ),
      ),
    );
  }
}

class _UpcomingEventsPanel extends StatelessWidget {
  const _UpcomingEventsPanel({required this.viewModel});

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Upcoming Events',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              viewModel.upcomingEventsSectionLabel,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 14,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            if (viewModel.isUpcomingEventsLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              )
            else if (viewModel.upcomingEventsErrorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  viewModel.upcomingEventsErrorMessage!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 12,
                  ),
                ),
              )
            else if (viewModel.upcomingEvents.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'No events available',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: viewModel.upcomingEvents.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (BuildContext context, int index) {
                  final UpcomingEvent event = viewModel.upcomingEvents[index];
                  return _UpcomingEventTile(event: event);
                },
              ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.center,
              child: TextButton(
                onPressed: () {},
                child: const Text('View More'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UpcomingEventTile extends StatelessWidget {
  const _UpcomingEventTile({required this.event});

  final UpcomingEvent event;

  IconData _iconForEvent() {
    final String eventName = event.eventName.toLowerCase();
    if (eventName.contains('birth')) {
      return Icons.cake_outlined;
    }
    if (eventName.contains('anniv')) {
      return Icons.favorite_border;
    }
    return Icons.event_outlined;
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFF9FBFE),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(_iconForEvent(), size: 18, color: AppColors.primaryBlue),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.customerName.isEmpty ? 'Unknown' : event.customerName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${event.customerType.isEmpty ? 'Unknown' : event.customerType} • '
                    '${event.eventName.isEmpty ? 'Event' : event.eventName}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    event.eventDate.isEmpty ? '-' : event.eventDate,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          event.customerLocation.isEmpty
                              ? '-'
                              : event.customerLocation,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
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
        // color indicator changed from circle to square to remove round appearance
        Container(
          width: 10,
          height: 10,
          color: color,
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: 12,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
