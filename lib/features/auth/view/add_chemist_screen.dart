import 'package:flutter/material.dart';
import 'package:vivocare/core/auth/auth_storage.dart';
import 'package:vivocare/core/config/api_config.dart';
import 'package:vivocare/core/network/network_client.dart';
import 'package:vivocare/core/network/network_exception.dart';
import 'package:vivocare/core/network/network_response.dart';
import 'package:vivocare/features/auth/view/widgets/swipe_action_tile.dart';

enum _ChemistActionMode { add, edit }

class AddChemistScreen extends StatefulWidget {
  const AddChemistScreen({super.key});

  @override
  State<AddChemistScreen> createState() => _AddChemistScreenState();
}

class _AddChemistScreenState extends State<AddChemistScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey _formSectionKey = GlobalKey();

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactPersonNameController =
      TextEditingController();
  final TextEditingController _contactPersonEmailController =
      TextEditingController();
  final TextEditingController _contactPersonDobController =
      TextEditingController();
  final TextEditingController _contactPersonDomController =
      TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  late final NetworkClient _networkClient;

  _ChemistActionMode _mode = _ChemistActionMode.add;
  bool _isSubmitting = false;
  bool _isActionInProgress = false;
  bool _isLoadingChemists = false;
  List<_ChemistRecord> _chemistRecords = <_ChemistRecord>[];
  _ChemistRecord? _selectedChemist;
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
    _fullNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _contactPersonNameController.dispose();
    _contactPersonEmailController.dispose();
    _contactPersonDobController.dispose();
    _contactPersonDomController.dispose();
    _stateController.dispose();
    _cityController.dispose();
    _areaController.dispose();
    _countryController.dispose();
    _searchController.dispose();
    _networkClient.close();
    super.dispose();
  }

  bool get _isBusy => _isSubmitting || _isActionInProgress;

  void _switchMode(_ChemistActionMode mode) {
    if (_mode == mode) {
      return;
    }

    setState(() {
      _mode = mode;
      _selectedChemist = null;
      _searchController.clear();
      _chemistRecords = mode == _ChemistActionMode.add
          ? _chemistRecords
          : <_ChemistRecord>[];
      _clearForm();
    });

    if (mode == _ChemistActionMode.edit) {
      _loadChemists();
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

  String? _validateRequired(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required.';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    final RegExp emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailPattern.hasMatch(value.trim())) {
      return 'Enter a valid email address.';
    }
    return null;
  }

  Future<void> _submit() async {
    final FormState? form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }

    if (_mode == _ChemistActionMode.edit && _selectedChemist == null) {
      _showCenterMessage('Swipe left on a chemist and tap Edit first.',
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
      if (_mode == _ChemistActionMode.add) {
        await _createChemist(session);
      } else {
        await _updateChemist(session, _selectedChemist!.id);
      }
    } on NetworkException catch (error) {
      _showCenterMessage(error.message, isError: true);
    } catch (_) {
      _showCenterMessage('Unable to save chemist right now.', isError: true);
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  Future<void> _createChemist(AuthSession session) async {
    final NetworkResponse<dynamic> response = await _networkClient.post(
      '${ApiConfig.apiVersionPath}/chemists',
      headers: _authHeaders(session),
      body: _buildChemistRequestBody(),
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _clearForm();
    });

    _showCenterMessage(
      _extractResponseMessage(response.data) ?? 'Chemist saved successfully',
    );
  }

  Future<void> _updateChemist(AuthSession session, String chemistId) async {
    final NetworkResponse<dynamic> response = await _networkClient.put(
      '${ApiConfig.apiVersionPath}/chemists/$chemistId',
      headers: _authHeaders(session),
      body: _buildChemistRequestBody(),
    );

    _showCenterMessage(
      _extractResponseMessage(response.data) ?? 'Chemist updated successfully',
    );
    await _loadChemists(search: _searchController.text);
  }

  Future<void> _loadChemists({String search = ''}) async {
    final AuthSession? session = await _loadSessionOrShowError();
    if (session == null) {
      return;
    }

    setState(() {
      _isLoadingChemists = true;
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
        '${ApiConfig.apiVersionPath}/chemists',
        headers: _authHeaders(session),
        queryParameters: query,
      );

      final List<_ChemistRecord> chemists = _parseChemists(response.data);

      if (!mounted) {
        return;
      }

      setState(() {
        _chemistRecords = chemists;
      });
    } on NetworkException catch (error) {
      _showCenterMessage(error.message, isError: true);
    } catch (_) {
      _showCenterMessage('Unable to load chemist list.', isError: true);
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingChemists = false;
        });
      }
    }
  }

  Future<void> _handleEditChemist(_ChemistRecord chemist) async {
    final AuthSession? session = await _loadSessionOrShowError();
    if (session == null) {
      return;
    }

    setState(() {
      _isActionInProgress = true;
    });

    try {
      final NetworkResponse<dynamic> response = await _networkClient.get(
        '${ApiConfig.apiVersionPath}/chemists/${chemist.id}',
        headers: _authHeaders(session),
      );

      final _ChemistRecord details = _ChemistRecord.fromJson(
        _extractEntityMap(response.data),
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _selectedChemist = details;
        _applyChemistToForm(details);
      });

      _scrollToForm();
    } on NetworkException catch (error) {
      _showCenterMessage(error.message, isError: true);
    } catch (_) {
      _showCenterMessage('Unable to load chemist details.', isError: true);
    } finally {
      if (mounted) {
        setState(() {
          _isActionInProgress = false;
        });
      }
    }
  }

  Future<void> _handleDeleteChemist(_ChemistRecord chemist) async {
    final bool shouldDelete = await _confirmDelete(
      title: 'Delete Chemist',
      message: 'Delete ${chemist.displayName}?',
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
        '${ApiConfig.apiVersionPath}/chemists/${chemist.id}',
        headers: _authHeaders(session),
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _chemistRecords = _chemistRecords
            .where((_ChemistRecord item) => item.id != chemist.id)
            .toList(growable: false);
        if (_selectedChemist?.id == chemist.id) {
          _selectedChemist = null;
          _clearForm();
        }
      });

      _showCenterMessage(
        _extractResponseMessage(response.data) ?? 'Chemist deleted successfully',
      );
      await _loadChemists(search: _searchController.text);
    } on NetworkException catch (error) {
      _showCenterMessage(error.message, isError: true);
    } catch (_) {
      _showCenterMessage('Unable to delete chemist right now.', isError: true);
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

  List<_ChemistRecord> _parseChemists(dynamic data) {
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
      return const <_ChemistRecord>[];
    }

    final List<_ChemistRecord> chemists = <_ChemistRecord>[];
    for (final dynamic item in rawItems) {
      final _ChemistRecord chemist = _ChemistRecord.fromJson(_asMap(item));
      if (chemist.id.isNotEmpty) {
        chemists.add(chemist);
      }
    }
    return chemists;
  }

  Map<String, dynamic> _extractEntityMap(dynamic data) {
    final Map<String, dynamic> root = _asMap(data);
    final Map<String, dynamic> nested = _asMap(root['data']);
    return nested.isNotEmpty ? nested : root;
  }

  void _applyChemistToForm(_ChemistRecord chemist) {
    _fullNameController.text = chemist.fullName;
    _phoneController.text = chemist.phone;
    _emailController.text = chemist.email;
    _contactPersonNameController.text = chemist.contactPersonName;
    _contactPersonEmailController.text = chemist.contactPersonEmail;
    _contactPersonDobController.text = chemist.contactPersonDob;
    _contactPersonDomController.text = chemist.contactPersonDom;
    _stateController.text = chemist.state;
    _cityController.text = chemist.city;
    _areaController.text = chemist.area;
    _countryController.text = chemist.country;
  }

  void _clearForm() {
    _fullNameController.clear();
    _phoneController.clear();
    _emailController.clear();
    _contactPersonNameController.clear();
    _contactPersonEmailController.clear();
    _contactPersonDobController.clear();
    _contactPersonDomController.clear();
    _stateController.clear();
    _cityController.clear();
    _areaController.clear();
    _countryController.clear();
  }

  Map<String, dynamic> _buildChemistRequestBody() {
    return <String, dynamic>{
      'full_name': _nullIfEmpty(_fullNameController.text),
      'phone': _nullIfEmpty(_phoneController.text),
      'email': _nullIfEmpty(_emailController.text),
      'contact_person_name': _nullIfEmpty(_contactPersonNameController.text),
      'contact_person_email': _nullIfEmpty(_contactPersonEmailController.text),
      'contact_person_dob': _nullIfEmpty(_contactPersonDobController.text),
      'contact_person_dom': _nullIfEmpty(_contactPersonDomController.text),
      'state': _nullIfEmpty(_stateController.text),
      'city': _nullIfEmpty(_cityController.text),
      'area': _nullIfEmpty(_areaController.text),
      'country': _nullIfEmpty(_countryController.text),
    };
  }

  Map<String, String> _authHeaders(AuthSession session) {
    return <String, String>{'Authorization': session.authorizationHeader};
  }

  String? _nullIfEmpty(String value) {
    final String trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
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

  Widget _buildChemistListCard() {
    return _buildSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Chemist List',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1D3557),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Swipe left on any chemist row to reveal Edit and Delete.',
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
                    labelText: 'Search chemists',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: _isLoadingChemists
                      ? null
                      : () => _loadChemists(search: _searchController.text),
                  child: _isLoadingChemists
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
                    'Chemist Name',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Chemist Code',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          if (_isLoadingChemists)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_chemistRecords.isEmpty)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FBFD),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFDCE6F0)),
              ),
              child: const Text(
                'No chemists found.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6C7A89),
                ),
              ),
            )
          else
            Column(
              children: _chemistRecords.map((_ChemistRecord chemist) {
                final bool isSelected = _selectedChemist?.id == chemist.id;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: SwipeActionTile(
                    onEdit: () => _handleEditChemist(chemist),
                    onDelete: () => _handleDeleteChemist(chemist),
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
                              chemist.fullName,
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
                              chemist.chemistCode.isEmpty
                                  ? '-'
                                  : chemist.chemistCode,
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
    final bool isEditMode = _mode == _ChemistActionMode.edit;
    final bool showForm = !isEditMode || _selectedChemist != null;

    return _buildSurface(
      key: _formSectionKey,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              isEditMode ? 'Edit Chemist' : 'Add Chemist',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1D3557),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              isEditMode
                  ? 'Choose a chemist from the list above, then update the fields below.'
                  : 'Fill the chemist details and save them to the API.',
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF6C7A89),
              ),
            ),
            if (isEditMode && _selectedChemist != null) ...[
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F8FC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFD7E3F0)),
                ),
                child: Text(
                  'Editing ${_selectedChemist!.displayName}',
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
                  'No chemist selected yet. Swipe left on a row above and tap Edit.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6C7A89),
                  ),
                ),
              )
            else ...[
              _FormTextField(
                controller: _fullNameController,
                label: 'Full Name *',
                validator: _validateRequired,
              ),
              _FormTextField(
                controller: _phoneController,
                label: 'Phone',
                keyboardType: TextInputType.phone,
              ),
              _FormTextField(
                controller: _emailController,
                label: 'Email',
                keyboardType: TextInputType.emailAddress,
                validator: _validateEmail,
              ),
              _FormTextField(
                controller: _contactPersonNameController,
                label: 'Contact Person Name',
              ),
              _FormTextField(
                controller: _contactPersonEmailController,
                label: 'Contact Person Email',
                keyboardType: TextInputType.emailAddress,
                validator: _validateEmail,
              ),
              _DateField(
                controller: _contactPersonDobController,
                label: 'Contact Person DOB (YYYY-MM-DD)',
                onTap: () => _pickDate(_contactPersonDobController),
              ),
              _DateField(
                controller: _contactPersonDomController,
                label: 'Contact Person DOM (YYYY-MM-DD)',
                onTap: () => _pickDate(_contactPersonDomController),
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
                          isEditMode ? 'Update Chemist' : 'Save Chemist',
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
      appBar: AppBar(title: const Text('Chemist')),
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
                                label: 'Add Chemist',
                                isActive: _mode == _ChemistActionMode.add,
                                onTap: () =>
                                    _switchMode(_ChemistActionMode.add),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _ModeButton(
                                label: 'Edit Chemist',
                                isActive: _mode == _ChemistActionMode.edit,
                                onTap: () =>
                                    _switchMode(_ChemistActionMode.edit),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (_mode == _ChemistActionMode.edit) ...[
                        const SizedBox(height: 16),
                        _buildChemistListCard(),
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

class _ChemistRecord {
  const _ChemistRecord({
    required this.id,
    required this.chemistCode,
    required this.fullName,
    required this.phone,
    required this.email,
    required this.contactPersonName,
    required this.contactPersonEmail,
    required this.contactPersonDob,
    required this.contactPersonDom,
    required this.state,
    required this.city,
    required this.area,
    required this.country,
  });

  final String id;
  final String chemistCode;
  final String fullName;
  final String phone;
  final String email;
  final String contactPersonName;
  final String contactPersonEmail;
  final String contactPersonDob;
  final String contactPersonDom;
  final String state;
  final String city;
  final String area;
  final String country;

  String get displayName {
    if (chemistCode.isEmpty) {
      return fullName.isEmpty ? 'Unnamed Chemist' : fullName;
    }
    return '${fullName.isEmpty ? 'Unnamed Chemist' : fullName} ($chemistCode)';
  }

  factory _ChemistRecord.fromJson(Map<String, dynamic> json) {
    return _ChemistRecord(
      id: _asString(json['id']),
      chemistCode: _asString(json['chemist_code']),
      fullName: _asString(json['full_name']).isEmpty
          ? _asString(json['name'])
          : _asString(json['full_name']),
      phone: _asString(json['phone']),
      email: _asString(json['email']),
      contactPersonName: _asString(json['contact_person_name']),
      contactPersonEmail: _asString(json['contact_person_email']),
      contactPersonDob: _asDateString(json['contact_person_dob']),
      contactPersonDom: _asDateString(json['contact_person_dom']),
      state: _asString(json['state']),
      city: _asString(json['city']),
      area: _asString(json['area']),
      country: _asString(json['country']),
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
