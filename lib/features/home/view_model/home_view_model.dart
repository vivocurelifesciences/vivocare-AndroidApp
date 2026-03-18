import 'package:flutter/material.dart';
import 'package:vivocure/core/auth/auth_storage.dart';
import 'package:vivocure/core/config/api_config.dart';
import 'package:vivocure/core/navigation/home_user_context.dart';
import 'package:vivocure/core/network/network_client.dart';
import 'package:vivocure/core/network/network_exception.dart';
import 'package:vivocure/core/products/product_cache_service.dart';
import 'package:vivocure/features/home/model/home_menu_item.dart';

class HomeViewModel extends ChangeNotifier {
  static const int homeMenuIndex = 0;
  static const int planMeetMenuIndex = 1;
  static const int performanceMenuIndex = 2;
  static const int addDoctorMenuIndex = 3;
  static const int addChemistMenuIndex = 4;
  static const int logoutMenuIndex = 5;

  String _userName = '';
  String _roleName = '';
  String _employeeCode = '';
  int _selectedMenuIndex = homeMenuIndex;
  final List<PlanMeetEntry> _planMeetEntries = <PlanMeetEntry>[];
  final List<DcrEntry> _apiDcrEntries = <DcrEntry>[];
  final NetworkClient _networkClient = NetworkClient(
    scheme: ApiConfig.scheme,
    host: ApiConfig.host,
  );
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
      label: 'Plan & Meet',
      icon: Icons.event_note_outlined,
      isActive: _selectedMenuIndex == planMeetMenuIndex,
    ),
    const HomeMenuItem(label: 'Performance', icon: Icons.trending_up_outlined),
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
      final AuthSession session = await AuthStorage.loadSession();
      if (!session.hasAccessToken) {
        _upcomingEvents = <UpcomingEvent>[];
        _upcomingEventsErrorMessage = 'Session expired. Please login again.';
        return;
      }

      final dynamic responseData = (await _networkClient.get(
        '${ApiConfig.apiVersionPath}/upcoming-events/',
        headers: <String, String>{'Authorization': session.authorizationHeader},
      )).data;

      final Map<String, dynamic> root = _asMap(responseData);
      final dynamic rawItems = root.isNotEmpty ? root['data'] : responseData;
      final List<dynamic> items = rawItems is List ? rawItems : <dynamic>[];
      final String message = _asString(root['msg']);

      _upcomingEvents = items
          .map<UpcomingEvent>(
            (dynamic item) => UpcomingEvent.fromJson(_asMap(item)),
          )
          .toList(growable: false);

      if (message.isNotEmpty && message.toLowerCase() != 'upcoming events') {
        _upcomingEventsSectionLabel = message;
      } else {
        _upcomingEventsSectionLabel = 'Birthdays & Anniversaries';
      }
    } on NetworkException catch (error) {
      _upcomingEvents = <UpcomingEvent>[];
      _upcomingEventsErrorMessage = error.message;
    } catch (_) {
      _upcomingEvents = <UpcomingEvent>[];
      _upcomingEventsErrorMessage = 'Unable to load upcoming events.';
    } finally {
      _isUpcomingEventsLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchTodayPlan() async {
    if (_isTodayPlanLoading) {
      return;
    }

    _isTodayPlanLoading = true;
    _todayPlanErrorMessage = null;
    notifyListeners();

    try {
      final AuthSession session = await AuthStorage.loadSession();
      if (!session.hasAccessToken) {
        _todayVisits = 0;
        _doctorVisits = 0;
        _chemistVisits = 0;
        _todayPlanErrorMessage = 'Session expired. Please login again.';
        return;
      }

      final dynamic responseData = (await _networkClient.get(
        '${ApiConfig.apiVersionPath}/plans/today-plan',
        headers: <String, String>{'Authorization': session.authorizationHeader},
      )).data;

      final Map<String, dynamic> root = _asMap(responseData);
      final Map<String, dynamic> data = _asMap(root['data']);
      _todayVisits = _asInt(data['total_count']);
      _doctorVisits = _asInt(data['doctor_count']);
      _chemistVisits = _asInt(data['chemist_count']);
    } on NetworkException catch (error) {
      _todayPlanErrorMessage = error.message;
    } catch (_) {
      _todayPlanErrorMessage = 'Unable to load today plan.';
    } finally {
      _isTodayPlanLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadCachedProducts() async {
    try {
      final List<CachedProduct> cachedProducts =
          await ProductCacheService.loadCachedProducts();
      _medicinePresentations = cachedProducts
          .map<MedicinePresentation>(
            (CachedProduct item) => MedicinePresentation(
              id: item.id,
              name: item.name,
              code: item.code,
              imageUrl: item.imageUrl,
              localImagePath: item.localImagePath,
            ),
          )
          .toList(growable: false);
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
    final AuthSession session = await AuthStorage.loadSession();
    if (!session.hasAccessToken) {
      throw const NetworkException(
        message: 'Session expired. Please login again.',
        type: NetworkExceptionType.unauthorized,
      );
    }

    final dynamic responseData = (await _networkClient.get(
      '${ApiConfig.apiVersionPath}/plans/doctor-chemist-dropdown',
      headers: <String, String>{'Authorization': session.authorizationHeader},
    )).data;

    final Map<String, dynamic> root = _asMap(responseData);
    final dynamic payload = root['data'] ?? responseData;
    final Map<String, dynamic> data = _asMap(payload);

    List<PlanCustomerOption> doctors = _parsePlanCustomerOptions(
      data['doctors'],
      fallbackType: 'doctor',
    );
    List<PlanCustomerOption> chemists = _parsePlanCustomerOptions(
      data['chemists'],
      fallbackType: 'chemist',
    );

    if (doctors.isEmpty && chemists.isEmpty) {
      final List<PlanCustomerOption> combined = _parsePlanCustomerOptions(
        payload,
      );
      doctors = combined
          .where((PlanCustomerOption item) => item.normalizedType == 'doctor')
          .toList(growable: false);
      chemists = combined
          .where((PlanCustomerOption item) => item.normalizedType == 'chemist')
          .toList(growable: false);
    }

    try {
      await _refreshCustomerProfiles(session);
    } on NetworkException catch (error) {
      if (error.type == NetworkExceptionType.unauthorized) {
        rethrow;
      }
    }

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

  Future<String> createPlans({
    required DateTime visitDate,
    required List<PlanCustomerOption> customers,
  }) async {
    final AuthSession session = await AuthStorage.loadSession();
    if (!session.hasAccessToken) {
      throw const NetworkException(
        message: 'Session expired. Please login again.',
        type: NetworkExceptionType.unauthorized,
      );
    }

    final List<Map<String, dynamic>> plans = customers
        .where(
          (PlanCustomerOption item) =>
              item.id.trim().isNotEmpty && item.normalizedType.isNotEmpty,
        )
        .map(
          (PlanCustomerOption item) => <String, dynamic>{
            'visit_date': formatApiDate(visitDate),
            'customer_type': item.normalizedType,
            'customer_id': item.id,
          },
        )
        .toList(growable: false);

    final dynamic responseData = (await _networkClient.post(
      '${ApiConfig.apiVersionPath}/plans',
      headers: <String, String>{'Authorization': session.authorizationHeader},
      body: <String, dynamic>{'plans': plans},
    )).data;

    await fetchPlanMeetEntries(visitDate: visitDate);
    await fetchTodayPlan();
    return _extractMessage(responseData) ?? 'Plans created successfully.';
  }

  Future<String> createDcr({
    required String planId,
    required int supportValue,
    required int expectedSupportValue,
    List<String> productIds = const <String>[],
  }) async {
    final String trimmedPlanId = planId.trim();
    if (trimmedPlanId.isEmpty) {
      throw const NetworkException(
        message: 'Plan id is missing for this entry.',
        type: NetworkExceptionType.unknown,
      );
    }

    final AuthSession session = await AuthStorage.loadSession();
    if (!session.hasAccessToken) {
      throw const NetworkException(
        message: 'Session expired. Please login again.',
        type: NetworkExceptionType.unauthorized,
      );
    }

    final String productIdsValue = productIds
        .map((String item) => item.trim())
        .where((String item) => item.isNotEmpty)
        .join(',');

    final Map<String, dynamic> body = <String, dynamic>{
      'plan_id': trimmedPlanId,
      'support_value': supportValue,
      'expected_support_value': expectedSupportValue,
    };
    if (productIdsValue.isNotEmpty) {
      body['product_ids'] = productIdsValue;
    }

    final dynamic responseData = (await _networkClient.post(
      '${ApiConfig.apiVersionPath}/dcr',
      headers: <String, String>{'Authorization': session.authorizationHeader},
      body: body,
    )).data;

    await fetchDcrEntries(
      todayOnly: _isTodayDcrFilter,
      startDate: _dcrStartDate,
      endDate: _dcrEndDate,
    );
    return _extractMessage(responseData) ?? 'DCR created successfully.';
  }

  Future<void> fetchPlanMeetEntries({DateTime? visitDate}) async {
    final DateTime targetDate = _toDateOnly(visitDate ?? DateTime.now());
    _currentPlanMeetDate = targetDate;
    _isPlanMeetLoading = true;
    _planMeetErrorMessage = null;
    notifyListeners();

    try {
      final AuthSession session = await AuthStorage.loadSession();
      if (!session.hasAccessToken) {
        _planMeetEntries.clear();
        _planMeetErrorMessage = 'Session expired. Please login again.';
        return;
      }

      final dynamic responseData = (await _networkClient.get(
        '${ApiConfig.apiVersionPath}/plans',
        headers: <String, String>{'Authorization': session.authorizationHeader},
        queryParameters: <String, dynamic>{
          'visit_date': formatApiDate(targetDate),
        },
      )).data;

      final Map<String, dynamic> root = _asMap(responseData);
      dynamic rawItems = root['data'];
      if (rawItems is! List) {
        final Map<String, dynamic> nested = _asMap(root['data']);
        rawItems = nested['items'];
        if (rawItems is! List) {
          rawItems = nested['data'];
        }
        if (rawItems is! List) {
          rawItems = nested['plans'];
        }
      }

      final List<dynamic> items = rawItems is List ? rawItems : <dynamic>[];
      _planMeetEntries
        ..clear()
        ..addAll(
          items
              .map<PlanMeetEntry>(
                (dynamic item) => PlanMeetEntry.fromJson(_asMap(item)),
              )
              .where((PlanMeetEntry item) => item.name.trim().isNotEmpty),
        );

      if (_planMeetEntries.isNotEmpty &&
          _shouldRefreshCustomerProfiles(_planMeetEntries)) {
        try {
          await _refreshCustomerProfiles(session);
        } on NetworkException catch (error) {
          if (error.type == NetworkExceptionType.unauthorized) {
            rethrow;
          }
        }
      }

      _planMeetEntries.sort((PlanMeetEntry a, PlanMeetEntry b) {
        final int byVisitDate = b.visitDate.compareTo(a.visitDate);
        if (byVisitDate != 0) {
          return byVisitDate;
        }
        return b.createdAt.compareTo(a.createdAt);
      });
    } on NetworkException catch (error) {
      _planMeetEntries.clear();
      _planMeetErrorMessage = error.message;
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
      final AuthSession session = await AuthStorage.loadSession();
      if (!session.hasAccessToken) {
        _apiDcrEntries.clear();
        _dcrErrorMessage = 'Session expired. Please login again.';
        return;
      }

      final dynamic responseData = (await _networkClient.get(
        '${ApiConfig.apiVersionPath}/dcr',
        headers: <String, String>{'Authorization': session.authorizationHeader},
        queryParameters: <String, dynamic>{
          'filter_type': filterType,
          'sort_order': sortOrder,
          'limit': limit,
          if (!resolvedTodayOnly) 'start_date': formatApiDate(_dcrStartDate),
          if (!resolvedTodayOnly) 'end_date': formatApiDate(_dcrEndDate),
        },
      )).data;

      final Map<String, dynamic> root = _asMap(responseData);
      dynamic rawItems = root['data'];
      if (rawItems is! List) {
        final Map<String, dynamic> nested = _asMap(root['data']);
        rawItems = nested['items'];
        if (rawItems is! List) {
          rawItems = nested['data'];
        }
        if (rawItems is! List) {
          rawItems = nested['dcrs'];
        }
      }

      final List<dynamic> items = rawItems is List ? rawItems : <dynamic>[];
      _apiDcrEntries
        ..clear()
        ..addAll(
          items
              .map<DcrEntry>((dynamic item) => DcrEntry.fromJson(_asMap(item)))
              .where((DcrEntry item) => item.customerName.isNotEmpty),
        );
    } on NetworkException catch (error) {
      _apiDcrEntries.clear();
      _dcrErrorMessage = error.message;
    } catch (_) {
      _apiDcrEntries.clear();
      _dcrErrorMessage = 'Unable to load DCR entries.';
    } finally {
      _isDcrLoading = false;
      notifyListeners();
    }
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

  List<PlanCustomerOption> _parsePlanCustomerOptions(
    dynamic rawItems, {
    String fallbackType = '',
  }) {
    if (rawItems is! List) {
      return const <PlanCustomerOption>[];
    }

    final List<PlanCustomerOption> items = <PlanCustomerOption>[];
    for (final dynamic rawItem in rawItems) {
      final PlanCustomerOption item = PlanCustomerOption.fromJson(
        _asMap(rawItem),
        fallbackType: fallbackType,
      );
      if (item.id.isNotEmpty && item.name.isNotEmpty) {
        items.add(item);
      }
    }
    return items;
  }

  Map<String, CustomerProfile> _parseCustomerProfilesFromListResponse(
    dynamic responseData, {
    required String type,
  }) {
    final Map<String, dynamic> root = _asMap(responseData);
    dynamic rawItems = root['data'];
    if (rawItems is! List) {
      final Map<String, dynamic> nested = _asMap(root['data']);
      rawItems = nested['items'];
      if (rawItems is! List) {
        rawItems = nested['data'];
      }
    }

    final List<dynamic> items = rawItems is List ? rawItems : <dynamic>[];
    final Map<String, CustomerProfile> profilesById =
        <String, CustomerProfile>{};
    for (final dynamic item in items) {
      final CustomerProfile profile = CustomerProfile.fromJson(
        _asMap(item),
        fallbackType: type,
      );
      if (profile.id.isNotEmpty) {
        profilesById[profile.id] = profile;
      }
    }
    return profilesById;
  }

  Future<void> _refreshCustomerProfiles(AuthSession session) async {
    final List<dynamic>
    detailedResponses = await Future.wait<dynamic>(<Future<dynamic>>[
      _networkClient.get(
        '${ApiConfig.apiVersionPath}/doctors',
        headers: <String, String>{'Authorization': session.authorizationHeader},
        queryParameters: <String, dynamic>{'limit': 100, 'sort_order': 'asc'},
      ),
      _networkClient.get(
        '${ApiConfig.apiVersionPath}/chemists',
        headers: <String, String>{'Authorization': session.authorizationHeader},
        queryParameters: <String, dynamic>{'limit': 100, 'sort_order': 'asc'},
      ),
    ]);

    final Map<String, CustomerProfile> profilesById =
        _parseCustomerProfilesFromListResponse(
          detailedResponses[0].data,
          type: 'doctor',
        )..addAll(
          _parseCustomerProfilesFromListResponse(
            detailedResponses[1].data,
            type: 'chemist',
          ),
        );

    if (profilesById.isEmpty) {
      return;
    }

    _customerProfilesById
      ..clear()
      ..addAll(profilesById);
  }

  String? _extractMessage(dynamic data) {
    if (data is String && data.trim().isNotEmpty) {
      return data.trim();
    }
    if (data is List) {
      for (final dynamic item in data) {
        final String? message = _extractMessage(item);
        if (message != null && message.isNotEmpty) {
          return message;
        }
      }
      return null;
    }

    final Map<String, dynamic> map = _asMap(data);
    for (final String key in const <String>['msg', 'message', 'detail']) {
      final String? message = _extractMessage(map[key]);
      if (message != null && message.isNotEmpty) {
        return message;
      }
    }
    return null;
  }

  Map<String, dynamic> _asMap(Object? value) {
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

  String _asString(Object? value) {
    if (value is String) {
      return value.trim();
    }
    if (value == null) {
      return '';
    }
    return value.toString().trim();
  }

  int _asInt(Object? value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value.trim()) ?? 0;
    }
    return 0;
  }

  @override
  void dispose() {
    _networkClient.close();
    super.dispose();
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
  });

  final String id;
  final String customerId;
  final String customerCode;
  final String type;
  final String name;
  final DateTime visitDate;
  final DateTime createdAt;

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
