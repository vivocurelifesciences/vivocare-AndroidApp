import 'package:flutter/material.dart';
import 'package:vivocare/core/auth/auth_storage.dart';
import 'package:vivocare/core/config/api_config.dart';
import 'package:vivocare/core/network/network_client.dart';
import 'package:vivocare/core/network/network_exception.dart';
import 'package:vivocare/core/network/network_response.dart';
import 'package:vivocare/features/auth/view/widgets/swipe_action_tile.dart';

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

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _potentialController = TextEditingController();
  final TextEditingController _supportValueController = TextEditingController();
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
  List<_DoctorRecord> _doctorRecords = <_DoctorRecord>[];
  _DoctorRecord? _selectedDoctor;
  String? _selectedQualification;
  String? _selectedSpeciality;
  String? _selectedCategory;
  String? _centerMessage;
  bool _isCenterMessageError = false;

  @override
  void initState() {
    super.initState();
    _networkClient = NetworkClient(
      scheme: ApiConfig.scheme,
      host: ApiConfig.host,
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _potentialController.dispose();
    _supportValueController.dispose();
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
    _networkClient.close();
    super.dispose();
  }

  bool get _isBusy => _isSubmitting || _isActionInProgress;

  void _switchMode(_DoctorActionMode mode) {
    if (_mode == mode) {
      return;
    }

    setState(() {
      _mode = mode;
      _selectedDoctor = null;
      _searchController.clear();
      _doctorRecords = mode == _DoctorActionMode.add
          ? _doctorRecords
          : <_DoctorRecord>[];
      _clearForm();
    });

    if (mode == _DoctorActionMode.edit) {
      _loadDoctors();
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

  String? _validateNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    if (double.tryParse(value.trim()) == null) {
      return 'Enter a valid number.';
    }
    return null;
  }

  String? _validateInteger(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    if (int.tryParse(value.trim()) == null) {
      return 'Enter a valid integer.';
    }
    return null;
  }

  Future<void> _submit() async {
    final FormState? form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }

    if (_mode == _DoctorActionMode.edit && _selectedDoctor == null) {
      _showCenterMessage('Swipe left on a doctor and tap Edit first.',
          isError: true);
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
      body: _buildDoctorRequestBody(includeStatus: false),
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

  Future<void> _loadDoctors({String search = ''}) async {
    final AuthSession? session = await _loadSessionOrShowError();
    if (session == null) {
      return;
    }

    setState(() {
      _isLoadingDoctors = true;
    });

    try {
      final String trimmedSearch = search.trim();
      final Map<String, dynamic> query = <String, dynamic>{
        'limit': 100,
        'sort_order': 'asc',
      };
      if (trimmedSearch.isNotEmpty) {
        query['search_text'] = trimmedSearch;
      }

      final NetworkResponse<dynamic> response = await _networkClient.get(
        '${ApiConfig.apiVersionPath}/doctors',
        headers: _authHeaders(session),
        queryParameters: query,
      );

      final List<_DoctorRecord> doctors = _parseDoctors(response.data);

      if (!mounted) {
        return;
      }

      setState(() {
        _doctorRecords = doctors;
      });
    } on NetworkException catch (error) {
      _showCenterMessage(error.message, isError: true);
    } catch (_) {
      _showCenterMessage('Unable to load doctor list.', isError: true);
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingDoctors = false;
        });
      }
    }
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

  List<_DoctorRecord> _parseDoctors(dynamic data) {
    final Map<String, dynamic> root = _asMap(data);

    Object? rawItems = root['items'];
    if (rawItems is! List) {
      final Map<String, dynamic> nested = _asMap(root['data']);
      rawItems = nested['items'];
      if (rawItems is! List) {
        rawItems = nested['data'];
      }
    }

    if (rawItems is! List) {
      rawItems = root['data'];
    }

    if (rawItems is! List) {
      return const <_DoctorRecord>[];
    }

    final List<_DoctorRecord> doctors = <_DoctorRecord>[];
    for (final dynamic item in rawItems) {
      final _DoctorRecord doctor = _DoctorRecord.fromJson(_asMap(item));
      if (doctor.id.isNotEmpty) {
        doctors.add(doctor);
      }
    }
    return doctors;
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
  }

  void _clearForm() {
    _firstNameController.clear();
    _middleNameController.clear();
    _lastNameController.clear();
    _potentialController.clear();
    _supportValueController.clear();
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
  }

  Map<String, dynamic> _buildDoctorRequestBody({required bool includeStatus}) {
    final Map<String, dynamic> body = <String, dynamic>{
      'first_name': _nullIfEmpty(_firstNameController.text),
      'middle_name': _nullIfEmpty(_middleNameController.text),
      'last_name': _nullIfEmpty(_lastNameController.text),
      'qualification': _selectedQualification,
      'speciality': _selectedSpeciality,
      'category': _selectedCategory,
      'potential': _doubleOrNull(_potentialController.text),
      'support_value': _doubleOrNull(_supportValueController.text),
      'phone': _nullIfEmpty(_phoneController.text),
      'state': _nullIfEmpty(_stateController.text),
      'city': _nullIfEmpty(_cityController.text),
      'area': _nullIfEmpty(_areaController.text),
      'country': _nullIfEmpty(_countryController.text),
      'dob': _nullIfEmpty(_dobController.text),
      'dom': _nullIfEmpty(_domController.text),
      'experience_years': _intOrNull(_experienceYearsController.text),
    };

    if (includeStatus) {
      body['status'] = _nullIfEmpty(_statusController.text);
    }

    return body;
  }

  Map<String, String> _authHeaders(AuthSession session) {
    return <String, String>{'Authorization': session.authorizationHeader};
  }

  String? _nullIfEmpty(String value) {
    final String trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  String? _normalizeOption(String value, List<String> options) {
    final String normalized = value.trim().toUpperCase();
    if (options.contains(normalized)) {
      return normalized;
    }
    return null;
  }

  double? _doubleOrNull(String value) {
    final String trimmed = value.trim();
    if (trimmed.isEmpty) {
      return null;
    }
    return double.tryParse(trimmed);
  }

  int? _intOrNull(String value) {
    final String trimmed = value.trim();
    if (trimmed.isEmpty) {
      return null;
    }
    return int.tryParse(trimmed);
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

  void _showCenterMessage(String message, {bool isError = false}) {
    if (!mounted) {
      return;
    }

    setState(() {
      _centerMessage = message;
      _isCenterMessageError = isError;
    });

    Future<void>.delayed(const Duration(seconds: 2), () {
      if (!mounted) {
        return;
      }
      setState(() {
        _centerMessage = null;
        _isCenterMessageError = false;
      });
    });
  }

  Widget _buildSurface({
    required Widget child,
    Key? key,
  }) {
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: child,
      ),
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
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF6C7A89),
            ),
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
                  onPressed: _isLoadingDoctors
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
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6C7A89),
                ),
              ),
            )
          else
            Column(
              children: _doctorRecords.map((_DoctorRecord doctor) {
                final bool isSelected = _selectedDoctor?.id == doctor.id;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: SwipeActionTile(
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
                              style: const TextStyle(
                                color: Color(0xFF52606D),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(growable: false),
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
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF6C7A89),
              ),
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
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6C7A89),
                  ),
                ),
              )
            else ...[
              _FormTextField(
                controller: _firstNameController,
                label: 'First Name',
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
              _FormTextField(
                controller: _potentialController,
                label: 'Potential',
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: _validateNumber,
              ),
              _FormTextField(
                controller: _supportValueController,
                label: 'Support Value',
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: _validateNumber,
              ),
              _FormTextField(
                controller: _phoneController,
                label: 'Phone',
                keyboardType: TextInputType.phone,
              ),
              _FormTextField(
                controller: _stateController,
                label: 'State',
              ),
              _FormTextField(
                controller: _cityController,
                label: 'City',
              ),
              _FormTextField(
                controller: _areaController,
                label: 'Area',
              ),
              _FormTextField(
                controller: _countryController,
                label: 'Country',
              ),
              _DateField(
                controller: _dobController,
                label: 'DOB (YYYY-MM-DD)',
                onTap: () => _pickDate(_dobController),
              ),
              _DateField(
                controller: _domController,
                label: 'DOM (YYYY-MM-DD)',
                onTap: () => _pickDate(_domController),
              ),
              _FormTextField(
                controller: _experienceYearsController,
                label: 'Experience Years',
                keyboardType: TextInputType.number,
                validator: _validateInteger,
              ),
              if (isEditMode)
                _FormTextField(
                  controller: _statusController,
                  label: 'Status',
                ),
              const SizedBox(height: 16),
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
                      : Text(
                          isEditMode ? 'Update Doctor' : 'Save Doctor',
                        ),
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
      body: SafeArea(
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
                                onTap: () => _switchMode(_DoctorActionMode.add),
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
              if (_isBusy)
                Positioned.fill(
                  child: IgnorePointer(
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.3),
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                  ),
                ),
              if (_centerMessage != null)
                Positioned.fill(
                  child: IgnorePointer(
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.3),
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: _isCenterMessageError
                                ? const Color(0xFFFFF2F2)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _isCenterMessageError
                                  ? const Color(0xFFFFC9C9)
                                  : const Color(0xFFE3EAF3),
                            ),
                          ),
                          child: Text(
                            _centerMessage!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
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
        child: Text(
          label,
          overflow: TextOverflow.ellipsis,
        ),
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
  });

  final TextEditingController controller;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        onTap: onTap,
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
    required this.phone,
    required this.state,
    required this.city,
    required this.area,
    required this.country,
    required this.dob,
    required this.dom,
    required this.experienceYears,
    required this.status,
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
  final String phone;
  final String state;
  final String city;
  final String area;
  final String country;
  final String dob;
  final String dom;
  final String experienceYears;
  final String status;

  String get fullName {
    final String combined = <String>[firstName, middleName, lastName]
        .where((String value) => value.trim().isNotEmpty)
        .join(' ')
        .trim();
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
      phone: _asString(json['phone']),
      state: _asString(json['state']),
      city: _asString(json['city']),
      area: _asString(json['area']),
      country: _asString(json['country']),
      dob: _asDateString(json['dob']),
      dom: _asDateString(json['dom']),
      experienceYears: _asString(json['experience_years']),
      status: _asString(json['status']),
    );
  }
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
