import 'package:flutter/material.dart';
import 'package:vivocure/core/layout/responsive.dart';
import 'package:vivocure/core/theme/app_colors.dart';
import 'package:vivocure/core/widgets/app_loader.dart';
import 'package:vivocure/core/widgets/app_panel.dart';
import 'package:vivocure/core/widgets/app_reveal.dart';
import 'package:vivocure/features/home/view_model/home_view_model.dart';

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
      compact ? 14 : 24,
      compact ? 12 : 18,
      compact ? 14 : 24,
      18,
    );

    // Phones: a single scrolling column (events stacked under the cards) so
    // nothing is squeezed side-by-side. Tablet layout below is unchanged.
    if (context.isMobile) {
      return SingleChildScrollView(
        padding: contentPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            AppReveal(
              child: _HeaderSection(viewModel: viewModel, compact: true),
            ),
            const SizedBox(height: 16),
            AppReveal(
              delay: const Duration(milliseconds: 90),
              child: _TodayPlanCard(viewModel: viewModel),
            ),
            const SizedBox(height: 14),
            AppReveal(
              delay: const Duration(milliseconds: 140),
              child: _TodayTipCard(viewModel: viewModel),
            ),
            const SizedBox(height: 14),
            AppReveal(
              delay: const Duration(milliseconds: 190),
              child: _UpcomingEventsPanel(viewModel: viewModel),
            ),
          ],
        ),
      );
    }

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
                    AppReveal(
                      child: _HeaderSection(
                        viewModel: viewModel,
                        compact: compact,
                      ),
                    ),
                    const SizedBox(height: 20),
                    AppReveal(
                      delay: const Duration(milliseconds: 90),
                      child: LayoutBuilder(
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
                                      child: _TodayPlanCard(
                                        viewModel: viewModel,
                                      ),
                                    ),
                                    const SizedBox(width: 18),
                                    Expanded(
                                      child: _TodayTipCard(
                                        viewModel: viewModel,
                                      ),
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
                  child: AppReveal(
                    delay: const Duration(milliseconds: 180),
                    child: _UpcomingEventsPanel(viewModel: viewModel),
                  ),
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
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[Color(0xFFEAF4FF), Color(0xFFD8E9FA)],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.borderStrong),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 16 : 22,
          vertical: compact ? 16 : 20,
        ),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final bool stacked = constraints.maxWidth < 620;
            final Widget greetingBlock = _HeaderGreeting(viewModel: viewModel);
            final Widget brandBlock = _HeaderBrandPanel(
              viewModel: viewModel,
              compact: compact,
            );

            if (stacked) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  greetingBlock,
                  const SizedBox(height: 14),
                  brandBlock,
                ],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 4, child: greetingBlock),
                const SizedBox(width: 18),
                Expanded(flex: 3, child: brandBlock),
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
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.72),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: AppColors.borderStrong),
          ),
          child: Text(
            'Today\'s Workspace',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.primaryBlueDark,
            ),
          ),
        ),
        const SizedBox(height: 14),
        RichText(
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          text: TextSpan(
            children: <InlineSpan>[
              TextSpan(
                text: 'Hi ${viewModel.userName} ',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontSize: 21,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryBlueDeep,
                ),
              ),
              TextSpan(
                text: viewModel.employeeMeta,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryBlueDark,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 240),
          child: Text(
            viewModel.greeting,
            key: ValueKey<String>(viewModel.greeting),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryBlueDark,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Review today\'s visits, events and updates from one place.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
            height: 1.35,
          ),
        ),
      ],
    );
  }
}

class _HeaderBrandPanel extends StatelessWidget {
  const _HeaderBrandPanel({required this.viewModel, required this.compact});

  final HomeViewModel viewModel;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(compact ? 14 : 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.borderStrong),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.calendar_month_outlined,
                  color: AppColors.primaryBlueDark,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Today',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.primaryBlueDark,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 240),
            child: Text(
              viewModel.formattedDate,
              key: ValueKey<String>(viewModel.formattedDate),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: 17,
                height: 1.25,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
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
      title: "Today's Objectives (Aaj ka Plan)",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Allocated visits',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 650),
            curve: Curves.easeOutCubic,
            tween: Tween<double>(end: viewModel.todayVisits.toDouble()),
            builder: (BuildContext context, double value, _) {
              return Text(
                value.round().toString(),
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontSize: 30,
                  color: AppColors.primaryBlue,
                  fontWeight: FontWeight.w700,
                ),
              );
            },
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
            const SizedBox(height: 16),
            const Center(
              child: AppLoader(label: 'Loading today plan', dotSize: 8),
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
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _MetricBadge(
                label: 'Doctors',
                value: '${viewModel.doctorVisits}',
                color: AppColors.doctor,
              ),
              _MetricBadge(
                label: 'Chemists',
                value: '${viewModel.chemistVisits}',
                color: AppColors.chemist,
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
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 240),
            child: Align(
              key: ValueKey<String>(viewModel.todaysTip),
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
    return AppPanel(
      padding: const EdgeInsets.all(22),
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
    );
  }
}

class _MetricBadge extends StatelessWidget {
  const _MetricBadge({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.22)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(
            '$label $value',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _UpcomingEventsPanel extends StatelessWidget {
  const _UpcomingEventsPanel({required this.viewModel});

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return AppPanel(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            viewModel.upcomingEventsSectionLabel,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (viewModel.isUpcomingEventsLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: AppLoader(label: 'Loading events', dotSize: 8),
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
        ],
      ),
    );
  }
}

class _UpcomingEventTile extends StatelessWidget {
  const _UpcomingEventTile({required this.event});

  final UpcomingEvent event;

  bool get _isAnniversary {
    final String eventName = event.eventName.toLowerCase();
    return eventName.contains('anniv') || eventName.contains('anniversary');
  }

  bool get _isBirthday {
    final String eventName = event.eventName.toLowerCase();
    return eventName.contains('birth') || eventName.contains('birthday');
  }

  Color get _accentColor {
    if (_isAnniversary) {
      return AppColors.accentMint;
    }
    if (_isBirthday) {
      return AppColors.accentAmber;
    }
    return AppColors.primaryBlue;
  }

  Color get _surfaceColor => _accentColor.withValues(alpha: 0.08);

  Color get _borderColor => _accentColor.withValues(alpha: 0.26);

  IconData _iconForEvent() {
    if (_isAnniversary) {
      return Icons.card_giftcard_outlined;
    }

    if (_isBirthday) {
      return Icons.cake_outlined;
    }

    return Icons.event_outlined;
  }

  /// A real location: non-empty and not a leftover placeholder like "string".
  String? get _location {
    final String value = event.customerLocation.trim();
    if (value.isEmpty || value.toLowerCase() == 'string') {
      return null;
    }
    return value;
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: _surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: _accentColor.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(_iconForEvent(), size: 18, color: _accentColor),
            ),
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
                      color: _accentColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    event.eventDate.isEmpty ? '-' : event.eventDate,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: _accentColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  // Only show a location row when there's a real location.
                  if (_location != null) ...[
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
                            _location!,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
