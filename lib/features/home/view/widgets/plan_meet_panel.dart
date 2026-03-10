import 'dart:io';

import 'package:flutter/material.dart';
import 'package:vivocare/core/network/network_exception.dart';
import 'package:vivocare/core/theme/app_colors.dart';
import 'package:vivocare/features/home/view_model/home_view_model.dart';

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
    if (!entry.isDoctor) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Doctor details are available for doctors.'),
        ),
      );
      return;
    }

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) =>
          _DoctorDetailsSheet(doctorName: entry.name, viewModel: viewModel),
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'Plan & Meet',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.end,
                children: [
                  SizedBox(
                    height: 38,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final String? message = await showDialog<String>(
                          context: context,
                          builder: (_) =>
                              _PlanMeetAddDialog(viewModel: viewModel),
                        );
                        if (context.mounted && message != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(message)),
                          );
                        }
                      },
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Add'),
                    ),
                  ),
                  SizedBox(
                    height: 38,
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        await showDialog<void>(
                          context: context,
                          builder: (_) =>
                              _CreateDcrDialog(viewModel: viewModel),
                        );
                      },
                      icon: const Icon(Icons.description_outlined, size: 18),
                      label: const Text('Create DCR'),
                    ),
                  ),
                ],
              ),
            ],
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
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: viewModel.planMeetEntries.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (BuildContext context, int index) {
                final PlanMeetEntry entry = viewModel.planMeetEntries[index];
                return _PlanEntryCard(
                  entry: entry,
                  viewModel: viewModel,
                  onTap: () => _openQuickEntryDetails(context, entry),
                );
              },
            ),
          const SizedBox(height: 20),
          Text(
            'DCR Entries',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          if (viewModel.dcrEntries.isEmpty)
            const _EmptySectionCard(
              message: 'No DCR created yet. Tap Create DCR to add one.',
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
      ),
    );
  }
}

class _EmptySectionCard extends StatelessWidget {
  const _EmptySectionCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(padding: const EdgeInsets.all(20), child: Text(message)),
    );
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
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: entry.isDoctor
                      ? const Color(0xFFE8F6FA)
                      : const Color(0xFFFFF5E8),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  entry.typeLabel,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 12,
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
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Date: ${viewModel.formatShortDate(entry.visitDate)}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
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
      ),
    );
  }
}

class _DoctorDetailsSheet extends StatefulWidget {
  const _DoctorDetailsSheet({
    required this.doctorName,
    required this.viewModel,
  });

  final String doctorName;
  final HomeViewModel viewModel;

  @override
  State<_DoctorDetailsSheet> createState() => _DoctorDetailsSheetState();
}

class _DoctorDetailsSheetState extends State<_DoctorDetailsSheet> {
  final Set<String> _selectedMedicineIds = <String>{};

  List<MedicinePresentation> get _selectedMedicines {
    return widget.viewModel.getMedicinePresentationsByIds(_selectedMedicineIds);
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

  @override
  Widget build(BuildContext context) {
    final DoctorProfile doctor = widget.viewModel.getDoctorProfile(
      widget.doctorName,
    );

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          top: 16,
          right: 16,
          bottom: 16 + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Doctor Full Details',
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
              Text(
                doctor.name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              _DetailLine(label: 'Qualification', value: doctor.qualification),
              _DetailLine(label: 'Speciality', value: doctor.speciality),
              _DetailLine(label: 'Phone', value: doctor.phone),
              _DetailLine(label: 'Area', value: doctor.area),
              _DetailLine(label: 'City', value: doctor.city),
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
                        'Selected Products (${_selectedMedicines.length})',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: _openMedicineSelector,
                      icon: const Icon(Icons.medication_outlined, size: 18),
                      label: const Text('Select Medicine'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                if (_selectedMedicines.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7FAFD),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Text(
                      'Select one or more products to view the slideshow.',
                    ),
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
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton.icon(
                    onPressed: _selectedMedicines.isEmpty
                        ? null
                        : () {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => _MedicinePresentationScreen(
                                  presentations: _selectedMedicines,
                                ),
                              ),
                            );
                          },
                    icon: const Icon(Icons.slideshow_outlined),
                    label: const Text('View Presentation'),
                  ),
                ),
              ],
            ],
          ),
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

class _MedicinePresentationScreen extends StatefulWidget {
  const _MedicinePresentationScreen({required this.presentations});

  final List<MedicinePresentation> presentations;

  @override
  State<_MedicinePresentationScreen> createState() =>
      _MedicinePresentationScreenState();
}

class _MedicinePresentationScreenState
    extends State<_MedicinePresentationScreen> {
  int _activeSlideIndex = 0;

  List<_PresentationSlide> get _slides => <_PresentationSlide>[
    const _PresentationSlide(
      title: 'Vivocure',
      assetPath: 'assets/images/vivocare_logo.jpeg',
    ),
    ...widget.presentations.map(
      (MedicinePresentation item) => _PresentationSlide(
        title: item.code.isEmpty ? item.name : '${item.name} (${item.code})',
        localImagePath: item.localImagePath,
        imageUrl: item.imageUrl,
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final _PresentationSlide activeSlide = _slides[_activeSlideIndex];
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          _buildSlideshowView(context),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Row(
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        activeSlide.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlideshowView(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            itemCount: _slides.length,
            onPageChanged: (int index) {
              setState(() {
                _activeSlideIndex = index;
              });
            },
            itemBuilder: (BuildContext context, int index) {
              final _PresentationSlide slide = _slides[index];
              return InteractiveViewer(
                minScale: 1,
                maxScale: 4,
                child: Center(
                  child: _buildSlideImage(slide),
                ),
              );
            },
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 6, 12, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List<Widget>.generate(_slides.length, (
                int index,
              ) {
                final bool isActive = _activeSlideIndex == index;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: isActive ? 18 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColors.primaryBlue
                        : AppColors.textSecondary.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(999),
                  ),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSlideImage(_PresentationSlide slide) {
    if (slide.assetPath.isNotEmpty) {
      return Image.asset(
        slide.assetPath,
        fit: BoxFit.contain,
        width: double.infinity,
      );
    }

    if (slide.localImagePath.isNotEmpty &&
        File(slide.localImagePath).existsSync()) {
      return Image.file(
        File(slide.localImagePath),
        fit: BoxFit.contain,
        width: double.infinity,
      );
    }

    if (slide.imageUrl.isNotEmpty) {
      return Image.network(
        slide.imageUrl,
        fit: BoxFit.contain,
        width: double.infinity,
        errorBuilder: (_, _, _) => _buildSlideFallback(slide.title),
      );
    }

    return _buildSlideFallback(slide.title);
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

    return widget.products.where((MedicinePresentation item) {
      return item.name.toLowerCase().contains(normalizedQuery) ||
          item.code.toLowerCase().contains(normalizedQuery);
    }).toList(growable: false);
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
                        final MedicinePresentation item = _filteredProducts[index];
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

class _PresentationSlide {
  const _PresentationSlide({
    required this.title,
    this.assetPath = '',
    this.localImagePath = '',
    this.imageUrl = '',
  });

  final String title;
  final String assetPath;
  final String localImagePath;
  final String imageUrl;
}

class _DcrEntryCard extends StatelessWidget {
  const _DcrEntryCard({required this.entry, required this.viewModel});

  final DcrEntry entry;
  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.calendar_month_outlined,
                  size: 18,
                  color: AppColors.primaryBlueDark,
                ),
                const SizedBox(width: 6),
                Text(
                  viewModel.formatDcrDropdownDate(entry.dcrDate),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Doctors: ${entry.doctorNames.length} | Chemists: ${entry.chemistNames.length}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 12,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (entry.doctorNames.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                'Doctors',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 12,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: entry.doctorNames
                    .map<Widget>(
                      (String name) => Chip(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                        backgroundColor: const Color(0xFFE8F6FA),
                        side: const BorderSide(color: AppColors.border),
                        label: Text(
                          name,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                fontSize: 12,
                                color: AppColors.textPrimary,
                              ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
            if (entry.chemistNames.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                'Chemists',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 12,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: entry.chemistNames
                    .map<Widget>(
                      (String name) => Chip(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                        backgroundColor: const Color(0xFFFFF5E8),
                        side: const BorderSide(color: AppColors.border),
                        label: Text(
                          name,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                fontSize: 12,
                                color: AppColors.textPrimary,
                              ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
            const SizedBox(height: 8),
            Text(
              'Updated: ${viewModel.formatShortDate(entry.updatedAt)}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
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
      final PlanDropdownData data =
          await widget.viewModel.fetchPlanDoctorChemistDropdown();
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
                          subtitle: item.code.isEmpty
                              ? null
                              : Text(
                                  item.code,
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
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

class _CreateDcrDialog extends StatefulWidget {
  const _CreateDcrDialog({required this.viewModel});

  final HomeViewModel viewModel;

  @override
  State<_CreateDcrDialog> createState() => _CreateDcrDialogState();
}

class _CreateDcrDialogState extends State<_CreateDcrDialog> {
  final TextEditingController _searchController = TextEditingController();
  final Set<String> _selectedDoctors = <String>{};
  final Set<String> _selectedChemists = <String>{};

  late final List<DateTime> _dateOptions;
  DateTime? _selectedDate;
  bool _doctorTab = true;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _dateOptions = widget.viewModel.getDcrDateOptions();
    _selectedDate = _dateOptions.isEmpty ? null : _dateOptions.first;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<String> get _source => _doctorTab
      ? widget.viewModel.dummyDoctors
      : widget.viewModel.dummyChemists;

  List<String> get _filteredResults {
    final String normalizedQuery = _query.trim();
    if (normalizedQuery.isEmpty) {
      return _source;
    }
    final String q = normalizedQuery.toLowerCase();
    return _source
        .where((String item) => item.toLowerCase().contains(q))
        .toList();
  }

  bool get _canSave {
    return _selectedDate != null &&
        (_selectedDoctors.isNotEmpty || _selectedChemists.isNotEmpty);
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

  void _toggleSelection(String name) {
    final Set<String> target = _doctorTab
        ? _selectedDoctors
        : _selectedChemists;
    setState(() {
      if (target.contains(name)) {
        target.remove(name);
      } else {
        target.add(name);
      }
    });
  }

  bool _isSelected(String name) {
    final Set<String> target = _doctorTab
        ? _selectedDoctors
        : _selectedChemists;
    return target.contains(name);
  }

  void _saveDcr() {
    if (!_canSave) {
      return;
    }

    widget.viewModel.saveOrMergeDcr(
      date: _selectedDate!,
      doctors: _selectedDoctors.toList(growable: false),
      chemists: _selectedChemists.toList(growable: false),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(16),
      content: SizedBox(
        width: 620,
        height: 560,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Create DCR',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<DateTime>(
              initialValue: _selectedDate,
              decoration: const InputDecoration(labelText: 'DCR Date'),
              items: _dateOptions
                  .map(
                    (DateTime date) => DropdownMenuItem<DateTime>(
                      value: date,
                      child: Text(widget.viewModel.formatDcrDropdownDate(date)),
                    ),
                  )
                  .toList(),
              onChanged: (DateTime? value) {
                setState(() {
                  _selectedDate = value;
                });
              },
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _TypeTab(
                    label: 'Doctor (${widget.viewModel.dummyDoctors.length})',
                    isSelected: _doctorTab,
                    onTap: () => _switchTab(true),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _TypeTab(
                    label: 'Chemist (${widget.viewModel.dummyChemists.length})',
                    isSelected: !_doctorTab,
                    onTap: () => _switchTab(false),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
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
            const SizedBox(height: 10),
            Text(
              'Selected: Doctors ${_selectedDoctors.length} | Chemists ${_selectedChemists.length}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 12,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _filteredResults.isEmpty
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
                        final String item = _filteredResults[index];
                        final bool isSelected = _isSelected(item);

                        return ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(color: AppColors.border),
                          ),
                          tileColor: const Color(0xFFF9FBFE),
                          title: Text(
                            item,
                            style: Theme.of(
                              context,
                            ).textTheme.bodyLarge?.copyWith(fontSize: 14),
                          ),
                          leading: Checkbox(
                            value: isSelected,
                            onChanged: (_) => _toggleSelection(item),
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
        ElevatedButton(
          onPressed: _canSave ? _saveDcr : null,
          child: const Text('Save DCR'),
        ),
      ],
    );
  }
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
