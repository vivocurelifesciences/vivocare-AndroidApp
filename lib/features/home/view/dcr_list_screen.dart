import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vivocure/core/layout/responsive.dart';
import 'package:vivocure/core/network/network_exception.dart';
import 'package:vivocure/core/theme/app_colors.dart';
import 'package:vivocure/core/widgets/app_alert_dialog.dart';
import 'package:vivocure/core/widgets/app_page_backdrop.dart';
import 'package:vivocure/core/widgets/app_panel.dart';
import 'package:vivocure/features/home/view_model/home_view_model.dart';

class DcrListScreen extends StatefulWidget {
  const DcrListScreen({super.key, required this.viewModel});

  final HomeViewModel viewModel;

  @override
  State<DcrListScreen> createState() => _DcrListScreenState();
}

/// Opens the pre-filled "Make a DCR" bottom sheet for [entry] and returns the
/// success message (or null if dismissed). Shared by the DCR list and the
/// post-presentation quick-create flow so both reuse the same pre-population
/// (presented products + customer support values) and one-DCR-per-plan rule.
Future<String?> showDcrCreationSheet(
  BuildContext context, {
  required PlanMeetEntry entry,
  required HomeViewModel viewModel,
}) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => FractionallySizedBox(
      heightFactor: 0.9,
      child: _PlanDcrCreationSheet(entry: entry, viewModel: viewModel),
    ),
  );
}

class _DcrListScreenState extends State<DcrListScreen> {
  int _activeSectionIndex = 0;
  bool _didCreateDcr = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.viewModel.fetchPlanMeetEntries(visitDate: DateTime.now());
      widget.viewModel.fetchTodayDcrEntries();
    });
  }

  Future<void> _selectPlanDate() async {
    final DateTime initialDate = widget.viewModel.currentPlanMeetDate;
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDate == null) {
      return;
    }

    await widget.viewModel.fetchPlanMeetEntries(visitDate: pickedDate);
  }

  Future<void> _selectDcrDate({required bool isStartDate}) async {
    final DateTime initialDate = isStartDate
        ? widget.viewModel.dcrStartDate
        : widget.viewModel.dcrEndDate;
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDate == null) {
      return;
    }

    final DateTime nextStartDate = isStartDate
        ? pickedDate
        : widget.viewModel.dcrStartDate;
    final DateTime nextEndDate = isStartDate
        ? widget.viewModel.dcrEndDate
        : pickedDate;
    await widget.viewModel.setDcrDateRange(
      startDate: nextStartDate,
      endDate: nextEndDate,
    );
  }

  Future<void> _openCreateDcrSheet(PlanMeetEntry entry) async {
    final String? message = await showDcrCreationSheet(
      context,
      entry: entry,
      viewModel: widget.viewModel,
    );

    if (!mounted || message == null) {
      return;
    }

    _didCreateDcr = true;
    await AppAlertDialog.showSuccess(context: context, message: message);
  }

  void _closeScreen() {
    if (!mounted) {
      return;
    }
    Navigator.of(context).pop(_didCreateDcr);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.viewModel,
      builder: (BuildContext context, _) {
        final HomeViewModel viewModel = widget.viewModel;

        return PopScope<void>(
          canPop: false,
          onPopInvokedWithResult: (bool didPop, void _) {
            if (didPop) {
              return;
            }
            _closeScreen();
          },
          child: Scaffold(
            body: AppPageBackdrop(
              child: SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
                      child: AppPanel(
                        padding: const EdgeInsets.all(20),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: <Color>[Color(0xFFF8FBFF), Color(0xFFEAF4FF)],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            IconButton(
                              onPressed: _closeScreen,
                              icon: const Icon(Icons.arrow_back_rounded),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Create DCR',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall
                                        ?.copyWith(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w700,
                                        ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Use Make a DCR to submit new DCR from plan entries, or use Get DCR List to load existing DCR records.',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: _SectionTab(
                                    label: 'Make a DCR',
                                    isSelected: _activeSectionIndex == 0,
                                    onTap: () {
                                      setState(() {
                                        _activeSectionIndex = 0;
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: _SectionTab(
                                    label: 'Get DCR List',
                                    isSelected: _activeSectionIndex == 1,
                                    onTap: () {
                                      setState(() {
                                        _activeSectionIndex = 1;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            if (_activeSectionIndex == 0)
                              _MakeDcrSection(
                                viewModel: viewModel,
                                selectedDate: viewModel.currentPlanMeetDate,
                                onPlanDateTap: _selectPlanDate,
                                onCreateDcrTap: _openCreateDcrSheet,
                              )
                            else
                              _DcrHistorySection(
                                viewModel: viewModel,
                                onTodayTap: viewModel.fetchTodayDcrEntries,
                                onStartDateTap: () =>
                                    _selectDcrDate(isStartDate: true),
                                onEndDateTap: () =>
                                    _selectDcrDate(isStartDate: false),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _MakeDcrSection extends StatelessWidget {
  const _MakeDcrSection({
    required this.viewModel,
    required this.selectedDate,
    required this.onPlanDateTap,
    required this.onCreateDcrTap,
  });

  final HomeViewModel viewModel;
  final DateTime selectedDate;
  final Future<void> Function() onPlanDateTap;
  final Future<void> Function(PlanMeetEntry entry) onCreateDcrTap;

  @override
  Widget build(BuildContext context) {
    final List<PlanMeetEntry> pendingPlanEntries =
        viewModel.pendingPlanMeetEntriesForDcr;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 10,
          runSpacing: 10,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            _DateInfoChip(
              label: 'Plan Date',
              value: viewModel.formatDcrDropdownDate(selectedDate),
              isSelected: true,
              onTap: onPlanDateTap,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Text(
                '${pendingPlanEntries.length} plan${pendingPlanEntries.length == 1 ? '' : 's'}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        if (viewModel.isPlanMeetLoading)
          const _EmptySectionCard(message: 'Loading plans for selected date...')
        else if (viewModel.planMeetErrorMessage != null)
          _EmptySectionCard(message: viewModel.planMeetErrorMessage!)
        else if (pendingPlanEntries.isEmpty)
          _EmptySectionCard(
            message:
                'No plan entry available for ${viewModel.formatShortDate(selectedDate)}.',
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: pendingPlanEntries.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (BuildContext context, int index) {
              final PlanMeetEntry entry = pendingPlanEntries[index];
              final CustomerProfile profile = viewModel
                  .getCustomerProfileForEntry(entry);

              return AppPanel(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: entry.isDoctor
                                ? const Color(0xFFE8F6FA)
                                : const Color(0xFFFFF5E8),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            entry.typeLabel,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          viewModel.formatShortDate(entry.visitDate),
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      entry.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${entry.customerCode.isEmpty ? '-' : entry.customerCode} • ${profile.city.isEmpty ? '-' : profile.city}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
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
                      ],
                    ),
                    const SizedBox(height: 14),
                    LayoutBuilder(
                      builder:
                          (BuildContext context, BoxConstraints constraints) {
                            final bool isCompact = constraints.maxWidth < 540;
                            final Widget actionButton = SizedBox(
                              height: 44,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryBlueDark,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                onPressed: entry.id.trim().isEmpty
                                    ? null
                                    : () => onCreateDcrTap(entry),
                                icon: const Icon(
                                  Icons.checklist_rounded,
                                  size: 18,
                                ),
                                label: const Text('Select Plan'),
                              ),
                            );

                            if (isCompact) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Choose this planned visit to create DCR.',
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(
                                          color: AppColors.textSecondary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                  const SizedBox(height: 10),
                                  SizedBox(
                                    width: double.infinity,
                                    child: actionButton,
                                  ),
                                ],
                              );
                            }

                            return Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Choose this planned visit to create DCR.',
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(
                                          color: AppColors.textSecondary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                actionButton,
                              ],
                            );
                          },
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }
}

class _DcrHistorySection extends StatelessWidget {
  const _DcrHistorySection({
    required this.viewModel,
    required this.onTodayTap,
    required this.onStartDateTap,
    required this.onEndDateTap,
  });

  final HomeViewModel viewModel;
  final Future<void> Function() onTodayTap;
  final Future<void> Function() onStartDateTap;
  final Future<void> Function() onEndDateTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            ChoiceChip(
              label: const Text('Today'),
              selected: viewModel.isTodayDcrFilter,
              onSelected: (_) => onTodayTap(),
              selectedColor: const Color(0xFFDDEEFF),
              side: const BorderSide(color: AppColors.border),
              labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            _DateInfoChip(
              label: 'From',
              value: viewModel.formatDcrDropdownDate(viewModel.dcrStartDate),
              isSelected: !viewModel.isTodayDcrFilter,
              onTap: onStartDateTap,
            ),
            _DateInfoChip(
              label: 'To',
              value: viewModel.formatDcrDropdownDate(viewModel.dcrEndDate),
              isSelected: !viewModel.isTodayDcrFilter,
              onTap: onEndDateTap,
            ),
          ],
        ),
        const SizedBox(height: 14),
        if (viewModel.isDcrLoading)
          const _EmptySectionCard(message: 'Loading DCR entries...')
        else if (viewModel.dcrErrorMessage != null)
          _EmptySectionCard(message: viewModel.dcrErrorMessage!)
        else if (viewModel.dcrEntries.isEmpty)
          const _EmptySectionCard(
            message: 'No DCR found for the selected filter.',
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: viewModel.dcrEntries.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (BuildContext context, int index) {
              final DcrEntry entry = viewModel.dcrEntries[index];
              return _DcrEntryCard(entry: entry, viewModel: viewModel);
            },
          ),
      ],
    );
  }
}

class _PlanDcrCreationSheet extends StatefulWidget {
  const _PlanDcrCreationSheet({required this.entry, required this.viewModel});

  final PlanMeetEntry entry;
  final HomeViewModel viewModel;

  @override
  State<_PlanDcrCreationSheet> createState() => _PlanDcrCreationSheetState();
}

class _PlanDcrCreationSheetState extends State<_PlanDcrCreationSheet> {
  /// Ordered: the rep's presentation sequence is preserved end-to-end.
  final List<String> _selectedMedicineIds = <String>[];
  late final TextEditingController _supportValueController;
  late final TextEditingController _expectedSupportValueController;
  bool _isCreatingDcr = false;
  String? _errorMessage;
  CustomerPresentationHistory? _history;
  bool _historyExpanded = false;
  bool _prefilledFromPresentation = false;
  bool _prefilledFromCustomer = false;

  /// Sample quantity per selected product id (defaults to 1 when selected).
  final Map<String, int> _quantities = <String, int>{};

  /// The DCR's visit date — defaults to the plan's date, editable for
  /// backdated entries.
  late DateTime _visitDate;

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

  bool get _canSubmit {
    return !_isCreatingDcr && widget.entry.id.trim().isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    final CustomerProfile customer = widget.viewModel
        .getCustomerProfileForEntry(widget.entry);
    _supportValueController = TextEditingController(
      text: _initialNumericValue(customer.supportValue),
    );
    _expectedSupportValueController = TextEditingController(
      text: _initialNumericValue(customer.expectedSupportValue),
    );
    _visitDate = widget.entry.visitDate;
    _loadPresentationSelection();
  }

  /// Ensures every selected product has a quantity (default 1).
  void _syncQuantityDefaults() {
    for (final String id in _selectedMedicineIds) {
      _quantities.putIfAbsent(id, () => 1);
    }
    _quantities.removeWhere(
      (String id, _) => !_selectedMedicineIds.contains(id),
    );
  }

  Future<void> _loadPresentationSelection() async {
    // Pre-fill priority: (1) exactly what was shown in View Presentation for
    // this visit (per plan); else (2) the products last used for this same
    // customer (per doctor/chemist). The rep can still edit before saving.
    final List<String> presented = await widget.viewModel
        .loadPresentedSelection(widget.entry.id);
    final List<String> lastForCustomer = await widget.viewModel
        .loadCustomerProductSelection(
          customerType: widget.entry.type,
          customerId: widget.entry.customerId,
        );
    final bool usingPresented = presented.isNotEmpty;
    final List<String> source = usingPresented ? presented : lastForCustomer;
    final Map<String, MedicinePresentation> byId =
        <String, MedicinePresentation>{
          for (final MedicinePresentation m
              in widget.viewModel.getMedicinePresentationsByIds(source))
            m.id: m,
        };

    final CustomerPresentationHistory? history = await widget.viewModel
        .fetchPresentationHistory(widget.entry);
    if (!mounted) {
      return;
    }
    setState(() {
      _history = history;
      if (_selectedMedicineIds.isEmpty && source.isNotEmpty) {
        _selectedMedicineIds.addAll(source.where(byId.containsKey));
        _prefilledFromPresentation = usingPresented;
        _prefilledFromCustomer =
            !usingPresented && _selectedMedicineIds.isNotEmpty;
      }
      _syncQuantityDefaults();
    });
  }

  Future<void> _pickVisitDate() async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _visitDate,
      firstDate: DateTime(2020),
      lastDate: now,
      helpText: 'Select DCR visit date',
    );
    if (picked == null || !mounted) {
      return;
    }
    setState(() {
      _visitDate = DateTime(picked.year, picked.month, picked.day);
    });
  }

  @override
  void dispose() {
    _supportValueController.dispose();
    _expectedSupportValueController.dispose();
    super.dispose();
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
      // Keep the rep's existing order; append newly picked products after.
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
      _syncQuantityDefaults();
    });
  }

  void _setQuantity(String productId, int qty) {
    setState(() {
      _quantities[productId] = qty.clamp(1, 9999);
    });
  }

  void _shuffleSelected() {
    if (_selectedMedicineIds.length < 2) {
      return;
    }
    setState(() {
      _selectedMedicineIds.shuffle(math.Random());
    });
  }

  void _onReorderSelected(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final String moved = _selectedMedicineIds.removeAt(oldIndex);
      _selectedMedicineIds.insert(newIndex, moved);
    });
  }

  Future<void> _submit() async {
    if (!_canSubmit) {
      return;
    }

    final int? supportValue = _parseNumber(_supportValueController.text);
    final int? expectedSupportValue = _parseNumber(
      _expectedSupportValueController.text,
    );
    if (supportValue == null || expectedSupportValue == null) {
      setState(() {
        _errorMessage =
            'Enter valid integer values for support and expected support.';
      });
      return;
    }

    setState(() {
      _isCreatingDcr = true;
      _errorMessage = null;
    });

    try {
      final String message = await widget.viewModel.createDcr(
        planId: widget.entry.id,
        supportValue: supportValue,
        expectedSupportValue: expectedSupportValue,
        productIds: _selectedMedicineIds.toList(growable: false),
        productQuantities: Map<String, int>.fromEntries(
          _selectedMedicineIds.map(
            (String id) => MapEntry<String, int>(id, _quantities[id] ?? 1),
          ),
        ),
        visitDate: _visitDate,
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
        _errorMessage = 'Unable to create DCR right now.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isCreatingDcr = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final CustomerProfile customer = widget.viewModel
        .getCustomerProfileForEntry(widget.entry);

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
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Make a DCR',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customer.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${widget.entry.typeLabel} • ${widget.entry.customerCode.isEmpty ? '-' : widget.entry.customerCode} • ${widget.viewModel.formatShortDate(widget.entry.visitDate)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
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
                    if (_history != null) ...[
                      const SizedBox(height: 14),
                      _PresentationHistoryCard(
                        history: _history!,
                        formatDate: widget.viewModel.formatShortDate,
                        expanded: _historyExpanded,
                        autoLoaded: false,
                        onToggleExpanded: () {
                          setState(() {
                            _historyExpanded = !_historyExpanded;
                          });
                        },
                        onSelectAll: () {
                          setState(() {
                            _selectedMedicineIds
                              ..clear()
                              ..addAll(
                                _history!.allShownMedicines.map(
                                  (MedicinePresentation m) => m.id,
                                ),
                              );
                          });
                        },
                      ),
                    ],
                    const SizedBox(height: 14),
                    // Backdated DCRs: pick the visit date (defaults to plan).
                    InkWell(
                      onTap: _pickVisitDate,
                      borderRadius: BorderRadius.circular(12),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Visit date',
                          prefixIcon: Icon(Icons.event_outlined),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.viewModel.formatShortDate(_visitDate),
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const Icon(
                              Icons.edit_calendar_outlined,
                              size: 18,
                              color: AppColors.textSecondary,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _supportValueController,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: const InputDecoration(
                              labelText: 'Support Value',
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _expectedSupportValueController,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: const InputDecoration(
                              labelText: 'Expected Support Value',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    if (widget.viewModel.medicinePresentations.isEmpty)
                      const _EmptySectionCard(
                        message:
                            'No products available yet. Product images are loaded from local cache after login.',
                      )
                    else ...[
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Presentation (${_selectedMedicines.length})',
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ),
                          IconButton(
                            tooltip: 'Shuffle order',
                            onPressed: _selectedMedicines.length < 2
                                ? null
                                : _shuffleSelected,
                            icon: const Icon(Icons.shuffle_rounded, size: 20),
                          ),
                          OutlinedButton.icon(
                            onPressed: _openMedicineSelector,
                            icon: const Icon(
                              Icons.medication_outlined,
                              size: 18,
                            ),
                            label: const Text('Select Medicine'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      if (_prefilledFromPresentation || _prefilledFromCustomer)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            _prefilledFromPresentation
                                ? 'Pre-filled with the products you showed in '
                                      'View Presentation. Adjust if needed.'
                                : 'Pre-filled with this customer\'s last '
                                      'products. Adjust if needed.',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(fontStyle: FontStyle.italic),
                          ),
                        ),
                      if (_selectedMedicines.isEmpty)
                        const _EmptySectionCard(
                          message:
                              'Products are optional. Select medicines only if you want to attach them to this DCR.',
                        )
                      else ...[
                        Text(
                          'Drag to set the order you will present in.',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 8),
                        ReorderableListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          buildDefaultDragHandles: false,
                          itemCount: _selectedMedicines.length,
                          onReorder: _onReorderSelected,
                          proxyDecorator:
                              (Widget child, int index, Animation<double> a) =>
                                  Material(
                                    color: Colors.transparent,
                                    elevation: 4,
                                    borderRadius: BorderRadius.circular(12),
                                    child: child,
                                  ),
                          itemBuilder: (BuildContext context, int index) {
                            final MedicinePresentation item =
                                _selectedMedicines[index];
                            final int qty = _quantities[item.id] ?? 1;
                            return _SelectedMedicineTile(
                              key: ValueKey<String>(item.id),
                              index: index,
                              medicine: item,
                              quantity: qty,
                              onQuantityChanged: (int next) =>
                                  _setQuantity(item.id, next),
                              onRemove: () {
                                setState(() {
                                  _selectedMedicineIds.remove(item.id);
                                });
                              },
                            );
                          },
                        ),
                      ],
                    ],
                  ],
                ),
              ),
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF2F2),
                  borderRadius: BorderRadius.circular(12),
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
            ],
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton.icon(
                onPressed: _canSubmit ? _submit : null,
                icon: _isCreatingDcr
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.description_outlined),
                label: Text(_isCreatingDcr ? 'Creating...' : 'Create DCR'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _initialNumericValue(String value) {
    final String trimmed = value.trim();
    return trimmed.isEmpty || trimmed == '-' ? '0' : trimmed;
  }

  int? _parseNumber(String value) {
    final String trimmed = value.trim();
    if (trimmed.isEmpty) {
      return 0;
    }
    return int.tryParse(trimmed);
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
        .where(
          (MedicinePresentation item) =>
              item.name.toLowerCase().contains(normalizedQuery) ||
              item.code.toLowerCase().contains(normalizedQuery),
        )
        .toList(growable: false);
  }

  void _applySearch() {
    setState(() {
      _query = _searchController.text.trim();
    });
  }

  void _toggleSelection(String id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = context.dialogSize(tabletWidth: 540, tabletHeight: 520);
    return AlertDialog(
      contentPadding: const EdgeInsets.all(16),
      content: SizedBox(
        width: size.width,
        height: size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Medicine',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                    onSubmitted: (_) => _applySearch(),
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
            const SizedBox(height: 12),
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

class _SectionTab extends StatelessWidget {
  const _SectionTab({
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
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFDDEEFF) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primaryBlueDark : AppColors.border,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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

class _EmptySectionCard extends StatelessWidget {
  const _EmptySectionCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return AppPanel(child: Text(message));
  }
}

class _DcrEntryCard extends StatelessWidget {
  const _DcrEntryCard({required this.entry, required this.viewModel});

  final DcrEntry entry;
  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return AppPanel(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CalendarDateBadge(date: entry.dcrDate),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: entry.normalizedType == 'doctor'
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
                    if (entry.customerCode.isNotEmpty)
                      Text(
                        entry.customerCode,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  entry.customerName,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Visit Date: ${viewModel.formatDcrDropdownDate(entry.dcrDate)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _MetricPill(
                      label: 'Support',
                      value: _displayValue(entry.supportValue),
                    ),
                    _MetricPill(
                      label: 'Expected',
                      value: _displayValue(entry.expectedSupportValue),
                    ),
                  ],
                ),
                if (entry.products.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Text(
                    'Products',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: entry.products
                        .map<Widget>(
                          (DcrProduct product) => Chip(
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            visualDensity: VisualDensity.compact,
                            backgroundColor: const Color(0xFFF6FAFE),
                            side: const BorderSide(color: AppColors.border),
                            label: Text(
                              product.quantity > 0
                                  ? '${product.displayLabel}  ×${product.quantity}'
                                  : product.displayLabel,
                            ),
                          ),
                        )
                        .toList(growable: false),
                  ),
                ],
              ],
            ),
          ),
        ],
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

class _CalendarDateBadge extends StatelessWidget {
  const _CalendarDateBadge({required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    const List<String> months = <String>[
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC',
    ];

    return Container(
      width: 82,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FBFF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.borderStrong),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            months[date.month - 1],
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.primaryBlueDark,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            date.day.toString().padLeft(2, '0'),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '${date.year}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _DateInfoChip extends StatelessWidget {
  const _DateInfoChip({
    required this.label,
    required this.value,
    this.onTap,
    this.isSelected = false,
  });

  final String label;
  final String value;
  final VoidCallback? onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFDDEEFF) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.primaryBlueDark : AppColors.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            if (onTap != null) ...[
              const SizedBox(width: 10),
              const Icon(
                Icons.calendar_month_outlined,
                size: 18,
                color: AppColors.primaryBlueDark,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

String _displayValue(String value) {
  final String trimmed = value.trim();
  return trimmed.isEmpty ? '-' : trimmed;
}

/// "Previously shown to this customer" — the permanent presentation history.
/// Collapsed: union of products with a recency note. Expanded: visit-by-visit
/// log, most recent first.
class _PresentationHistoryCard extends StatelessWidget {
  const _PresentationHistoryCard({
    required this.history,
    required this.formatDate,
    required this.expanded,
    required this.autoLoaded,
    required this.onToggleExpanded,
    required this.onSelectAll,
  });

  final CustomerPresentationHistory history;
  final String Function(DateTime) formatDate;
  final bool expanded;
  final bool autoLoaded;
  final VoidCallback onToggleExpanded;
  final VoidCallback onSelectAll;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final DateTime? lastDate = history.visits.first.visitDate;
    final String subtitle =
        '${history.allShownMedicines.length} product'
        '${history.allShownMedicines.length == 1 ? '' : 's'} across '
        '${history.visits.length} visit'
        '${history.visits.length == 1 ? '' : 's'}'
        '${lastDate == null ? '' : ' · last on ${formatDate(lastDate)}'}';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primaryBlue.withValues(alpha: 0.25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.history, size: 18, color: AppColors.primaryBlue),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Previously shown',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: AppColors.primaryBlue,
                      ),
                    ),
                    Text(subtitle, style: theme.textTheme.bodySmall),
                  ],
                ),
              ),
              TextButton(
                onPressed: onSelectAll,
                style: TextButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                ),
                child: const Text('Select all'),
              ),
              IconButton(
                tooltip: expanded ? 'Hide history' : 'View history',
                visualDensity: VisualDensity.compact,
                onPressed: onToggleExpanded,
                icon: Icon(
                  expanded ? Icons.expand_less : Icons.expand_more,
                  color: AppColors.primaryBlue,
                ),
              ),
            ],
          ),
          if (autoLoaded) ...[
            const SizedBox(height: 6),
            Text(
              'Loaded into your presentation automatically — deselect '
              'anything you will skip this visit.',
              style: theme.textTheme.bodySmall?.copyWith(
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
          const SizedBox(height: 8),
          if (!expanded)
            _medicineChips(theme, history.allShownMedicines)
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: history.visits
                  .map(
                    (PresentationHistoryVisit visit) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            visit.visitDate == null
                                ? 'Earlier visit'
                                : formatDate(visit.visitDate!),
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: AppColors.primaryBlueDark,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          _medicineChips(theme, visit.medicines),
                        ],
                      ),
                    ),
                  )
                  .toList(growable: false),
            ),
        ],
      ),
    );
  }

  Widget _medicineChips(ThemeData theme, List<MedicinePresentation> items) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items
          .map(
            (MedicinePresentation medicine) => Chip(
              visualDensity: VisualDensity.compact,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              backgroundColor: Colors.white,
              side: BorderSide(
                color: AppColors.primaryBlue.withValues(alpha: 0.3),
              ),
              label: Text(
                medicine.name,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          )
          .toList(growable: false),
    );
  }
}

/// One row of the in-sheet presentation order: position, name, sample-quantity
/// stepper, remove, drag handle.
class _SelectedMedicineTile extends StatelessWidget {
  const _SelectedMedicineTile({
    super.key,
    required this.index,
    required this.medicine,
    required this.quantity,
    required this.onQuantityChanged,
    required this.onRemove,
  });

  final int index;
  final MedicinePresentation medicine;
  final int quantity;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Text(
                '${index + 1}',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: AppColors.primaryBlue,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    medicine.code.isEmpty
                        ? medicine.name
                        : '${medicine.name} (${medicine.code})',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Sample qty: $quantity',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            _QuantityStepper(quantity: quantity, onChanged: onQuantityChanged),
            IconButton(
              tooltip: 'Remove',
              visualDensity: VisualDensity.compact,
              onPressed: onRemove,
              icon: const Icon(Icons.close, size: 18),
            ),
            ReorderableDragStartListener(
              index: index,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                child: Icon(
                  Icons.drag_handle,
                  size: 20,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Compact -/+ stepper for a product's sample quantity (minimum 1).
class _QuantityStepper extends StatelessWidget {
  const _QuantityStepper({required this.quantity, required this.onChanged});

  final int quantity;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardTint,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepButton(
            icon: Icons.remove,
            onTap: quantity > 1 ? () => onChanged(quantity - 1) : null,
          ),
          SizedBox(
            width: 28,
            child: Text(
              '$quantity',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          _StepButton(icon: Icons.add, onTap: () => onChanged(quantity + 1)),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Icon(
          icon,
          size: 18,
          color: onTap == null
              ? AppColors.textSecondary.withValues(alpha: 0.4)
              : AppColors.primaryBlue,
        ),
      ),
    );
  }
}
