import 'package:flutter/material.dart';
import 'package:vivocare/core/auth/auth_storage.dart';
import 'package:vivocare/core/config/api_config.dart';
import 'package:vivocare/core/navigation/home_user_context.dart';
import 'package:vivocare/core/network/network_client.dart';
import 'package:vivocare/core/network/network_exception.dart';
import 'package:vivocare/core/products/product_cache_service.dart';
import 'package:vivocare/features/home/model/home_menu_item.dart';

class HomeViewModel extends ChangeNotifier {
  static const int homeMenuIndex = 0;
  static const int planMeetMenuIndex = 1;
  static const int performanceMenuIndex = 2;
  static const int addDoctorMenuIndex = 3;
  static const int addChemistMenuIndex = 4;
  static const int logoutMenuIndex = 5;

  String _userName = 'Jiwan Prakash Mishra';
  String _roleName = '';
  String _employeeCode = '';
  int _selectedMenuIndex = homeMenuIndex;
  final List<PlanMeetEntry> _planMeetEntries = <PlanMeetEntry>[];
  final List<DcrEntry> _dcrEntries = <DcrEntry>[];
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
  DateTime _currentPlanMeetDate = DateTime.now();
  List<MedicinePresentation> _medicinePresentations = <MedicinePresentation>[];

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
  DateTime get currentPlanMeetDate => _toDateOnly(_currentPlanMeetDate);

  String get userName => _userName;

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
    return '(FLM | Discovery | 1465)';
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

  List<String> get dummyDoctors => const <String>[
    'Dr. Gayathri Patil',
    'Dr. Subhash Katakdare',
    'Dr. Shrikant V. Patil',
    'Dr. V. B. Bharati',
    'Dr. Ajit Mane',
    'Dr. Priya Joshi',
  ];

  List<String> get dummyChemists => const <String>[
    'Gayatri Medico',
    'Patil Pharma',
    'LifeCare Chemist',
    'Apollo Pharmacy Nerul',
    'Sanjivani Medical',
    'Wellness Chemist Point',
  ];

  List<DoctorProfile> get dummyDoctorProfiles => const <DoctorProfile>[
    DoctorProfile(
      name: 'Dr. Gayathri Patil',
      qualification: 'MBBS, MD',
      speciality: 'Internal Medicine',
      phone: '9820011101',
      area: 'Khopoli',
      city: 'Raigad',
    ),
    DoctorProfile(
      name: 'Dr. Subhash Katakdare',
      qualification: 'MBBS',
      speciality: 'General Physician',
      phone: '9820011102',
      area: 'Khopoli - 2',
      city: 'Raigad',
    ),
    DoctorProfile(
      name: 'Dr. Shrikant V. Patil',
      qualification: 'MBBS, DNB',
      speciality: 'Cardiology',
      phone: '9820011103',
      area: 'Khopoli - 1',
      city: 'Raigad',
    ),
    DoctorProfile(
      name: 'Dr. V. B. Bharati',
      qualification: 'MBBS, MD',
      speciality: 'Pediatrics',
      phone: '9820011104',
      area: 'Nerul East',
      city: 'Navi Mumbai',
    ),
    DoctorProfile(
      name: 'Dr. Ajit Mane',
      qualification: 'MBBS',
      speciality: 'Orthopedics',
      phone: '9820011105',
      area: 'Panvel',
      city: 'Raigad',
    ),
    DoctorProfile(
      name: 'Dr. Priya Joshi',
      qualification: 'MBBS, MD',
      speciality: 'Gynecology',
      phone: '9820011106',
      area: 'Belapur',
      city: 'Navi Mumbai',
    ),
  ];

  List<MedicinePresentation> get medicinePresentations =>
      List<MedicinePresentation>.unmodifiable(_medicinePresentations);

  List<String> get medicineNames => _medicinePresentations
      .map((MedicinePresentation item) => item.name)
      .toList(growable: false);

  List<PlanMeetEntry> get planMeetEntries =>
      List<PlanMeetEntry>.unmodifiable(_planMeetEntries);

  List<DcrEntry> get dcrEntries {
    final List<DcrEntry> copy = List<DcrEntry>.from(_dcrEntries);
    copy.sort((DcrEntry a, DcrEntry b) {
      final int byDate = b.dcrDate.compareTo(a.dcrDate);
      if (byDate != 0) {
        return byDate;
      }
      return b.updatedAt.compareTo(a.updatedAt);
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
    _dcrEntries.clear();
    _upcomingEvents.clear();
    _upcomingEventsErrorMessage = null;
    _upcomingEventsSectionLabel = 'Birthdays & Anniversaries';
    _isTodayPlanLoading = false;
    _todayPlanErrorMessage = null;
    _todayVisits = 0;
    _doctorVisits = 0;
    _chemistVisits = 0;
    _isPlanMeetLoading = false;
    _planMeetErrorMessage = null;
    _currentPlanMeetDate = DateTime.now();
    _medicinePresentations = <MedicinePresentation>[];
  }

  void addPlanMeetEntry({required String type, required String name}) {
    _planMeetEntries.insert(
      0,
      PlanMeetEntry(
        id: '',
        customerId: '',
        customerCode: '',
        type: type,
        name: name,
        visitDate: _toDateOnly(DateTime.now()),
        createdAt: DateTime.now(),
      ),
    );
    notifyListeners();
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

  List<DateTime> getDcrDateOptions() {
    final DateTime today = _toDateOnly(DateTime.now());
    return List<DateTime>.generate(
      7,
      (int index) => today.subtract(Duration(days: index)),
    );
  }

  DoctorProfile getDoctorProfile(String doctorName) {
    for (final DoctorProfile profile in dummyDoctorProfiles) {
      if (profile.name.toLowerCase() == doctorName.toLowerCase()) {
        return profile;
      }
    }

    return DoctorProfile(
      name: doctorName,
      qualification: 'MBBS',
      speciality: 'General Physician',
      phone: 'NA',
      area: 'NA',
      city: 'NA',
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

  void saveOrMergeDcr({
    required DateTime date,
    required List<String> doctors,
    required List<String> chemists,
  }) {
    final DateTime normalizedDate = _toDateOnly(date);
    final DateTime now = DateTime.now();
    final int existingIndex = _dcrEntries.indexWhere(
      (DcrEntry entry) => _isSameDay(entry.dcrDate, normalizedDate),
    );

    if (existingIndex >= 0) {
      final DcrEntry existing = _dcrEntries[existingIndex];
      _dcrEntries[existingIndex] = DcrEntry(
        dcrDate: normalizedDate,
        doctorNames: _mergeUnique(existing.doctorNames, doctors),
        chemistNames: _mergeUnique(existing.chemistNames, chemists),
        updatedAt: now,
      );
    } else {
      _dcrEntries.add(
        DcrEntry(
          dcrDate: normalizedDate,
          doctorNames: _mergeUnique(const <String>[], doctors),
          chemistNames: _mergeUnique(const <String>[], chemists),
          updatedAt: now,
        ),
      );
    }

    notifyListeners();
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

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  List<String> _mergeUnique(List<String> existing, List<String> incoming) {
    final Set<String> merged = <String>{};
    for (final String item in existing) {
      final String trimmed = item.trim();
      if (trimmed.isNotEmpty) {
        merged.add(trimmed);
      }
    }
    for (final String item in incoming) {
      final String trimmed = item.trim();
      if (trimmed.isNotEmpty) {
        merged.add(trimmed);
      }
    }
    return merged.toList(growable: false);
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
  const PlanDropdownData({
    required this.doctors,
    required this.chemists,
  });

  final List<PlanCustomerOption> doctors;
  final List<PlanCustomerOption> chemists;
}

class PlanCustomerOption {
  const PlanCustomerOption({
    required this.id,
    required this.name,
    required this.code,
    required this.customerType,
  });

  final String id;
  final String name;
  final String code;
  final String customerType;

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
    );
  }
}

class DcrEntry {
  const DcrEntry({
    required this.dcrDate,
    required this.doctorNames,
    required this.chemistNames,
    required this.updatedAt,
  });

  final DateTime dcrDate;
  final List<String> doctorNames;
  final List<String> chemistNames;
  final DateTime updatedAt;
}

class DoctorProfile {
  const DoctorProfile({
    required this.name,
    required this.qualification,
    required this.speciality,
    required this.phone,
    required this.area,
    required this.city,
  });

  final String name;
  final String qualification;
  final String speciality;
  final String phone;
  final String area;
  final String city;
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
