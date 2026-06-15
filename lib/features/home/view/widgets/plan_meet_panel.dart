import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:vivocure/app/router/app_router.dart';
import 'package:vivocure/core/network/network_exception.dart';
import 'package:vivocure/core/theme/app_colors.dart';
import 'package:vivocure/core/widgets/app_alert_dialog.dart';
import 'package:vivocure/core/widgets/app_panel.dart';
import 'package:vivocure/features/home/view/dcr_list_screen.dart';
import 'package:vivocure/features/home/view_model/home_view_model.dart';

class PlanMeetPanel extends StatelessWidget {
  const PlanMeetPanel({
    super.key,
    required this.viewModel,
    this.compact = false,
  });

  final HomeViewModel viewModel;
  final bool compact;

  Future<void> _openQuickEntryDetails(
    BuildContext context,
    PlanMeetEntry entry,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => FractionallySizedBox(
        heightFactor: 0.92,
        child: _CustomerDetailsSheet(entry: entry, viewModel: viewModel),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final EdgeInsets contentPadding = EdgeInsets.fromLTRB(
      compact ? 14 : 26,
      4,
      compact ? 14 : 26,
      18,
    );

    return SingleChildScrollView(
      padding: contentPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppPanel(
            padding: const EdgeInsets.all(22),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[Color(0xFFF8FBFF), Color(0xFFEAF4FF)],
            ),
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final Widget headerText = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.92),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: AppColors.borderStrong),
                      ),
                      child: Text(
                        'Daily Planning',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.primaryBlueDark,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Planning',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontSize: 24, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Build daily doctor and chemist plans, then review DCR activity from the same workspace.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                );

                final Widget headerActions = SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 40,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                          ),
                          onPressed: () async {
                            final String? message = await showDialog<String>(
                              context: context,
                              builder: (_) =>
                                  _PlanMeetAddDialog(viewModel: viewModel),
                            );
                            if (context.mounted && message != null) {
                              await AppAlertDialog.showSuccess(
                                context: context,
                                message: message,
                              );
                            }
                          },
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('Add'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        height: 40,
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                          ),
                          onPressed: () async {
                            final bool? didCreateDcr =
                                await Navigator.of(context).push<bool>(
                                  MaterialPageRoute<bool>(
                                    builder: (_) =>
                                        DcrListScreen(viewModel: viewModel),
                                  ),
                                );
                            if (context.mounted && didCreateDcr == true) {
                              await viewModel.fetchPlanMeetEntries(
                                visitDate: viewModel.currentPlanMeetDate,
                              );
                            }
                          },
                          icon: const Icon(
                            Icons.description_outlined,
                            size: 18,
                          ),
                          label: const Text('Create DCR'),
                        ),
                      ),
                    ],
                  ),
                );

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    headerText,
                    const SizedBox(height: 16),
                    Align(
                      alignment: constraints.maxWidth < 760
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      child: headerActions,
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Quick Entries',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          if (viewModel.isPlanMeetLoading)
            const _EmptySectionCard(message: 'Loading plans...')
          else if (viewModel.planMeetErrorMessage != null)
            _EmptySectionCard(message: viewModel.planMeetErrorMessage!)
          else if (viewModel.planMeetEntries.isEmpty)
            const _EmptySectionCard(
              message:
                  'No doctor/chemist selected yet. Tap Add to create plan.',
            )
          // A visit with a recorded DCR is done for the day — it leaves the
          // quick entries list immediately.
          else if (viewModel.pendingPlanMeetEntriesForDcr.isEmpty)
            const _EmptySectionCard(
              message:
                  'All planned visits for this date have DCRs recorded. '
                  'Tap Add to plan another visit.',
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: viewModel.pendingPlanMeetEntriesForDcr.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (BuildContext context, int index) {
                final PlanMeetEntry entry =
                    viewModel.pendingPlanMeetEntriesForDcr[index];
                return _PlanEntryCard(
                  entry: entry,
                  viewModel: viewModel,
                  onTap: () => _openQuickEntryDetails(context, entry),
                );
              },
            ),
        ],
      ),
    );
  }
}

class _EmptySectionCard extends StatelessWidget {
  const _EmptySectionCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return AppPanel(child: Text(message));
  }
}

class _PlanEntryCard extends StatelessWidget {
  const _PlanEntryCard({
    required this.entry,
    required this.viewModel,
    required this.onTap,
  });

  final PlanMeetEntry entry;
  final HomeViewModel viewModel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final CustomerProfile profile = viewModel.getCustomerProfileForEntry(entry);

    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: AppPanel(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              decoration: BoxDecoration(
                color: entry.isDoctor
                    ? const Color(0xFFE8F6FA)
                    : const Color(0xFFFFF5E8),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                entry.typeLabel,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.name,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${profile.code.isEmpty ? '' : ' ${profile.code}'}'
                    ' • ${viewModel.formatShortDate(entry.visitDate)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _MetricPill(
                        label: 'Potential',
                        value: _displayValue(profile.potential),
                      ),
                      _MetricPill(
                        label: 'Support',
                        value: _displayValue(profile.supportValue),
                      ),
                      _MetricPill(
                        label: 'Expected',
                        value: _displayValue(profile.expectedSupportValue),
                      ),
                      if (entry.isDoctor &&
                          profile.qualification.trim().isNotEmpty)
                        _MetricPill(
                          label: 'Qualification',
                          value: _displayValue(profile.qualification),
                        ),
                      if (profile.area.trim().isNotEmpty)
                        _MetricPill(
                          label: 'Area',
                          value: _displayValue(profile.area),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomerDetailsSheet extends StatefulWidget {
  const _CustomerDetailsSheet({required this.entry, required this.viewModel});

  final PlanMeetEntry entry;
  final HomeViewModel viewModel;

  @override
  State<_CustomerDetailsSheet> createState() => _CustomerDetailsSheetState();
}

class _CustomerDetailsSheetState extends State<_CustomerDetailsSheet> {
  /// Ordered: this is the exact slide order of the presentation.
  final List<String> _selectedMedicineIds = <String>[];

  /// Only what the rep explicitly selected — the presentation never
  /// auto-includes products.
  List<MedicinePresentation> get _selectedMedicines {
    final Map<String, MedicinePresentation> byId =
        <String, MedicinePresentation>{
          for (final MedicinePresentation m
              in widget.viewModel.getMedicinePresentationsByIds(
                _selectedMedicineIds,
              ))
            m.id: m,
        };
    return _selectedMedicineIds
        .map((String id) => byId[id])
        .whereType<MedicinePresentation>()
        .toList(growable: false);
  }

  Future<void> _openMedicineSelector() async {
    final Set<String>? selectedIds = await showDialog<Set<String>>(
      context: context,
      builder: (_) => _MedicineSelectionDialog(
        products: widget.viewModel.medicinePresentations,
        initialSelectedIds: _selectedMedicineIds.toSet(),
      ),
    );

    if (!mounted || selectedIds == null) {
      return;
    }

    setState(() {
      // Keep the arranged order; append newly picked products at the end.
      _selectedMedicineIds.removeWhere(
        (String id) => !selectedIds.contains(id),
      );
      for (final MedicinePresentation m
          in widget.viewModel.medicinePresentations) {
        if (selectedIds.contains(m.id) &&
            !_selectedMedicineIds.contains(m.id)) {
          _selectedMedicineIds.add(m.id);
        }
      }
    });
  }

  /// Opens the arrange/shuffle screen with ONLY the selected products and
  /// applies the order it returns.
  Future<void> _arrangeSelected() async {
    final Object? result = await Navigator.of(context).pushNamed(
      AppRoutes.reorderProducts,
      arguments: List<String>.of(_selectedMedicineIds),
    );
    if (!mounted || result is! List<String>) {
      return;
    }
    setState(() {
      _selectedMedicineIds
        ..clear()
        ..addAll(result);
    });
  }

  @override
  Widget build(BuildContext context) {
    final CustomerProfile customer = widget.viewModel
        .getCustomerProfileForEntry(widget.entry);
    final String typeLabel = widget.entry.typeLabel;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          top: 16,
          right: 16,
          bottom:
              16 +
              MediaQuery.of(context).viewInsets.bottom +
              MediaQuery.of(context).padding.bottom,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '$typeLabel Full Details',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    Text(
                      customer.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (customer.code.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        '$typeLabel Code: ${customer.code}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _MetricPill(
                          label: 'Potential',
                          value: _displayValue(customer.potential),
                        ),
                        _MetricPill(
                          label: 'Support',
                          value: _displayValue(customer.supportValue),
                        ),
                        _MetricPill(
                          label: 'Expected',
                          value: _displayValue(customer.expectedSupportValue),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    if (widget.entry.isDoctor) ...[
                      _DetailLine(
                        label: 'Qualification',
                        value: _displayValue(customer.qualification),
                      ),
                      _DetailLine(
                        label: 'Speciality',
                        value: _displayValue(customer.speciality),
                      ),
                    ] else ...[
                      _DetailLine(
                        label: 'Email',
                        value: _displayValue(customer.email),
                      ),
                      _DetailLine(
                        label: 'Contact Person',
                        value: _displayValue(customer.contactPersonName),
                      ),
                      _DetailLine(
                        label: 'Contact Email',
                        value: _displayValue(customer.contactPersonEmail),
                      ),
                    ],
                    _DetailLine(
                      label: 'Phone',
                      value: _displayValue(customer.phone),
                    ),
                    _DetailLine(
                      label: 'Area',
                      value: _displayValue(customer.area),
                    ),
                    _DetailLine(
                      label: 'City',
                      value: _displayValue(customer.city),
                    ),
                    _DetailLine(
                      label: 'State',
                      value: _displayValue(customer.state),
                    ),
                    _DetailLine(
                      label: 'Country',
                      value: _displayValue(customer.country),
                    ),
                    const SizedBox(height: 14),
                    if (widget.viewModel.medicinePresentations.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7FAFD),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: const Text(
                          'No products available yet. Product images are loaded from local cache after login.',
                        ),
                      )
                    else ...[
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Presentation Products (${_selectedMedicines.length})',
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ),
                          IconButton(
                            tooltip: 'Arrange presentation order',
                            onPressed: _selectedMedicines.length < 2
                                ? null
                                : _arrangeSelected,
                            icon: const Icon(Icons.swap_vert, size: 20),
                          ),
                          OutlinedButton.icon(
                            onPressed: _openMedicineSelector,
                            icon: const Icon(
                              Icons.medication_outlined,
                              size: 18,
                            ),
                            label: const Text('Select Product'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      if (_selectedMedicines.isEmpty)
                        Text(
                          'No products selected. Tap "Select Product" to '
                          'choose what to present.',
                          style: Theme.of(context).textTheme.bodySmall,
                        )
                      else
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _selectedMedicines
                              .map(
                                (MedicinePresentation item) => Chip(
                                  label: Text(
                                    item.code.isEmpty
                                        ? item.name
                                        : '${item.name} (${item.code})',
                                  ),
                                  onDeleted: () {
                                    setState(() {
                                      _selectedMedicineIds.remove(item.id);
                                    });
                                  },
                                ),
                              )
                              .toList(growable: false),
                        ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: OutlinedButton.icon(
                onPressed: _selectedMedicines.isEmpty
                    ? null
                    : () {
                        // Remember exactly what was presented on this visit so
                        // the Create DCR sheet pre-fills the same products.
                        unawaited(
                          widget.viewModel.recordPresentedSelection(
                            planId: widget.entry.id,
                            productIds: List<String>.of(_selectedMedicineIds),
                          ),
                        );
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => _MedicinePresentationScreen(
                              presentations: _selectedMedicines,
                              customerName: customer.name,
                              isDoctor: widget.entry.isDoctor,
                            ),
                          ),
                        );
                      },
                icon: const Icon(Icons.slideshow_outlined),
                label: const Text('View Presentation'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailLine extends StatelessWidget {
  const _DetailLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: RichText(
        text: TextSpan(
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: 13,
            color: AppColors.textPrimary,
          ),
          children: <TextSpan>[
            TextSpan(
              text: '$label: ',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}

class _MetricPill extends StatelessWidget {
  const _MetricPill({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF6FAFE),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        '$label: $value',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _MedicinePresentationScreen extends StatefulWidget {
  const _MedicinePresentationScreen({
    required this.presentations,
    required this.customerName,
    required this.isDoctor,
  });

  final List<MedicinePresentation> presentations;
  final String customerName;
  final bool isDoctor;

  @override
  State<_MedicinePresentationScreen> createState() =>
      _MedicinePresentationScreenState();
}

class _MedicinePresentationScreenState
    extends State<_MedicinePresentationScreen> {
  static const String _introAssetPath = 'assets/images/presentation.jpeg';
  static const String _logoAssetPath = 'assets/images/vivocure_logo.jpeg';

  int _activeSlideIndex = 0;
  late final PageController _pageController;

  /// Slide order is fixed: (1) the customer's name as the opening page,
  /// (2) the company introduction, then (3) the selected products.
  List<_PresentationSlide> get _slides => <_PresentationSlide>[
    _PresentationSlide(
      kind: _SlideKind.title,
      title: widget.isDoctor
          ? 'Dr. ${widget.customerName}'
          : widget.customerName,
      subtitle: widget.isDoctor
          ? 'Product presentation'
          : 'Product presentation • Chemist',
    ),
    const _PresentationSlide(
      kind: _SlideKind.intro,
      title: 'Company Introduction',
      assetPath: _introAssetPath,
    ),
    ...widget.presentations.map(
      (MedicinePresentation item) => _PresentationSlide(
        kind: _SlideKind.product,
        title: item.code.isEmpty ? item.name : '${item.name} (${item.code})',
        localImagePath: item.localImagePath,
        imageUrl: item.imageUrl,
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToSlide(int index) {
    if (index < 0 || index >= _slides.length) {
      return;
    }
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050B14),
      body: Stack(
        children: [
          Positioned.fill(child: _buildSlideshowView()),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
              child: Column(
                children: [
                  Row(
                    children: [
                      _PresentationActionButton(
                        icon: Icons.arrow_back_rounded,
                        onTap: () => Navigator.of(context).pop(),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.44),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.16),
                          ),
                        ),
                        child: Text(
                          '${_activeSlideIndex + 1}/${_slides.length}',
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  if (_slides.length > 1)
                    Row(
                      children: [
                        _PresentationActionButton(
                          icon: Icons.chevron_left_rounded,
                          onTap: () => _goToSlide(_activeSlideIndex - 1),
                        ),
                        const Spacer(),
                        _PresentationActionButton(
                          icon: Icons.chevron_right_rounded,
                          onTap: () => _goToSlide(_activeSlideIndex + 1),
                        ),
                      ],
                    ),
                  const SizedBox(height: 18),
                  if (_slides.length > 1)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List<Widget>.generate(_slides.length, (
                        int index,
                      ) {
                        final bool isActive = index == _activeSlideIndex;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          width: isActive ? 22 : 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          decoration: BoxDecoration(
                            color: isActive
                                ? Colors.white
                                : Colors.white.withValues(alpha: 0.38),
                            borderRadius: BorderRadius.circular(999),
                          ),
                        );
                      }),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlideshowView() {
    return PageView.builder(
      controller: _pageController,
      itemCount: _slides.length,
      onPageChanged: (int index) {
        setState(() {
          _activeSlideIndex = index;
        });
      },
      itemBuilder: (BuildContext context, int index) {
        final _PresentationSlide slide = _slides[index];
        return ColoredBox(
          color: const Color(0xFF050B14),
          child: _buildSlideImage(slide),
        );
      },
    );
  }
}

class _PresentationActionButton extends StatelessWidget {
  const _PresentationActionButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.42),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: IconButton(
        onPressed: onTap,
        icon: Icon(icon, color: Colors.white),
      ),
    );
  }
}

extension on _MedicinePresentationScreenState {
  Widget _buildSlideImage(_PresentationSlide slide) {
    switch (slide.kind) {
      case _SlideKind.title:
        return _buildTitleSlide(slide);
      case _SlideKind.intro:
        return SizedBox.expand(
          child: Image.asset(
            slide.assetPath,
            fit: BoxFit.contain,
            filterQuality: FilterQuality.high,
            errorBuilder: (_, _, _) => _buildSlideFallback(slide.title),
          ),
        );
      case _SlideKind.product:
        break;
    }

    if (slide.localImagePath.isNotEmpty &&
        File(slide.localImagePath).existsSync()) {
      return SizedBox.expand(
        child: Image.file(
          File(slide.localImagePath),
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
        ),
      );
    }

    if (slide.imageUrl.isNotEmpty) {
      return SizedBox.expand(
        child: Image.network(
          slide.imageUrl,
          fit: BoxFit.contain,
          loadingBuilder:
              (
                BuildContext context,
                Widget child,
                ImageChunkEvent? loadingProgress,
              ) {
                if (loadingProgress == null) {
                  return child;
                }
                return const Center(
                  child: CircularProgressIndicator(strokeWidth: 2.2),
                );
              },
          errorBuilder: (_, _, _) => _buildSlideFallback(slide.title),
        ),
      );
    }

    return _buildSlideFallback(slide.title);
  }

  /// Opening page: who this presentation is for, with company branding.
  Widget _buildTitleSlide(_PresentationSlide slide) {
    final ThemeData theme = Theme.of(context);
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[Color(0xFF0A1B30), Color(0xFF050B14)],
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  _MedicinePresentationScreenState._logoAssetPath,
                  width: 132,
                  height: 132,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const SizedBox.shrink(),
                ),
              ),
              const SizedBox(height: 28),
              Text(
                slide.title,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                slide.subtitle,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.72),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 36),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Swipe to begin',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.55),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 16,
                    color: Colors.white.withValues(alpha: 0.55),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSlideFallback(String title) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAFD),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.broken_image_outlined,
            size: 54,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          const Text('Image not available'),
        ],
      ),
    );
  }
}

class _MedicineSelectionDialog extends StatefulWidget {
  const _MedicineSelectionDialog({
    required this.products,
    required this.initialSelectedIds,
  });

  final List<MedicinePresentation> products;
  final Set<String> initialSelectedIds;

  @override
  State<_MedicineSelectionDialog> createState() =>
      _MedicineSelectionDialogState();
}

class _MedicineSelectionDialogState extends State<_MedicineSelectionDialog> {
  final TextEditingController _searchController = TextEditingController();
  late final Set<String> _selectedIds;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _selectedIds = Set<String>.from(widget.initialSelectedIds);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<MedicinePresentation> get _filteredProducts {
    final String normalizedQuery = _query.trim().toLowerCase();
    if (normalizedQuery.isEmpty) {
      return widget.products;
    }

    return widget.products
        .where((MedicinePresentation item) {
          return item.name.toLowerCase().contains(normalizedQuery) ||
              item.code.toLowerCase().contains(normalizedQuery);
        })
        .toList(growable: false);
  }

  void _toggleSelection(String productId) {
    setState(() {
      if (_selectedIds.contains(productId)) {
        _selectedIds.remove(productId);
      } else {
        _selectedIds.add(productId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(16),
      content: SizedBox(
        width: 560,
        height: 520,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Products',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _searchController,
              onChanged: (String value) {
                setState(() {
                  _query = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search medicine',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isEmpty
                    ? null
                    : IconButton(
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _query = '';
                          });
                        },
                        icon: const Icon(Icons.close),
                      ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Selected: ${_selectedIds.length}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _filteredProducts.isEmpty
                  ? const Center(child: Text('No products found.'))
                  : ListView.separated(
                      itemCount: _filteredProducts.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 8),
                      itemBuilder: (BuildContext context, int index) {
                        final MedicinePresentation item =
                            _filteredProducts[index];
                        final bool isSelected = _selectedIds.contains(item.id);
                        return ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(color: AppColors.border),
                          ),
                          tileColor: const Color(0xFFF9FBFE),
                          leading: Checkbox(
                            value: isSelected,
                            onChanged: (_) => _toggleSelection(item.id),
                          ),
                          title: Text(item.name),
                          subtitle: item.code.isEmpty ? null : Text(item.code),
                          onTap: () => _toggleSelection(item.id),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(_selectedIds),
          child: const Text('Done'),
        ),
      ],
    );
  }
}

enum _SlideKind { title, intro, product }

class _PresentationSlide {
  const _PresentationSlide({
    required this.kind,
    required this.title,
    this.subtitle = '',
    this.assetPath = '',
    this.localImagePath = '',
    this.imageUrl = '',
  });

  final _SlideKind kind;
  final String title;
  final String subtitle;
  final String assetPath;
  final String localImagePath;
  final String imageUrl;
}

class _PlanMeetAddDialog extends StatefulWidget {
  const _PlanMeetAddDialog({required this.viewModel});

  final HomeViewModel viewModel;

  @override
  State<_PlanMeetAddDialog> createState() => _PlanMeetAddDialogState();
}

class _PlanMeetAddDialogState extends State<_PlanMeetAddDialog> {
  final TextEditingController _searchController = TextEditingController();
  final Set<String> _selectedDoctorIds = <String>{};
  final Set<String> _selectedChemistIds = <String>{};
  bool _doctorTab = true;
  bool _isLoading = true;
  bool _isSubmitting = false;
  String _query = '';
  String? _errorMessage;
  List<PlanCustomerOption> _doctors = <PlanCustomerOption>[];
  List<PlanCustomerOption> _chemists = <PlanCustomerOption>[];

  @override
  void initState() {
    super.initState();
    _loadDropdownData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<PlanCustomerOption> get _source => _doctorTab ? _doctors : _chemists;

  List<PlanCustomerOption> get _filteredResults {
    final String normalizedQuery = _query.trim().toLowerCase();
    if (normalizedQuery.isEmpty) {
      return _source;
    }
    return _source
        .where(
          (PlanCustomerOption item) =>
              item.name.toLowerCase().contains(normalizedQuery) ||
              item.code.toLowerCase().contains(normalizedQuery),
        )
        .toList(growable: false);
  }

  bool get _canSubmit {
    return !_isSubmitting &&
        (_selectedDoctorIds.isNotEmpty || _selectedChemistIds.isNotEmpty);
  }

  Future<void> _loadDropdownData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final PlanDropdownData data = await widget.viewModel
          .fetchPlanDoctorChemistDropdown();
      if (!mounted) {
        return;
      }
      setState(() {
        _doctors = data.doctors;
        _chemists = data.chemists;
      });
    } on NetworkException catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _errorMessage = error.message;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _errorMessage = 'Unable to load doctor and chemist list.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _applySearch() {
    setState(() {
      _query = _searchController.text.trim();
    });
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _query = '';
    });
  }

  void _switchTab(bool doctorTab) {
    setState(() {
      _doctorTab = doctorTab;
      _searchController.clear();
      _query = '';
    });
  }

  void _toggleSelection(PlanCustomerOption item) {
    final Set<String> target = item.normalizedType == 'doctor'
        ? _selectedDoctorIds
        : _selectedChemistIds;

    setState(() {
      if (target.contains(item.id)) {
        target.remove(item.id);
      } else {
        target.add(item.id);
      }
    });
  }

  bool _isSelected(PlanCustomerOption item) {
    final Set<String> target = item.normalizedType == 'doctor'
        ? _selectedDoctorIds
        : _selectedChemistIds;
    return target.contains(item.id);
  }

  Future<void> _savePlans() async {
    if (!_canSubmit) {
      return;
    }

    final List<PlanCustomerOption> selectedCustomers = <PlanCustomerOption>[
      ..._doctors.where(
        (PlanCustomerOption item) => _selectedDoctorIds.contains(item.id),
      ),
      ..._chemists.where(
        (PlanCustomerOption item) => _selectedChemistIds.contains(item.id),
      ),
    ];

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      final String message = await widget.viewModel.createPlans(
        visitDate: DateTime.now(),
        customers: selectedCustomers,
      );
      if (!mounted) {
        return;
      }
      Navigator.of(context).pop(message);
    } on NetworkException catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _errorMessage = error.message;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _errorMessage = 'Unable to create plan right now.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(16),
      content: SizedBox(
        width: 580,
        height: 540,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Select Doctor/Chemist',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: _canSubmit ? _savePlans : null,
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Done'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_errorMessage != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF2F2),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFFFC9C9)),
                ),
                child: Text(
                  _errorMessage!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF9F1D1D),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
            Row(
              children: [
                Expanded(
                  child: _TypeTab(
                    label: 'Doctor (${_doctors.length})',
                    isSelected: _doctorTab,
                    onTap: () => _switchTab(true),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _TypeTab(
                    label: 'Chemist (${_chemists.length})',
                    isSelected: !_doctorTab,
                    onTap: () => _switchTab(false),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    textInputAction: TextInputAction.search,
                    onChanged: (_) => setState(() {}),
                    onSubmitted: (_) => _applySearch(),
                    decoration: InputDecoration(
                      hintText: 'Search ${_doctorTab ? 'doctor' : 'chemist'}',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchController.text.isEmpty
                          ? null
                          : IconButton(
                              onPressed: _clearSearch,
                              icon: const Icon(Icons.close),
                            ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  height: 46,
                  child: ElevatedButton(
                    onPressed: _applySearch,
                    child: const Text('Search'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              'Selected: Doctors ${_selectedDoctorIds.length} | Chemists ${_selectedChemistIds.length}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 12,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredResults.isEmpty
                  ? Center(
                      child: Text(
                        'No ${_doctorTab ? 'doctor' : 'chemist'} found.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    )
                  : ListView.separated(
                      itemCount: _filteredResults.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 8),
                      itemBuilder: (BuildContext context, int index) {
                        final PlanCustomerOption item = _filteredResults[index];
                        final bool isSelected = _isSelected(item);
                        return ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(color: AppColors.border),
                          ),
                          tileColor: const Color(0xFFF9FBFE),
                          title: Text(
                            item.name,
                            style: Theme.of(
                              context,
                            ).textTheme.bodyLarge?.copyWith(fontSize: 14),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (item.code.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Text(
                                    item.code,
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(
                                          color: AppColors.textSecondary,
                                        ),
                                  ),
                                ),
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  'Potential: ${_displayValue(item.potential)}'
                                  '  |  Support: ${_displayValue(item.supportValue)}'
                                  '  |  Expected: ${_displayValue(item.expectedSupportValue)}',
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                ),
                              ),
                            ],
                          ),
                          leading: Checkbox(
                            value: isSelected,
                            onChanged: (_) => _toggleSelection(item),
                          ),
                          trailing: Text(
                            item.typeLabel,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          onTap: () => _toggleSelection(item),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}

String _displayValue(String value) {
  final String trimmed = value.trim();
  return trimmed.isEmpty ? '-' : trimmed;
}

class _TypeTab extends StatelessWidget {
  const _TypeTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? AppColors.primaryBlueDark : AppColors.border,
              width: isSelected ? 3 : 1,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(
            label,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontSize: 15,
              color: isSelected
                  ? AppColors.primaryBlueDark
                  : AppColors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
