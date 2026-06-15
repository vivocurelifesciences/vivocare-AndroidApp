import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vivocure/core/app_services.dart';
import 'package:vivocure/core/db/app_database.dart' as db;
import 'package:vivocure/core/navigation/home_user_context.dart';
import 'package:vivocure/core/presentation/presentation_history_service.dart';
import 'package:vivocure/data/repositories/plan_repository.dart';
import 'package:vivocure/features/home/model/home_menu_item.dart';

class HomeViewModel extends ChangeNotifier {
  static const int homeMenuIndex = 0;
  static const int planMeetMenuIndex = 1;
  static const int executionMenuIndex = 2;
  static const int addDoctorMenuIndex = 3;
  static const int addChemistMenuIndex = 4;
  static const int logoutMenuIndex = 5;

  String _userName = '';
  String _roleName = '';
  String _employeeCode = '';
  int _selectedMenuIndex = homeMenuIndex;
  final List<PlanMeetEntry> _planMeetEntries = <PlanMeetEntry>[];
  final List<DcrEntry> _apiDcrEntries = <DcrEntry>[];
  final Set<String> _recentlyCreatedDcrPlanIds = <String>{};
  List<UpcomingEvent> _upcomingEvents = <UpcomingEvent>[];
  bool _isUpcomingEventsLoading = false;
  String? _upcomingEventsErrorMessage;
  String _upcomingEventsSectionLabel = 'Birthdays & Anniversaries';
  bool _isTodayPlanLoading = false;
  String? _todayPlanErrorMessage;
  int _todayVisits = 0;
  int _doctorVisits = 0;
  int _chemistVisits = 0;
  bool _isPlanMeetLoading = false;
  String? _planMeetErrorMessage;
  bool _isDcrLoading = false;
  String? _dcrErrorMessage;
  bool _isTodayDcrFilter = true;
  DateTime _dcrStartDate = DateTime.now();
  DateTime _dcrEndDate = DateTime.now();
  DateTime _currentPlanMeetDate = DateTime.now();
  List<MedicinePresentation> _medicinePresentations = <MedicinePresentation>[];
  final Map<String, CustomerProfile> _customerProfilesById =
      <String, CustomerProfile>{};

  // primary sidebar items
  List<HomeMenuItem> get menuItems => <HomeMenuItem>[
    HomeMenuItem(
      label: 'Home',
      icon: Icons.home_outlined,
      isActive: _selectedMenuIndex == homeMenuIndex,
    ),
    HomeMenuItem(
      label: 'Planning',
      icon: Icons.event_note_outlined,
      isActive: _selectedMenuIndex == planMeetMenuIndex,
    ),
    const HomeMenuItem(label: 'Execution', icon: Icons.trending_up_outlined),
    const HomeMenuItem(label: 'Add Doctor', icon: Icons.person_add_outlined),
    const HomeMenuItem(
      label: 'Add Chemist',
      icon: Icons.local_pharmacy_outlined,
    ),
    const HomeMenuItem(label: 'Logout', icon: Icons.logout_outlined),
  ];

  int get selectedMenuIndex => _selectedMenuIndex;
  bool get isPlanMeetSelected => _selectedMenuIndex == planMeetMenuIndex;
  bool get isTodayPlanLoading => _isTodayPlanLoading;
  String? get todayPlanErrorMessage => _todayPlanErrorMessage;
  int get todayVisits => _todayVisits;
  int get doctorVisits => _doctorVisits;
  int get chemistVisits => _chemistVisits;
  bool get isPlanMeetLoading => _isPlanMeetLoading;
  String? get planMeetErrorMessage => _planMeetErrorMessage;
  bool get isDcrLoading => _isDcrLoading;
  String? get dcrErrorMessage => _dcrErrorMessage;
  bool get isTodayDcrFilter => _isTodayDcrFilter;
  DateTime get dcrStartDate => _toDateOnly(_dcrStartDate);
  DateTime get dcrEndDate => _toDateOnly(_dcrEndDate);
  DateTime get currentPlanMeetDate => _toDateOnly(_currentPlanMeetDate);

  String get userName => _userName.trim().isEmpty ? 'User' : _userName;

  String get employeeMeta {
    final String role = _roleName.trim();
    final String code = _employeeCode.trim();

    if (role.isNotEmpty && code.isNotEmpty) {
      return '($role/$code)';
    }
    if (role.isNotEmpty) {
      return '($role)';
    }
    if (code.isNotEmpty) {
      return '($code)';
    }
    return '';
  }

  String get greeting {
    final int hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning!';
    }
    if (hour < 17) {
      return 'Good Afternoon!';
    }
    return 'Good Evening!';
  }

  String get formattedDate {
    final DateTime now = DateTime.now();
    const List<String> weekdays = <String>[
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    const List<String> months = <String>[
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return '${weekdays[now.weekday - 1]}, ${now.day}${_daySuffix(now.day)} ${months[now.month - 1]} ${now.year}';
  }

  String get todaysTip => 'No Record Found';

  List<MedicinePresentation> get medicinePresentations =>
      List<MedicinePresentation>.unmodifiable(_medicinePresentations);

  List<String> get medicineNames => _medicinePresentations
      .map((MedicinePresentation item) => item.name)
      .toList(growable: false);

  List<PlanMeetEntry> get planMeetEntries =>
      List<PlanMeetEntry>.unmodifiable(_planMeetEntries);

  List<PlanMeetEntry> get pendingPlanMeetEntriesForDcr {
    final Set<String> completedPlanIds = <String>{
      ..._recentlyCreatedDcrPlanIds,
      ..._apiDcrEntries
          .map((DcrEntry entry) => entry.planId.trim())
          .where((String item) => item.isNotEmpty),
    };

    return List<PlanMeetEntry>.unmodifiable(
      _planMeetEntries.where((PlanMeetEntry entry) {
        // Completed plans (DCR recorded — including offline) drop out of the
        // "pending DCR" list immediately.
        if (entry.visitStatus == 2) {
          return false;
        }
        return !completedPlanIds.contains(entry.id.trim());
      }),
    );
  }

  List<DcrEntry> get dcrEntries {
    final Map<String, DcrEntry> entriesByKey = <String, DcrEntry>{};
    for (final DcrEntry entry in _apiDcrEntries) {
      final String key = _buildDcrKey(
        date: entry.dcrDate,
        customerType: entry.customerType,
        customerName: entry.customerName,
        customerCode: entry.customerCode,
      );
      final DcrEntry? existing = entriesByKey[key];
      if (existing == null || entry.updatedAt.isAfter(existing.updatedAt)) {
        entriesByKey[key] = entry;
      }
    }

    final List<DcrEntry> copy = entriesByKey.values.toList(growable: false);
    copy.sort((DcrEntry a, DcrEntry b) {
      final int byDate = b.dcrDate.compareTo(a.dcrDate);
      if (byDate != 0) {
        return byDate;
      }
      final int byUpdatedAt = b.updatedAt.compareTo(a.updatedAt);
      if (byUpdatedAt != 0) {
        return byUpdatedAt;
      }
      return a.customerName.toLowerCase().compareTo(
        b.customerName.toLowerCase(),
      );
    });
    return List<DcrEntry>.unmodifiable(copy);
  }

  List<UpcomingEvent> get upcomingEvents =>
      List<UpcomingEvent>.unmodifiable(_upcomingEvents);
  bool get isUpcomingEventsLoading => _isUpcomingEventsLoading;
  String? get upcomingEventsErrorMessage => _upcomingEventsErrorMessage;
  String get upcomingEventsSectionLabel => _upcomingEventsSectionLabel;

  Future<void> fetchUpcomingEvents() async {
    if (_isUpcomingEventsLoading) {
      return;
    }

    _isUpcomingEventsLoading = true;
    _upcomingEventsErrorMessage = null;
    notifyListeners();

    try {
      // Computed entirely from the local database: birthdays/anniversaries
      // within ±7 days of today across the rep's doctors and chemist contact
      // persons. Each entry carries its real occurrence date so the list can
      // be ordered chronologically (recent past first, upcoming last).
      final List<({DateTime when, UpcomingEvent event})> dated =
          <({DateTime when, UpcomingEvent event})>[];
      final DateTime today = _toDateOnly(DateTime.now());

      final List<db.Doctor> doctors = await AppServices.doctors.searchDoctors(
        limit: 2000,
      );
      for (final db.Doctor doctor in doctors) {
        final String fullName = <String?>[
          doctor.firstName,
          doctor.middleName,
          doctor.lastName,
        ].whereType<String>().where((s) => s.isNotEmpty).join(' ').trim();
        _appendEventIfNear(
          dated,
          today: today,
          rawDate: doctor.dob,
          eventName: 'Birthday',
          customerName: fullName,
          customerType: 'Doctor',
          customerLocation: doctor.area ?? '',
        );
        _appendEventIfNear(
          dated,
          today: today,
          rawDate: doctor.dom,
          eventName: 'Anniversary',
          customerName: fullName,
          customerType: 'Doctor',
          customerLocation: doctor.area ?? '',
        );
      }

      final List<db.Chemist> chemists = await AppServices.chemists
          .searchChemists(limit: 2000);
      for (final db.Chemist chemist in chemists) {
        _appendEventIfNear(
          dated,
          today: today,
          rawDate: chemist.contactPersonDob,
          eventName: 'Birthday',
          customerName: chemist.fullName,
          customerType: 'Chemist',
          customerLocation: chemist.area ?? '',
        );
        _appendEventIfNear(
          dated,
          today: today,
          rawDate: chemist.contactPersonDom,
          eventName: 'Anniversary',
          customerName: chemist.fullName,
          customerType: 'Chemist',
          customerLocation: chemist.area ?? '',
        );
      }

      dated.sort((a, b) => a.when.compareTo(b.when));
      _upcomingEvents = dated
          .map((({DateTime when, UpcomingEvent event}) e) => e.event)
          .toList(growable: false);
      _upcomingEventsSectionLabel = 'Birthdays & Anniversaries';
    } catch (_) {
      _upcomingEvents = <UpcomingEvent>[];
      _upcomingEventsErrorMessage = 'Unable to load Birthdays & Anniversaries.';
    } finally {
      _isUpcomingEventsLoading = false;
      notifyListeners();
    }
  }

  /// Window for birthdays/anniversaries on the home dashboard: this many days
  /// before and after today (recurring annually).
  static const int _eventWindowDays = 7;

  void _appendEventIfNear(
    List<({DateTime when, UpcomingEvent event})> events, {
    required DateTime today,
    required String? rawDate,
    required String eventName,
    required String customerName,
    required String customerType,
    required String customerLocation,
  }) {
    if (rawDate == null || rawDate.isEmpty || customerName.isEmpty) {
      return;
    }
    final DateTime? parsed = DateTime.tryParse(rawDate);
    if (parsed == null) {
      return;
    }

    // The date recurs every year, so the relevant occurrence near "today"
    // could fall in the previous, current, or next calendar year (handles the
    // December/January wrap). Pick the one within the ±window.
    DateTime? occurrence;
    for (final int year in <int>[today.year - 1, today.year, today.year + 1]) {
      final DateTime candidate = DateTime(year, parsed.month, parsed.day);
      if (candidate.difference(today).inDays.abs() <= _eventWindowDays) {
        occurrence = candidate;
        break;
      }
    }
    if (occurrence == null) {
      return;
    }

    events.add((
      when: occurrence,
      event: UpcomingEvent(
        eventName: eventName,
        eventDate: _relativeDayLabel(today, occurrence),
        customerName: customerName,
        customerType: customerType,
        customerLocation: customerLocation,
      ),
    ));
  }

  /// Human label for an event date relative to today (within the ±7d window):
  /// Today / Tomorrow / Yesterday / "in N days" / "N days ago".
  String _relativeDayLabel(DateTime today, DateTime date) {
    final int diff = date.difference(today).inDays;
    if (diff == 0) {
      return 'Today';
    }
    if (diff == 1) {
      return 'Tomorrow';
    }
    if (diff == -1) {
      return 'Yesterday';
    }
    final String dateText =
        '${date.day} ${_fullMonthName(date.month)}, ${date.year}';
    if (diff > 1) {
      return '$dateText (in $diff days)';
    }
    return '$dateText (${diff.abs()} days ago)';
  }

  String _fullMonthName(int month) {
    const List<String> months = <String>[
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }

  Future<void> fetchTodayPlan() async {
    if (_isTodayPlanLoading) {
      return;
    }

    _isTodayPlanLoading = true;
    _todayPlanErrorMessage = null;
    notifyListeners();

    try {
      final PlanCounts counts = await AppServices.plans.todayPlanCounts();
      _todayVisits = counts.total;
      _doctorVisits = counts.doctors;
      _chemistVisits = counts.chemists;
    } catch (_) {
      _todayPlanErrorMessage = 'Unable to load today plan.';
    } finally {
      _isTodayPlanLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadCachedProducts() async {
    try {
      final List<db.Product> products = await AppServices.products
          .allProducts();
      final List<MedicinePresentation> presentations = <MedicinePresentation>[];
      for (final db.Product product in products) {
        final String? localPath = await AppServices.products.localImagePath(
          product.id,
        );
        presentations.add(
          MedicinePresentation(
            id: product.id,
            name: product.productName,
            code: product.productCode ?? '',
            imageUrl: product.primaryImageUrl ?? '',
            localImagePath: localPath ?? '',
          ),
        );
      }
      _medicinePresentations = presentations;
      notifyListeners();
    } catch (_) {
      _medicinePresentations = <MedicinePresentation>[];
      notifyListeners();
    }
  }

  String _daySuffix(int day) {
    if (day >= 11 && day <= 13) {
      return 'th';
    }

    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  void initializeFromArgs(Object? args) {
    final HomeUserContext contextArgs = HomeUserContext.fromRouteArgs(args);
    final String nextName = contextArgs.userName.trim();
    final String nextRole = contextArgs.roleName.trim();
    final String nextCode = contextArgs.employeeCode.trim();

    if (nextName.isEmpty && nextRole.isEmpty && nextCode.isEmpty) {
      return;
    }

    final bool hasNameChange = nextName.isNotEmpty && nextName != _userName;
    final bool hasRoleChange = nextRole != _roleName;
    final bool hasCodeChange = nextCode != _employeeCode;
    if (!hasNameChange && !hasRoleChange && !hasCodeChange) {
      return;
    }

    if (hasNameChange) {
      _userName = nextName;
    }
    _roleName = nextRole;
    _employeeCode = nextCode;
    notifyListeners();
  }

  void selectMenu(int index) {
    if (index == _selectedMenuIndex) {
      return;
    }
    _selectedMenuIndex = index;
    notifyListeners();
  }

  void resetForLogout() {
    _selectedMenuIndex = homeMenuIndex;
    _planMeetEntries.clear();
    _apiDcrEntries.clear();
    _recentlyCreatedDcrPlanIds.clear();
    _upcomingEvents = <UpcomingEvent>[];
    _upcomingEventsErrorMessage = null;
    _upcomingEventsSectionLabel = 'Birthdays & Anniversaries';
    _isTodayPlanLoading = false;
    _todayPlanErrorMessage = null;
    _todayVisits = 0;
    _doctorVisits = 0;
    _chemistVisits = 0;
    _isPlanMeetLoading = false;
    _planMeetErrorMessage = null;
    _isDcrLoading = false;
    _dcrErrorMessage = null;
    _isTodayDcrFilter = true;
    _dcrStartDate = DateTime.now();
    _dcrEndDate = DateTime.now();
    _currentPlanMeetDate = DateTime.now();
    _medicinePresentations = <MedicinePresentation>[];
    _customerProfilesById.clear();
  }

  Future<PlanDropdownData> fetchPlanDoctorChemistDropdown() async {
    await _refreshCustomerProfiles();

    final List<db.Doctor> doctorRows = await AppServices.doctors
        .dropdownOptions();
    final List<db.Chemist> chemistRows = await AppServices.chemists
        .dropdownOptions();

    List<PlanCustomerOption> doctors = doctorRows
        .map(_doctorOption)
        .where((PlanCustomerOption item) => item.name.isNotEmpty)
        .toList(growable: false);
    List<PlanCustomerOption> chemists = chemistRows
        .map(_chemistOption)
        .where((PlanCustomerOption item) => item.name.isNotEmpty)
        .toList(growable: false);

    final Map<String, CustomerProfile> profilesById = _customerProfilesById;
    doctors = doctors
        .map(
          (PlanCustomerOption item) => item.mergeProfile(profilesById[item.id]),
        )
        .toList(growable: false);
    chemists = chemists
        .map(
          (PlanCustomerOption item) => item.mergeProfile(profilesById[item.id]),
        )
        .toList(growable: false);

    doctors.sort((PlanCustomerOption a, PlanCustomerOption b) {
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });
    chemists.sort((PlanCustomerOption a, PlanCustomerOption b) {
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });

    return PlanDropdownData(doctors: doctors, chemists: chemists);
  }

  PlanCustomerOption _doctorOption(db.Doctor row) {
    final String name = <String?>[
      row.firstName,
      row.middleName,
      row.lastName,
    ].whereType<String>().where((s) => s.isNotEmpty).join(' ').trim();
    return PlanCustomerOption(
      id: row.id,
      name: name,
      code: row.doctorCode ?? '',
      customerType: 'doctor',
    );
  }

  PlanCustomerOption _chemistOption(db.Chemist row) {
    return PlanCustomerOption(
      id: row.id,
      name: row.fullName,
      code: row.chemistCode ?? '',
      customerType: 'chemist',
    );
  }

  Future<String> createPlans({
    required DateTime visitDate,
    required List<PlanCustomerOption> customers,
  }) async {
    final List<({String customerId, String customerType})> entries = customers
        .where(
          (PlanCustomerOption item) =>
              item.id.trim().isNotEmpty && item.normalizedType.isNotEmpty,
        )
        .map(
          (PlanCustomerOption item) =>
              (customerId: item.id, customerType: item.normalizedType),
        )
        .toList(growable: false);

    final List<String> created = await AppServices.plans.createPlans(
      visitDate: visitDate,
      customers: entries,
    );

    await fetchPlanMeetEntries(visitDate: visitDate);
    await fetchTodayPlan();
    if (created.isEmpty) {
      return 'These customers are already planned for this date.';
    }
    if (created.length < entries.length) {
      return '${created.length} plan(s) saved; '
          '${entries.length - created.length} already existed.';
    }
    return 'Plans created successfully.';
  }

  Future<String> createDcr({
    required String planId,
    required int supportValue,
    required int expectedSupportValue,
    List<String> productIds = const <String>[],
  }) async {
    final String trimmedPlanId = planId.trim();
    if (trimmedPlanId.isEmpty) {
      throw StateError('Plan id is missing for this entry.');
    }

    final List<String> cleanedProductIds = productIds
        .map((String item) => item.trim())
        .where((String item) => item.isNotEmpty)
        .toList(growable: false);

    await AppServices.dcrs.createDcr(
      planId: trimmedPlanId,
      supportValue: supportValue.toDouble(),
      expectedSupportValue: expectedSupportValue.toDouble(),
      productIds: cleanedProductIds,
    );

    // The presented selection has served its purpose for this visit.
    await clearPresentedSelection(trimmedPlanId);
    _recentlyCreatedDcrPlanIds.add(trimmedPlanId);
    await fetchPlanMeetEntries(visitDate: _currentPlanMeetDate);
    await fetchDcrEntries(
      todayOnly: _isTodayDcrFilter,
      startDate: _dcrStartDate,
      endDate: _dcrEndDate,
    );
    return 'DCR created successfully.';
  }

  Future<void> fetchPlanMeetEntries({DateTime? visitDate}) async {
    final DateTime targetDate = _toDateOnly(visitDate ?? DateTime.now());
    _currentPlanMeetDate = targetDate;
    _isPlanMeetLoading = true;
    _planMeetErrorMessage = null;
    notifyListeners();

    try {
      final List<db.DailyPlan> rows = await AppServices.plans.plansForDate(
        targetDate,
      );

      // Resolve customer names/codes from the local doctors/chemists tables.
      final List<String> doctorIds = rows
          .where((r) => r.customerType == 'doctor')
          .map((r) => r.customerId)
          .toList(growable: false);
      final List<String> chemistIds = rows
          .where((r) => r.customerType == 'chemist')
          .map((r) => r.customerId)
          .toList(growable: false);
      final Map<String, db.Doctor> doctorsById = <String, db.Doctor>{
        for (final db.Doctor d in await AppServices.doctors.byIds(doctorIds))
          d.id: d,
      };
      final Map<String, db.Chemist> chemistsById = <String, db.Chemist>{
        for (final db.Chemist c in await AppServices.chemists.byIds(chemistIds))
          c.id: c,
      };

      _planMeetEntries
        ..clear()
        ..addAll(
          rows
              .map<PlanMeetEntry>((db.DailyPlan row) {
                String name = '';
                String code = '';
                if (row.customerType == 'doctor') {
                  final db.Doctor? doctor = doctorsById[row.customerId];
                  if (doctor != null) {
                    name =
                        <String?>[
                              doctor.firstName,
                              doctor.middleName,
                              doctor.lastName,
                            ]
                            .whereType<String>()
                            .where((s) => s.isNotEmpty)
                            .join(' ')
                            .trim();
                    code = doctor.doctorCode ?? '';
                  }
                } else {
                  final db.Chemist? chemist = chemistsById[row.customerId];
                  if (chemist != null) {
                    name = chemist.fullName;
                    code = chemist.chemistCode ?? '';
                  }
                }
                return PlanMeetEntry(
                  id: row.id,
                  customerId: row.customerId,
                  customerCode: code,
                  type: row.customerType,
                  name: name,
                  visitDate: DateTime.tryParse(row.visitDate) ?? targetDate,
                  createdAt:
                      DateTime.tryParse(row.cdt ?? '') ??
                      (DateTime.tryParse(row.visitDate) ?? targetDate),
                  visitStatus: row.visitStatus,
                );
              })
              .where((PlanMeetEntry item) => item.name.trim().isNotEmpty),
        );

      if (_planMeetEntries.isNotEmpty &&
          _shouldRefreshCustomerProfiles(_planMeetEntries)) {
        await _refreshCustomerProfiles();
      }

      _planMeetEntries.sort((PlanMeetEntry a, PlanMeetEntry b) {
        final int byVisitDate = b.visitDate.compareTo(a.visitDate);
        if (byVisitDate != 0) {
          return byVisitDate;
        }
        return b.createdAt.compareTo(a.createdAt);
      });
    } catch (_) {
      _planMeetEntries.clear();
      _planMeetErrorMessage = 'Unable to load plans.';
    } finally {
      _isPlanMeetLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchDcrEntries({
    String filterType = 'today',
    bool? todayOnly,
    DateTime? startDate,
    DateTime? endDate,
    String sortOrder = 'asc',
    int limit = 100,
  }) async {
    if (_isDcrLoading) {
      return;
    }

    _isDcrLoading = true;
    _dcrErrorMessage = null;
    final bool resolvedTodayOnly = todayOnly ?? _isTodayDcrFilter;
    _isTodayDcrFilter = resolvedTodayOnly;
    if (!resolvedTodayOnly) {
      final DateTime resolvedStartDate = _toDateOnly(
        startDate ?? _dcrStartDate,
      );
      final DateTime resolvedEndDate = _toDateOnly(endDate ?? _dcrEndDate);
      _dcrStartDate = resolvedStartDate;
      _dcrEndDate = resolvedEndDate.isBefore(resolvedStartDate)
          ? resolvedStartDate
          : resolvedEndDate;
    }
    notifyListeners();

    try {
      final DateTime rangeStart = resolvedTodayOnly
          ? _toDateOnly(DateTime.now())
          : _toDateOnly(_dcrStartDate);
      // Inclusive by calendar date — the repository handles day bounds.
      final DateTime rangeEnd = resolvedTodayOnly
          ? _toDateOnly(DateTime.now())
          : _toDateOnly(_dcrEndDate);

      final List<db.Dcr> rows = await AppServices.dcrs.dcrsBetween(
        start: rangeStart,
        end: rangeEnd,
      );

      final List<DcrEntry> entries = <DcrEntry>[];
      for (final db.Dcr row in rows) {
        entries.add(await _dcrEntryFromRow(row));
      }
      _apiDcrEntries
        ..clear()
        ..addAll(
          entries.where((DcrEntry item) => item.customerName.isNotEmpty),
        );
    } catch (_) {
      _apiDcrEntries.clear();
      _dcrErrorMessage = 'Unable to load DCR entries.';
    } finally {
      _isDcrLoading = false;
      notifyListeners();
    }
  }

  Future<DcrEntry> _dcrEntryFromRow(db.Dcr row) async {
    String customerType = '';
    String customerId = '';
    String customerName = '';
    String customerCode = '';

    final String planId = row.planId ?? '';
    if (planId.isNotEmpty) {
      final db.DailyPlan? plan = await AppServices.plans.getById(planId);
      if (plan != null) {
        customerType = plan.customerType;
        customerId = plan.customerId;
        if (plan.customerType == 'doctor') {
          final db.Doctor? doctor = await AppServices.doctors.getById(
            plan.customerId,
          );
          if (doctor != null) {
            customerName = <String?>[
              doctor.firstName,
              doctor.middleName,
              doctor.lastName,
            ].whereType<String>().where((s) => s.isNotEmpty).join(' ').trim();
            customerCode = doctor.doctorCode ?? '';
          }
        } else if (plan.customerType == 'chemist') {
          final db.Chemist? chemist = await AppServices.chemists.getById(
            plan.customerId,
          );
          if (chemist != null) {
            customerName = chemist.fullName;
            customerCode = chemist.chemistCode ?? '';
          }
        }
      }
    }

    final List<String> productIds = (row.productIds ?? '')
        .split(',')
        .map((String id) => id.trim())
        .where((String id) => id.isNotEmpty)
        .toList(growable: false);
    final List<db.Product> products = await AppServices.products.byIds(
      productIds,
    );

    final DateTime visitDateTime =
        DateTime.tryParse(row.visitDatetime) ?? DateTime.now();
    final DateTime updatedAt =
        DateTime.tryParse(row.locallyChangedAt ?? '') ??
        DateTime.tryParse(row.serverUdt ?? '') ??
        visitDateTime;

    return DcrEntry(
      id: row.id,
      planId: planId,
      customerId: customerId,
      customerType: customerType,
      customerName: customerName,
      customerCode: customerCode,
      visitDateTime: visitDateTime,
      remarks: row.remarks ?? '',
      supportValue: _numericString(row.supportValue),
      potential: _numericString(row.potential),
      expectedSupportValue: _numericString(row.expectedSupportValue),
      products: products
          .map(
            (db.Product p) => DcrProduct(
              id: p.id,
              productName: p.productName,
              productCode: p.productCode ?? '',
            ),
          )
          .toList(growable: false),
      updatedAt: updatedAt,
      isLocalOnly: row.localStatus != 'synced',
    );
  }

  String _numericString(double? value) {
    if (value == null) {
      return '';
    }
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }
    return value.toString();
  }

  Future<void> setDcrDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final DateTime normalizedStartDate = _toDateOnly(startDate);
    final DateTime normalizedEndDate = _toDateOnly(endDate);
    _dcrStartDate = normalizedStartDate.isAfter(normalizedEndDate)
        ? normalizedEndDate
        : normalizedStartDate;
    _dcrEndDate = normalizedEndDate.isBefore(normalizedStartDate)
        ? normalizedStartDate
        : normalizedEndDate;
    _isTodayDcrFilter = false;
    notifyListeners();
    await fetchDcrEntries(
      todayOnly: false,
      startDate: _dcrStartDate,
      endDate: _dcrEndDate,
    );
  }

  Future<void> fetchTodayDcrEntries() async {
    _isTodayDcrFilter = true;
    notifyListeners();
    await fetchDcrEntries(todayOnly: true);
  }

  CustomerProfile getCustomerProfileForEntry(PlanMeetEntry entry) {
    final CustomerProfile? byId = _customerProfilesById[entry.customerId];
    if (byId != null) {
      return byId;
    }

    for (final CustomerProfile profile in _customerProfilesById.values) {
      if (profile.type == entry.type.trim().toLowerCase() &&
          profile.name.toLowerCase() == entry.name.toLowerCase()) {
        return profile;
      }
    }

    return CustomerProfile(
      id: entry.customerId,
      code: entry.customerCode,
      type: entry.isDoctor ? 'doctor' : entry.type.trim().toLowerCase(),
      name: entry.name,
      qualification: '-',
      speciality: '-',
      phone: '-',
      area: '-',
      city: '-',
      state: '-',
      country: '-',
      potential: '-',
      supportValue: '-',
      expectedSupportValue: '-',
      email: '-',
      contactPersonName: '-',
      contactPersonEmail: '-',
    );
  }

  // ------------------------------------------------- presented selection
  // What the rep actually showed in View Presentation, keyed by plan, kept
  // in the encrypted local DB so it survives restarts until the DCR is made.

  static String _presentedSelectionKey(String planId) =>
      'presented_selection_${planId.trim()}';

  Future<void> recordPresentedSelection({
    required String planId,
    required List<String> productIds,
  }) async {
    if (planId.trim().isEmpty || productIds.isEmpty) {
      return;
    }
    await AppServices.db.setKv(
      _presentedSelectionKey(planId),
      jsonEncode(productIds),
    );
  }

  Future<List<String>> loadPresentedSelection(String planId) async {
    if (planId.trim().isEmpty) {
      return const <String>[];
    }
    final String? raw = await AppServices.db.getKv(
      _presentedSelectionKey(planId),
    );
    if (raw == null || raw.isEmpty) {
      return const <String>[];
    }
    try {
      return (jsonDecode(raw) as List<dynamic>)
          .map((dynamic id) => id.toString())
          .toList(growable: false);
    } catch (_) {
      return const <String>[];
    }
  }

  Future<void> clearPresentedSelection(String planId) =>
      AppServices.db.setKv(_presentedSelectionKey(planId), null);

  /// Complete presentation history for this customer (most recent visit
  /// first) plus the union of everything they have already seen. Reads the
  /// permanent local history table, so it works fully offline and survives
  /// app restarts. Returns null when nothing was ever presented.
  Future<CustomerPresentationHistory?> fetchPresentationHistory(
    PlanMeetEntry entry,
  ) async {
    try {
      final List<PresentationVisit> visits = await AppServices.dcrs.history
          .historyForCustomer(
            customerType: entry.type.trim().toLowerCase(),
            customerId: entry.customerId,
          );
      if (visits.isEmpty) {
        return null;
      }

      final List<String> allIds = visits
          .expand((PresentationVisit v) => v.productIds)
          .toSet()
          .toList(growable: false);
      final List<db.Product> products = await AppServices.products.byIds(
        allIds,
      );
      final Map<String, MedicinePresentation> byId =
          <String, MedicinePresentation>{
            for (final db.Product p in products)
              p.id: MedicinePresentation(
                id: p.id,
                name: p.productName,
                code: p.productCode ?? '',
                imageUrl: p.primaryImageUrl ?? '',
                localImagePath: '',
              ),
          };

      final List<PresentationHistoryVisit> resolved = visits
          .map(
            (PresentationVisit v) => PresentationHistoryVisit(
              visitDate: v.shownAt,
              medicines: v.productIds
                  .map((String id) => byId[id])
                  .whereType<MedicinePresentation>()
                  .toList(growable: false),
            ),
          )
          .where((PresentationHistoryVisit v) => v.medicines.isNotEmpty)
          .toList(growable: false);
      if (resolved.isEmpty) {
        return null;
      }

      // Union ordered by recency: most recently shown products first.
      final List<MedicinePresentation> union = <MedicinePresentation>[];
      final Set<String> seen = <String>{};
      for (final PresentationVisit visit in visits) {
        for (final String id in visit.productIds) {
          final MedicinePresentation? medicine = byId[id];
          if (medicine != null && seen.add(id)) {
            union.add(medicine);
          }
        }
      }
      return CustomerPresentationHistory(
        visits: resolved,
        allShownMedicines: union,
      );
    } catch (_) {
      return null;
    }
  }

  MedicinePresentation getMedicinePresentationByName(String name) {
    for (final MedicinePresentation item in _medicinePresentations) {
      if (item.name.toLowerCase() == name.toLowerCase()) {
        return item;
      }
    }

    return MedicinePresentation(
      id: '',
      name: name,
      code: '',
      imageUrl: '',
      localImagePath: '',
    );
  }

  List<MedicinePresentation> getMedicinePresentationsByIds(
    Iterable<String> ids,
  ) {
    final Set<String> normalizedIds = ids
        .map((String item) => item.trim())
        .where((String item) => item.isNotEmpty)
        .toSet();
    return _medicinePresentations
        .where((MedicinePresentation item) => normalizedIds.contains(item.id))
        .toList(growable: false);
  }

  String formatDcrDropdownDate(DateTime date) {
    const List<String> weekdays = <String>[
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun',
    ];
    return '${weekdays[date.weekday - 1]}, ${formatShortDate(date)}';
  }

  String formatShortDate(DateTime date) {
    const List<String> months = <String>[
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
    final String day = date.day.toString().padLeft(2, '0');
    return '$day ${months[date.month - 1]} ${date.year}';
  }

  String formatApiDate(DateTime date) {
    final DateTime normalized = _toDateOnly(date);
    final String month = normalized.month.toString().padLeft(2, '0');
    final String day = normalized.day.toString().padLeft(2, '0');
    return '${normalized.year}-$month-$day';
  }

  DateTime _toDateOnly(DateTime value) {
    return DateTime(value.year, value.month, value.day);
  }

  bool _shouldRefreshCustomerProfiles(Iterable<PlanMeetEntry> entries) {
    if (_customerProfilesById.isEmpty) {
      return true;
    }

    for (final PlanMeetEntry entry in entries) {
      if (entry.customerId.trim().isEmpty) {
        continue;
      }
      if (!_customerProfilesById.containsKey(entry.customerId.trim())) {
        return true;
      }
    }
    return false;
  }

  String _buildDcrKey({
    required DateTime date,
    required String customerType,
    required String customerName,
    required String customerCode,
  }) {
    final DateTime normalizedDate = _toDateOnly(date);
    return <String>[
      formatApiDate(normalizedDate),
      customerType.trim().toLowerCase(),
      customerName.trim().toLowerCase(),
      customerCode.trim().toLowerCase(),
    ].join('|');
  }

  Future<void> _refreshCustomerProfiles() async {
    final Map<String, CustomerProfile> profilesById =
        <String, CustomerProfile>{};

    for (final db.Doctor row in await AppServices.doctors.searchDoctors(
      limit: 2000,
    )) {
      final String name = <String?>[
        row.firstName,
        row.middleName,
        row.lastName,
      ].whereType<String>().where((s) => s.isNotEmpty).join(' ').trim();
      profilesById[row.id] = CustomerProfile(
        id: row.id,
        code: row.doctorCode ?? '',
        type: 'doctor',
        name: name,
        qualification: row.qualification ?? '',
        speciality: row.speciality ?? '',
        phone: row.phone ?? '',
        area: row.area ?? '',
        city: row.city ?? '',
        state: row.state ?? '',
        country: row.country ?? '',
        potential: _numericString(row.potential),
        supportValue: _numericString(row.supportValue),
        expectedSupportValue: _numericString(row.expectedSupportValue),
        email: row.email ?? '',
      );
    }

    for (final db.Chemist row in await AppServices.chemists.searchChemists(
      limit: 2000,
    )) {
      profilesById[row.id] = CustomerProfile(
        id: row.id,
        code: row.chemistCode ?? '',
        type: 'chemist',
        name: row.fullName,
        phone: row.phone ?? '',
        area: row.area ?? '',
        city: row.city ?? '',
        state: row.state ?? '',
        country: row.country ?? '',
        potential: _numericString(row.potential),
        supportValue: _numericString(row.supportValue),
        expectedSupportValue: _numericString(row.expectedSupportValue),
        email: row.email ?? '',
        contactPersonName: row.contactPersonName ?? '',
        contactPersonEmail: row.contactPersonEmail ?? '',
      );
    }

    if (profilesById.isEmpty) {
      return;
    }

    _customerProfilesById
      ..clear()
      ..addAll(profilesById);
  }
}

class UpcomingEvent {
  const UpcomingEvent({
    required this.eventName,
    required this.eventDate,
    required this.customerName,
    required this.customerType,
    required this.customerLocation,
  });

  final String eventName;
  final String eventDate;
  final String customerName;
  final String customerType;
  final String customerLocation;

  factory UpcomingEvent.fromJson(Map<String, dynamic> json) {
    return UpcomingEvent(
      eventName: _readString(json['event_name']),
      eventDate: _readString(json['event_date']),
      customerName: _readString(json['customer_name']),
      customerType: _readString(json['customer_type']),
      customerLocation: _readString(json['customer_location']),
    );
  }

  static String _readString(Object? value) {
    if (value is String) {
      return value.trim();
    }
    if (value == null) {
      return '';
    }
    return value.toString().trim();
  }
}

class PlanMeetEntry {
  const PlanMeetEntry({
    required this.id,
    required this.customerId,
    required this.customerCode,
    required this.type,
    required this.name,
    required this.visitDate,
    required this.createdAt,
    this.visitStatus = 1,
  });

  final String id;
  final String customerId;
  final String customerCode;
  final String type;
  final String name;
  final DateTime visitDate;
  final DateTime createdAt;

  /// 1 = Planned, 2 = Completed (DCR exists), 3 = Cancelled.
  final int visitStatus;

  bool get isDoctor => type.trim().toLowerCase() == 'doctor';

  String get typeLabel {
    final String normalized = type.trim().toLowerCase();
    if (normalized.isEmpty) {
      return 'Unknown';
    }
    return '${normalized[0].toUpperCase()}${normalized.substring(1)}';
  }

  factory PlanMeetEntry.fromJson(Map<String, dynamic> json) {
    final String customerName = _readStringValue(json['customer_name']);
    final String fallbackName = _readStringValue(json['name']);
    final DateTime visitDate = _readDateValue(json['visit_date']);
    final DateTime createdAt = _readDateValue(
      json['created_at'],
      fallback: visitDate,
    );

    return PlanMeetEntry(
      id: _readStringValue(json['id']),
      customerId: _readStringValue(json['customer_id']),
      customerCode: _readStringValue(json['customer_code']),
      type: _readStringValue(json['customer_type']).isEmpty
          ? _readStringValue(json['type'])
          : _readStringValue(json['customer_type']),
      name: customerName.isEmpty ? fallbackName : customerName,
      visitDate: visitDate,
      createdAt: createdAt,
    );
  }
}

class PlanDropdownData {
  const PlanDropdownData({required this.doctors, required this.chemists});

  final List<PlanCustomerOption> doctors;
  final List<PlanCustomerOption> chemists;
}

class PlanCustomerOption {
  const PlanCustomerOption({
    required this.id,
    required this.name,
    required this.code,
    required this.customerType,
    this.potential = '',
    this.supportValue = '',
    this.expectedSupportValue = '',
    this.qualification = '',
    this.speciality = '',
    this.phone = '',
    this.area = '',
    this.city = '',
    this.state = '',
    this.country = '',
    this.email = '',
    this.contactPersonName = '',
    this.contactPersonEmail = '',
  });

  final String id;
  final String name;
  final String code;
  final String customerType;
  final String potential;
  final String supportValue;
  final String expectedSupportValue;
  final String qualification;
  final String speciality;
  final String phone;
  final String area;
  final String city;
  final String state;
  final String country;
  final String email;
  final String contactPersonName;
  final String contactPersonEmail;

  String get normalizedType => customerType.trim().toLowerCase();

  String get typeLabel {
    if (normalizedType.isEmpty) {
      return 'Unknown';
    }
    return '${normalizedType[0].toUpperCase()}${normalizedType.substring(1)}';
  }

  factory PlanCustomerOption.fromJson(
    Map<String, dynamic> json, {
    String fallbackType = '',
  }) {
    return PlanCustomerOption(
      id: _readStringValue(json['id']).isEmpty
          ? _readStringValue(json['customer_id'])
          : _readStringValue(json['id']),
      name: _readStringValue(json['name']).isEmpty
          ? _readStringValue(json['customer_name'])
          : _readStringValue(json['name']),
      code: _readStringValue(json['code']).isEmpty
          ? _readStringValue(json['customer_code'])
          : _readStringValue(json['code']),
      customerType: _readStringValue(json['customer_type']).isEmpty
          ? fallbackType
          : _readStringValue(json['customer_type']),
      potential: _readNumericStringValue(json['potential']),
      supportValue: _readNumericStringValue(json['support_value']),
      expectedSupportValue: _readNumericStringValue(
        json['expected_support_value'],
      ),
      qualification: _readStringValue(json['qualification']),
      speciality: _readStringValue(json['speciality']),
      phone: _readStringValue(json['phone']),
      area: _readStringValue(json['area']),
      city: _readStringValue(json['city']),
      state: _readStringValue(json['state']),
      country: _readStringValue(json['country']),
      email: _readStringValue(json['email']),
      contactPersonName: _readStringValue(json['contact_person_name']),
      contactPersonEmail: _readStringValue(json['contact_person_email']),
    );
  }

  PlanCustomerOption mergeProfile(CustomerProfile? profile) {
    if (profile == null) {
      return this;
    }
    return PlanCustomerOption(
      id: id,
      name: name,
      code: code,
      customerType: customerType,
      potential: profile.potential,
      supportValue: profile.supportValue,
      expectedSupportValue: profile.expectedSupportValue,
      qualification: profile.qualification,
      speciality: profile.speciality,
      phone: profile.phone,
      area: profile.area,
      city: profile.city,
      state: profile.state,
      country: profile.country,
      email: profile.email,
      contactPersonName: profile.contactPersonName,
      contactPersonEmail: profile.contactPersonEmail,
    );
  }
}

class DcrEntry {
  const DcrEntry({
    required this.id,
    required this.planId,
    required this.customerId,
    required this.customerType,
    required this.customerName,
    required this.customerCode,
    required this.visitDateTime,
    required this.remarks,
    required this.supportValue,
    required this.potential,
    required this.expectedSupportValue,
    required this.products,
    required this.updatedAt,
    this.isLocalOnly = false,
  });

  final String id;
  final String planId;
  final String customerId;
  final String customerType;
  final String customerName;
  final String customerCode;
  final DateTime visitDateTime;
  final String remarks;
  final String supportValue;
  final String potential;
  final String expectedSupportValue;
  final List<DcrProduct> products;
  final DateTime updatedAt;
  final bool isLocalOnly;

  DateTime get dcrDate =>
      DateTime(visitDateTime.year, visitDateTime.month, visitDateTime.day);

  String get normalizedType => customerType.trim().toLowerCase();

  String get typeLabel {
    if (normalizedType.isEmpty) {
      return 'Unknown';
    }
    return '${normalizedType[0].toUpperCase()}${normalizedType.substring(1)}';
  }

  factory DcrEntry.fromJson(Map<String, dynamic> json) {
    final DateTime visitDateTime = _readDateTimeValue(json['visit_datetime']);
    final List<dynamic> rawProducts = json['products'] is List
        ? json['products'] as List<dynamic>
        : <dynamic>[];
    return DcrEntry(
      id: _readStringValue(json['id']),
      planId: _readStringValue(json['plan_id']),
      customerId: _readStringValue(json['customer_id']),
      customerType: _readStringValue(json['customer_type']),
      customerName: _readStringValue(json['customer_name']),
      customerCode: _readStringValue(json['customer_code']),
      visitDateTime: visitDateTime,
      remarks: _readStringValue(json['remarks']),
      supportValue: _readNumericStringValue(json['support_value']),
      potential: _readNumericStringValue(json['potential']),
      expectedSupportValue: _readNumericStringValue(
        json['expected_support_value'],
      ),
      products: rawProducts
          .map<DcrProduct>(
            (dynamic item) => DcrProduct.fromJson(_readMapValue(item)),
          )
          .toList(growable: false),
      updatedAt: _readDateTimeValue(
        json['updated_at'],
        fallback: _readDateTimeValue(json['udt'], fallback: visitDateTime),
      ),
    );
  }
}

class DcrProduct {
  const DcrProduct({
    required this.id,
    required this.productName,
    required this.productCode,
  });

  final String id;
  final String productName;
  final String productCode;

  String get displayLabel {
    if (productCode.isEmpty) {
      return productName;
    }
    if (productName.isEmpty) {
      return productCode;
    }
    return '$productName ($productCode)';
  }

  factory DcrProduct.fromJson(Map<String, dynamic> json) {
    return DcrProduct(
      id: _readStringValue(json['id']),
      productName: _readStringValue(json['product_name']),
      productCode: _readStringValue(json['product_code']),
    );
  }
}

class CustomerProfile {
  const CustomerProfile({
    required this.id,
    required this.code,
    required this.type,
    required this.name,
    this.qualification = '',
    this.speciality = '',
    this.phone = '',
    this.area = '',
    this.city = '',
    this.state = '',
    this.country = '',
    this.potential = '',
    this.supportValue = '',
    this.expectedSupportValue = '',
    this.email = '',
    this.contactPersonName = '',
    this.contactPersonEmail = '',
  });

  final String id;
  final String code;
  final String type;
  final String name;
  final String qualification;
  final String speciality;
  final String phone;
  final String area;
  final String city;
  final String state;
  final String country;
  final String potential;
  final String supportValue;
  final String expectedSupportValue;
  final String email;
  final String contactPersonName;
  final String contactPersonEmail;

  factory CustomerProfile.fromJson(
    Map<String, dynamic> json, {
    required String fallbackType,
  }) {
    final String normalizedType =
        _readStringValue(json['customer_type']).isEmpty
        ? fallbackType
        : _readStringValue(json['customer_type']).toLowerCase();

    final String resolvedName = normalizedType == 'doctor'
        ? <String>[
            _readStringValue(json['first_name']),
            _readStringValue(json['middle_name']),
            _readStringValue(json['last_name']),
          ].where((String item) => item.isNotEmpty).join(' ').trim()
        : _readStringValue(json['full_name']).isEmpty
        ? _readStringValue(json['name'])
        : _readStringValue(json['full_name']);

    return CustomerProfile(
      id: _readStringValue(json['id']),
      code: normalizedType == 'doctor'
          ? _readStringValue(json['doctor_code'])
          : _readStringValue(json['chemist_code']),
      type: normalizedType,
      name: resolvedName,
      qualification: _readStringValue(json['qualification']),
      speciality: _readStringValue(json['speciality']),
      phone: _readStringValue(json['phone']),
      area: _readStringValue(json['area']),
      city: _readStringValue(json['city']),
      state: _readStringValue(json['state']),
      country: _readStringValue(json['country']),
      potential: _readNumericStringValue(json['potential']),
      supportValue: _readNumericStringValue(json['support_value']),
      expectedSupportValue: _readNumericStringValue(
        json['expected_support_value'],
      ),
      email: _readStringValue(json['email']),
      contactPersonName: _readStringValue(json['contact_person_name']),
      contactPersonEmail: _readStringValue(json['contact_person_email']),
    );
  }
}

/// One past visit in a customer's presentation history.
class PresentationHistoryVisit {
  const PresentationHistoryVisit({
    required this.visitDate,
    required this.medicines,
  });

  final DateTime? visitDate;
  final List<MedicinePresentation> medicines;
}

/// Everything ever presented to a customer: visit-by-visit history plus the
/// recency-ordered union used to pre-select products on the next visit.
class CustomerPresentationHistory {
  const CustomerPresentationHistory({
    required this.visits,
    required this.allShownMedicines,
  });

  final List<PresentationHistoryVisit> visits;
  final List<MedicinePresentation> allShownMedicines;
}

class MedicinePresentation {
  const MedicinePresentation({
    required this.id,
    required this.name,
    required this.code,
    required this.imageUrl,
    required this.localImagePath,
  });

  final String id;
  final String name;
  final String code;
  final String imageUrl;
  final String localImagePath;
}

String _readStringValue(Object? value) {
  if (value is String) {
    return value.trim();
  }
  if (value == null) {
    return '';
  }
  return value.toString().trim();
}

String _readNumericStringValue(Object? value) {
  if (value == null) {
    return '';
  }
  if (value is num) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }
    return value.toString();
  }
  return _readStringValue(value);
}

Map<String, dynamic> _readMapValue(Object? value) {
  if (value is Map<String, dynamic>) {
    return value;
  }
  if (value is Map) {
    return value.map(
      (Object? key, Object? value) =>
          MapEntry<String, dynamic>(key.toString(), value),
    );
  }
  return <String, dynamic>{};
}

DateTime _readDateTimeValue(Object? value, {DateTime? fallback}) {
  if (value is DateTime) {
    return value;
  }

  final String raw = _readStringValue(value);
  if (raw.isEmpty) {
    return fallback ?? DateTime.now();
  }

  return DateTime.tryParse(raw) ?? fallback ?? DateTime.now();
}

DateTime _readDateValue(Object? value, {DateTime? fallback}) {
  if (value is DateTime) {
    return DateTime(value.year, value.month, value.day);
  }

  final String raw = _readStringValue(value);
  if (raw.isEmpty) {
    final DateTime base = fallback ?? DateTime.now();
    return DateTime(base.year, base.month, base.day);
  }

  final DateTime? parsed = DateTime.tryParse(raw);
  if (parsed == null) {
    final DateTime base = fallback ?? DateTime.now();
    return DateTime(base.year, base.month, base.day);
  }

  return DateTime(parsed.year, parsed.month, parsed.day);
}
