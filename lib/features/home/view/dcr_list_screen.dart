import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vivocure/core/network/network_exception.dart';
import 'package:vivocure/core/theme/app_colors.dart';
import 'package:vivocure/core/widgets/app_page_backdrop.dart';
import 'package:vivocure/core/widgets/app_panel.dart';
import 'package:vivocure/features/home/view_model/home_view_model.dart';

class DcrListScreen extends StatefulWidget {
  const DcrListScreen({super.key, required this.viewModel});

  final HomeViewModel viewModel;

  @override
  State<DcrListScreen> createState() => _DcrListScreenState();
}

class _DcrListScreenState extends State<DcrListScreen> {
  int _activeSectionIndex = 0;

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
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => FractionallySizedBox(
        heightFactor: 0.9,
        child: _PlanDcrCreationSheet(entry: entry, viewModel: widget.viewModel),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.viewModel,
      builder: (BuildContext context, _) {
        final HomeViewModel viewModel = widget.viewModel;

        return Scaffold(
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
                            onPressed: () => Navigator.of(context).pop(),
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
                                  style: Theme.of(context).textTheme.bodyMedium,
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
                '${viewModel.planMeetEntries.length} plan${viewModel.planMeetEntries.length == 1 ? '' : 's'}',
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
        else if (viewModel.planMeetEntries.isEmpty)
          _EmptySectionCard(
            message:
                'No plan entry available for ${viewModel.formatShortDate(selectedDate)}.',
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: viewModel.planMeetEntries.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (BuildContext context, int index) {
              final PlanMeetEntry entry = viewModel.planMeetEntries[index];
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
  final Set<String> _selectedMedicineIds = <String>{};
  late final TextEditingController _supportValueController;
  late final TextEditingController _expectedSupportValueController;
  bool _isCreatingDcr = false;
  String? _errorMessage;

  List<MedicinePresentation> get _selectedMedicines {
    return widget.viewModel.getMedicinePresentationsByIds(_selectedMedicineIds);
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
        initialSelectedIds: _selectedMedicineIds,
      ),
    );

    if (!mounted || selectedIds == null) {
      return;
    }

    setState(() {
      _selectedMedicineIds
        ..clear()
        ..addAll(selectedIds);
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
      );
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
      Navigator.of(context).pop();
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
                              'Selected Products (${_selectedMedicines.length})',
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
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
                      if (_selectedMedicines.isEmpty)
                        const _EmptySectionCard(
                          message:
                              'Products are optional. Select medicines only if you want to attach them to this DCR.',
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
    return AlertDialog(
      contentPadding: const EdgeInsets.all(16),
      content: SizedBox(
        width: 540,
        height: 520,
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
                            label: Text(product.displayLabel),
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
