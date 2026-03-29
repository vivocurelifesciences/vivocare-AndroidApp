import 'package:flutter/material.dart';
import 'package:vivocure/core/auth/auth_storage.dart';
import 'package:vivocure/core/config/api_config.dart';
import 'package:vivocure/core/network/network_client.dart';
import 'package:vivocure/core/network/network_exception.dart';
import 'package:vivocure/core/network/network_response.dart';
import 'package:vivocure/core/widgets/app_alert_dialog.dart';
import 'package:vivocure/core/widgets/app_page_backdrop.dart';
import 'package:vivocure/features/auth/view/widgets/swipe_action_tile.dart';

enum _DoctorActionMode { add, edit }

class AddDoctorScreen extends StatefulWidget {
  const AddDoctorScreen({super.key});

  @override
  State<AddDoctorScreen> createState() => _AddDoctorScreenState();
}

class _AddDoctorScreenState extends State<AddDoctorScreen> {
  static const List<String> _qualificationOptions = <String>[
    'NON MBBS',
    'MBBS',
    'MD',
    'MBBS DNB',
    'MD DGO',
    'MBBS DGO',
    'MD DCH',
    'MBBS DCH',
    'MS ORTHO',
    'D ORTHO',
    'MS',
    'MBBS ENT',
    'MS ENT',
    'DVD',
  ];

  static const List<String> _specialityOptions = <String>[
    'GP',
    'Physician',
    'Gynecologist',
    'Pediatrician',
    'Orthopedic Surgeon',
    'General Surgeon',
    'ENT Specialist',
    'Dermatologist',
  ];

  static const List<String> _categoryOptions = <String>['A', 'B', 'C', 'D'];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey _formSectionKey = GlobalKey();
  final ScrollController _doctorListScrollController = ScrollController();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _potentialController = TextEditingController();
  final TextEditingController _supportValueController = TextEditingController();
  final TextEditingController _expectedSupportValueController =
      TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _domController = TextEditingController();
  final TextEditingController _experienceYearsController =
      TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  late final NetworkClient _networkClient;

  _DoctorActionMode _mode = _DoctorActionMode.add;
  bool _isSubmitting = false;
  bool _isActionInProgress = false;
  bool _isLoadingDoctors = false;
  bool _isLoadingMoreDoctors = false;
  bool _isLoadingChemistOptions = false;
  bool _showValidationErrors = false;
  List<_DoctorRecord> _doctorRecords = <_DoctorRecord>[];
  List<_DoctorChemistOption> _availableChemists = <_DoctorChemistOption>[];
  List<_DoctorChemistOption> _selectedChemists = <_DoctorChemistOption>[];
  _DoctorRecord? _selectedDoctor;
  String? _nextDoctorCursor;
  String _currentDoctorSearch = '';
  String? _selectedQualification;
  String? _selectedSpeciality;
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _networkClient = NetworkClient(
      scheme: ApiConfig.scheme,
      host: ApiConfig.host,
    );
    _doctorListScrollController.addListener(_handleDoctorListScroll);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _potentialController.dispose();
    _supportValueController.dispose();
    _expectedSupportValueController.dispose();
    _phoneController.dispose();
    _stateController.dispose();
    _cityController.dispose();
    _areaController.dispose();
    _countryController.dispose();
    _dobController.dispose();
    _domController.dispose();
    _experienceYearsController.dispose();
    _statusController.dispose();
    _searchController.dispose();
    _doctorListScrollController.dispose();
    _networkClient.close();
    super.dispose();
  }

  bool get _isBusy => _isSubmitting || _isActionInProgress;

  bool get _isFetchingDoctorData => _isLoadingDoctors || _isLoadingMoreDoctors;

  bool get _isLoadingOverlayVisible =>
      _isBusy || _isLoadingDoctors || _isLoadingChemistOptions;

  String get _loadingOverlayMessage {
    if (_isLoadingChemistOptions) {
      return 'Loading chemists...';
    }
    if (_isFetchingDoctorData) {
      return 'Loading doctors...';
    }
    return 'Please wait...';
  }

  void _switchMode(_DoctorActionMode mode) {
    if (_mode == mode) {
      return;
    }

    setState(() {
      _mode = mode;
      _selectedDoctor = null;
      _showValidationErrors = false;
      _searchController.clear();
      _currentDoctorSearch = '';
      _nextDoctorCursor = null;
      _isLoadingMoreDoctors = false;
      _doctorRecords = mode == _DoctorActionMode.add
          ? _doctorRecords
          : <_DoctorRecord>[];
      _clearForm();
    });

    if (mode == _DoctorActionMode.edit) {
      _loadDoctors();
    }
  }

  void _handleDoctorListScroll() {
    if (!_doctorListScrollController.hasClients ||
        _isLoadingDoctors ||
        _isLoadingMoreDoctors) {
      return;
    }

    final String nextCursor = _nextDoctorCursor?.trim() ?? '';
    if (nextCursor.isEmpty) {
      return;
    }

    final ScrollPosition position = _doctorListScrollController.position;
    if (position.extentAfter < 220) {
      _loadDoctors(loadMore: true);
    }
  }

  Future<AuthSession?> _loadSessionOrShowError() async {
    final AuthSession session = await AuthStorage.loadSession();
    if (!session.hasAccessToken) {
      _showCenterMessage('Session expired. Please login again.', isError: true);
      return null;
    }
    return session;
  }

  Future<void> _pickDate(TextEditingController controller) async {
    final DateTime now = DateTime.now();
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (selected == null) {
      return;
    }

    controller.text = _formatDate(selected);
  }

  String _formatDate(DateTime date) {
    final String month = date.month.toString().padLeft(2, '0');
    final String day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  String? _validateRequired(String? value, {required String fieldLabel}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldLabel is required.';
    }
    return null;
  }

  String? _validateOptionalPhone(String? value) {
    final String trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return null;
    }
    final String normalized = trimmed.replaceAll(RegExp(r'\s+'), '');
    if (!RegExp(r'^[0-9]{10,15}$').hasMatch(normalized)) {
      return 'Enter a valid phone number.';
    }
    return null;
  }

  String? _validateDate(
    String? value, {
    required String fieldLabel,
    bool required = false,
  }) {
    final String trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return required ? '$fieldLabel is required.' : null;
    }
    if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(trimmed)) {
      return 'Use YYYY-MM-DD format.';
    }
    if (DateTime.tryParse(trimmed) == null) {
      return 'Enter a valid $fieldLabel.';
    }
    return null;
  }

  String? _validateNonNegativeInteger(
    String? value, {
    required String fieldLabel,
  }) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    final int? parsed = int.tryParse(value.trim());
    if (parsed == null) {
      return 'Enter a valid $fieldLabel.';
    }
    if (parsed < 0) {
      return '$fieldLabel cannot be negative.';
    }
    return null;
  }

  Future<void> _submit() async {
    final FormState? form = _formKey.currentState;
    if (form == null) {
      return;
    }
    if (!form.validate()) {
      setState(() {
        _showValidationErrors = true;
      });
      _scrollToForm();
      return;
    }

    if (_mode == _DoctorActionMode.edit && _selectedDoctor == null) {
      _showCenterMessage(
        'Swipe left on a doctor and tap Edit first.',
        isError: true,
      );
      return;
    }

    final AuthSession? session = await _loadSessionOrShowError();
    if (session == null) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      if (_mode == _DoctorActionMode.add) {
        await _createDoctor(session);
      } else {
        await _updateDoctor(session, _selectedDoctor!.id);
      }
    } on NetworkException catch (error) {
      _showCenterMessage(error.message, isError: true);
    } catch (_) {
      _showCenterMessage('Unable to save doctor right now.', isError: true);
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  Future<void> _createDoctor(AuthSession session) async {
    final NetworkResponse<dynamic> response = await _networkClient.post(
      '${ApiConfig.apiVersionPath}/doctors',
      headers: _authHeaders(session),
      body: _buildDoctorRequestBody(
        includeStatus: false,
        omitEmptyFields: true,
      ),
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _clearForm();
    });

    _showCenterMessage(
      _extractResponseMessage(response.data) ?? 'Doctor saved successfully',
    );
  }

  Future<void> _updateDoctor(AuthSession session, String doctorId) async {
    final NetworkResponse<dynamic> response = await _networkClient.put(
      '${ApiConfig.apiVersionPath}/doctors/$doctorId',
      headers: _authHeaders(session),
      body: _buildDoctorRequestBody(includeStatus: true),
    );

    _showCenterMessage(
      _extractResponseMessage(response.data) ?? 'Doctor updated successfully',
    );
    await _loadDoctors(search: _searchController.text);
  }

  Future<void> _loadDoctors({String search = '', bool loadMore = false}) async {
    if (loadMore) {
      final String nextCursor = _nextDoctorCursor?.trim() ?? '';
      if (_isLoadingDoctors || _isLoadingMoreDoctors || nextCursor.isEmpty) {
        return;
      }
    }

    final AuthSession? session = await _loadSessionOrShowError();
    if (session == null) {
      return;
    }

    final String trimmedSearch = loadMore
        ? _currentDoctorSearch
        : search.trim();

    setState(() {
      if (loadMore) {
        _isLoadingMoreDoctors = true;
      } else {
        _isLoadingDoctors = true;
        _currentDoctorSearch = trimmedSearch;
        _nextDoctorCursor = null;
      }
    });

    try {
      final bool isSearchRequest = trimmedSearch.isNotEmpty;
      final Map<String, dynamic> query = <String, dynamic>{'sort_order': 'asc'};
      if (isSearchRequest) {
        query['search_text'] = trimmedSearch;
      } else {
        query['limit'] = 100;
      }
      final String nextCursor = _nextDoctorCursor?.trim() ?? '';
      if (loadMore && nextCursor.isNotEmpty) {
        query['cursor'] = nextCursor;
      }

      final NetworkResponse<dynamic> response = await _networkClient.get(
        '${ApiConfig.apiVersionPath}/doctors',
        headers: _authHeaders(session),
        queryParameters: query,
      );

      final _DoctorListPage page = _parseDoctorPage(response.data);

      if (!mounted) {
        return;
      }

      final String resolvedNextCursor = page.nextCursor.trim();
      setState(() {
        if (loadMore) {
          final Set<String> existingIds = _doctorRecords
              .map((_DoctorRecord item) => item.id)
              .toSet();
          _doctorRecords = <_DoctorRecord>[
            ..._doctorRecords,
            ...page.doctors.where(
              (_DoctorRecord item) => !existingIds.contains(item.id),
            ),
          ];
        } else {
          _doctorRecords = page.doctors;
        }
        _nextDoctorCursor =
            resolvedNextCursor.isEmpty || resolvedNextCursor == nextCursor
            ? null
            : resolvedNextCursor;
      });
      if (!loadMore && _doctorListScrollController.hasClients) {
        _doctorListScrollController.jumpTo(0);
      }
    } on NetworkException catch (error) {
      _showCenterMessage(error.message, isError: true);
    } catch (_) {
      _showCenterMessage('Unable to load doctor list.', isError: true);
    } finally {
      if (mounted) {
        setState(() {
          if (loadMore) {
            _isLoadingMoreDoctors = false;
          } else {
            _isLoadingDoctors = false;
          }
        });
      }
    }
  }

  Future<bool> _ensureChemistOptionsLoaded({bool forceRefresh = false}) async {
    if (_isLoadingChemistOptions) {
      return false;
    }
    if (!forceRefresh && _availableChemists.isNotEmpty) {
      return true;
    }

    final AuthSession? session = await _loadSessionOrShowError();
    if (session == null) {
      return false;
    }

    setState(() {
      _isLoadingChemistOptions = true;
    });

    try {
      final NetworkResponse<dynamic> response = await _networkClient.get(
        '${ApiConfig.apiVersionPath}/plans/doctor-chemist-dropdown',
        headers: _authHeaders(session),
      );

      final List<_DoctorChemistOption> chemists = _parseChemistDropdownOptions(
        response.data,
      );

      if (!mounted) {
        return false;
      }

      setState(() {
        _availableChemists = chemists;
        _selectedChemists = _mergeChemistSelections(
          selected: _selectedChemists,
          available: chemists,
        );
      });
      return true;
    } on NetworkException catch (error) {
      _showCenterMessage(error.message, isError: true);
      return false;
    } catch (_) {
      _showCenterMessage('Unable to load chemist list.', isError: true);
      return false;
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingChemistOptions = false;
        });
      }
    }
  }

  Future<void> _openChemistSelector() async {
    final bool hasChemists = await _ensureChemistOptionsLoaded();
    if (!hasChemists || !mounted) {
      return;
    }

    final List<_DoctorChemistOption>? selection =
        await _showChemistSelectionDialog();
    if (selection == null || !mounted) {
      return;
    }

    setState(() {
      _selectedChemists = selection;
    });
  }

  Future<List<_DoctorChemistOption>?> _showChemistSelectionDialog() {
    final Set<String> selectedIds = _selectedChemists
        .map((_DoctorChemistOption item) => item.id)
        .toSet();
    String searchText = '';

    return showDialog<List<_DoctorChemistOption>>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setDialogState) {
            final List<_DoctorChemistOption> filteredChemists =
                _availableChemists
                    .where((_DoctorChemistOption item) {
                      final String query = searchText.trim().toLowerCase();
                      if (query.isEmpty) {
                        return true;
                      }
                      return item.name.toLowerCase().contains(query) ||
                          item.code.toLowerCase().contains(query) ||
                          item.area.toLowerCase().contains(query);
                    })
                    .toList(growable: false);

            return AlertDialog(
              title: const Text('Select Chemists'),
              content: SizedBox(
                width: 680,
                height: 560,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Search chemists',
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (String value) {
                        setDialogState(() {
                          searchText = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFDCE6F0)),
                        ),
                        child: _availableChemists.isEmpty
                            ? const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Text(
                                    'No chemists available from planned chemist data.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF6C7A89),
                                    ),
                                  ),
                                ),
                              )
                            : filteredChemists.isEmpty
                            ? const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Text(
                                    'No chemists found for this search.',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF6C7A89),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              )
                            : ListView.separated(
                                itemCount: filteredChemists.length,
                                separatorBuilder: (_, _) =>
                                    const Divider(height: 1),
                                itemBuilder: (BuildContext context, int index) {
                                  final _DoctorChemistOption chemist =
                                      filteredChemists[index];
                                  final bool isSelected = selectedIds.contains(
                                    chemist.id,
                                  );

                                  return CheckboxListTile(
                                    value: isSelected,
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    title: Text(chemist.name),
                                    subtitle: Text(
                                      [
                                        if (chemist.code.isNotEmpty)
                                          'Code: ${chemist.code}',
                                        if (chemist.area.isNotEmpty)
                                          'Area: ${chemist.area}',
                                      ].join('  |  '),
                                    ),
                                    onChanged: (bool? value) {
                                      setDialogState(() {
                                        if (value ?? false) {
                                          selectedIds.add(chemist.id);
                                        } else {
                                          selectedIds.remove(chemist.id);
                                        }
                                      });
                                    },
                                  );
                                },
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: selectedIds.isEmpty
                      ? null
                      : () {
                          setDialogState(() {
                            selectedIds.clear();
                          });
                        },
                  child: const Text('Clear'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(
                      _availableChemists
                          .where(
                            (_DoctorChemistOption item) =>
                                selectedIds.contains(item.id),
                          )
                          .toList(growable: false),
                    );
                  },
                  child: const Text('Done'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  List<_DoctorChemistOption> _mergeChemistSelections({
    required List<_DoctorChemistOption> selected,
    required List<_DoctorChemistOption> available,
  }) {
    final Map<String, _DoctorChemistOption> availableById =
        <String, _DoctorChemistOption>{
          for (final _DoctorChemistOption item in available) item.id: item,
        };
    final List<_DoctorChemistOption> merged = <_DoctorChemistOption>[];
    final Set<String> seenIds = <String>{};

    for (final _DoctorChemistOption item in selected) {
      final String id = item.id.trim();
      if (id.isEmpty || !seenIds.add(id)) {
        continue;
      }
      merged.add(availableById[id] ?? item);
    }

    return merged;
  }

  Future<void> _handleEditDoctor(_DoctorRecord doctor) async {
    final AuthSession? session = await _loadSessionOrShowError();
    if (session == null) {
      return;
    }

    setState(() {
      _isActionInProgress = true;
    });

    try {
      final NetworkResponse<dynamic> response = await _networkClient.get(
        '${ApiConfig.apiVersionPath}/doctors/${doctor.id}',
        headers: _authHeaders(session),
      );

      final _DoctorRecord details = _DoctorRecord.fromJson(
        _extractEntityMap(response.data),
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _selectedDoctor = details;
        _applyDoctorToForm(details);
      });

      _scrollToForm();
    } on NetworkException catch (error) {
      _showCenterMessage(error.message, isError: true);
    } catch (_) {
      _showCenterMessage('Unable to load doctor details.', isError: true);
    } finally {
      if (mounted) {
        setState(() {
          _isActionInProgress = false;
        });
      }
    }
  }

  Future<void> _handleDeleteDoctor(_DoctorRecord doctor) async {
    final bool shouldDelete = await _confirmDelete(
      title: 'Delete Doctor',
      message: 'Delete ${doctor.displayName}?',
    );

    if (!shouldDelete) {
      return;
    }

    final AuthSession? session = await _loadSessionOrShowError();
    if (session == null) {
      return;
    }

    setState(() {
      _isActionInProgress = true;
    });

    try {
      final NetworkResponse<dynamic> response = await _networkClient.delete(
        '${ApiConfig.apiVersionPath}/doctors/${doctor.id}',
        headers: _authHeaders(session),
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _doctorRecords = _doctorRecords
            .where((_DoctorRecord item) => item.id != doctor.id)
            .toList(growable: false);
        if (_selectedDoctor?.id == doctor.id) {
          _selectedDoctor = null;
          _clearForm();
        }
      });

      _showCenterMessage(
        _extractResponseMessage(response.data) ?? 'Doctor deleted successfully',
      );
      await _loadDoctors(search: _searchController.text);
    } on NetworkException catch (error) {
      _showCenterMessage(error.message, isError: true);
    } catch (_) {
      _showCenterMessage('Unable to delete doctor right now.', isError: true);
    } finally {
      if (mounted) {
        setState(() {
          _isActionInProgress = false;
        });
      }
    }
  }

  Future<bool> _confirmDelete({
    required String title,
    required String message,
  }) async {
    final bool? result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE53935),
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  void _scrollToForm() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final BuildContext? formContext = _formSectionKey.currentContext;
      if (formContext == null) {
        return;
      }

      Scrollable.ensureVisible(
        formContext,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
      );
    });
  }

  _DoctorListPage _parseDoctorPage(dynamic data) {
    final Map<String, dynamic> root = _asMap(data);
    final Map<String, dynamic> nested = _asMap(root['data']);
    final String nextCursor = _asString(nested['next_cursor']);

    Object? rawItems = root['items'];
    if (rawItems is! List) {
      rawItems = nested['items'];
      if (rawItems is! List) {
        rawItems = nested['data'];
      }
    }

    if (rawItems is! List) {
      rawItems = root['data'];
    }

    if (rawItems is! List) {
      return _DoctorListPage(
        doctors: const <_DoctorRecord>[],
        nextCursor: nextCursor,
      );
    }

    final List<_DoctorRecord> doctors = <_DoctorRecord>[];
    for (final dynamic item in rawItems) {
      final _DoctorRecord doctor = _DoctorRecord.fromJson(_asMap(item));
      if (doctor.id.isNotEmpty) {
        doctors.add(doctor);
      }
    }
    return _DoctorListPage(doctors: doctors, nextCursor: nextCursor);
  }

  Map<String, dynamic> _extractEntityMap(dynamic data) {
    final Map<String, dynamic> root = _asMap(data);
    final Map<String, dynamic> nested = _asMap(root['data']);
    return nested.isNotEmpty ? nested : root;
  }

  void _applyDoctorToForm(_DoctorRecord doctor) {
    _firstNameController.text = doctor.firstName;
    _middleNameController.text = doctor.middleName;
    _lastNameController.text = doctor.lastName;
    _potentialController.text = doctor.potential;
    _supportValueController.text = doctor.supportValue;
    _expectedSupportValueController.text = doctor.expectedSupportValue;
    _phoneController.text = doctor.phone;
    _stateController.text = doctor.state;
    _cityController.text = doctor.city;
    _areaController.text = doctor.area;
    _countryController.text = doctor.country;
    _dobController.text = doctor.dob;
    _domController.text = doctor.dom;
    _experienceYearsController.text = doctor.experienceYears;
    _statusController.text = doctor.status;
    _selectedQualification = _normalizeOption(
      doctor.qualification,
      _qualificationOptions,
    );
    _selectedSpeciality = _normalizeOption(
      doctor.speciality,
      _specialityOptions,
    );
    _selectedCategory = _normalizeOption(doctor.category, _categoryOptions);
    _selectedChemists = _mergeChemistSelections(
      selected: doctor.chemists,
      available: _availableChemists,
    );
  }

  void _clearForm() {
    _firstNameController.clear();
    _middleNameController.clear();
    _lastNameController.clear();
    _potentialController.clear();
    _supportValueController.clear();
    _expectedSupportValueController.clear();
    _phoneController.clear();
    _stateController.clear();
    _cityController.clear();
    _areaController.clear();
    _countryController.clear();
    _dobController.clear();
    _domController.clear();
    _experienceYearsController.clear();
    _statusController.clear();
    _selectedQualification = null;
    _selectedSpeciality = null;
    _selectedCategory = null;
    _selectedChemists = <_DoctorChemistOption>[];
    _showValidationErrors = false;
  }

  Map<String, dynamic> _buildDoctorRequestBody({
    required bool includeStatus,
    bool omitEmptyFields = false,
  }) {
    final Map<String, dynamic> body = <String, dynamic>{
      'first_name': _textOrEmpty(_firstNameController.text),
      'middle_name': _textOrEmpty(_middleNameController.text),
      'last_name': _textOrEmpty(_lastNameController.text),
      'qualification': _selectedQualification ?? '',
      'speciality': _selectedSpeciality ?? '',
      'category': _selectedCategory ?? '',
      'potential': _intOrEmpty(_potentialController.text),
      'support_value': _intOrEmpty(_supportValueController.text),
      'expected_support_value': _intOrEmpty(
        _expectedSupportValueController.text,
      ),
      'phone': _textOrEmpty(_phoneController.text),
      'state': _textOrEmpty(_stateController.text),
      'city': _textOrEmpty(_cityController.text),
      'area': _textOrEmpty(_areaController.text),
      'country': _textOrEmpty(_countryController.text),
      'dob': _textOrEmpty(_dobController.text),
      'dom': _textOrEmpty(_domController.text),
      'experience_years': _intOrEmpty(_experienceYearsController.text),
      'chemist_ids': _selectedChemists
          .map((_DoctorChemistOption item) => item.id.trim())
          .where((String id) => id.isNotEmpty)
          .join(','),
    };

    if (includeStatus) {
      body['status'] = _textOrEmpty(_statusController.text);
    }

    if (omitEmptyFields) {
      body.removeWhere((String key, dynamic value) => value == '');
    }

    return body;
  }

  Map<String, String> _authHeaders(AuthSession session) {
    return <String, String>{'Authorization': session.authorizationHeader};
  }

  String _textOrEmpty(String value) {
    return value.trim();
  }

  String? _normalizeOption(String value, List<String> options) {
    final String normalized = value.trim().toUpperCase();
    if (options.contains(normalized)) {
      return normalized;
    }
    return null;
  }

  Object _intOrEmpty(String value) {
    final String trimmed = value.trim();
    if (trimmed.isEmpty) {
      return '';
    }
    return int.tryParse(trimmed) ?? trimmed;
  }

  String? _extractResponseMessage(dynamic data) {
    if (data is String && data.trim().isNotEmpty) {
      return data.trim();
    }
    if (data is List) {
      for (final dynamic item in data) {
        final String? message = _extractResponseMessage(item);
        if (message != null) {
          return message;
        }
      }
    }
    final Map<String, dynamic> map = _asMap(data);
    for (final String key in const <String>['msg', 'message', 'detail']) {
      final String? message = _extractResponseMessage(map[key]);
      if (message != null && message.isNotEmpty) {
        return message;
      }
    }
    return null;
  }

  Future<void> _showCenterMessage(String message, {bool isError = false}) {
    if (!mounted) {
      return Future<void>.value();
    }

    return AppAlertDialog.show(
      context: context,
      message: message,
      type: isError ? AppAlertType.error : AppAlertType.success,
    );
  }

  Widget _buildSurface({required Widget child, Key? key}) {
    return DecoratedBox(
      key: key,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE3EAF3)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x110F2744),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Padding(padding: const EdgeInsets.all(16), child: child),
    );
  }

  Widget _buildDoctorListCard() {
    return _buildSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Doctor List',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1D3557),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Swipe left on any doctor row to reveal Edit and Delete.',
            style: TextStyle(fontSize: 13, color: Color(0xFF6C7A89)),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    labelText: 'Search doctors',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: _isLoadingDoctors || _isLoadingMoreDoctors
                      ? null
                      : () => _loadDoctors(search: _searchController.text),
                  child: _isLoadingDoctors
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Search'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F7FB),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    'Doctor Name',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Doctor Code',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Expected SV',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          if (_isLoadingDoctors)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_doctorRecords.isEmpty)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FBFD),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFDCE6F0)),
              ),
              child: const Text(
                'No doctors found.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Color(0xFF6C7A89)),
              ),
            )
          else
            SizedBox(
              height: 420,
              child: ListView.separated(
                controller: _doctorListScrollController,
                itemCount:
                    _doctorRecords.length + (_isLoadingMoreDoctors ? 1 : 0),
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (BuildContext context, int index) {
                  if (index >= _doctorRecords.length) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      child: Center(
                        child: CircularProgressIndicator(strokeWidth: 2.2),
                      ),
                    );
                  }

                  final _DoctorRecord doctor = _doctorRecords[index];
                  final bool isSelected = _selectedDoctor?.id == doctor.id;
                  return SwipeActionTile(
                    onEdit: () => _handleEditDoctor(doctor),
                    onDelete: () => _handleDeleteDoctor(doctor),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFFEAF4FF)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF1E88E5)
                              : const Color(0xFFDCE6F0),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: Text(
                              doctor.fullName,
                              style: TextStyle(
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w600,
                                color: const Color(0xFF1D3557),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: Text(
                              doctor.doctorCode.isEmpty
                                  ? '-'
                                  : doctor.doctorCode,
                              style: const TextStyle(color: Color(0xFF52606D)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: Text(
                              doctor.expectedSupportValue.isEmpty
                                  ? '-'
                                  : doctor.expectedSupportValue,
                              style: const TextStyle(color: Color(0xFF52606D)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFormCard() {
    final bool isEditMode = _mode == _DoctorActionMode.edit;
    final bool showForm = !isEditMode || _selectedDoctor != null;

    return _buildSurface(
      key: _formSectionKey,
      child: Form(
        key: _formKey,
        autovalidateMode: _showValidationErrors
            ? AutovalidateMode.onUserInteraction
            : AutovalidateMode.disabled,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              isEditMode ? 'Edit Doctor' : 'Add Doctor',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1D3557),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              isEditMode
                  ? 'Choose a doctor from the list above, then update the fields below.'
                  : 'Fill the doctor details and save them to the API.',
              style: const TextStyle(fontSize: 13, color: Color(0xFF6C7A89)),
            ),
            if (isEditMode && _selectedDoctor != null) ...[
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F8FC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFD7E3F0)),
                ),
                child: Text(
                  'Editing ${_selectedDoctor!.displayName}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1D3557),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 16),
            if (!showForm)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FBFD),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFDCE6F0)),
                ),
                child: const Text(
                  'No doctor selected yet. Swipe left on a row above and tap Edit.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Color(0xFF6C7A89)),
                ),
              )
            else ...[
              _FormTextField(
                controller: _firstNameController,
                label: 'First Name *',
                validator: (String? value) =>
                    _validateRequired(value, fieldLabel: 'First name'),
              ),
              _FormTextField(
                controller: _middleNameController,
                label: 'Middle Name',
              ),
              _FormTextField(
                controller: _lastNameController,
                label: 'Last Name',
              ),
              DropdownButtonFormField<String>(
                key: ValueKey<String?>(
                  'doctor-qualification-${_selectedQualification ?? ''}',
                ),
                initialValue: _selectedQualification,
                decoration: const InputDecoration(labelText: 'Qualification'),
                items: _qualificationOptions
                    .map(
                      (String option) => DropdownMenuItem<String>(
                        value: option,
                        child: Text(option),
                      ),
                    )
                    .toList(growable: false),
                onChanged: (String? value) {
                  setState(() {
                    _selectedQualification = value;
                  });
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                key: ValueKey<String?>(
                  'doctor-speciality-${_selectedSpeciality ?? ''}',
                ),
                initialValue: _selectedSpeciality,
                decoration: const InputDecoration(labelText: 'Speciality'),
                items: _specialityOptions
                    .map(
                      (String option) => DropdownMenuItem<String>(
                        value: option,
                        child: Text(option),
                      ),
                    )
                    .toList(growable: false),
                onChanged: (String? value) {
                  setState(() {
                    _selectedSpeciality = value;
                  });
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                key: ValueKey<String?>(
                  'doctor-category-${_selectedCategory ?? ''}',
                ),
                initialValue: _selectedCategory,
                decoration: const InputDecoration(labelText: 'Category'),
                items: _categoryOptions
                    .map(
                      (String category) => DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      ),
                    )
                    .toList(growable: false),
                onChanged: (String? value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Linked Chemists',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1D3557),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 48,
                child: OutlinedButton.icon(
                  onPressed: _isBusy || _isLoadingChemistOptions
                      ? null
                      : _openChemistSelector,
                  icon: _isLoadingChemistOptions
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2.2),
                        )
                      : const Icon(Icons.local_pharmacy_outlined),
                  label: Text(
                    _selectedChemists.isEmpty
                        ? 'Select Chemists'
                        : 'Selected Chemists (${_selectedChemists.length})',
                  ),
                ),
              ),
              const SizedBox(height: 12),
              if (_selectedChemists.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FBFD),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFDCE6F0)),
                  ),
                  child: const Text(
                    'No chemists selected.',
                    style: TextStyle(fontSize: 14, color: Color(0xFF6C7A89)),
                  ),
                )
              else
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _selectedChemists
                      .map(
                        (_DoctorChemistOption item) => InputChip(
                          label: Text(item.displayLabel),
                          onDeleted: _isBusy
                              ? null
                              : () {
                                  setState(() {
                                    _selectedChemists = _selectedChemists
                                        .where(
                                          (_DoctorChemistOption chemist) =>
                                              chemist.id != item.id,
                                        )
                                        .toList(growable: false);
                                  });
                                },
                        ),
                      )
                      .toList(growable: false),
                ),
              const SizedBox(height: 12),
              _FormTextField(
                controller: _potentialController,
                label: 'Potential',
                keyboardType: TextInputType.number,
                validator: (String? value) =>
                    _validateNonNegativeInteger(value, fieldLabel: 'Potential'),
              ),
              _FormTextField(
                controller: _supportValueController,
                label: 'Support Value',
                keyboardType: TextInputType.number,
                validator: (String? value) => _validateNonNegativeInteger(
                  value,
                  fieldLabel: 'Support value',
                ),
              ),
              _FormTextField(
                controller: _expectedSupportValueController,
                label: 'Expected Support Value',
                keyboardType: TextInputType.number,
                validator: (String? value) => _validateNonNegativeInteger(
                  value,
                  fieldLabel: 'Expected support value',
                ),
              ),
              _FormTextField(
                controller: _phoneController,
                label: 'Phone',
                keyboardType: TextInputType.phone,
                validator: _validateOptionalPhone,
              ),
              _FormTextField(controller: _stateController, label: 'State'),
              _FormTextField(controller: _cityController, label: 'City'),
              _FormTextField(controller: _areaController, label: 'Area'),
              _FormTextField(controller: _countryController, label: 'Country'),
              _DateField(
                controller: _dobController,
                label: 'DOB (YYYY-MM-DD)',
                onTap: () => _pickDate(_dobController),
                validator: (String? value) =>
                    _validateDate(value, fieldLabel: 'DOB'),
              ),
              _DateField(
                controller: _domController,
                label: 'DOM (YYYY-MM-DD)',
                onTap: () => _pickDate(_domController),
                validator: (String? value) =>
                    _validateDate(value, fieldLabel: 'DOM'),
              ),
              _FormTextField(
                controller: _experienceYearsController,
                label: 'Experience Years',
                keyboardType: TextInputType.number,
                validator: (String? value) => _validateNonNegativeInteger(
                  value,
                  fieldLabel: 'Experience years',
                ),
              ),
              if (isEditMode) const SizedBox(height: 16),
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: _isBusy ? null : _submit,
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2.2),
                        )
                      : Text(isEditMode ? 'Update Doctor' : 'Save Doctor'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Doctor')),
      body: AppPageBackdrop(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Stack(
              children: [
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 920),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildSurface(
                          child: Row(
                            children: [
                              Expanded(
                                child: _ModeButton(
                                  label: 'Add Doctor',
                                  isActive: _mode == _DoctorActionMode.add,
                                  onTap: () =>
                                      _switchMode(_DoctorActionMode.add),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _ModeButton(
                                  label: 'Edit Doctor',
                                  isActive: _mode == _DoctorActionMode.edit,
                                  onTap: () =>
                                      _switchMode(_DoctorActionMode.edit),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (_mode == _DoctorActionMode.edit) ...[
                          const SizedBox(height: 16),
                          _buildDoctorListCard(),
                        ],
                        const SizedBox(height: 16),
                        _buildFormCard(),
                      ],
                    ),
                  ),
                ),
                if (_isLoadingOverlayVisible)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: Container(
                        color: Colors.black.withValues(alpha: 0.3),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircularProgressIndicator(),
                            const SizedBox(height: 14),
                            Text(
                              _loadingOverlayMessage,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  const _ModeButton({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: 44,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: isActive ? colorScheme.primary : Colors.white,
          foregroundColor: isActive ? Colors.white : colorScheme.primary,
          side: BorderSide(color: colorScheme.primary),
        ),
        child: Text(label, overflow: TextOverflow.ellipsis),
      ),
    );
  }
}

class _FormTextField extends StatelessWidget {
  const _FormTextField({
    required this.controller,
    required this.label,
    this.keyboardType,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({
    required this.controller,
    required this.label,
    required this.onTap,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final VoidCallback onTap;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        onTap: onTap,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: IconButton(
            onPressed: onTap,
            icon: const Icon(Icons.calendar_month_outlined),
          ),
        ),
      ),
    );
  }
}

class _DoctorRecord {
  const _DoctorRecord({
    required this.id,
    required this.doctorCode,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.qualification,
    required this.speciality,
    required this.category,
    required this.potential,
    required this.supportValue,
    required this.expectedSupportValue,
    required this.phone,
    required this.state,
    required this.city,
    required this.area,
    required this.country,
    required this.dob,
    required this.dom,
    required this.experienceYears,
    required this.status,
    required this.chemists,
  });

  final String id;
  final String doctorCode;
  final String firstName;
  final String middleName;
  final String lastName;
  final String qualification;
  final String speciality;
  final String category;
  final String potential;
  final String supportValue;
  final String expectedSupportValue;
  final String phone;
  final String state;
  final String city;
  final String area;
  final String country;
  final String dob;
  final String dom;
  final String experienceYears;
  final String status;
  final List<_DoctorChemistOption> chemists;

  String get fullName {
    final String combined = <String>[
      firstName,
      middleName,
      lastName,
    ].where((String value) => value.trim().isNotEmpty).join(' ').trim();
    return combined.isEmpty ? 'Unnamed Doctor' : combined;
  }

  String get displayName {
    if (doctorCode.isEmpty) {
      return fullName;
    }
    return '$fullName ($doctorCode)';
  }

  factory _DoctorRecord.fromJson(Map<String, dynamic> json) {
    return _DoctorRecord(
      id: _asString(json['id']),
      doctorCode: _asString(json['doctor_code']),
      firstName: _asString(json['first_name']),
      middleName: _asString(json['middle_name']),
      lastName: _asString(json['last_name']),
      qualification: _asString(json['qualification']),
      speciality: _asString(json['speciality']),
      category: _asString(json['category']),
      potential: _asString(json['potential']),
      supportValue: _asString(json['support_value']),
      expectedSupportValue: _asString(json['expected_support_value']),
      phone: _asString(json['phone']),
      state: _asString(json['state']),
      city: _asString(json['city']),
      area: _asString(json['area']),
      country: _asString(json['country']),
      dob: _asDateString(json['dob']),
      dom: _asDateString(json['dom']),
      experienceYears: _asString(json['experience_years']),
      status: _asString(json['status']),
      chemists: _parseDoctorChemistSelections(
        rawChemistIds: json['chemist_ids'],
        rawChemists: json['chemists'],
      ),
    );
  }
}

class _DoctorListPage {
  const _DoctorListPage({required this.doctors, required this.nextCursor});

  final List<_DoctorRecord> doctors;
  final String nextCursor;
}

class _DoctorChemistOption {
  const _DoctorChemistOption({
    required this.id,
    required this.name,
    required this.code,
    required this.area,
    this.customerType = 'chemist',
  });

  final String id;
  final String name;
  final String code;
  final String area;
  final String customerType;

  String get normalizedType => customerType.trim().toLowerCase();

  String get displayLabel {
    final String resolvedName = name.trim().isEmpty ? id : name;
    if (area.isEmpty) {
      return resolvedName;
    }
    return '$resolvedName • $area';
  }

  factory _DoctorChemistOption.fromJson(
    Map<String, dynamic> json, {
    String fallbackType = 'chemist',
  }) {
    final String firstName = _asString(json['first_name']);
    final String middleName = _asString(json['middle_name']);
    final String lastName = _asString(json['last_name']);
    final String combinedName = <String>[
      firstName,
      middleName,
      lastName,
    ].where((String value) => value.trim().isNotEmpty).join(' ').trim();

    return _DoctorChemistOption(
      id: _asString(json['id']).isEmpty
          ? _asString(json['customer_id'])
          : _asString(json['id']),
      name: _asString(json['name']).isEmpty
          ? (_asString(json['customer_name']).isEmpty
                ? combinedName
                : _asString(json['customer_name']))
          : _asString(json['name']),
      code: _asString(json['chemist_code']).isEmpty
          ? (_asString(json['code']).isEmpty
                ? _asString(json['customer_code'])
                : _asString(json['code']))
          : _asString(json['chemist_code']),
      area: _asString(json['area']),
      customerType: _asString(json['customer_type']).isEmpty
          ? fallbackType
          : _asString(json['customer_type']),
    );
  }
}

List<_DoctorChemistOption> _parseChemistDropdownOptions(dynamic data) {
  final Map<String, dynamic> root = _asMap(data);
  final dynamic payload = root['data'] ?? data;
  final Map<String, dynamic> nested = _asMap(payload);

  List<_DoctorChemistOption> chemists = _parseChemistOptionList(
    nested['chemists'],
    fallbackType: 'chemist',
  );

  if (chemists.isEmpty) {
    chemists = _parseChemistOptionList(payload)
        .where((_DoctorChemistOption item) {
          return item.normalizedType == 'chemist';
        })
        .toList(growable: false);
  }

  final List<_DoctorChemistOption> uniqueChemists = <_DoctorChemistOption>[];
  final Set<String> seenIds = <String>{};

  for (final _DoctorChemistOption item in chemists) {
    final String id = item.id.trim();
    if (id.isEmpty || !seenIds.add(id)) {
      continue;
    }
    uniqueChemists.add(item);
  }

  uniqueChemists.sort((_DoctorChemistOption a, _DoctorChemistOption b) {
    return a.name.toLowerCase().compareTo(b.name.toLowerCase());
  });

  return uniqueChemists;
}

List<_DoctorChemistOption> _parseChemistOptionList(
  Object? rawData, {
  String fallbackType = 'chemist',
}) {
  if (rawData is! List) {
    return <_DoctorChemistOption>[];
  }

  final List<_DoctorChemistOption> chemists = <_DoctorChemistOption>[];
  for (final dynamic item in rawData) {
    final _DoctorChemistOption chemist = _DoctorChemistOption.fromJson(
      _asMap(item),
      fallbackType: fallbackType,
    );
    if (chemist.id.isNotEmpty) {
      chemists.add(chemist);
    }
  }

  return chemists;
}

List<_DoctorChemistOption> _parseDoctorChemistSelections({
  required Object? rawChemistIds,
  required Object? rawChemists,
}) {
  final List<_DoctorChemistOption> chemists = _parseChemistOptionList(
    rawChemists,
    fallbackType: 'chemist',
  );
  final Set<String> seenIds = chemists
      .map((_DoctorChemistOption item) => item.id)
      .where((String id) => id.trim().isNotEmpty)
      .toSet();

  final List<String> chemistIds = _readStringList(rawChemistIds);
  for (final String chemistId in chemistIds) {
    final String id = chemistId.trim();
    if (id.isEmpty || !seenIds.add(id)) {
      continue;
    }
    chemists.add(_DoctorChemistOption(id: id, name: id, code: '', area: ''));
  }

  return chemists;
}

Map<String, dynamic> _asMap(Object? value) {
  if (value is Map<String, dynamic>) {
    return value;
  }
  if (value is Map) {
    return value.map(
      (Object? key, Object? item) =>
          MapEntry<String, dynamic>(key.toString(), item),
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

String _asDateString(Object? value) {
  final String raw = _asString(value);
  if (raw.length >= 10) {
    return raw.substring(0, 10);
  }
  return raw;
}

List<String> _readStringList(Object? value) {
  if (value is List) {
    return value
        .map((Object? item) => _asString(item))
        .where((String item) => item.isNotEmpty)
        .toList(growable: false);
  }

  final String raw = _asString(value);
  if (raw.isEmpty) {
    return <String>[];
  }

  return raw
      .split(',')
      .map((String item) => item.trim())
      .where((String item) => item.isNotEmpty)
      .toList(growable: false);
}
