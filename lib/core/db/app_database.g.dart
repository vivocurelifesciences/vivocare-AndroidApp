// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $DoctorsTable extends Doctors with TableInfo<$DoctorsTable, Doctor> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DoctorsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('active'),
  );
  static const VerificationMeta _isEnabledMeta = const VerificationMeta(
    'isEnabled',
  );
  @override
  late final GeneratedColumn<bool> isEnabled = GeneratedColumn<bool>(
    'is_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _serverUdtMeta = const VerificationMeta(
    'serverUdt',
  );
  @override
  late final GeneratedColumn<String> serverUdt = GeneratedColumn<String>(
    'server_udt',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _localStatusMeta = const VerificationMeta(
    'localStatus',
  );
  @override
  late final GeneratedColumn<String> localStatus = GeneratedColumn<String>(
    'local_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('synced'),
  );
  static const VerificationMeta _locallyChangedAtMeta = const VerificationMeta(
    'locallyChangedAt',
  );
  @override
  late final GeneratedColumn<String> locallyChangedAt = GeneratedColumn<String>(
    'locally_changed_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _doctorCodeMeta = const VerificationMeta(
    'doctorCode',
  );
  @override
  late final GeneratedColumn<String> doctorCode = GeneratedColumn<String>(
    'doctor_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _doctorTypeMeta = const VerificationMeta(
    'doctorType',
  );
  @override
  late final GeneratedColumn<String> doctorType = GeneratedColumn<String>(
    'doctor_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _firstNameMeta = const VerificationMeta(
    'firstName',
  );
  @override
  late final GeneratedColumn<String> firstName = GeneratedColumn<String>(
    'first_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _middleNameMeta = const VerificationMeta(
    'middleName',
  );
  @override
  late final GeneratedColumn<String> middleName = GeneratedColumn<String>(
    'middle_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastNameMeta = const VerificationMeta(
    'lastName',
  );
  @override
  late final GeneratedColumn<String> lastName = GeneratedColumn<String>(
    'last_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _qualificationMeta = const VerificationMeta(
    'qualification',
  );
  @override
  late final GeneratedColumn<String> qualification = GeneratedColumn<String>(
    'qualification',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _specialityMeta = const VerificationMeta(
    'speciality',
  );
  @override
  late final GeneratedColumn<String> speciality = GeneratedColumn<String>(
    'speciality',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _potentialMeta = const VerificationMeta(
    'potential',
  );
  @override
  late final GeneratedColumn<double> potential = GeneratedColumn<double>(
    'potential',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _supportValueMeta = const VerificationMeta(
    'supportValue',
  );
  @override
  late final GeneratedColumn<double> supportValue = GeneratedColumn<double>(
    'support_value',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _expectedSupportValueMeta =
      const VerificationMeta('expectedSupportValue');
  @override
  late final GeneratedColumn<double> expectedSupportValue =
      GeneratedColumn<double>(
        'expected_support_value',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
    'state',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cityMeta = const VerificationMeta('city');
  @override
  late final GeneratedColumn<String> city = GeneratedColumn<String>(
    'city',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _areaMeta = const VerificationMeta('area');
  @override
  late final GeneratedColumn<String> area = GeneratedColumn<String>(
    'area',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _countryMeta = const VerificationMeta(
    'country',
  );
  @override
  late final GeneratedColumn<String> country = GeneratedColumn<String>(
    'country',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dobMeta = const VerificationMeta('dob');
  @override
  late final GeneratedColumn<String> dob = GeneratedColumn<String>(
    'dob',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _domMeta = const VerificationMeta('dom');
  @override
  late final GeneratedColumn<String> dom = GeneratedColumn<String>(
    'dom',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _experienceYearsMeta = const VerificationMeta(
    'experienceYears',
  );
  @override
  late final GeneratedColumn<int> experienceYears = GeneratedColumn<int>(
    'experience_years',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _chemistIdsMeta = const VerificationMeta(
    'chemistIds',
  );
  @override
  late final GeneratedColumn<String> chemistIds = GeneratedColumn<String>(
    'chemist_ids',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cdtMeta = const VerificationMeta('cdt');
  @override
  late final GeneratedColumn<String> cdt = GeneratedColumn<String>(
    'cdt',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    status,
    isEnabled,
    serverUdt,
    localStatus,
    locallyChangedAt,
    id,
    doctorCode,
    doctorType,
    firstName,
    middleName,
    lastName,
    qualification,
    speciality,
    category,
    potential,
    supportValue,
    expectedSupportValue,
    phone,
    email,
    state,
    city,
    area,
    country,
    dob,
    dom,
    experienceYears,
    chemistIds,
    cdt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'doctors';
  @override
  VerificationContext validateIntegrity(
    Insertable<Doctor> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('is_enabled')) {
      context.handle(
        _isEnabledMeta,
        isEnabled.isAcceptableOrUnknown(data['is_enabled']!, _isEnabledMeta),
      );
    }
    if (data.containsKey('server_udt')) {
      context.handle(
        _serverUdtMeta,
        serverUdt.isAcceptableOrUnknown(data['server_udt']!, _serverUdtMeta),
      );
    }
    if (data.containsKey('local_status')) {
      context.handle(
        _localStatusMeta,
        localStatus.isAcceptableOrUnknown(
          data['local_status']!,
          _localStatusMeta,
        ),
      );
    }
    if (data.containsKey('locally_changed_at')) {
      context.handle(
        _locallyChangedAtMeta,
        locallyChangedAt.isAcceptableOrUnknown(
          data['locally_changed_at']!,
          _locallyChangedAtMeta,
        ),
      );
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('doctor_code')) {
      context.handle(
        _doctorCodeMeta,
        doctorCode.isAcceptableOrUnknown(data['doctor_code']!, _doctorCodeMeta),
      );
    }
    if (data.containsKey('doctor_type')) {
      context.handle(
        _doctorTypeMeta,
        doctorType.isAcceptableOrUnknown(data['doctor_type']!, _doctorTypeMeta),
      );
    }
    if (data.containsKey('first_name')) {
      context.handle(
        _firstNameMeta,
        firstName.isAcceptableOrUnknown(data['first_name']!, _firstNameMeta),
      );
    }
    if (data.containsKey('middle_name')) {
      context.handle(
        _middleNameMeta,
        middleName.isAcceptableOrUnknown(data['middle_name']!, _middleNameMeta),
      );
    }
    if (data.containsKey('last_name')) {
      context.handle(
        _lastNameMeta,
        lastName.isAcceptableOrUnknown(data['last_name']!, _lastNameMeta),
      );
    }
    if (data.containsKey('qualification')) {
      context.handle(
        _qualificationMeta,
        qualification.isAcceptableOrUnknown(
          data['qualification']!,
          _qualificationMeta,
        ),
      );
    }
    if (data.containsKey('speciality')) {
      context.handle(
        _specialityMeta,
        speciality.isAcceptableOrUnknown(data['speciality']!, _specialityMeta),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('potential')) {
      context.handle(
        _potentialMeta,
        potential.isAcceptableOrUnknown(data['potential']!, _potentialMeta),
      );
    }
    if (data.containsKey('support_value')) {
      context.handle(
        _supportValueMeta,
        supportValue.isAcceptableOrUnknown(
          data['support_value']!,
          _supportValueMeta,
        ),
      );
    }
    if (data.containsKey('expected_support_value')) {
      context.handle(
        _expectedSupportValueMeta,
        expectedSupportValue.isAcceptableOrUnknown(
          data['expected_support_value']!,
          _expectedSupportValueMeta,
        ),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('state')) {
      context.handle(
        _stateMeta,
        state.isAcceptableOrUnknown(data['state']!, _stateMeta),
      );
    }
    if (data.containsKey('city')) {
      context.handle(
        _cityMeta,
        city.isAcceptableOrUnknown(data['city']!, _cityMeta),
      );
    }
    if (data.containsKey('area')) {
      context.handle(
        _areaMeta,
        area.isAcceptableOrUnknown(data['area']!, _areaMeta),
      );
    }
    if (data.containsKey('country')) {
      context.handle(
        _countryMeta,
        country.isAcceptableOrUnknown(data['country']!, _countryMeta),
      );
    }
    if (data.containsKey('dob')) {
      context.handle(
        _dobMeta,
        dob.isAcceptableOrUnknown(data['dob']!, _dobMeta),
      );
    }
    if (data.containsKey('dom')) {
      context.handle(
        _domMeta,
        dom.isAcceptableOrUnknown(data['dom']!, _domMeta),
      );
    }
    if (data.containsKey('experience_years')) {
      context.handle(
        _experienceYearsMeta,
        experienceYears.isAcceptableOrUnknown(
          data['experience_years']!,
          _experienceYearsMeta,
        ),
      );
    }
    if (data.containsKey('chemist_ids')) {
      context.handle(
        _chemistIdsMeta,
        chemistIds.isAcceptableOrUnknown(data['chemist_ids']!, _chemistIdsMeta),
      );
    }
    if (data.containsKey('cdt')) {
      context.handle(
        _cdtMeta,
        cdt.isAcceptableOrUnknown(data['cdt']!, _cdtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Doctor map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Doctor(
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      isEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_enabled'],
      )!,
      serverUdt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_udt'],
      ),
      localStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_status'],
      )!,
      locallyChangedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}locally_changed_at'],
      ),
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      doctorCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}doctor_code'],
      ),
      doctorType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}doctor_type'],
      ),
      firstName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}first_name'],
      ),
      middleName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}middle_name'],
      ),
      lastName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_name'],
      ),
      qualification: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}qualification'],
      ),
      speciality: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}speciality'],
      ),
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      ),
      potential: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}potential'],
      ),
      supportValue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}support_value'],
      ),
      expectedSupportValue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}expected_support_value'],
      ),
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state'],
      ),
      city: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}city'],
      ),
      area: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}area'],
      ),
      country: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}country'],
      ),
      dob: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dob'],
      ),
      dom: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dom'],
      ),
      experienceYears: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}experience_years'],
      ),
      chemistIds: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}chemist_ids'],
      ),
      cdt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cdt'],
      ),
    );
  }

  @override
  $DoctorsTable createAlias(String alias) {
    return $DoctorsTable(attachedDatabase, alias);
  }
}

class Doctor extends DataClass implements Insertable<Doctor> {
  final String status;
  final bool isEnabled;
  final String? serverUdt;
  final String localStatus;
  final String? locallyChangedAt;
  final String id;
  final String? doctorCode;
  final String? doctorType;
  final String? firstName;
  final String? middleName;
  final String? lastName;
  final String? qualification;
  final String? speciality;
  final String? category;
  final double? potential;
  final double? supportValue;
  final double? expectedSupportValue;
  final String? phone;
  final String? email;
  final String? state;
  final String? city;
  final String? area;
  final String? country;
  final String? dob;
  final String? dom;
  final int? experienceYears;
  final String? chemistIds;
  final String? cdt;
  const Doctor({
    required this.status,
    required this.isEnabled,
    this.serverUdt,
    required this.localStatus,
    this.locallyChangedAt,
    required this.id,
    this.doctorCode,
    this.doctorType,
    this.firstName,
    this.middleName,
    this.lastName,
    this.qualification,
    this.speciality,
    this.category,
    this.potential,
    this.supportValue,
    this.expectedSupportValue,
    this.phone,
    this.email,
    this.state,
    this.city,
    this.area,
    this.country,
    this.dob,
    this.dom,
    this.experienceYears,
    this.chemistIds,
    this.cdt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['status'] = Variable<String>(status);
    map['is_enabled'] = Variable<bool>(isEnabled);
    if (!nullToAbsent || serverUdt != null) {
      map['server_udt'] = Variable<String>(serverUdt);
    }
    map['local_status'] = Variable<String>(localStatus);
    if (!nullToAbsent || locallyChangedAt != null) {
      map['locally_changed_at'] = Variable<String>(locallyChangedAt);
    }
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || doctorCode != null) {
      map['doctor_code'] = Variable<String>(doctorCode);
    }
    if (!nullToAbsent || doctorType != null) {
      map['doctor_type'] = Variable<String>(doctorType);
    }
    if (!nullToAbsent || firstName != null) {
      map['first_name'] = Variable<String>(firstName);
    }
    if (!nullToAbsent || middleName != null) {
      map['middle_name'] = Variable<String>(middleName);
    }
    if (!nullToAbsent || lastName != null) {
      map['last_name'] = Variable<String>(lastName);
    }
    if (!nullToAbsent || qualification != null) {
      map['qualification'] = Variable<String>(qualification);
    }
    if (!nullToAbsent || speciality != null) {
      map['speciality'] = Variable<String>(speciality);
    }
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    if (!nullToAbsent || potential != null) {
      map['potential'] = Variable<double>(potential);
    }
    if (!nullToAbsent || supportValue != null) {
      map['support_value'] = Variable<double>(supportValue);
    }
    if (!nullToAbsent || expectedSupportValue != null) {
      map['expected_support_value'] = Variable<double>(expectedSupportValue);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || state != null) {
      map['state'] = Variable<String>(state);
    }
    if (!nullToAbsent || city != null) {
      map['city'] = Variable<String>(city);
    }
    if (!nullToAbsent || area != null) {
      map['area'] = Variable<String>(area);
    }
    if (!nullToAbsent || country != null) {
      map['country'] = Variable<String>(country);
    }
    if (!nullToAbsent || dob != null) {
      map['dob'] = Variable<String>(dob);
    }
    if (!nullToAbsent || dom != null) {
      map['dom'] = Variable<String>(dom);
    }
    if (!nullToAbsent || experienceYears != null) {
      map['experience_years'] = Variable<int>(experienceYears);
    }
    if (!nullToAbsent || chemistIds != null) {
      map['chemist_ids'] = Variable<String>(chemistIds);
    }
    if (!nullToAbsent || cdt != null) {
      map['cdt'] = Variable<String>(cdt);
    }
    return map;
  }

  DoctorsCompanion toCompanion(bool nullToAbsent) {
    return DoctorsCompanion(
      status: Value(status),
      isEnabled: Value(isEnabled),
      serverUdt: serverUdt == null && nullToAbsent
          ? const Value.absent()
          : Value(serverUdt),
      localStatus: Value(localStatus),
      locallyChangedAt: locallyChangedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(locallyChangedAt),
      id: Value(id),
      doctorCode: doctorCode == null && nullToAbsent
          ? const Value.absent()
          : Value(doctorCode),
      doctorType: doctorType == null && nullToAbsent
          ? const Value.absent()
          : Value(doctorType),
      firstName: firstName == null && nullToAbsent
          ? const Value.absent()
          : Value(firstName),
      middleName: middleName == null && nullToAbsent
          ? const Value.absent()
          : Value(middleName),
      lastName: lastName == null && nullToAbsent
          ? const Value.absent()
          : Value(lastName),
      qualification: qualification == null && nullToAbsent
          ? const Value.absent()
          : Value(qualification),
      speciality: speciality == null && nullToAbsent
          ? const Value.absent()
          : Value(speciality),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      potential: potential == null && nullToAbsent
          ? const Value.absent()
          : Value(potential),
      supportValue: supportValue == null && nullToAbsent
          ? const Value.absent()
          : Value(supportValue),
      expectedSupportValue: expectedSupportValue == null && nullToAbsent
          ? const Value.absent()
          : Value(expectedSupportValue),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      state: state == null && nullToAbsent
          ? const Value.absent()
          : Value(state),
      city: city == null && nullToAbsent ? const Value.absent() : Value(city),
      area: area == null && nullToAbsent ? const Value.absent() : Value(area),
      country: country == null && nullToAbsent
          ? const Value.absent()
          : Value(country),
      dob: dob == null && nullToAbsent ? const Value.absent() : Value(dob),
      dom: dom == null && nullToAbsent ? const Value.absent() : Value(dom),
      experienceYears: experienceYears == null && nullToAbsent
          ? const Value.absent()
          : Value(experienceYears),
      chemistIds: chemistIds == null && nullToAbsent
          ? const Value.absent()
          : Value(chemistIds),
      cdt: cdt == null && nullToAbsent ? const Value.absent() : Value(cdt),
    );
  }

  factory Doctor.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Doctor(
      status: serializer.fromJson<String>(json['status']),
      isEnabled: serializer.fromJson<bool>(json['isEnabled']),
      serverUdt: serializer.fromJson<String?>(json['serverUdt']),
      localStatus: serializer.fromJson<String>(json['localStatus']),
      locallyChangedAt: serializer.fromJson<String?>(json['locallyChangedAt']),
      id: serializer.fromJson<String>(json['id']),
      doctorCode: serializer.fromJson<String?>(json['doctorCode']),
      doctorType: serializer.fromJson<String?>(json['doctorType']),
      firstName: serializer.fromJson<String?>(json['firstName']),
      middleName: serializer.fromJson<String?>(json['middleName']),
      lastName: serializer.fromJson<String?>(json['lastName']),
      qualification: serializer.fromJson<String?>(json['qualification']),
      speciality: serializer.fromJson<String?>(json['speciality']),
      category: serializer.fromJson<String?>(json['category']),
      potential: serializer.fromJson<double?>(json['potential']),
      supportValue: serializer.fromJson<double?>(json['supportValue']),
      expectedSupportValue: serializer.fromJson<double?>(
        json['expectedSupportValue'],
      ),
      phone: serializer.fromJson<String?>(json['phone']),
      email: serializer.fromJson<String?>(json['email']),
      state: serializer.fromJson<String?>(json['state']),
      city: serializer.fromJson<String?>(json['city']),
      area: serializer.fromJson<String?>(json['area']),
      country: serializer.fromJson<String?>(json['country']),
      dob: serializer.fromJson<String?>(json['dob']),
      dom: serializer.fromJson<String?>(json['dom']),
      experienceYears: serializer.fromJson<int?>(json['experienceYears']),
      chemistIds: serializer.fromJson<String?>(json['chemistIds']),
      cdt: serializer.fromJson<String?>(json['cdt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'status': serializer.toJson<String>(status),
      'isEnabled': serializer.toJson<bool>(isEnabled),
      'serverUdt': serializer.toJson<String?>(serverUdt),
      'localStatus': serializer.toJson<String>(localStatus),
      'locallyChangedAt': serializer.toJson<String?>(locallyChangedAt),
      'id': serializer.toJson<String>(id),
      'doctorCode': serializer.toJson<String?>(doctorCode),
      'doctorType': serializer.toJson<String?>(doctorType),
      'firstName': serializer.toJson<String?>(firstName),
      'middleName': serializer.toJson<String?>(middleName),
      'lastName': serializer.toJson<String?>(lastName),
      'qualification': serializer.toJson<String?>(qualification),
      'speciality': serializer.toJson<String?>(speciality),
      'category': serializer.toJson<String?>(category),
      'potential': serializer.toJson<double?>(potential),
      'supportValue': serializer.toJson<double?>(supportValue),
      'expectedSupportValue': serializer.toJson<double?>(expectedSupportValue),
      'phone': serializer.toJson<String?>(phone),
      'email': serializer.toJson<String?>(email),
      'state': serializer.toJson<String?>(state),
      'city': serializer.toJson<String?>(city),
      'area': serializer.toJson<String?>(area),
      'country': serializer.toJson<String?>(country),
      'dob': serializer.toJson<String?>(dob),
      'dom': serializer.toJson<String?>(dom),
      'experienceYears': serializer.toJson<int?>(experienceYears),
      'chemistIds': serializer.toJson<String?>(chemistIds),
      'cdt': serializer.toJson<String?>(cdt),
    };
  }

  Doctor copyWith({
    String? status,
    bool? isEnabled,
    Value<String?> serverUdt = const Value.absent(),
    String? localStatus,
    Value<String?> locallyChangedAt = const Value.absent(),
    String? id,
    Value<String?> doctorCode = const Value.absent(),
    Value<String?> doctorType = const Value.absent(),
    Value<String?> firstName = const Value.absent(),
    Value<String?> middleName = const Value.absent(),
    Value<String?> lastName = const Value.absent(),
    Value<String?> qualification = const Value.absent(),
    Value<String?> speciality = const Value.absent(),
    Value<String?> category = const Value.absent(),
    Value<double?> potential = const Value.absent(),
    Value<double?> supportValue = const Value.absent(),
    Value<double?> expectedSupportValue = const Value.absent(),
    Value<String?> phone = const Value.absent(),
    Value<String?> email = const Value.absent(),
    Value<String?> state = const Value.absent(),
    Value<String?> city = const Value.absent(),
    Value<String?> area = const Value.absent(),
    Value<String?> country = const Value.absent(),
    Value<String?> dob = const Value.absent(),
    Value<String?> dom = const Value.absent(),
    Value<int?> experienceYears = const Value.absent(),
    Value<String?> chemistIds = const Value.absent(),
    Value<String?> cdt = const Value.absent(),
  }) => Doctor(
    status: status ?? this.status,
    isEnabled: isEnabled ?? this.isEnabled,
    serverUdt: serverUdt.present ? serverUdt.value : this.serverUdt,
    localStatus: localStatus ?? this.localStatus,
    locallyChangedAt: locallyChangedAt.present
        ? locallyChangedAt.value
        : this.locallyChangedAt,
    id: id ?? this.id,
    doctorCode: doctorCode.present ? doctorCode.value : this.doctorCode,
    doctorType: doctorType.present ? doctorType.value : this.doctorType,
    firstName: firstName.present ? firstName.value : this.firstName,
    middleName: middleName.present ? middleName.value : this.middleName,
    lastName: lastName.present ? lastName.value : this.lastName,
    qualification: qualification.present
        ? qualification.value
        : this.qualification,
    speciality: speciality.present ? speciality.value : this.speciality,
    category: category.present ? category.value : this.category,
    potential: potential.present ? potential.value : this.potential,
    supportValue: supportValue.present ? supportValue.value : this.supportValue,
    expectedSupportValue: expectedSupportValue.present
        ? expectedSupportValue.value
        : this.expectedSupportValue,
    phone: phone.present ? phone.value : this.phone,
    email: email.present ? email.value : this.email,
    state: state.present ? state.value : this.state,
    city: city.present ? city.value : this.city,
    area: area.present ? area.value : this.area,
    country: country.present ? country.value : this.country,
    dob: dob.present ? dob.value : this.dob,
    dom: dom.present ? dom.value : this.dom,
    experienceYears: experienceYears.present
        ? experienceYears.value
        : this.experienceYears,
    chemistIds: chemistIds.present ? chemistIds.value : this.chemistIds,
    cdt: cdt.present ? cdt.value : this.cdt,
  );
  Doctor copyWithCompanion(DoctorsCompanion data) {
    return Doctor(
      status: data.status.present ? data.status.value : this.status,
      isEnabled: data.isEnabled.present ? data.isEnabled.value : this.isEnabled,
      serverUdt: data.serverUdt.present ? data.serverUdt.value : this.serverUdt,
      localStatus: data.localStatus.present
          ? data.localStatus.value
          : this.localStatus,
      locallyChangedAt: data.locallyChangedAt.present
          ? data.locallyChangedAt.value
          : this.locallyChangedAt,
      id: data.id.present ? data.id.value : this.id,
      doctorCode: data.doctorCode.present
          ? data.doctorCode.value
          : this.doctorCode,
      doctorType: data.doctorType.present
          ? data.doctorType.value
          : this.doctorType,
      firstName: data.firstName.present ? data.firstName.value : this.firstName,
      middleName: data.middleName.present
          ? data.middleName.value
          : this.middleName,
      lastName: data.lastName.present ? data.lastName.value : this.lastName,
      qualification: data.qualification.present
          ? data.qualification.value
          : this.qualification,
      speciality: data.speciality.present
          ? data.speciality.value
          : this.speciality,
      category: data.category.present ? data.category.value : this.category,
      potential: data.potential.present ? data.potential.value : this.potential,
      supportValue: data.supportValue.present
          ? data.supportValue.value
          : this.supportValue,
      expectedSupportValue: data.expectedSupportValue.present
          ? data.expectedSupportValue.value
          : this.expectedSupportValue,
      phone: data.phone.present ? data.phone.value : this.phone,
      email: data.email.present ? data.email.value : this.email,
      state: data.state.present ? data.state.value : this.state,
      city: data.city.present ? data.city.value : this.city,
      area: data.area.present ? data.area.value : this.area,
      country: data.country.present ? data.country.value : this.country,
      dob: data.dob.present ? data.dob.value : this.dob,
      dom: data.dom.present ? data.dom.value : this.dom,
      experienceYears: data.experienceYears.present
          ? data.experienceYears.value
          : this.experienceYears,
      chemistIds: data.chemistIds.present
          ? data.chemistIds.value
          : this.chemistIds,
      cdt: data.cdt.present ? data.cdt.value : this.cdt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Doctor(')
          ..write('status: $status, ')
          ..write('isEnabled: $isEnabled, ')
          ..write('serverUdt: $serverUdt, ')
          ..write('localStatus: $localStatus, ')
          ..write('locallyChangedAt: $locallyChangedAt, ')
          ..write('id: $id, ')
          ..write('doctorCode: $doctorCode, ')
          ..write('doctorType: $doctorType, ')
          ..write('firstName: $firstName, ')
          ..write('middleName: $middleName, ')
          ..write('lastName: $lastName, ')
          ..write('qualification: $qualification, ')
          ..write('speciality: $speciality, ')
          ..write('category: $category, ')
          ..write('potential: $potential, ')
          ..write('supportValue: $supportValue, ')
          ..write('expectedSupportValue: $expectedSupportValue, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('state: $state, ')
          ..write('city: $city, ')
          ..write('area: $area, ')
          ..write('country: $country, ')
          ..write('dob: $dob, ')
          ..write('dom: $dom, ')
          ..write('experienceYears: $experienceYears, ')
          ..write('chemistIds: $chemistIds, ')
          ..write('cdt: $cdt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    status,
    isEnabled,
    serverUdt,
    localStatus,
    locallyChangedAt,
    id,
    doctorCode,
    doctorType,
    firstName,
    middleName,
    lastName,
    qualification,
    speciality,
    category,
    potential,
    supportValue,
    expectedSupportValue,
    phone,
    email,
    state,
    city,
    area,
    country,
    dob,
    dom,
    experienceYears,
    chemistIds,
    cdt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Doctor &&
          other.status == this.status &&
          other.isEnabled == this.isEnabled &&
          other.serverUdt == this.serverUdt &&
          other.localStatus == this.localStatus &&
          other.locallyChangedAt == this.locallyChangedAt &&
          other.id == this.id &&
          other.doctorCode == this.doctorCode &&
          other.doctorType == this.doctorType &&
          other.firstName == this.firstName &&
          other.middleName == this.middleName &&
          other.lastName == this.lastName &&
          other.qualification == this.qualification &&
          other.speciality == this.speciality &&
          other.category == this.category &&
          other.potential == this.potential &&
          other.supportValue == this.supportValue &&
          other.expectedSupportValue == this.expectedSupportValue &&
          other.phone == this.phone &&
          other.email == this.email &&
          other.state == this.state &&
          other.city == this.city &&
          other.area == this.area &&
          other.country == this.country &&
          other.dob == this.dob &&
          other.dom == this.dom &&
          other.experienceYears == this.experienceYears &&
          other.chemistIds == this.chemistIds &&
          other.cdt == this.cdt);
}

class DoctorsCompanion extends UpdateCompanion<Doctor> {
  final Value<String> status;
  final Value<bool> isEnabled;
  final Value<String?> serverUdt;
  final Value<String> localStatus;
  final Value<String?> locallyChangedAt;
  final Value<String> id;
  final Value<String?> doctorCode;
  final Value<String?> doctorType;
  final Value<String?> firstName;
  final Value<String?> middleName;
  final Value<String?> lastName;
  final Value<String?> qualification;
  final Value<String?> speciality;
  final Value<String?> category;
  final Value<double?> potential;
  final Value<double?> supportValue;
  final Value<double?> expectedSupportValue;
  final Value<String?> phone;
  final Value<String?> email;
  final Value<String?> state;
  final Value<String?> city;
  final Value<String?> area;
  final Value<String?> country;
  final Value<String?> dob;
  final Value<String?> dom;
  final Value<int?> experienceYears;
  final Value<String?> chemistIds;
  final Value<String?> cdt;
  final Value<int> rowid;
  const DoctorsCompanion({
    this.status = const Value.absent(),
    this.isEnabled = const Value.absent(),
    this.serverUdt = const Value.absent(),
    this.localStatus = const Value.absent(),
    this.locallyChangedAt = const Value.absent(),
    this.id = const Value.absent(),
    this.doctorCode = const Value.absent(),
    this.doctorType = const Value.absent(),
    this.firstName = const Value.absent(),
    this.middleName = const Value.absent(),
    this.lastName = const Value.absent(),
    this.qualification = const Value.absent(),
    this.speciality = const Value.absent(),
    this.category = const Value.absent(),
    this.potential = const Value.absent(),
    this.supportValue = const Value.absent(),
    this.expectedSupportValue = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.state = const Value.absent(),
    this.city = const Value.absent(),
    this.area = const Value.absent(),
    this.country = const Value.absent(),
    this.dob = const Value.absent(),
    this.dom = const Value.absent(),
    this.experienceYears = const Value.absent(),
    this.chemistIds = const Value.absent(),
    this.cdt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DoctorsCompanion.insert({
    this.status = const Value.absent(),
    this.isEnabled = const Value.absent(),
    this.serverUdt = const Value.absent(),
    this.localStatus = const Value.absent(),
    this.locallyChangedAt = const Value.absent(),
    required String id,
    this.doctorCode = const Value.absent(),
    this.doctorType = const Value.absent(),
    this.firstName = const Value.absent(),
    this.middleName = const Value.absent(),
    this.lastName = const Value.absent(),
    this.qualification = const Value.absent(),
    this.speciality = const Value.absent(),
    this.category = const Value.absent(),
    this.potential = const Value.absent(),
    this.supportValue = const Value.absent(),
    this.expectedSupportValue = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.state = const Value.absent(),
    this.city = const Value.absent(),
    this.area = const Value.absent(),
    this.country = const Value.absent(),
    this.dob = const Value.absent(),
    this.dom = const Value.absent(),
    this.experienceYears = const Value.absent(),
    this.chemistIds = const Value.absent(),
    this.cdt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<Doctor> custom({
    Expression<String>? status,
    Expression<bool>? isEnabled,
    Expression<String>? serverUdt,
    Expression<String>? localStatus,
    Expression<String>? locallyChangedAt,
    Expression<String>? id,
    Expression<String>? doctorCode,
    Expression<String>? doctorType,
    Expression<String>? firstName,
    Expression<String>? middleName,
    Expression<String>? lastName,
    Expression<String>? qualification,
    Expression<String>? speciality,
    Expression<String>? category,
    Expression<double>? potential,
    Expression<double>? supportValue,
    Expression<double>? expectedSupportValue,
    Expression<String>? phone,
    Expression<String>? email,
    Expression<String>? state,
    Expression<String>? city,
    Expression<String>? area,
    Expression<String>? country,
    Expression<String>? dob,
    Expression<String>? dom,
    Expression<int>? experienceYears,
    Expression<String>? chemistIds,
    Expression<String>? cdt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (status != null) 'status': status,
      if (isEnabled != null) 'is_enabled': isEnabled,
      if (serverUdt != null) 'server_udt': serverUdt,
      if (localStatus != null) 'local_status': localStatus,
      if (locallyChangedAt != null) 'locally_changed_at': locallyChangedAt,
      if (id != null) 'id': id,
      if (doctorCode != null) 'doctor_code': doctorCode,
      if (doctorType != null) 'doctor_type': doctorType,
      if (firstName != null) 'first_name': firstName,
      if (middleName != null) 'middle_name': middleName,
      if (lastName != null) 'last_name': lastName,
      if (qualification != null) 'qualification': qualification,
      if (speciality != null) 'speciality': speciality,
      if (category != null) 'category': category,
      if (potential != null) 'potential': potential,
      if (supportValue != null) 'support_value': supportValue,
      if (expectedSupportValue != null)
        'expected_support_value': expectedSupportValue,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (state != null) 'state': state,
      if (city != null) 'city': city,
      if (area != null) 'area': area,
      if (country != null) 'country': country,
      if (dob != null) 'dob': dob,
      if (dom != null) 'dom': dom,
      if (experienceYears != null) 'experience_years': experienceYears,
      if (chemistIds != null) 'chemist_ids': chemistIds,
      if (cdt != null) 'cdt': cdt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DoctorsCompanion copyWith({
    Value<String>? status,
    Value<bool>? isEnabled,
    Value<String?>? serverUdt,
    Value<String>? localStatus,
    Value<String?>? locallyChangedAt,
    Value<String>? id,
    Value<String?>? doctorCode,
    Value<String?>? doctorType,
    Value<String?>? firstName,
    Value<String?>? middleName,
    Value<String?>? lastName,
    Value<String?>? qualification,
    Value<String?>? speciality,
    Value<String?>? category,
    Value<double?>? potential,
    Value<double?>? supportValue,
    Value<double?>? expectedSupportValue,
    Value<String?>? phone,
    Value<String?>? email,
    Value<String?>? state,
    Value<String?>? city,
    Value<String?>? area,
    Value<String?>? country,
    Value<String?>? dob,
    Value<String?>? dom,
    Value<int?>? experienceYears,
    Value<String?>? chemistIds,
    Value<String?>? cdt,
    Value<int>? rowid,
  }) {
    return DoctorsCompanion(
      status: status ?? this.status,
      isEnabled: isEnabled ?? this.isEnabled,
      serverUdt: serverUdt ?? this.serverUdt,
      localStatus: localStatus ?? this.localStatus,
      locallyChangedAt: locallyChangedAt ?? this.locallyChangedAt,
      id: id ?? this.id,
      doctorCode: doctorCode ?? this.doctorCode,
      doctorType: doctorType ?? this.doctorType,
      firstName: firstName ?? this.firstName,
      middleName: middleName ?? this.middleName,
      lastName: lastName ?? this.lastName,
      qualification: qualification ?? this.qualification,
      speciality: speciality ?? this.speciality,
      category: category ?? this.category,
      potential: potential ?? this.potential,
      supportValue: supportValue ?? this.supportValue,
      expectedSupportValue: expectedSupportValue ?? this.expectedSupportValue,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      state: state ?? this.state,
      city: city ?? this.city,
      area: area ?? this.area,
      country: country ?? this.country,
      dob: dob ?? this.dob,
      dom: dom ?? this.dom,
      experienceYears: experienceYears ?? this.experienceYears,
      chemistIds: chemistIds ?? this.chemistIds,
      cdt: cdt ?? this.cdt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (isEnabled.present) {
      map['is_enabled'] = Variable<bool>(isEnabled.value);
    }
    if (serverUdt.present) {
      map['server_udt'] = Variable<String>(serverUdt.value);
    }
    if (localStatus.present) {
      map['local_status'] = Variable<String>(localStatus.value);
    }
    if (locallyChangedAt.present) {
      map['locally_changed_at'] = Variable<String>(locallyChangedAt.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (doctorCode.present) {
      map['doctor_code'] = Variable<String>(doctorCode.value);
    }
    if (doctorType.present) {
      map['doctor_type'] = Variable<String>(doctorType.value);
    }
    if (firstName.present) {
      map['first_name'] = Variable<String>(firstName.value);
    }
    if (middleName.present) {
      map['middle_name'] = Variable<String>(middleName.value);
    }
    if (lastName.present) {
      map['last_name'] = Variable<String>(lastName.value);
    }
    if (qualification.present) {
      map['qualification'] = Variable<String>(qualification.value);
    }
    if (speciality.present) {
      map['speciality'] = Variable<String>(speciality.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (potential.present) {
      map['potential'] = Variable<double>(potential.value);
    }
    if (supportValue.present) {
      map['support_value'] = Variable<double>(supportValue.value);
    }
    if (expectedSupportValue.present) {
      map['expected_support_value'] = Variable<double>(
        expectedSupportValue.value,
      );
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (city.present) {
      map['city'] = Variable<String>(city.value);
    }
    if (area.present) {
      map['area'] = Variable<String>(area.value);
    }
    if (country.present) {
      map['country'] = Variable<String>(country.value);
    }
    if (dob.present) {
      map['dob'] = Variable<String>(dob.value);
    }
    if (dom.present) {
      map['dom'] = Variable<String>(dom.value);
    }
    if (experienceYears.present) {
      map['experience_years'] = Variable<int>(experienceYears.value);
    }
    if (chemistIds.present) {
      map['chemist_ids'] = Variable<String>(chemistIds.value);
    }
    if (cdt.present) {
      map['cdt'] = Variable<String>(cdt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DoctorsCompanion(')
          ..write('status: $status, ')
          ..write('isEnabled: $isEnabled, ')
          ..write('serverUdt: $serverUdt, ')
          ..write('localStatus: $localStatus, ')
          ..write('locallyChangedAt: $locallyChangedAt, ')
          ..write('id: $id, ')
          ..write('doctorCode: $doctorCode, ')
          ..write('doctorType: $doctorType, ')
          ..write('firstName: $firstName, ')
          ..write('middleName: $middleName, ')
          ..write('lastName: $lastName, ')
          ..write('qualification: $qualification, ')
          ..write('speciality: $speciality, ')
          ..write('category: $category, ')
          ..write('potential: $potential, ')
          ..write('supportValue: $supportValue, ')
          ..write('expectedSupportValue: $expectedSupportValue, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('state: $state, ')
          ..write('city: $city, ')
          ..write('area: $area, ')
          ..write('country: $country, ')
          ..write('dob: $dob, ')
          ..write('dom: $dom, ')
          ..write('experienceYears: $experienceYears, ')
          ..write('chemistIds: $chemistIds, ')
          ..write('cdt: $cdt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChemistsTable extends Chemists with TableInfo<$ChemistsTable, Chemist> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChemistsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('active'),
  );
  static const VerificationMeta _isEnabledMeta = const VerificationMeta(
    'isEnabled',
  );
  @override
  late final GeneratedColumn<bool> isEnabled = GeneratedColumn<bool>(
    'is_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _serverUdtMeta = const VerificationMeta(
    'serverUdt',
  );
  @override
  late final GeneratedColumn<String> serverUdt = GeneratedColumn<String>(
    'server_udt',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _localStatusMeta = const VerificationMeta(
    'localStatus',
  );
  @override
  late final GeneratedColumn<String> localStatus = GeneratedColumn<String>(
    'local_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('synced'),
  );
  static const VerificationMeta _locallyChangedAtMeta = const VerificationMeta(
    'locallyChangedAt',
  );
  @override
  late final GeneratedColumn<String> locallyChangedAt = GeneratedColumn<String>(
    'locally_changed_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _chemistCodeMeta = const VerificationMeta(
    'chemistCode',
  );
  @override
  late final GeneratedColumn<String> chemistCode = GeneratedColumn<String>(
    'chemist_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fullNameMeta = const VerificationMeta(
    'fullName',
  );
  @override
  late final GeneratedColumn<String> fullName = GeneratedColumn<String>(
    'full_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _contactPersonNameMeta = const VerificationMeta(
    'contactPersonName',
  );
  @override
  late final GeneratedColumn<String> contactPersonName =
      GeneratedColumn<String>(
        'contact_person_name',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _contactPersonEmailMeta =
      const VerificationMeta('contactPersonEmail');
  @override
  late final GeneratedColumn<String> contactPersonEmail =
      GeneratedColumn<String>(
        'contact_person_email',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _contactPersonDobMeta = const VerificationMeta(
    'contactPersonDob',
  );
  @override
  late final GeneratedColumn<String> contactPersonDob = GeneratedColumn<String>(
    'contact_person_dob',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _contactPersonDomMeta = const VerificationMeta(
    'contactPersonDom',
  );
  @override
  late final GeneratedColumn<String> contactPersonDom = GeneratedColumn<String>(
    'contact_person_dom',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
    'state',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cityMeta = const VerificationMeta('city');
  @override
  late final GeneratedColumn<String> city = GeneratedColumn<String>(
    'city',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _areaMeta = const VerificationMeta('area');
  @override
  late final GeneratedColumn<String> area = GeneratedColumn<String>(
    'area',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _countryMeta = const VerificationMeta(
    'country',
  );
  @override
  late final GeneratedColumn<String> country = GeneratedColumn<String>(
    'country',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _potentialMeta = const VerificationMeta(
    'potential',
  );
  @override
  late final GeneratedColumn<double> potential = GeneratedColumn<double>(
    'potential',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _supportValueMeta = const VerificationMeta(
    'supportValue',
  );
  @override
  late final GeneratedColumn<double> supportValue = GeneratedColumn<double>(
    'support_value',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _expectedSupportValueMeta =
      const VerificationMeta('expectedSupportValue');
  @override
  late final GeneratedColumn<double> expectedSupportValue =
      GeneratedColumn<double>(
        'expected_support_value',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _cdtMeta = const VerificationMeta('cdt');
  @override
  late final GeneratedColumn<String> cdt = GeneratedColumn<String>(
    'cdt',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    status,
    isEnabled,
    serverUdt,
    localStatus,
    locallyChangedAt,
    id,
    chemistCode,
    fullName,
    phone,
    email,
    contactPersonName,
    contactPersonEmail,
    contactPersonDob,
    contactPersonDom,
    state,
    city,
    area,
    country,
    potential,
    supportValue,
    expectedSupportValue,
    cdt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chemists';
  @override
  VerificationContext validateIntegrity(
    Insertable<Chemist> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('is_enabled')) {
      context.handle(
        _isEnabledMeta,
        isEnabled.isAcceptableOrUnknown(data['is_enabled']!, _isEnabledMeta),
      );
    }
    if (data.containsKey('server_udt')) {
      context.handle(
        _serverUdtMeta,
        serverUdt.isAcceptableOrUnknown(data['server_udt']!, _serverUdtMeta),
      );
    }
    if (data.containsKey('local_status')) {
      context.handle(
        _localStatusMeta,
        localStatus.isAcceptableOrUnknown(
          data['local_status']!,
          _localStatusMeta,
        ),
      );
    }
    if (data.containsKey('locally_changed_at')) {
      context.handle(
        _locallyChangedAtMeta,
        locallyChangedAt.isAcceptableOrUnknown(
          data['locally_changed_at']!,
          _locallyChangedAtMeta,
        ),
      );
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('chemist_code')) {
      context.handle(
        _chemistCodeMeta,
        chemistCode.isAcceptableOrUnknown(
          data['chemist_code']!,
          _chemistCodeMeta,
        ),
      );
    }
    if (data.containsKey('full_name')) {
      context.handle(
        _fullNameMeta,
        fullName.isAcceptableOrUnknown(data['full_name']!, _fullNameMeta),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('contact_person_name')) {
      context.handle(
        _contactPersonNameMeta,
        contactPersonName.isAcceptableOrUnknown(
          data['contact_person_name']!,
          _contactPersonNameMeta,
        ),
      );
    }
    if (data.containsKey('contact_person_email')) {
      context.handle(
        _contactPersonEmailMeta,
        contactPersonEmail.isAcceptableOrUnknown(
          data['contact_person_email']!,
          _contactPersonEmailMeta,
        ),
      );
    }
    if (data.containsKey('contact_person_dob')) {
      context.handle(
        _contactPersonDobMeta,
        contactPersonDob.isAcceptableOrUnknown(
          data['contact_person_dob']!,
          _contactPersonDobMeta,
        ),
      );
    }
    if (data.containsKey('contact_person_dom')) {
      context.handle(
        _contactPersonDomMeta,
        contactPersonDom.isAcceptableOrUnknown(
          data['contact_person_dom']!,
          _contactPersonDomMeta,
        ),
      );
    }
    if (data.containsKey('state')) {
      context.handle(
        _stateMeta,
        state.isAcceptableOrUnknown(data['state']!, _stateMeta),
      );
    }
    if (data.containsKey('city')) {
      context.handle(
        _cityMeta,
        city.isAcceptableOrUnknown(data['city']!, _cityMeta),
      );
    }
    if (data.containsKey('area')) {
      context.handle(
        _areaMeta,
        area.isAcceptableOrUnknown(data['area']!, _areaMeta),
      );
    }
    if (data.containsKey('country')) {
      context.handle(
        _countryMeta,
        country.isAcceptableOrUnknown(data['country']!, _countryMeta),
      );
    }
    if (data.containsKey('potential')) {
      context.handle(
        _potentialMeta,
        potential.isAcceptableOrUnknown(data['potential']!, _potentialMeta),
      );
    }
    if (data.containsKey('support_value')) {
      context.handle(
        _supportValueMeta,
        supportValue.isAcceptableOrUnknown(
          data['support_value']!,
          _supportValueMeta,
        ),
      );
    }
    if (data.containsKey('expected_support_value')) {
      context.handle(
        _expectedSupportValueMeta,
        expectedSupportValue.isAcceptableOrUnknown(
          data['expected_support_value']!,
          _expectedSupportValueMeta,
        ),
      );
    }
    if (data.containsKey('cdt')) {
      context.handle(
        _cdtMeta,
        cdt.isAcceptableOrUnknown(data['cdt']!, _cdtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Chemist map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Chemist(
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      isEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_enabled'],
      )!,
      serverUdt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_udt'],
      ),
      localStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_status'],
      )!,
      locallyChangedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}locally_changed_at'],
      ),
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      chemistCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}chemist_code'],
      ),
      fullName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}full_name'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      contactPersonName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}contact_person_name'],
      ),
      contactPersonEmail: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}contact_person_email'],
      ),
      contactPersonDob: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}contact_person_dob'],
      ),
      contactPersonDom: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}contact_person_dom'],
      ),
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state'],
      ),
      city: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}city'],
      ),
      area: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}area'],
      ),
      country: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}country'],
      ),
      potential: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}potential'],
      ),
      supportValue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}support_value'],
      ),
      expectedSupportValue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}expected_support_value'],
      ),
      cdt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cdt'],
      ),
    );
  }

  @override
  $ChemistsTable createAlias(String alias) {
    return $ChemistsTable(attachedDatabase, alias);
  }
}

class Chemist extends DataClass implements Insertable<Chemist> {
  final String status;
  final bool isEnabled;
  final String? serverUdt;
  final String localStatus;
  final String? locallyChangedAt;
  final String id;
  final String? chemistCode;
  final String fullName;
  final String? phone;
  final String? email;
  final String? contactPersonName;
  final String? contactPersonEmail;
  final String? contactPersonDob;
  final String? contactPersonDom;
  final String? state;
  final String? city;
  final String? area;
  final String? country;
  final double? potential;
  final double? supportValue;
  final double? expectedSupportValue;
  final String? cdt;
  const Chemist({
    required this.status,
    required this.isEnabled,
    this.serverUdt,
    required this.localStatus,
    this.locallyChangedAt,
    required this.id,
    this.chemistCode,
    required this.fullName,
    this.phone,
    this.email,
    this.contactPersonName,
    this.contactPersonEmail,
    this.contactPersonDob,
    this.contactPersonDom,
    this.state,
    this.city,
    this.area,
    this.country,
    this.potential,
    this.supportValue,
    this.expectedSupportValue,
    this.cdt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['status'] = Variable<String>(status);
    map['is_enabled'] = Variable<bool>(isEnabled);
    if (!nullToAbsent || serverUdt != null) {
      map['server_udt'] = Variable<String>(serverUdt);
    }
    map['local_status'] = Variable<String>(localStatus);
    if (!nullToAbsent || locallyChangedAt != null) {
      map['locally_changed_at'] = Variable<String>(locallyChangedAt);
    }
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || chemistCode != null) {
      map['chemist_code'] = Variable<String>(chemistCode);
    }
    map['full_name'] = Variable<String>(fullName);
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || contactPersonName != null) {
      map['contact_person_name'] = Variable<String>(contactPersonName);
    }
    if (!nullToAbsent || contactPersonEmail != null) {
      map['contact_person_email'] = Variable<String>(contactPersonEmail);
    }
    if (!nullToAbsent || contactPersonDob != null) {
      map['contact_person_dob'] = Variable<String>(contactPersonDob);
    }
    if (!nullToAbsent || contactPersonDom != null) {
      map['contact_person_dom'] = Variable<String>(contactPersonDom);
    }
    if (!nullToAbsent || state != null) {
      map['state'] = Variable<String>(state);
    }
    if (!nullToAbsent || city != null) {
      map['city'] = Variable<String>(city);
    }
    if (!nullToAbsent || area != null) {
      map['area'] = Variable<String>(area);
    }
    if (!nullToAbsent || country != null) {
      map['country'] = Variable<String>(country);
    }
    if (!nullToAbsent || potential != null) {
      map['potential'] = Variable<double>(potential);
    }
    if (!nullToAbsent || supportValue != null) {
      map['support_value'] = Variable<double>(supportValue);
    }
    if (!nullToAbsent || expectedSupportValue != null) {
      map['expected_support_value'] = Variable<double>(expectedSupportValue);
    }
    if (!nullToAbsent || cdt != null) {
      map['cdt'] = Variable<String>(cdt);
    }
    return map;
  }

  ChemistsCompanion toCompanion(bool nullToAbsent) {
    return ChemistsCompanion(
      status: Value(status),
      isEnabled: Value(isEnabled),
      serverUdt: serverUdt == null && nullToAbsent
          ? const Value.absent()
          : Value(serverUdt),
      localStatus: Value(localStatus),
      locallyChangedAt: locallyChangedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(locallyChangedAt),
      id: Value(id),
      chemistCode: chemistCode == null && nullToAbsent
          ? const Value.absent()
          : Value(chemistCode),
      fullName: Value(fullName),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      contactPersonName: contactPersonName == null && nullToAbsent
          ? const Value.absent()
          : Value(contactPersonName),
      contactPersonEmail: contactPersonEmail == null && nullToAbsent
          ? const Value.absent()
          : Value(contactPersonEmail),
      contactPersonDob: contactPersonDob == null && nullToAbsent
          ? const Value.absent()
          : Value(contactPersonDob),
      contactPersonDom: contactPersonDom == null && nullToAbsent
          ? const Value.absent()
          : Value(contactPersonDom),
      state: state == null && nullToAbsent
          ? const Value.absent()
          : Value(state),
      city: city == null && nullToAbsent ? const Value.absent() : Value(city),
      area: area == null && nullToAbsent ? const Value.absent() : Value(area),
      country: country == null && nullToAbsent
          ? const Value.absent()
          : Value(country),
      potential: potential == null && nullToAbsent
          ? const Value.absent()
          : Value(potential),
      supportValue: supportValue == null && nullToAbsent
          ? const Value.absent()
          : Value(supportValue),
      expectedSupportValue: expectedSupportValue == null && nullToAbsent
          ? const Value.absent()
          : Value(expectedSupportValue),
      cdt: cdt == null && nullToAbsent ? const Value.absent() : Value(cdt),
    );
  }

  factory Chemist.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Chemist(
      status: serializer.fromJson<String>(json['status']),
      isEnabled: serializer.fromJson<bool>(json['isEnabled']),
      serverUdt: serializer.fromJson<String?>(json['serverUdt']),
      localStatus: serializer.fromJson<String>(json['localStatus']),
      locallyChangedAt: serializer.fromJson<String?>(json['locallyChangedAt']),
      id: serializer.fromJson<String>(json['id']),
      chemistCode: serializer.fromJson<String?>(json['chemistCode']),
      fullName: serializer.fromJson<String>(json['fullName']),
      phone: serializer.fromJson<String?>(json['phone']),
      email: serializer.fromJson<String?>(json['email']),
      contactPersonName: serializer.fromJson<String?>(
        json['contactPersonName'],
      ),
      contactPersonEmail: serializer.fromJson<String?>(
        json['contactPersonEmail'],
      ),
      contactPersonDob: serializer.fromJson<String?>(json['contactPersonDob']),
      contactPersonDom: serializer.fromJson<String?>(json['contactPersonDom']),
      state: serializer.fromJson<String?>(json['state']),
      city: serializer.fromJson<String?>(json['city']),
      area: serializer.fromJson<String?>(json['area']),
      country: serializer.fromJson<String?>(json['country']),
      potential: serializer.fromJson<double?>(json['potential']),
      supportValue: serializer.fromJson<double?>(json['supportValue']),
      expectedSupportValue: serializer.fromJson<double?>(
        json['expectedSupportValue'],
      ),
      cdt: serializer.fromJson<String?>(json['cdt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'status': serializer.toJson<String>(status),
      'isEnabled': serializer.toJson<bool>(isEnabled),
      'serverUdt': serializer.toJson<String?>(serverUdt),
      'localStatus': serializer.toJson<String>(localStatus),
      'locallyChangedAt': serializer.toJson<String?>(locallyChangedAt),
      'id': serializer.toJson<String>(id),
      'chemistCode': serializer.toJson<String?>(chemistCode),
      'fullName': serializer.toJson<String>(fullName),
      'phone': serializer.toJson<String?>(phone),
      'email': serializer.toJson<String?>(email),
      'contactPersonName': serializer.toJson<String?>(contactPersonName),
      'contactPersonEmail': serializer.toJson<String?>(contactPersonEmail),
      'contactPersonDob': serializer.toJson<String?>(contactPersonDob),
      'contactPersonDom': serializer.toJson<String?>(contactPersonDom),
      'state': serializer.toJson<String?>(state),
      'city': serializer.toJson<String?>(city),
      'area': serializer.toJson<String?>(area),
      'country': serializer.toJson<String?>(country),
      'potential': serializer.toJson<double?>(potential),
      'supportValue': serializer.toJson<double?>(supportValue),
      'expectedSupportValue': serializer.toJson<double?>(expectedSupportValue),
      'cdt': serializer.toJson<String?>(cdt),
    };
  }

  Chemist copyWith({
    String? status,
    bool? isEnabled,
    Value<String?> serverUdt = const Value.absent(),
    String? localStatus,
    Value<String?> locallyChangedAt = const Value.absent(),
    String? id,
    Value<String?> chemistCode = const Value.absent(),
    String? fullName,
    Value<String?> phone = const Value.absent(),
    Value<String?> email = const Value.absent(),
    Value<String?> contactPersonName = const Value.absent(),
    Value<String?> contactPersonEmail = const Value.absent(),
    Value<String?> contactPersonDob = const Value.absent(),
    Value<String?> contactPersonDom = const Value.absent(),
    Value<String?> state = const Value.absent(),
    Value<String?> city = const Value.absent(),
    Value<String?> area = const Value.absent(),
    Value<String?> country = const Value.absent(),
    Value<double?> potential = const Value.absent(),
    Value<double?> supportValue = const Value.absent(),
    Value<double?> expectedSupportValue = const Value.absent(),
    Value<String?> cdt = const Value.absent(),
  }) => Chemist(
    status: status ?? this.status,
    isEnabled: isEnabled ?? this.isEnabled,
    serverUdt: serverUdt.present ? serverUdt.value : this.serverUdt,
    localStatus: localStatus ?? this.localStatus,
    locallyChangedAt: locallyChangedAt.present
        ? locallyChangedAt.value
        : this.locallyChangedAt,
    id: id ?? this.id,
    chemistCode: chemistCode.present ? chemistCode.value : this.chemistCode,
    fullName: fullName ?? this.fullName,
    phone: phone.present ? phone.value : this.phone,
    email: email.present ? email.value : this.email,
    contactPersonName: contactPersonName.present
        ? contactPersonName.value
        : this.contactPersonName,
    contactPersonEmail: contactPersonEmail.present
        ? contactPersonEmail.value
        : this.contactPersonEmail,
    contactPersonDob: contactPersonDob.present
        ? contactPersonDob.value
        : this.contactPersonDob,
    contactPersonDom: contactPersonDom.present
        ? contactPersonDom.value
        : this.contactPersonDom,
    state: state.present ? state.value : this.state,
    city: city.present ? city.value : this.city,
    area: area.present ? area.value : this.area,
    country: country.present ? country.value : this.country,
    potential: potential.present ? potential.value : this.potential,
    supportValue: supportValue.present ? supportValue.value : this.supportValue,
    expectedSupportValue: expectedSupportValue.present
        ? expectedSupportValue.value
        : this.expectedSupportValue,
    cdt: cdt.present ? cdt.value : this.cdt,
  );
  Chemist copyWithCompanion(ChemistsCompanion data) {
    return Chemist(
      status: data.status.present ? data.status.value : this.status,
      isEnabled: data.isEnabled.present ? data.isEnabled.value : this.isEnabled,
      serverUdt: data.serverUdt.present ? data.serverUdt.value : this.serverUdt,
      localStatus: data.localStatus.present
          ? data.localStatus.value
          : this.localStatus,
      locallyChangedAt: data.locallyChangedAt.present
          ? data.locallyChangedAt.value
          : this.locallyChangedAt,
      id: data.id.present ? data.id.value : this.id,
      chemistCode: data.chemistCode.present
          ? data.chemistCode.value
          : this.chemistCode,
      fullName: data.fullName.present ? data.fullName.value : this.fullName,
      phone: data.phone.present ? data.phone.value : this.phone,
      email: data.email.present ? data.email.value : this.email,
      contactPersonName: data.contactPersonName.present
          ? data.contactPersonName.value
          : this.contactPersonName,
      contactPersonEmail: data.contactPersonEmail.present
          ? data.contactPersonEmail.value
          : this.contactPersonEmail,
      contactPersonDob: data.contactPersonDob.present
          ? data.contactPersonDob.value
          : this.contactPersonDob,
      contactPersonDom: data.contactPersonDom.present
          ? data.contactPersonDom.value
          : this.contactPersonDom,
      state: data.state.present ? data.state.value : this.state,
      city: data.city.present ? data.city.value : this.city,
      area: data.area.present ? data.area.value : this.area,
      country: data.country.present ? data.country.value : this.country,
      potential: data.potential.present ? data.potential.value : this.potential,
      supportValue: data.supportValue.present
          ? data.supportValue.value
          : this.supportValue,
      expectedSupportValue: data.expectedSupportValue.present
          ? data.expectedSupportValue.value
          : this.expectedSupportValue,
      cdt: data.cdt.present ? data.cdt.value : this.cdt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Chemist(')
          ..write('status: $status, ')
          ..write('isEnabled: $isEnabled, ')
          ..write('serverUdt: $serverUdt, ')
          ..write('localStatus: $localStatus, ')
          ..write('locallyChangedAt: $locallyChangedAt, ')
          ..write('id: $id, ')
          ..write('chemistCode: $chemistCode, ')
          ..write('fullName: $fullName, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('contactPersonName: $contactPersonName, ')
          ..write('contactPersonEmail: $contactPersonEmail, ')
          ..write('contactPersonDob: $contactPersonDob, ')
          ..write('contactPersonDom: $contactPersonDom, ')
          ..write('state: $state, ')
          ..write('city: $city, ')
          ..write('area: $area, ')
          ..write('country: $country, ')
          ..write('potential: $potential, ')
          ..write('supportValue: $supportValue, ')
          ..write('expectedSupportValue: $expectedSupportValue, ')
          ..write('cdt: $cdt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    status,
    isEnabled,
    serverUdt,
    localStatus,
    locallyChangedAt,
    id,
    chemistCode,
    fullName,
    phone,
    email,
    contactPersonName,
    contactPersonEmail,
    contactPersonDob,
    contactPersonDom,
    state,
    city,
    area,
    country,
    potential,
    supportValue,
    expectedSupportValue,
    cdt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Chemist &&
          other.status == this.status &&
          other.isEnabled == this.isEnabled &&
          other.serverUdt == this.serverUdt &&
          other.localStatus == this.localStatus &&
          other.locallyChangedAt == this.locallyChangedAt &&
          other.id == this.id &&
          other.chemistCode == this.chemistCode &&
          other.fullName == this.fullName &&
          other.phone == this.phone &&
          other.email == this.email &&
          other.contactPersonName == this.contactPersonName &&
          other.contactPersonEmail == this.contactPersonEmail &&
          other.contactPersonDob == this.contactPersonDob &&
          other.contactPersonDom == this.contactPersonDom &&
          other.state == this.state &&
          other.city == this.city &&
          other.area == this.area &&
          other.country == this.country &&
          other.potential == this.potential &&
          other.supportValue == this.supportValue &&
          other.expectedSupportValue == this.expectedSupportValue &&
          other.cdt == this.cdt);
}

class ChemistsCompanion extends UpdateCompanion<Chemist> {
  final Value<String> status;
  final Value<bool> isEnabled;
  final Value<String?> serverUdt;
  final Value<String> localStatus;
  final Value<String?> locallyChangedAt;
  final Value<String> id;
  final Value<String?> chemistCode;
  final Value<String> fullName;
  final Value<String?> phone;
  final Value<String?> email;
  final Value<String?> contactPersonName;
  final Value<String?> contactPersonEmail;
  final Value<String?> contactPersonDob;
  final Value<String?> contactPersonDom;
  final Value<String?> state;
  final Value<String?> city;
  final Value<String?> area;
  final Value<String?> country;
  final Value<double?> potential;
  final Value<double?> supportValue;
  final Value<double?> expectedSupportValue;
  final Value<String?> cdt;
  final Value<int> rowid;
  const ChemistsCompanion({
    this.status = const Value.absent(),
    this.isEnabled = const Value.absent(),
    this.serverUdt = const Value.absent(),
    this.localStatus = const Value.absent(),
    this.locallyChangedAt = const Value.absent(),
    this.id = const Value.absent(),
    this.chemistCode = const Value.absent(),
    this.fullName = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.contactPersonName = const Value.absent(),
    this.contactPersonEmail = const Value.absent(),
    this.contactPersonDob = const Value.absent(),
    this.contactPersonDom = const Value.absent(),
    this.state = const Value.absent(),
    this.city = const Value.absent(),
    this.area = const Value.absent(),
    this.country = const Value.absent(),
    this.potential = const Value.absent(),
    this.supportValue = const Value.absent(),
    this.expectedSupportValue = const Value.absent(),
    this.cdt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChemistsCompanion.insert({
    this.status = const Value.absent(),
    this.isEnabled = const Value.absent(),
    this.serverUdt = const Value.absent(),
    this.localStatus = const Value.absent(),
    this.locallyChangedAt = const Value.absent(),
    required String id,
    this.chemistCode = const Value.absent(),
    this.fullName = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.contactPersonName = const Value.absent(),
    this.contactPersonEmail = const Value.absent(),
    this.contactPersonDob = const Value.absent(),
    this.contactPersonDom = const Value.absent(),
    this.state = const Value.absent(),
    this.city = const Value.absent(),
    this.area = const Value.absent(),
    this.country = const Value.absent(),
    this.potential = const Value.absent(),
    this.supportValue = const Value.absent(),
    this.expectedSupportValue = const Value.absent(),
    this.cdt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<Chemist> custom({
    Expression<String>? status,
    Expression<bool>? isEnabled,
    Expression<String>? serverUdt,
    Expression<String>? localStatus,
    Expression<String>? locallyChangedAt,
    Expression<String>? id,
    Expression<String>? chemistCode,
    Expression<String>? fullName,
    Expression<String>? phone,
    Expression<String>? email,
    Expression<String>? contactPersonName,
    Expression<String>? contactPersonEmail,
    Expression<String>? contactPersonDob,
    Expression<String>? contactPersonDom,
    Expression<String>? state,
    Expression<String>? city,
    Expression<String>? area,
    Expression<String>? country,
    Expression<double>? potential,
    Expression<double>? supportValue,
    Expression<double>? expectedSupportValue,
    Expression<String>? cdt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (status != null) 'status': status,
      if (isEnabled != null) 'is_enabled': isEnabled,
      if (serverUdt != null) 'server_udt': serverUdt,
      if (localStatus != null) 'local_status': localStatus,
      if (locallyChangedAt != null) 'locally_changed_at': locallyChangedAt,
      if (id != null) 'id': id,
      if (chemistCode != null) 'chemist_code': chemistCode,
      if (fullName != null) 'full_name': fullName,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (contactPersonName != null) 'contact_person_name': contactPersonName,
      if (contactPersonEmail != null)
        'contact_person_email': contactPersonEmail,
      if (contactPersonDob != null) 'contact_person_dob': contactPersonDob,
      if (contactPersonDom != null) 'contact_person_dom': contactPersonDom,
      if (state != null) 'state': state,
      if (city != null) 'city': city,
      if (area != null) 'area': area,
      if (country != null) 'country': country,
      if (potential != null) 'potential': potential,
      if (supportValue != null) 'support_value': supportValue,
      if (expectedSupportValue != null)
        'expected_support_value': expectedSupportValue,
      if (cdt != null) 'cdt': cdt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChemistsCompanion copyWith({
    Value<String>? status,
    Value<bool>? isEnabled,
    Value<String?>? serverUdt,
    Value<String>? localStatus,
    Value<String?>? locallyChangedAt,
    Value<String>? id,
    Value<String?>? chemistCode,
    Value<String>? fullName,
    Value<String?>? phone,
    Value<String?>? email,
    Value<String?>? contactPersonName,
    Value<String?>? contactPersonEmail,
    Value<String?>? contactPersonDob,
    Value<String?>? contactPersonDom,
    Value<String?>? state,
    Value<String?>? city,
    Value<String?>? area,
    Value<String?>? country,
    Value<double?>? potential,
    Value<double?>? supportValue,
    Value<double?>? expectedSupportValue,
    Value<String?>? cdt,
    Value<int>? rowid,
  }) {
    return ChemistsCompanion(
      status: status ?? this.status,
      isEnabled: isEnabled ?? this.isEnabled,
      serverUdt: serverUdt ?? this.serverUdt,
      localStatus: localStatus ?? this.localStatus,
      locallyChangedAt: locallyChangedAt ?? this.locallyChangedAt,
      id: id ?? this.id,
      chemistCode: chemistCode ?? this.chemistCode,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      contactPersonName: contactPersonName ?? this.contactPersonName,
      contactPersonEmail: contactPersonEmail ?? this.contactPersonEmail,
      contactPersonDob: contactPersonDob ?? this.contactPersonDob,
      contactPersonDom: contactPersonDom ?? this.contactPersonDom,
      state: state ?? this.state,
      city: city ?? this.city,
      area: area ?? this.area,
      country: country ?? this.country,
      potential: potential ?? this.potential,
      supportValue: supportValue ?? this.supportValue,
      expectedSupportValue: expectedSupportValue ?? this.expectedSupportValue,
      cdt: cdt ?? this.cdt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (isEnabled.present) {
      map['is_enabled'] = Variable<bool>(isEnabled.value);
    }
    if (serverUdt.present) {
      map['server_udt'] = Variable<String>(serverUdt.value);
    }
    if (localStatus.present) {
      map['local_status'] = Variable<String>(localStatus.value);
    }
    if (locallyChangedAt.present) {
      map['locally_changed_at'] = Variable<String>(locallyChangedAt.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (chemistCode.present) {
      map['chemist_code'] = Variable<String>(chemistCode.value);
    }
    if (fullName.present) {
      map['full_name'] = Variable<String>(fullName.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (contactPersonName.present) {
      map['contact_person_name'] = Variable<String>(contactPersonName.value);
    }
    if (contactPersonEmail.present) {
      map['contact_person_email'] = Variable<String>(contactPersonEmail.value);
    }
    if (contactPersonDob.present) {
      map['contact_person_dob'] = Variable<String>(contactPersonDob.value);
    }
    if (contactPersonDom.present) {
      map['contact_person_dom'] = Variable<String>(contactPersonDom.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (city.present) {
      map['city'] = Variable<String>(city.value);
    }
    if (area.present) {
      map['area'] = Variable<String>(area.value);
    }
    if (country.present) {
      map['country'] = Variable<String>(country.value);
    }
    if (potential.present) {
      map['potential'] = Variable<double>(potential.value);
    }
    if (supportValue.present) {
      map['support_value'] = Variable<double>(supportValue.value);
    }
    if (expectedSupportValue.present) {
      map['expected_support_value'] = Variable<double>(
        expectedSupportValue.value,
      );
    }
    if (cdt.present) {
      map['cdt'] = Variable<String>(cdt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChemistsCompanion(')
          ..write('status: $status, ')
          ..write('isEnabled: $isEnabled, ')
          ..write('serverUdt: $serverUdt, ')
          ..write('localStatus: $localStatus, ')
          ..write('locallyChangedAt: $locallyChangedAt, ')
          ..write('id: $id, ')
          ..write('chemistCode: $chemistCode, ')
          ..write('fullName: $fullName, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('contactPersonName: $contactPersonName, ')
          ..write('contactPersonEmail: $contactPersonEmail, ')
          ..write('contactPersonDob: $contactPersonDob, ')
          ..write('contactPersonDom: $contactPersonDom, ')
          ..write('state: $state, ')
          ..write('city: $city, ')
          ..write('area: $area, ')
          ..write('country: $country, ')
          ..write('potential: $potential, ')
          ..write('supportValue: $supportValue, ')
          ..write('expectedSupportValue: $expectedSupportValue, ')
          ..write('cdt: $cdt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProductsTable extends Products with TableInfo<$ProductsTable, Product> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('active'),
  );
  static const VerificationMeta _isEnabledMeta = const VerificationMeta(
    'isEnabled',
  );
  @override
  late final GeneratedColumn<bool> isEnabled = GeneratedColumn<bool>(
    'is_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _serverUdtMeta = const VerificationMeta(
    'serverUdt',
  );
  @override
  late final GeneratedColumn<String> serverUdt = GeneratedColumn<String>(
    'server_udt',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _localStatusMeta = const VerificationMeta(
    'localStatus',
  );
  @override
  late final GeneratedColumn<String> localStatus = GeneratedColumn<String>(
    'local_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('synced'),
  );
  static const VerificationMeta _locallyChangedAtMeta = const VerificationMeta(
    'locallyChangedAt',
  );
  @override
  late final GeneratedColumn<String> locallyChangedAt = GeneratedColumn<String>(
    'locally_changed_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productCodeMeta = const VerificationMeta(
    'productCode',
  );
  @override
  late final GeneratedColumn<String> productCode = GeneratedColumn<String>(
    'product_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _productNameMeta = const VerificationMeta(
    'productName',
  );
  @override
  late final GeneratedColumn<String> productName = GeneratedColumn<String>(
    'product_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _imageUrlsJsonMeta = const VerificationMeta(
    'imageUrlsJson',
  );
  @override
  late final GeneratedColumn<String> imageUrlsJson = GeneratedColumn<String>(
    'image_urls_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _primaryImageUrlMeta = const VerificationMeta(
    'primaryImageUrl',
  );
  @override
  late final GeneratedColumn<String> primaryImageUrl = GeneratedColumn<String>(
    'primary_image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _productMetadataJsonMeta =
      const VerificationMeta('productMetadataJson');
  @override
  late final GeneratedColumn<String> productMetadataJson =
      GeneratedColumn<String>(
        'product_metadata_json',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _displayOrderMeta = const VerificationMeta(
    'displayOrder',
  );
  @override
  late final GeneratedColumn<int> displayOrder = GeneratedColumn<int>(
    'display_order',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    status,
    isEnabled,
    serverUdt,
    localStatus,
    locallyChangedAt,
    id,
    productCode,
    productName,
    imageUrlsJson,
    primaryImageUrl,
    productMetadataJson,
    displayOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'products';
  @override
  VerificationContext validateIntegrity(
    Insertable<Product> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('is_enabled')) {
      context.handle(
        _isEnabledMeta,
        isEnabled.isAcceptableOrUnknown(data['is_enabled']!, _isEnabledMeta),
      );
    }
    if (data.containsKey('server_udt')) {
      context.handle(
        _serverUdtMeta,
        serverUdt.isAcceptableOrUnknown(data['server_udt']!, _serverUdtMeta),
      );
    }
    if (data.containsKey('local_status')) {
      context.handle(
        _localStatusMeta,
        localStatus.isAcceptableOrUnknown(
          data['local_status']!,
          _localStatusMeta,
        ),
      );
    }
    if (data.containsKey('locally_changed_at')) {
      context.handle(
        _locallyChangedAtMeta,
        locallyChangedAt.isAcceptableOrUnknown(
          data['locally_changed_at']!,
          _locallyChangedAtMeta,
        ),
      );
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('product_code')) {
      context.handle(
        _productCodeMeta,
        productCode.isAcceptableOrUnknown(
          data['product_code']!,
          _productCodeMeta,
        ),
      );
    }
    if (data.containsKey('product_name')) {
      context.handle(
        _productNameMeta,
        productName.isAcceptableOrUnknown(
          data['product_name']!,
          _productNameMeta,
        ),
      );
    }
    if (data.containsKey('image_urls_json')) {
      context.handle(
        _imageUrlsJsonMeta,
        imageUrlsJson.isAcceptableOrUnknown(
          data['image_urls_json']!,
          _imageUrlsJsonMeta,
        ),
      );
    }
    if (data.containsKey('primary_image_url')) {
      context.handle(
        _primaryImageUrlMeta,
        primaryImageUrl.isAcceptableOrUnknown(
          data['primary_image_url']!,
          _primaryImageUrlMeta,
        ),
      );
    }
    if (data.containsKey('product_metadata_json')) {
      context.handle(
        _productMetadataJsonMeta,
        productMetadataJson.isAcceptableOrUnknown(
          data['product_metadata_json']!,
          _productMetadataJsonMeta,
        ),
      );
    }
    if (data.containsKey('display_order')) {
      context.handle(
        _displayOrderMeta,
        displayOrder.isAcceptableOrUnknown(
          data['display_order']!,
          _displayOrderMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Product map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Product(
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      isEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_enabled'],
      )!,
      serverUdt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_udt'],
      ),
      localStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_status'],
      )!,
      locallyChangedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}locally_changed_at'],
      ),
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      productCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_code'],
      ),
      productName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_name'],
      )!,
      imageUrlsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_urls_json'],
      ),
      primaryImageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}primary_image_url'],
      ),
      productMetadataJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_metadata_json'],
      ),
      displayOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}display_order'],
      ),
    );
  }

  @override
  $ProductsTable createAlias(String alias) {
    return $ProductsTable(attachedDatabase, alias);
  }
}

class Product extends DataClass implements Insertable<Product> {
  final String status;
  final bool isEnabled;
  final String? serverUdt;
  final String localStatus;
  final String? locallyChangedAt;
  final String id;
  final String? productCode;
  final String productName;

  /// JSON list of {metadata, object_key, url} entries from the sync payload.
  final String? imageUrlsJson;
  final String? primaryImageUrl;
  final String? productMetadataJson;
  final int? displayOrder;
  const Product({
    required this.status,
    required this.isEnabled,
    this.serverUdt,
    required this.localStatus,
    this.locallyChangedAt,
    required this.id,
    this.productCode,
    required this.productName,
    this.imageUrlsJson,
    this.primaryImageUrl,
    this.productMetadataJson,
    this.displayOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['status'] = Variable<String>(status);
    map['is_enabled'] = Variable<bool>(isEnabled);
    if (!nullToAbsent || serverUdt != null) {
      map['server_udt'] = Variable<String>(serverUdt);
    }
    map['local_status'] = Variable<String>(localStatus);
    if (!nullToAbsent || locallyChangedAt != null) {
      map['locally_changed_at'] = Variable<String>(locallyChangedAt);
    }
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || productCode != null) {
      map['product_code'] = Variable<String>(productCode);
    }
    map['product_name'] = Variable<String>(productName);
    if (!nullToAbsent || imageUrlsJson != null) {
      map['image_urls_json'] = Variable<String>(imageUrlsJson);
    }
    if (!nullToAbsent || primaryImageUrl != null) {
      map['primary_image_url'] = Variable<String>(primaryImageUrl);
    }
    if (!nullToAbsent || productMetadataJson != null) {
      map['product_metadata_json'] = Variable<String>(productMetadataJson);
    }
    if (!nullToAbsent || displayOrder != null) {
      map['display_order'] = Variable<int>(displayOrder);
    }
    return map;
  }

  ProductsCompanion toCompanion(bool nullToAbsent) {
    return ProductsCompanion(
      status: Value(status),
      isEnabled: Value(isEnabled),
      serverUdt: serverUdt == null && nullToAbsent
          ? const Value.absent()
          : Value(serverUdt),
      localStatus: Value(localStatus),
      locallyChangedAt: locallyChangedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(locallyChangedAt),
      id: Value(id),
      productCode: productCode == null && nullToAbsent
          ? const Value.absent()
          : Value(productCode),
      productName: Value(productName),
      imageUrlsJson: imageUrlsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrlsJson),
      primaryImageUrl: primaryImageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(primaryImageUrl),
      productMetadataJson: productMetadataJson == null && nullToAbsent
          ? const Value.absent()
          : Value(productMetadataJson),
      displayOrder: displayOrder == null && nullToAbsent
          ? const Value.absent()
          : Value(displayOrder),
    );
  }

  factory Product.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Product(
      status: serializer.fromJson<String>(json['status']),
      isEnabled: serializer.fromJson<bool>(json['isEnabled']),
      serverUdt: serializer.fromJson<String?>(json['serverUdt']),
      localStatus: serializer.fromJson<String>(json['localStatus']),
      locallyChangedAt: serializer.fromJson<String?>(json['locallyChangedAt']),
      id: serializer.fromJson<String>(json['id']),
      productCode: serializer.fromJson<String?>(json['productCode']),
      productName: serializer.fromJson<String>(json['productName']),
      imageUrlsJson: serializer.fromJson<String?>(json['imageUrlsJson']),
      primaryImageUrl: serializer.fromJson<String?>(json['primaryImageUrl']),
      productMetadataJson: serializer.fromJson<String?>(
        json['productMetadataJson'],
      ),
      displayOrder: serializer.fromJson<int?>(json['displayOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'status': serializer.toJson<String>(status),
      'isEnabled': serializer.toJson<bool>(isEnabled),
      'serverUdt': serializer.toJson<String?>(serverUdt),
      'localStatus': serializer.toJson<String>(localStatus),
      'locallyChangedAt': serializer.toJson<String?>(locallyChangedAt),
      'id': serializer.toJson<String>(id),
      'productCode': serializer.toJson<String?>(productCode),
      'productName': serializer.toJson<String>(productName),
      'imageUrlsJson': serializer.toJson<String?>(imageUrlsJson),
      'primaryImageUrl': serializer.toJson<String?>(primaryImageUrl),
      'productMetadataJson': serializer.toJson<String?>(productMetadataJson),
      'displayOrder': serializer.toJson<int?>(displayOrder),
    };
  }

  Product copyWith({
    String? status,
    bool? isEnabled,
    Value<String?> serverUdt = const Value.absent(),
    String? localStatus,
    Value<String?> locallyChangedAt = const Value.absent(),
    String? id,
    Value<String?> productCode = const Value.absent(),
    String? productName,
    Value<String?> imageUrlsJson = const Value.absent(),
    Value<String?> primaryImageUrl = const Value.absent(),
    Value<String?> productMetadataJson = const Value.absent(),
    Value<int?> displayOrder = const Value.absent(),
  }) => Product(
    status: status ?? this.status,
    isEnabled: isEnabled ?? this.isEnabled,
    serverUdt: serverUdt.present ? serverUdt.value : this.serverUdt,
    localStatus: localStatus ?? this.localStatus,
    locallyChangedAt: locallyChangedAt.present
        ? locallyChangedAt.value
        : this.locallyChangedAt,
    id: id ?? this.id,
    productCode: productCode.present ? productCode.value : this.productCode,
    productName: productName ?? this.productName,
    imageUrlsJson: imageUrlsJson.present
        ? imageUrlsJson.value
        : this.imageUrlsJson,
    primaryImageUrl: primaryImageUrl.present
        ? primaryImageUrl.value
        : this.primaryImageUrl,
    productMetadataJson: productMetadataJson.present
        ? productMetadataJson.value
        : this.productMetadataJson,
    displayOrder: displayOrder.present ? displayOrder.value : this.displayOrder,
  );
  Product copyWithCompanion(ProductsCompanion data) {
    return Product(
      status: data.status.present ? data.status.value : this.status,
      isEnabled: data.isEnabled.present ? data.isEnabled.value : this.isEnabled,
      serverUdt: data.serverUdt.present ? data.serverUdt.value : this.serverUdt,
      localStatus: data.localStatus.present
          ? data.localStatus.value
          : this.localStatus,
      locallyChangedAt: data.locallyChangedAt.present
          ? data.locallyChangedAt.value
          : this.locallyChangedAt,
      id: data.id.present ? data.id.value : this.id,
      productCode: data.productCode.present
          ? data.productCode.value
          : this.productCode,
      productName: data.productName.present
          ? data.productName.value
          : this.productName,
      imageUrlsJson: data.imageUrlsJson.present
          ? data.imageUrlsJson.value
          : this.imageUrlsJson,
      primaryImageUrl: data.primaryImageUrl.present
          ? data.primaryImageUrl.value
          : this.primaryImageUrl,
      productMetadataJson: data.productMetadataJson.present
          ? data.productMetadataJson.value
          : this.productMetadataJson,
      displayOrder: data.displayOrder.present
          ? data.displayOrder.value
          : this.displayOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Product(')
          ..write('status: $status, ')
          ..write('isEnabled: $isEnabled, ')
          ..write('serverUdt: $serverUdt, ')
          ..write('localStatus: $localStatus, ')
          ..write('locallyChangedAt: $locallyChangedAt, ')
          ..write('id: $id, ')
          ..write('productCode: $productCode, ')
          ..write('productName: $productName, ')
          ..write('imageUrlsJson: $imageUrlsJson, ')
          ..write('primaryImageUrl: $primaryImageUrl, ')
          ..write('productMetadataJson: $productMetadataJson, ')
          ..write('displayOrder: $displayOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    status,
    isEnabled,
    serverUdt,
    localStatus,
    locallyChangedAt,
    id,
    productCode,
    productName,
    imageUrlsJson,
    primaryImageUrl,
    productMetadataJson,
    displayOrder,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Product &&
          other.status == this.status &&
          other.isEnabled == this.isEnabled &&
          other.serverUdt == this.serverUdt &&
          other.localStatus == this.localStatus &&
          other.locallyChangedAt == this.locallyChangedAt &&
          other.id == this.id &&
          other.productCode == this.productCode &&
          other.productName == this.productName &&
          other.imageUrlsJson == this.imageUrlsJson &&
          other.primaryImageUrl == this.primaryImageUrl &&
          other.productMetadataJson == this.productMetadataJson &&
          other.displayOrder == this.displayOrder);
}

class ProductsCompanion extends UpdateCompanion<Product> {
  final Value<String> status;
  final Value<bool> isEnabled;
  final Value<String?> serverUdt;
  final Value<String> localStatus;
  final Value<String?> locallyChangedAt;
  final Value<String> id;
  final Value<String?> productCode;
  final Value<String> productName;
  final Value<String?> imageUrlsJson;
  final Value<String?> primaryImageUrl;
  final Value<String?> productMetadataJson;
  final Value<int?> displayOrder;
  final Value<int> rowid;
  const ProductsCompanion({
    this.status = const Value.absent(),
    this.isEnabled = const Value.absent(),
    this.serverUdt = const Value.absent(),
    this.localStatus = const Value.absent(),
    this.locallyChangedAt = const Value.absent(),
    this.id = const Value.absent(),
    this.productCode = const Value.absent(),
    this.productName = const Value.absent(),
    this.imageUrlsJson = const Value.absent(),
    this.primaryImageUrl = const Value.absent(),
    this.productMetadataJson = const Value.absent(),
    this.displayOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProductsCompanion.insert({
    this.status = const Value.absent(),
    this.isEnabled = const Value.absent(),
    this.serverUdt = const Value.absent(),
    this.localStatus = const Value.absent(),
    this.locallyChangedAt = const Value.absent(),
    required String id,
    this.productCode = const Value.absent(),
    this.productName = const Value.absent(),
    this.imageUrlsJson = const Value.absent(),
    this.primaryImageUrl = const Value.absent(),
    this.productMetadataJson = const Value.absent(),
    this.displayOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<Product> custom({
    Expression<String>? status,
    Expression<bool>? isEnabled,
    Expression<String>? serverUdt,
    Expression<String>? localStatus,
    Expression<String>? locallyChangedAt,
    Expression<String>? id,
    Expression<String>? productCode,
    Expression<String>? productName,
    Expression<String>? imageUrlsJson,
    Expression<String>? primaryImageUrl,
    Expression<String>? productMetadataJson,
    Expression<int>? displayOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (status != null) 'status': status,
      if (isEnabled != null) 'is_enabled': isEnabled,
      if (serverUdt != null) 'server_udt': serverUdt,
      if (localStatus != null) 'local_status': localStatus,
      if (locallyChangedAt != null) 'locally_changed_at': locallyChangedAt,
      if (id != null) 'id': id,
      if (productCode != null) 'product_code': productCode,
      if (productName != null) 'product_name': productName,
      if (imageUrlsJson != null) 'image_urls_json': imageUrlsJson,
      if (primaryImageUrl != null) 'primary_image_url': primaryImageUrl,
      if (productMetadataJson != null)
        'product_metadata_json': productMetadataJson,
      if (displayOrder != null) 'display_order': displayOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProductsCompanion copyWith({
    Value<String>? status,
    Value<bool>? isEnabled,
    Value<String?>? serverUdt,
    Value<String>? localStatus,
    Value<String?>? locallyChangedAt,
    Value<String>? id,
    Value<String?>? productCode,
    Value<String>? productName,
    Value<String?>? imageUrlsJson,
    Value<String?>? primaryImageUrl,
    Value<String?>? productMetadataJson,
    Value<int?>? displayOrder,
    Value<int>? rowid,
  }) {
    return ProductsCompanion(
      status: status ?? this.status,
      isEnabled: isEnabled ?? this.isEnabled,
      serverUdt: serverUdt ?? this.serverUdt,
      localStatus: localStatus ?? this.localStatus,
      locallyChangedAt: locallyChangedAt ?? this.locallyChangedAt,
      id: id ?? this.id,
      productCode: productCode ?? this.productCode,
      productName: productName ?? this.productName,
      imageUrlsJson: imageUrlsJson ?? this.imageUrlsJson,
      primaryImageUrl: primaryImageUrl ?? this.primaryImageUrl,
      productMetadataJson: productMetadataJson ?? this.productMetadataJson,
      displayOrder: displayOrder ?? this.displayOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (isEnabled.present) {
      map['is_enabled'] = Variable<bool>(isEnabled.value);
    }
    if (serverUdt.present) {
      map['server_udt'] = Variable<String>(serverUdt.value);
    }
    if (localStatus.present) {
      map['local_status'] = Variable<String>(localStatus.value);
    }
    if (locallyChangedAt.present) {
      map['locally_changed_at'] = Variable<String>(locallyChangedAt.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (productCode.present) {
      map['product_code'] = Variable<String>(productCode.value);
    }
    if (productName.present) {
      map['product_name'] = Variable<String>(productName.value);
    }
    if (imageUrlsJson.present) {
      map['image_urls_json'] = Variable<String>(imageUrlsJson.value);
    }
    if (primaryImageUrl.present) {
      map['primary_image_url'] = Variable<String>(primaryImageUrl.value);
    }
    if (productMetadataJson.present) {
      map['product_metadata_json'] = Variable<String>(
        productMetadataJson.value,
      );
    }
    if (displayOrder.present) {
      map['display_order'] = Variable<int>(displayOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductsCompanion(')
          ..write('status: $status, ')
          ..write('isEnabled: $isEnabled, ')
          ..write('serverUdt: $serverUdt, ')
          ..write('localStatus: $localStatus, ')
          ..write('locallyChangedAt: $locallyChangedAt, ')
          ..write('id: $id, ')
          ..write('productCode: $productCode, ')
          ..write('productName: $productName, ')
          ..write('imageUrlsJson: $imageUrlsJson, ')
          ..write('primaryImageUrl: $primaryImageUrl, ')
          ..write('productMetadataJson: $productMetadataJson, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DailyPlansTable extends DailyPlans
    with TableInfo<$DailyPlansTable, DailyPlan> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyPlansTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('active'),
  );
  static const VerificationMeta _isEnabledMeta = const VerificationMeta(
    'isEnabled',
  );
  @override
  late final GeneratedColumn<bool> isEnabled = GeneratedColumn<bool>(
    'is_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _serverUdtMeta = const VerificationMeta(
    'serverUdt',
  );
  @override
  late final GeneratedColumn<String> serverUdt = GeneratedColumn<String>(
    'server_udt',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _localStatusMeta = const VerificationMeta(
    'localStatus',
  );
  @override
  late final GeneratedColumn<String> localStatus = GeneratedColumn<String>(
    'local_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('synced'),
  );
  static const VerificationMeta _locallyChangedAtMeta = const VerificationMeta(
    'locallyChangedAt',
  );
  @override
  late final GeneratedColumn<String> locallyChangedAt = GeneratedColumn<String>(
    'locally_changed_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _visitDateMeta = const VerificationMeta(
    'visitDate',
  );
  @override
  late final GeneratedColumn<String> visitDate = GeneratedColumn<String>(
    'visit_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _visitStatusMeta = const VerificationMeta(
    'visitStatus',
  );
  @override
  late final GeneratedColumn<int> visitStatus = GeneratedColumn<int>(
    'visit_status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _customerTypeMeta = const VerificationMeta(
    'customerType',
  );
  @override
  late final GeneratedColumn<String> customerType = GeneratedColumn<String>(
    'customer_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('doctor'),
  );
  static const VerificationMeta _customerIdMeta = const VerificationMeta(
    'customerId',
  );
  @override
  late final GeneratedColumn<String> customerId = GeneratedColumn<String>(
    'customer_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isTeamVisitMeta = const VerificationMeta(
    'isTeamVisit',
  );
  @override
  late final GeneratedColumn<bool> isTeamVisit = GeneratedColumn<bool>(
    'is_team_visit',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_team_visit" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _cdtMeta = const VerificationMeta('cdt');
  @override
  late final GeneratedColumn<String> cdt = GeneratedColumn<String>(
    'cdt',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    status,
    isEnabled,
    serverUdt,
    localStatus,
    locallyChangedAt,
    id,
    userId,
    visitDate,
    visitStatus,
    customerType,
    customerId,
    isTeamVisit,
    cdt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_plans';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailyPlan> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('is_enabled')) {
      context.handle(
        _isEnabledMeta,
        isEnabled.isAcceptableOrUnknown(data['is_enabled']!, _isEnabledMeta),
      );
    }
    if (data.containsKey('server_udt')) {
      context.handle(
        _serverUdtMeta,
        serverUdt.isAcceptableOrUnknown(data['server_udt']!, _serverUdtMeta),
      );
    }
    if (data.containsKey('local_status')) {
      context.handle(
        _localStatusMeta,
        localStatus.isAcceptableOrUnknown(
          data['local_status']!,
          _localStatusMeta,
        ),
      );
    }
    if (data.containsKey('locally_changed_at')) {
      context.handle(
        _locallyChangedAtMeta,
        locallyChangedAt.isAcceptableOrUnknown(
          data['locally_changed_at']!,
          _locallyChangedAtMeta,
        ),
      );
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    if (data.containsKey('visit_date')) {
      context.handle(
        _visitDateMeta,
        visitDate.isAcceptableOrUnknown(data['visit_date']!, _visitDateMeta),
      );
    } else if (isInserting) {
      context.missing(_visitDateMeta);
    }
    if (data.containsKey('visit_status')) {
      context.handle(
        _visitStatusMeta,
        visitStatus.isAcceptableOrUnknown(
          data['visit_status']!,
          _visitStatusMeta,
        ),
      );
    }
    if (data.containsKey('customer_type')) {
      context.handle(
        _customerTypeMeta,
        customerType.isAcceptableOrUnknown(
          data['customer_type']!,
          _customerTypeMeta,
        ),
      );
    }
    if (data.containsKey('customer_id')) {
      context.handle(
        _customerIdMeta,
        customerId.isAcceptableOrUnknown(data['customer_id']!, _customerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_customerIdMeta);
    }
    if (data.containsKey('is_team_visit')) {
      context.handle(
        _isTeamVisitMeta,
        isTeamVisit.isAcceptableOrUnknown(
          data['is_team_visit']!,
          _isTeamVisitMeta,
        ),
      );
    }
    if (data.containsKey('cdt')) {
      context.handle(
        _cdtMeta,
        cdt.isAcceptableOrUnknown(data['cdt']!, _cdtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DailyPlan map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyPlan(
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      isEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_enabled'],
      )!,
      serverUdt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_udt'],
      ),
      localStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_status'],
      )!,
      locallyChangedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}locally_changed_at'],
      ),
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      ),
      visitDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}visit_date'],
      )!,
      visitStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}visit_status'],
      )!,
      customerType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_type'],
      )!,
      customerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_id'],
      )!,
      isTeamVisit: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_team_visit'],
      )!,
      cdt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cdt'],
      ),
    );
  }

  @override
  $DailyPlansTable createAlias(String alias) {
    return $DailyPlansTable(attachedDatabase, alias);
  }
}

class DailyPlan extends DataClass implements Insertable<DailyPlan> {
  final String status;
  final bool isEnabled;
  final String? serverUdt;
  final String localStatus;
  final String? locallyChangedAt;
  final String id;
  final String? userId;
  final String visitDate;
  final int visitStatus;
  final String customerType;
  final String customerId;
  final bool isTeamVisit;
  final String? cdt;
  const DailyPlan({
    required this.status,
    required this.isEnabled,
    this.serverUdt,
    required this.localStatus,
    this.locallyChangedAt,
    required this.id,
    this.userId,
    required this.visitDate,
    required this.visitStatus,
    required this.customerType,
    required this.customerId,
    required this.isTeamVisit,
    this.cdt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['status'] = Variable<String>(status);
    map['is_enabled'] = Variable<bool>(isEnabled);
    if (!nullToAbsent || serverUdt != null) {
      map['server_udt'] = Variable<String>(serverUdt);
    }
    map['local_status'] = Variable<String>(localStatus);
    if (!nullToAbsent || locallyChangedAt != null) {
      map['locally_changed_at'] = Variable<String>(locallyChangedAt);
    }
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    map['visit_date'] = Variable<String>(visitDate);
    map['visit_status'] = Variable<int>(visitStatus);
    map['customer_type'] = Variable<String>(customerType);
    map['customer_id'] = Variable<String>(customerId);
    map['is_team_visit'] = Variable<bool>(isTeamVisit);
    if (!nullToAbsent || cdt != null) {
      map['cdt'] = Variable<String>(cdt);
    }
    return map;
  }

  DailyPlansCompanion toCompanion(bool nullToAbsent) {
    return DailyPlansCompanion(
      status: Value(status),
      isEnabled: Value(isEnabled),
      serverUdt: serverUdt == null && nullToAbsent
          ? const Value.absent()
          : Value(serverUdt),
      localStatus: Value(localStatus),
      locallyChangedAt: locallyChangedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(locallyChangedAt),
      id: Value(id),
      userId: userId == null && nullToAbsent
          ? const Value.absent()
          : Value(userId),
      visitDate: Value(visitDate),
      visitStatus: Value(visitStatus),
      customerType: Value(customerType),
      customerId: Value(customerId),
      isTeamVisit: Value(isTeamVisit),
      cdt: cdt == null && nullToAbsent ? const Value.absent() : Value(cdt),
    );
  }

  factory DailyPlan.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyPlan(
      status: serializer.fromJson<String>(json['status']),
      isEnabled: serializer.fromJson<bool>(json['isEnabled']),
      serverUdt: serializer.fromJson<String?>(json['serverUdt']),
      localStatus: serializer.fromJson<String>(json['localStatus']),
      locallyChangedAt: serializer.fromJson<String?>(json['locallyChangedAt']),
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String?>(json['userId']),
      visitDate: serializer.fromJson<String>(json['visitDate']),
      visitStatus: serializer.fromJson<int>(json['visitStatus']),
      customerType: serializer.fromJson<String>(json['customerType']),
      customerId: serializer.fromJson<String>(json['customerId']),
      isTeamVisit: serializer.fromJson<bool>(json['isTeamVisit']),
      cdt: serializer.fromJson<String?>(json['cdt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'status': serializer.toJson<String>(status),
      'isEnabled': serializer.toJson<bool>(isEnabled),
      'serverUdt': serializer.toJson<String?>(serverUdt),
      'localStatus': serializer.toJson<String>(localStatus),
      'locallyChangedAt': serializer.toJson<String?>(locallyChangedAt),
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String?>(userId),
      'visitDate': serializer.toJson<String>(visitDate),
      'visitStatus': serializer.toJson<int>(visitStatus),
      'customerType': serializer.toJson<String>(customerType),
      'customerId': serializer.toJson<String>(customerId),
      'isTeamVisit': serializer.toJson<bool>(isTeamVisit),
      'cdt': serializer.toJson<String?>(cdt),
    };
  }

  DailyPlan copyWith({
    String? status,
    bool? isEnabled,
    Value<String?> serverUdt = const Value.absent(),
    String? localStatus,
    Value<String?> locallyChangedAt = const Value.absent(),
    String? id,
    Value<String?> userId = const Value.absent(),
    String? visitDate,
    int? visitStatus,
    String? customerType,
    String? customerId,
    bool? isTeamVisit,
    Value<String?> cdt = const Value.absent(),
  }) => DailyPlan(
    status: status ?? this.status,
    isEnabled: isEnabled ?? this.isEnabled,
    serverUdt: serverUdt.present ? serverUdt.value : this.serverUdt,
    localStatus: localStatus ?? this.localStatus,
    locallyChangedAt: locallyChangedAt.present
        ? locallyChangedAt.value
        : this.locallyChangedAt,
    id: id ?? this.id,
    userId: userId.present ? userId.value : this.userId,
    visitDate: visitDate ?? this.visitDate,
    visitStatus: visitStatus ?? this.visitStatus,
    customerType: customerType ?? this.customerType,
    customerId: customerId ?? this.customerId,
    isTeamVisit: isTeamVisit ?? this.isTeamVisit,
    cdt: cdt.present ? cdt.value : this.cdt,
  );
  DailyPlan copyWithCompanion(DailyPlansCompanion data) {
    return DailyPlan(
      status: data.status.present ? data.status.value : this.status,
      isEnabled: data.isEnabled.present ? data.isEnabled.value : this.isEnabled,
      serverUdt: data.serverUdt.present ? data.serverUdt.value : this.serverUdt,
      localStatus: data.localStatus.present
          ? data.localStatus.value
          : this.localStatus,
      locallyChangedAt: data.locallyChangedAt.present
          ? data.locallyChangedAt.value
          : this.locallyChangedAt,
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      visitDate: data.visitDate.present ? data.visitDate.value : this.visitDate,
      visitStatus: data.visitStatus.present
          ? data.visitStatus.value
          : this.visitStatus,
      customerType: data.customerType.present
          ? data.customerType.value
          : this.customerType,
      customerId: data.customerId.present
          ? data.customerId.value
          : this.customerId,
      isTeamVisit: data.isTeamVisit.present
          ? data.isTeamVisit.value
          : this.isTeamVisit,
      cdt: data.cdt.present ? data.cdt.value : this.cdt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyPlan(')
          ..write('status: $status, ')
          ..write('isEnabled: $isEnabled, ')
          ..write('serverUdt: $serverUdt, ')
          ..write('localStatus: $localStatus, ')
          ..write('locallyChangedAt: $locallyChangedAt, ')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('visitDate: $visitDate, ')
          ..write('visitStatus: $visitStatus, ')
          ..write('customerType: $customerType, ')
          ..write('customerId: $customerId, ')
          ..write('isTeamVisit: $isTeamVisit, ')
          ..write('cdt: $cdt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    status,
    isEnabled,
    serverUdt,
    localStatus,
    locallyChangedAt,
    id,
    userId,
    visitDate,
    visitStatus,
    customerType,
    customerId,
    isTeamVisit,
    cdt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyPlan &&
          other.status == this.status &&
          other.isEnabled == this.isEnabled &&
          other.serverUdt == this.serverUdt &&
          other.localStatus == this.localStatus &&
          other.locallyChangedAt == this.locallyChangedAt &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.visitDate == this.visitDate &&
          other.visitStatus == this.visitStatus &&
          other.customerType == this.customerType &&
          other.customerId == this.customerId &&
          other.isTeamVisit == this.isTeamVisit &&
          other.cdt == this.cdt);
}

class DailyPlansCompanion extends UpdateCompanion<DailyPlan> {
  final Value<String> status;
  final Value<bool> isEnabled;
  final Value<String?> serverUdt;
  final Value<String> localStatus;
  final Value<String?> locallyChangedAt;
  final Value<String> id;
  final Value<String?> userId;
  final Value<String> visitDate;
  final Value<int> visitStatus;
  final Value<String> customerType;
  final Value<String> customerId;
  final Value<bool> isTeamVisit;
  final Value<String?> cdt;
  final Value<int> rowid;
  const DailyPlansCompanion({
    this.status = const Value.absent(),
    this.isEnabled = const Value.absent(),
    this.serverUdt = const Value.absent(),
    this.localStatus = const Value.absent(),
    this.locallyChangedAt = const Value.absent(),
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.visitDate = const Value.absent(),
    this.visitStatus = const Value.absent(),
    this.customerType = const Value.absent(),
    this.customerId = const Value.absent(),
    this.isTeamVisit = const Value.absent(),
    this.cdt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DailyPlansCompanion.insert({
    this.status = const Value.absent(),
    this.isEnabled = const Value.absent(),
    this.serverUdt = const Value.absent(),
    this.localStatus = const Value.absent(),
    this.locallyChangedAt = const Value.absent(),
    required String id,
    this.userId = const Value.absent(),
    required String visitDate,
    this.visitStatus = const Value.absent(),
    this.customerType = const Value.absent(),
    required String customerId,
    this.isTeamVisit = const Value.absent(),
    this.cdt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       visitDate = Value(visitDate),
       customerId = Value(customerId);
  static Insertable<DailyPlan> custom({
    Expression<String>? status,
    Expression<bool>? isEnabled,
    Expression<String>? serverUdt,
    Expression<String>? localStatus,
    Expression<String>? locallyChangedAt,
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? visitDate,
    Expression<int>? visitStatus,
    Expression<String>? customerType,
    Expression<String>? customerId,
    Expression<bool>? isTeamVisit,
    Expression<String>? cdt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (status != null) 'status': status,
      if (isEnabled != null) 'is_enabled': isEnabled,
      if (serverUdt != null) 'server_udt': serverUdt,
      if (localStatus != null) 'local_status': localStatus,
      if (locallyChangedAt != null) 'locally_changed_at': locallyChangedAt,
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (visitDate != null) 'visit_date': visitDate,
      if (visitStatus != null) 'visit_status': visitStatus,
      if (customerType != null) 'customer_type': customerType,
      if (customerId != null) 'customer_id': customerId,
      if (isTeamVisit != null) 'is_team_visit': isTeamVisit,
      if (cdt != null) 'cdt': cdt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DailyPlansCompanion copyWith({
    Value<String>? status,
    Value<bool>? isEnabled,
    Value<String?>? serverUdt,
    Value<String>? localStatus,
    Value<String?>? locallyChangedAt,
    Value<String>? id,
    Value<String?>? userId,
    Value<String>? visitDate,
    Value<int>? visitStatus,
    Value<String>? customerType,
    Value<String>? customerId,
    Value<bool>? isTeamVisit,
    Value<String?>? cdt,
    Value<int>? rowid,
  }) {
    return DailyPlansCompanion(
      status: status ?? this.status,
      isEnabled: isEnabled ?? this.isEnabled,
      serverUdt: serverUdt ?? this.serverUdt,
      localStatus: localStatus ?? this.localStatus,
      locallyChangedAt: locallyChangedAt ?? this.locallyChangedAt,
      id: id ?? this.id,
      userId: userId ?? this.userId,
      visitDate: visitDate ?? this.visitDate,
      visitStatus: visitStatus ?? this.visitStatus,
      customerType: customerType ?? this.customerType,
      customerId: customerId ?? this.customerId,
      isTeamVisit: isTeamVisit ?? this.isTeamVisit,
      cdt: cdt ?? this.cdt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (isEnabled.present) {
      map['is_enabled'] = Variable<bool>(isEnabled.value);
    }
    if (serverUdt.present) {
      map['server_udt'] = Variable<String>(serverUdt.value);
    }
    if (localStatus.present) {
      map['local_status'] = Variable<String>(localStatus.value);
    }
    if (locallyChangedAt.present) {
      map['locally_changed_at'] = Variable<String>(locallyChangedAt.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (visitDate.present) {
      map['visit_date'] = Variable<String>(visitDate.value);
    }
    if (visitStatus.present) {
      map['visit_status'] = Variable<int>(visitStatus.value);
    }
    if (customerType.present) {
      map['customer_type'] = Variable<String>(customerType.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<String>(customerId.value);
    }
    if (isTeamVisit.present) {
      map['is_team_visit'] = Variable<bool>(isTeamVisit.value);
    }
    if (cdt.present) {
      map['cdt'] = Variable<String>(cdt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyPlansCompanion(')
          ..write('status: $status, ')
          ..write('isEnabled: $isEnabled, ')
          ..write('serverUdt: $serverUdt, ')
          ..write('localStatus: $localStatus, ')
          ..write('locallyChangedAt: $locallyChangedAt, ')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('visitDate: $visitDate, ')
          ..write('visitStatus: $visitStatus, ')
          ..write('customerType: $customerType, ')
          ..write('customerId: $customerId, ')
          ..write('isTeamVisit: $isTeamVisit, ')
          ..write('cdt: $cdt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DcrsTable extends Dcrs with TableInfo<$DcrsTable, Dcr> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DcrsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('active'),
  );
  static const VerificationMeta _isEnabledMeta = const VerificationMeta(
    'isEnabled',
  );
  @override
  late final GeneratedColumn<bool> isEnabled = GeneratedColumn<bool>(
    'is_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _serverUdtMeta = const VerificationMeta(
    'serverUdt',
  );
  @override
  late final GeneratedColumn<String> serverUdt = GeneratedColumn<String>(
    'server_udt',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _localStatusMeta = const VerificationMeta(
    'localStatus',
  );
  @override
  late final GeneratedColumn<String> localStatus = GeneratedColumn<String>(
    'local_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('synced'),
  );
  static const VerificationMeta _locallyChangedAtMeta = const VerificationMeta(
    'locallyChangedAt',
  );
  @override
  late final GeneratedColumn<String> locallyChangedAt = GeneratedColumn<String>(
    'locally_changed_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _planIdMeta = const VerificationMeta('planId');
  @override
  late final GeneratedColumn<String> planId = GeneratedColumn<String>(
    'plan_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _visitDatetimeMeta = const VerificationMeta(
    'visitDatetime',
  );
  @override
  late final GeneratedColumn<String> visitDatetime = GeneratedColumn<String>(
    'visit_datetime',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _remarksMeta = const VerificationMeta(
    'remarks',
  );
  @override
  late final GeneratedColumn<String> remarks = GeneratedColumn<String>(
    'remarks',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _supportValueMeta = const VerificationMeta(
    'supportValue',
  );
  @override
  late final GeneratedColumn<double> supportValue = GeneratedColumn<double>(
    'support_value',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _potentialMeta = const VerificationMeta(
    'potential',
  );
  @override
  late final GeneratedColumn<double> potential = GeneratedColumn<double>(
    'potential',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _expectedSupportValueMeta =
      const VerificationMeta('expectedSupportValue');
  @override
  late final GeneratedColumn<double> expectedSupportValue =
      GeneratedColumn<double>(
        'expected_support_value',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _productIdsMeta = const VerificationMeta(
    'productIds',
  );
  @override
  late final GeneratedColumn<String> productIds = GeneratedColumn<String>(
    'product_ids',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _productQuantitiesJsonMeta =
      const VerificationMeta('productQuantitiesJson');
  @override
  late final GeneratedColumn<String> productQuantitiesJson =
      GeneratedColumn<String>(
        'product_quantities_json',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _cdtMeta = const VerificationMeta('cdt');
  @override
  late final GeneratedColumn<String> cdt = GeneratedColumn<String>(
    'cdt',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    status,
    isEnabled,
    serverUdt,
    localStatus,
    locallyChangedAt,
    id,
    planId,
    userId,
    visitDatetime,
    remarks,
    supportValue,
    potential,
    expectedSupportValue,
    productIds,
    productQuantitiesJson,
    cdt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'dcrs';
  @override
  VerificationContext validateIntegrity(
    Insertable<Dcr> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('is_enabled')) {
      context.handle(
        _isEnabledMeta,
        isEnabled.isAcceptableOrUnknown(data['is_enabled']!, _isEnabledMeta),
      );
    }
    if (data.containsKey('server_udt')) {
      context.handle(
        _serverUdtMeta,
        serverUdt.isAcceptableOrUnknown(data['server_udt']!, _serverUdtMeta),
      );
    }
    if (data.containsKey('local_status')) {
      context.handle(
        _localStatusMeta,
        localStatus.isAcceptableOrUnknown(
          data['local_status']!,
          _localStatusMeta,
        ),
      );
    }
    if (data.containsKey('locally_changed_at')) {
      context.handle(
        _locallyChangedAtMeta,
        locallyChangedAt.isAcceptableOrUnknown(
          data['locally_changed_at']!,
          _locallyChangedAtMeta,
        ),
      );
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('plan_id')) {
      context.handle(
        _planIdMeta,
        planId.isAcceptableOrUnknown(data['plan_id']!, _planIdMeta),
      );
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    if (data.containsKey('visit_datetime')) {
      context.handle(
        _visitDatetimeMeta,
        visitDatetime.isAcceptableOrUnknown(
          data['visit_datetime']!,
          _visitDatetimeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_visitDatetimeMeta);
    }
    if (data.containsKey('remarks')) {
      context.handle(
        _remarksMeta,
        remarks.isAcceptableOrUnknown(data['remarks']!, _remarksMeta),
      );
    }
    if (data.containsKey('support_value')) {
      context.handle(
        _supportValueMeta,
        supportValue.isAcceptableOrUnknown(
          data['support_value']!,
          _supportValueMeta,
        ),
      );
    }
    if (data.containsKey('potential')) {
      context.handle(
        _potentialMeta,
        potential.isAcceptableOrUnknown(data['potential']!, _potentialMeta),
      );
    }
    if (data.containsKey('expected_support_value')) {
      context.handle(
        _expectedSupportValueMeta,
        expectedSupportValue.isAcceptableOrUnknown(
          data['expected_support_value']!,
          _expectedSupportValueMeta,
        ),
      );
    }
    if (data.containsKey('product_ids')) {
      context.handle(
        _productIdsMeta,
        productIds.isAcceptableOrUnknown(data['product_ids']!, _productIdsMeta),
      );
    }
    if (data.containsKey('product_quantities_json')) {
      context.handle(
        _productQuantitiesJsonMeta,
        productQuantitiesJson.isAcceptableOrUnknown(
          data['product_quantities_json']!,
          _productQuantitiesJsonMeta,
        ),
      );
    }
    if (data.containsKey('cdt')) {
      context.handle(
        _cdtMeta,
        cdt.isAcceptableOrUnknown(data['cdt']!, _cdtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Dcr map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Dcr(
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      isEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_enabled'],
      )!,
      serverUdt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_udt'],
      ),
      localStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_status'],
      )!,
      locallyChangedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}locally_changed_at'],
      ),
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      planId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plan_id'],
      ),
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      ),
      visitDatetime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}visit_datetime'],
      )!,
      remarks: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remarks'],
      ),
      supportValue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}support_value'],
      ),
      potential: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}potential'],
      ),
      expectedSupportValue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}expected_support_value'],
      ),
      productIds: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_ids'],
      ),
      productQuantitiesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_quantities_json'],
      ),
      cdt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cdt'],
      ),
    );
  }

  @override
  $DcrsTable createAlias(String alias) {
    return $DcrsTable(attachedDatabase, alias);
  }
}

class Dcr extends DataClass implements Insertable<Dcr> {
  final String status;
  final bool isEnabled;
  final String? serverUdt;
  final String localStatus;
  final String? locallyChangedAt;
  final String id;
  final String? planId;
  final String? userId;
  final String visitDatetime;
  final String? remarks;
  final double? supportValue;
  final double? potential;
  final double? expectedSupportValue;
  final String? productIds;

  /// JSON object mapping product id -> sample quantity recorded for the visit.
  final String? productQuantitiesJson;
  final String? cdt;
  const Dcr({
    required this.status,
    required this.isEnabled,
    this.serverUdt,
    required this.localStatus,
    this.locallyChangedAt,
    required this.id,
    this.planId,
    this.userId,
    required this.visitDatetime,
    this.remarks,
    this.supportValue,
    this.potential,
    this.expectedSupportValue,
    this.productIds,
    this.productQuantitiesJson,
    this.cdt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['status'] = Variable<String>(status);
    map['is_enabled'] = Variable<bool>(isEnabled);
    if (!nullToAbsent || serverUdt != null) {
      map['server_udt'] = Variable<String>(serverUdt);
    }
    map['local_status'] = Variable<String>(localStatus);
    if (!nullToAbsent || locallyChangedAt != null) {
      map['locally_changed_at'] = Variable<String>(locallyChangedAt);
    }
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || planId != null) {
      map['plan_id'] = Variable<String>(planId);
    }
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    map['visit_datetime'] = Variable<String>(visitDatetime);
    if (!nullToAbsent || remarks != null) {
      map['remarks'] = Variable<String>(remarks);
    }
    if (!nullToAbsent || supportValue != null) {
      map['support_value'] = Variable<double>(supportValue);
    }
    if (!nullToAbsent || potential != null) {
      map['potential'] = Variable<double>(potential);
    }
    if (!nullToAbsent || expectedSupportValue != null) {
      map['expected_support_value'] = Variable<double>(expectedSupportValue);
    }
    if (!nullToAbsent || productIds != null) {
      map['product_ids'] = Variable<String>(productIds);
    }
    if (!nullToAbsent || productQuantitiesJson != null) {
      map['product_quantities_json'] = Variable<String>(productQuantitiesJson);
    }
    if (!nullToAbsent || cdt != null) {
      map['cdt'] = Variable<String>(cdt);
    }
    return map;
  }

  DcrsCompanion toCompanion(bool nullToAbsent) {
    return DcrsCompanion(
      status: Value(status),
      isEnabled: Value(isEnabled),
      serverUdt: serverUdt == null && nullToAbsent
          ? const Value.absent()
          : Value(serverUdt),
      localStatus: Value(localStatus),
      locallyChangedAt: locallyChangedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(locallyChangedAt),
      id: Value(id),
      planId: planId == null && nullToAbsent
          ? const Value.absent()
          : Value(planId),
      userId: userId == null && nullToAbsent
          ? const Value.absent()
          : Value(userId),
      visitDatetime: Value(visitDatetime),
      remarks: remarks == null && nullToAbsent
          ? const Value.absent()
          : Value(remarks),
      supportValue: supportValue == null && nullToAbsent
          ? const Value.absent()
          : Value(supportValue),
      potential: potential == null && nullToAbsent
          ? const Value.absent()
          : Value(potential),
      expectedSupportValue: expectedSupportValue == null && nullToAbsent
          ? const Value.absent()
          : Value(expectedSupportValue),
      productIds: productIds == null && nullToAbsent
          ? const Value.absent()
          : Value(productIds),
      productQuantitiesJson: productQuantitiesJson == null && nullToAbsent
          ? const Value.absent()
          : Value(productQuantitiesJson),
      cdt: cdt == null && nullToAbsent ? const Value.absent() : Value(cdt),
    );
  }

  factory Dcr.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Dcr(
      status: serializer.fromJson<String>(json['status']),
      isEnabled: serializer.fromJson<bool>(json['isEnabled']),
      serverUdt: serializer.fromJson<String?>(json['serverUdt']),
      localStatus: serializer.fromJson<String>(json['localStatus']),
      locallyChangedAt: serializer.fromJson<String?>(json['locallyChangedAt']),
      id: serializer.fromJson<String>(json['id']),
      planId: serializer.fromJson<String?>(json['planId']),
      userId: serializer.fromJson<String?>(json['userId']),
      visitDatetime: serializer.fromJson<String>(json['visitDatetime']),
      remarks: serializer.fromJson<String?>(json['remarks']),
      supportValue: serializer.fromJson<double?>(json['supportValue']),
      potential: serializer.fromJson<double?>(json['potential']),
      expectedSupportValue: serializer.fromJson<double?>(
        json['expectedSupportValue'],
      ),
      productIds: serializer.fromJson<String?>(json['productIds']),
      productQuantitiesJson: serializer.fromJson<String?>(
        json['productQuantitiesJson'],
      ),
      cdt: serializer.fromJson<String?>(json['cdt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'status': serializer.toJson<String>(status),
      'isEnabled': serializer.toJson<bool>(isEnabled),
      'serverUdt': serializer.toJson<String?>(serverUdt),
      'localStatus': serializer.toJson<String>(localStatus),
      'locallyChangedAt': serializer.toJson<String?>(locallyChangedAt),
      'id': serializer.toJson<String>(id),
      'planId': serializer.toJson<String?>(planId),
      'userId': serializer.toJson<String?>(userId),
      'visitDatetime': serializer.toJson<String>(visitDatetime),
      'remarks': serializer.toJson<String?>(remarks),
      'supportValue': serializer.toJson<double?>(supportValue),
      'potential': serializer.toJson<double?>(potential),
      'expectedSupportValue': serializer.toJson<double?>(expectedSupportValue),
      'productIds': serializer.toJson<String?>(productIds),
      'productQuantitiesJson': serializer.toJson<String?>(
        productQuantitiesJson,
      ),
      'cdt': serializer.toJson<String?>(cdt),
    };
  }

  Dcr copyWith({
    String? status,
    bool? isEnabled,
    Value<String?> serverUdt = const Value.absent(),
    String? localStatus,
    Value<String?> locallyChangedAt = const Value.absent(),
    String? id,
    Value<String?> planId = const Value.absent(),
    Value<String?> userId = const Value.absent(),
    String? visitDatetime,
    Value<String?> remarks = const Value.absent(),
    Value<double?> supportValue = const Value.absent(),
    Value<double?> potential = const Value.absent(),
    Value<double?> expectedSupportValue = const Value.absent(),
    Value<String?> productIds = const Value.absent(),
    Value<String?> productQuantitiesJson = const Value.absent(),
    Value<String?> cdt = const Value.absent(),
  }) => Dcr(
    status: status ?? this.status,
    isEnabled: isEnabled ?? this.isEnabled,
    serverUdt: serverUdt.present ? serverUdt.value : this.serverUdt,
    localStatus: localStatus ?? this.localStatus,
    locallyChangedAt: locallyChangedAt.present
        ? locallyChangedAt.value
        : this.locallyChangedAt,
    id: id ?? this.id,
    planId: planId.present ? planId.value : this.planId,
    userId: userId.present ? userId.value : this.userId,
    visitDatetime: visitDatetime ?? this.visitDatetime,
    remarks: remarks.present ? remarks.value : this.remarks,
    supportValue: supportValue.present ? supportValue.value : this.supportValue,
    potential: potential.present ? potential.value : this.potential,
    expectedSupportValue: expectedSupportValue.present
        ? expectedSupportValue.value
        : this.expectedSupportValue,
    productIds: productIds.present ? productIds.value : this.productIds,
    productQuantitiesJson: productQuantitiesJson.present
        ? productQuantitiesJson.value
        : this.productQuantitiesJson,
    cdt: cdt.present ? cdt.value : this.cdt,
  );
  Dcr copyWithCompanion(DcrsCompanion data) {
    return Dcr(
      status: data.status.present ? data.status.value : this.status,
      isEnabled: data.isEnabled.present ? data.isEnabled.value : this.isEnabled,
      serverUdt: data.serverUdt.present ? data.serverUdt.value : this.serverUdt,
      localStatus: data.localStatus.present
          ? data.localStatus.value
          : this.localStatus,
      locallyChangedAt: data.locallyChangedAt.present
          ? data.locallyChangedAt.value
          : this.locallyChangedAt,
      id: data.id.present ? data.id.value : this.id,
      planId: data.planId.present ? data.planId.value : this.planId,
      userId: data.userId.present ? data.userId.value : this.userId,
      visitDatetime: data.visitDatetime.present
          ? data.visitDatetime.value
          : this.visitDatetime,
      remarks: data.remarks.present ? data.remarks.value : this.remarks,
      supportValue: data.supportValue.present
          ? data.supportValue.value
          : this.supportValue,
      potential: data.potential.present ? data.potential.value : this.potential,
      expectedSupportValue: data.expectedSupportValue.present
          ? data.expectedSupportValue.value
          : this.expectedSupportValue,
      productIds: data.productIds.present
          ? data.productIds.value
          : this.productIds,
      productQuantitiesJson: data.productQuantitiesJson.present
          ? data.productQuantitiesJson.value
          : this.productQuantitiesJson,
      cdt: data.cdt.present ? data.cdt.value : this.cdt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Dcr(')
          ..write('status: $status, ')
          ..write('isEnabled: $isEnabled, ')
          ..write('serverUdt: $serverUdt, ')
          ..write('localStatus: $localStatus, ')
          ..write('locallyChangedAt: $locallyChangedAt, ')
          ..write('id: $id, ')
          ..write('planId: $planId, ')
          ..write('userId: $userId, ')
          ..write('visitDatetime: $visitDatetime, ')
          ..write('remarks: $remarks, ')
          ..write('supportValue: $supportValue, ')
          ..write('potential: $potential, ')
          ..write('expectedSupportValue: $expectedSupportValue, ')
          ..write('productIds: $productIds, ')
          ..write('productQuantitiesJson: $productQuantitiesJson, ')
          ..write('cdt: $cdt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    status,
    isEnabled,
    serverUdt,
    localStatus,
    locallyChangedAt,
    id,
    planId,
    userId,
    visitDatetime,
    remarks,
    supportValue,
    potential,
    expectedSupportValue,
    productIds,
    productQuantitiesJson,
    cdt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Dcr &&
          other.status == this.status &&
          other.isEnabled == this.isEnabled &&
          other.serverUdt == this.serverUdt &&
          other.localStatus == this.localStatus &&
          other.locallyChangedAt == this.locallyChangedAt &&
          other.id == this.id &&
          other.planId == this.planId &&
          other.userId == this.userId &&
          other.visitDatetime == this.visitDatetime &&
          other.remarks == this.remarks &&
          other.supportValue == this.supportValue &&
          other.potential == this.potential &&
          other.expectedSupportValue == this.expectedSupportValue &&
          other.productIds == this.productIds &&
          other.productQuantitiesJson == this.productQuantitiesJson &&
          other.cdt == this.cdt);
}

class DcrsCompanion extends UpdateCompanion<Dcr> {
  final Value<String> status;
  final Value<bool> isEnabled;
  final Value<String?> serverUdt;
  final Value<String> localStatus;
  final Value<String?> locallyChangedAt;
  final Value<String> id;
  final Value<String?> planId;
  final Value<String?> userId;
  final Value<String> visitDatetime;
  final Value<String?> remarks;
  final Value<double?> supportValue;
  final Value<double?> potential;
  final Value<double?> expectedSupportValue;
  final Value<String?> productIds;
  final Value<String?> productQuantitiesJson;
  final Value<String?> cdt;
  final Value<int> rowid;
  const DcrsCompanion({
    this.status = const Value.absent(),
    this.isEnabled = const Value.absent(),
    this.serverUdt = const Value.absent(),
    this.localStatus = const Value.absent(),
    this.locallyChangedAt = const Value.absent(),
    this.id = const Value.absent(),
    this.planId = const Value.absent(),
    this.userId = const Value.absent(),
    this.visitDatetime = const Value.absent(),
    this.remarks = const Value.absent(),
    this.supportValue = const Value.absent(),
    this.potential = const Value.absent(),
    this.expectedSupportValue = const Value.absent(),
    this.productIds = const Value.absent(),
    this.productQuantitiesJson = const Value.absent(),
    this.cdt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DcrsCompanion.insert({
    this.status = const Value.absent(),
    this.isEnabled = const Value.absent(),
    this.serverUdt = const Value.absent(),
    this.localStatus = const Value.absent(),
    this.locallyChangedAt = const Value.absent(),
    required String id,
    this.planId = const Value.absent(),
    this.userId = const Value.absent(),
    required String visitDatetime,
    this.remarks = const Value.absent(),
    this.supportValue = const Value.absent(),
    this.potential = const Value.absent(),
    this.expectedSupportValue = const Value.absent(),
    this.productIds = const Value.absent(),
    this.productQuantitiesJson = const Value.absent(),
    this.cdt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       visitDatetime = Value(visitDatetime);
  static Insertable<Dcr> custom({
    Expression<String>? status,
    Expression<bool>? isEnabled,
    Expression<String>? serverUdt,
    Expression<String>? localStatus,
    Expression<String>? locallyChangedAt,
    Expression<String>? id,
    Expression<String>? planId,
    Expression<String>? userId,
    Expression<String>? visitDatetime,
    Expression<String>? remarks,
    Expression<double>? supportValue,
    Expression<double>? potential,
    Expression<double>? expectedSupportValue,
    Expression<String>? productIds,
    Expression<String>? productQuantitiesJson,
    Expression<String>? cdt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (status != null) 'status': status,
      if (isEnabled != null) 'is_enabled': isEnabled,
      if (serverUdt != null) 'server_udt': serverUdt,
      if (localStatus != null) 'local_status': localStatus,
      if (locallyChangedAt != null) 'locally_changed_at': locallyChangedAt,
      if (id != null) 'id': id,
      if (planId != null) 'plan_id': planId,
      if (userId != null) 'user_id': userId,
      if (visitDatetime != null) 'visit_datetime': visitDatetime,
      if (remarks != null) 'remarks': remarks,
      if (supportValue != null) 'support_value': supportValue,
      if (potential != null) 'potential': potential,
      if (expectedSupportValue != null)
        'expected_support_value': expectedSupportValue,
      if (productIds != null) 'product_ids': productIds,
      if (productQuantitiesJson != null)
        'product_quantities_json': productQuantitiesJson,
      if (cdt != null) 'cdt': cdt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DcrsCompanion copyWith({
    Value<String>? status,
    Value<bool>? isEnabled,
    Value<String?>? serverUdt,
    Value<String>? localStatus,
    Value<String?>? locallyChangedAt,
    Value<String>? id,
    Value<String?>? planId,
    Value<String?>? userId,
    Value<String>? visitDatetime,
    Value<String?>? remarks,
    Value<double?>? supportValue,
    Value<double?>? potential,
    Value<double?>? expectedSupportValue,
    Value<String?>? productIds,
    Value<String?>? productQuantitiesJson,
    Value<String?>? cdt,
    Value<int>? rowid,
  }) {
    return DcrsCompanion(
      status: status ?? this.status,
      isEnabled: isEnabled ?? this.isEnabled,
      serverUdt: serverUdt ?? this.serverUdt,
      localStatus: localStatus ?? this.localStatus,
      locallyChangedAt: locallyChangedAt ?? this.locallyChangedAt,
      id: id ?? this.id,
      planId: planId ?? this.planId,
      userId: userId ?? this.userId,
      visitDatetime: visitDatetime ?? this.visitDatetime,
      remarks: remarks ?? this.remarks,
      supportValue: supportValue ?? this.supportValue,
      potential: potential ?? this.potential,
      expectedSupportValue: expectedSupportValue ?? this.expectedSupportValue,
      productIds: productIds ?? this.productIds,
      productQuantitiesJson:
          productQuantitiesJson ?? this.productQuantitiesJson,
      cdt: cdt ?? this.cdt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (isEnabled.present) {
      map['is_enabled'] = Variable<bool>(isEnabled.value);
    }
    if (serverUdt.present) {
      map['server_udt'] = Variable<String>(serverUdt.value);
    }
    if (localStatus.present) {
      map['local_status'] = Variable<String>(localStatus.value);
    }
    if (locallyChangedAt.present) {
      map['locally_changed_at'] = Variable<String>(locallyChangedAt.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (planId.present) {
      map['plan_id'] = Variable<String>(planId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (visitDatetime.present) {
      map['visit_datetime'] = Variable<String>(visitDatetime.value);
    }
    if (remarks.present) {
      map['remarks'] = Variable<String>(remarks.value);
    }
    if (supportValue.present) {
      map['support_value'] = Variable<double>(supportValue.value);
    }
    if (potential.present) {
      map['potential'] = Variable<double>(potential.value);
    }
    if (expectedSupportValue.present) {
      map['expected_support_value'] = Variable<double>(
        expectedSupportValue.value,
      );
    }
    if (productIds.present) {
      map['product_ids'] = Variable<String>(productIds.value);
    }
    if (productQuantitiesJson.present) {
      map['product_quantities_json'] = Variable<String>(
        productQuantitiesJson.value,
      );
    }
    if (cdt.present) {
      map['cdt'] = Variable<String>(cdt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DcrsCompanion(')
          ..write('status: $status, ')
          ..write('isEnabled: $isEnabled, ')
          ..write('serverUdt: $serverUdt, ')
          ..write('localStatus: $localStatus, ')
          ..write('locallyChangedAt: $locallyChangedAt, ')
          ..write('id: $id, ')
          ..write('planId: $planId, ')
          ..write('userId: $userId, ')
          ..write('visitDatetime: $visitDatetime, ')
          ..write('remarks: $remarks, ')
          ..write('supportValue: $supportValue, ')
          ..write('potential: $potential, ')
          ..write('expectedSupportValue: $expectedSupportValue, ')
          ..write('productIds: $productIds, ')
          ..write('productQuantitiesJson: $productQuantitiesJson, ')
          ..write('cdt: $cdt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DcrProductRowsTable extends DcrProductRows
    with TableInfo<$DcrProductRowsTable, DcrProductRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DcrProductRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('active'),
  );
  static const VerificationMeta _isEnabledMeta = const VerificationMeta(
    'isEnabled',
  );
  @override
  late final GeneratedColumn<bool> isEnabled = GeneratedColumn<bool>(
    'is_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _serverUdtMeta = const VerificationMeta(
    'serverUdt',
  );
  @override
  late final GeneratedColumn<String> serverUdt = GeneratedColumn<String>(
    'server_udt',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _localStatusMeta = const VerificationMeta(
    'localStatus',
  );
  @override
  late final GeneratedColumn<String> localStatus = GeneratedColumn<String>(
    'local_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('synced'),
  );
  static const VerificationMeta _locallyChangedAtMeta = const VerificationMeta(
    'locallyChangedAt',
  );
  @override
  late final GeneratedColumn<String> locallyChangedAt = GeneratedColumn<String>(
    'locally_changed_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dcrIdMeta = const VerificationMeta('dcrId');
  @override
  late final GeneratedColumn<String> dcrId = GeneratedColumn<String>(
    'dcr_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _feedbackMeta = const VerificationMeta(
    'feedback',
  );
  @override
  late final GeneratedColumn<String> feedback = GeneratedColumn<String>(
    'feedback',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    status,
    isEnabled,
    serverUdt,
    localStatus,
    locallyChangedAt,
    id,
    dcrId,
    productId,
    quantity,
    feedback,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'dcr_product_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<DcrProductRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('is_enabled')) {
      context.handle(
        _isEnabledMeta,
        isEnabled.isAcceptableOrUnknown(data['is_enabled']!, _isEnabledMeta),
      );
    }
    if (data.containsKey('server_udt')) {
      context.handle(
        _serverUdtMeta,
        serverUdt.isAcceptableOrUnknown(data['server_udt']!, _serverUdtMeta),
      );
    }
    if (data.containsKey('local_status')) {
      context.handle(
        _localStatusMeta,
        localStatus.isAcceptableOrUnknown(
          data['local_status']!,
          _localStatusMeta,
        ),
      );
    }
    if (data.containsKey('locally_changed_at')) {
      context.handle(
        _locallyChangedAtMeta,
        locallyChangedAt.isAcceptableOrUnknown(
          data['locally_changed_at']!,
          _locallyChangedAtMeta,
        ),
      );
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('dcr_id')) {
      context.handle(
        _dcrIdMeta,
        dcrId.isAcceptableOrUnknown(data['dcr_id']!, _dcrIdMeta),
      );
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    }
    if (data.containsKey('feedback')) {
      context.handle(
        _feedbackMeta,
        feedback.isAcceptableOrUnknown(data['feedback']!, _feedbackMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DcrProductRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DcrProductRow(
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      isEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_enabled'],
      )!,
      serverUdt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_udt'],
      ),
      localStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_status'],
      )!,
      locallyChangedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}locally_changed_at'],
      ),
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      dcrId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dcr_id'],
      ),
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      ),
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
      feedback: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}feedback'],
      ),
    );
  }

  @override
  $DcrProductRowsTable createAlias(String alias) {
    return $DcrProductRowsTable(attachedDatabase, alias);
  }
}

class DcrProductRow extends DataClass implements Insertable<DcrProductRow> {
  final String status;
  final bool isEnabled;
  final String? serverUdt;
  final String localStatus;
  final String? locallyChangedAt;
  final String id;
  final String? dcrId;
  final String? productId;
  final int quantity;
  final String? feedback;
  const DcrProductRow({
    required this.status,
    required this.isEnabled,
    this.serverUdt,
    required this.localStatus,
    this.locallyChangedAt,
    required this.id,
    this.dcrId,
    this.productId,
    required this.quantity,
    this.feedback,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['status'] = Variable<String>(status);
    map['is_enabled'] = Variable<bool>(isEnabled);
    if (!nullToAbsent || serverUdt != null) {
      map['server_udt'] = Variable<String>(serverUdt);
    }
    map['local_status'] = Variable<String>(localStatus);
    if (!nullToAbsent || locallyChangedAt != null) {
      map['locally_changed_at'] = Variable<String>(locallyChangedAt);
    }
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || dcrId != null) {
      map['dcr_id'] = Variable<String>(dcrId);
    }
    if (!nullToAbsent || productId != null) {
      map['product_id'] = Variable<String>(productId);
    }
    map['quantity'] = Variable<int>(quantity);
    if (!nullToAbsent || feedback != null) {
      map['feedback'] = Variable<String>(feedback);
    }
    return map;
  }

  DcrProductRowsCompanion toCompanion(bool nullToAbsent) {
    return DcrProductRowsCompanion(
      status: Value(status),
      isEnabled: Value(isEnabled),
      serverUdt: serverUdt == null && nullToAbsent
          ? const Value.absent()
          : Value(serverUdt),
      localStatus: Value(localStatus),
      locallyChangedAt: locallyChangedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(locallyChangedAt),
      id: Value(id),
      dcrId: dcrId == null && nullToAbsent
          ? const Value.absent()
          : Value(dcrId),
      productId: productId == null && nullToAbsent
          ? const Value.absent()
          : Value(productId),
      quantity: Value(quantity),
      feedback: feedback == null && nullToAbsent
          ? const Value.absent()
          : Value(feedback),
    );
  }

  factory DcrProductRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DcrProductRow(
      status: serializer.fromJson<String>(json['status']),
      isEnabled: serializer.fromJson<bool>(json['isEnabled']),
      serverUdt: serializer.fromJson<String?>(json['serverUdt']),
      localStatus: serializer.fromJson<String>(json['localStatus']),
      locallyChangedAt: serializer.fromJson<String?>(json['locallyChangedAt']),
      id: serializer.fromJson<String>(json['id']),
      dcrId: serializer.fromJson<String?>(json['dcrId']),
      productId: serializer.fromJson<String?>(json['productId']),
      quantity: serializer.fromJson<int>(json['quantity']),
      feedback: serializer.fromJson<String?>(json['feedback']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'status': serializer.toJson<String>(status),
      'isEnabled': serializer.toJson<bool>(isEnabled),
      'serverUdt': serializer.toJson<String?>(serverUdt),
      'localStatus': serializer.toJson<String>(localStatus),
      'locallyChangedAt': serializer.toJson<String?>(locallyChangedAt),
      'id': serializer.toJson<String>(id),
      'dcrId': serializer.toJson<String?>(dcrId),
      'productId': serializer.toJson<String?>(productId),
      'quantity': serializer.toJson<int>(quantity),
      'feedback': serializer.toJson<String?>(feedback),
    };
  }

  DcrProductRow copyWith({
    String? status,
    bool? isEnabled,
    Value<String?> serverUdt = const Value.absent(),
    String? localStatus,
    Value<String?> locallyChangedAt = const Value.absent(),
    String? id,
    Value<String?> dcrId = const Value.absent(),
    Value<String?> productId = const Value.absent(),
    int? quantity,
    Value<String?> feedback = const Value.absent(),
  }) => DcrProductRow(
    status: status ?? this.status,
    isEnabled: isEnabled ?? this.isEnabled,
    serverUdt: serverUdt.present ? serverUdt.value : this.serverUdt,
    localStatus: localStatus ?? this.localStatus,
    locallyChangedAt: locallyChangedAt.present
        ? locallyChangedAt.value
        : this.locallyChangedAt,
    id: id ?? this.id,
    dcrId: dcrId.present ? dcrId.value : this.dcrId,
    productId: productId.present ? productId.value : this.productId,
    quantity: quantity ?? this.quantity,
    feedback: feedback.present ? feedback.value : this.feedback,
  );
  DcrProductRow copyWithCompanion(DcrProductRowsCompanion data) {
    return DcrProductRow(
      status: data.status.present ? data.status.value : this.status,
      isEnabled: data.isEnabled.present ? data.isEnabled.value : this.isEnabled,
      serverUdt: data.serverUdt.present ? data.serverUdt.value : this.serverUdt,
      localStatus: data.localStatus.present
          ? data.localStatus.value
          : this.localStatus,
      locallyChangedAt: data.locallyChangedAt.present
          ? data.locallyChangedAt.value
          : this.locallyChangedAt,
      id: data.id.present ? data.id.value : this.id,
      dcrId: data.dcrId.present ? data.dcrId.value : this.dcrId,
      productId: data.productId.present ? data.productId.value : this.productId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      feedback: data.feedback.present ? data.feedback.value : this.feedback,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DcrProductRow(')
          ..write('status: $status, ')
          ..write('isEnabled: $isEnabled, ')
          ..write('serverUdt: $serverUdt, ')
          ..write('localStatus: $localStatus, ')
          ..write('locallyChangedAt: $locallyChangedAt, ')
          ..write('id: $id, ')
          ..write('dcrId: $dcrId, ')
          ..write('productId: $productId, ')
          ..write('quantity: $quantity, ')
          ..write('feedback: $feedback')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    status,
    isEnabled,
    serverUdt,
    localStatus,
    locallyChangedAt,
    id,
    dcrId,
    productId,
    quantity,
    feedback,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DcrProductRow &&
          other.status == this.status &&
          other.isEnabled == this.isEnabled &&
          other.serverUdt == this.serverUdt &&
          other.localStatus == this.localStatus &&
          other.locallyChangedAt == this.locallyChangedAt &&
          other.id == this.id &&
          other.dcrId == this.dcrId &&
          other.productId == this.productId &&
          other.quantity == this.quantity &&
          other.feedback == this.feedback);
}

class DcrProductRowsCompanion extends UpdateCompanion<DcrProductRow> {
  final Value<String> status;
  final Value<bool> isEnabled;
  final Value<String?> serverUdt;
  final Value<String> localStatus;
  final Value<String?> locallyChangedAt;
  final Value<String> id;
  final Value<String?> dcrId;
  final Value<String?> productId;
  final Value<int> quantity;
  final Value<String?> feedback;
  final Value<int> rowid;
  const DcrProductRowsCompanion({
    this.status = const Value.absent(),
    this.isEnabled = const Value.absent(),
    this.serverUdt = const Value.absent(),
    this.localStatus = const Value.absent(),
    this.locallyChangedAt = const Value.absent(),
    this.id = const Value.absent(),
    this.dcrId = const Value.absent(),
    this.productId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.feedback = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DcrProductRowsCompanion.insert({
    this.status = const Value.absent(),
    this.isEnabled = const Value.absent(),
    this.serverUdt = const Value.absent(),
    this.localStatus = const Value.absent(),
    this.locallyChangedAt = const Value.absent(),
    required String id,
    this.dcrId = const Value.absent(),
    this.productId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.feedback = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<DcrProductRow> custom({
    Expression<String>? status,
    Expression<bool>? isEnabled,
    Expression<String>? serverUdt,
    Expression<String>? localStatus,
    Expression<String>? locallyChangedAt,
    Expression<String>? id,
    Expression<String>? dcrId,
    Expression<String>? productId,
    Expression<int>? quantity,
    Expression<String>? feedback,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (status != null) 'status': status,
      if (isEnabled != null) 'is_enabled': isEnabled,
      if (serverUdt != null) 'server_udt': serverUdt,
      if (localStatus != null) 'local_status': localStatus,
      if (locallyChangedAt != null) 'locally_changed_at': locallyChangedAt,
      if (id != null) 'id': id,
      if (dcrId != null) 'dcr_id': dcrId,
      if (productId != null) 'product_id': productId,
      if (quantity != null) 'quantity': quantity,
      if (feedback != null) 'feedback': feedback,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DcrProductRowsCompanion copyWith({
    Value<String>? status,
    Value<bool>? isEnabled,
    Value<String?>? serverUdt,
    Value<String>? localStatus,
    Value<String?>? locallyChangedAt,
    Value<String>? id,
    Value<String?>? dcrId,
    Value<String?>? productId,
    Value<int>? quantity,
    Value<String?>? feedback,
    Value<int>? rowid,
  }) {
    return DcrProductRowsCompanion(
      status: status ?? this.status,
      isEnabled: isEnabled ?? this.isEnabled,
      serverUdt: serverUdt ?? this.serverUdt,
      localStatus: localStatus ?? this.localStatus,
      locallyChangedAt: locallyChangedAt ?? this.locallyChangedAt,
      id: id ?? this.id,
      dcrId: dcrId ?? this.dcrId,
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      feedback: feedback ?? this.feedback,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (isEnabled.present) {
      map['is_enabled'] = Variable<bool>(isEnabled.value);
    }
    if (serverUdt.present) {
      map['server_udt'] = Variable<String>(serverUdt.value);
    }
    if (localStatus.present) {
      map['local_status'] = Variable<String>(localStatus.value);
    }
    if (locallyChangedAt.present) {
      map['locally_changed_at'] = Variable<String>(locallyChangedAt.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (dcrId.present) {
      map['dcr_id'] = Variable<String>(dcrId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (feedback.present) {
      map['feedback'] = Variable<String>(feedback.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DcrProductRowsCompanion(')
          ..write('status: $status, ')
          ..write('isEnabled: $isEnabled, ')
          ..write('serverUdt: $serverUdt, ')
          ..write('localStatus: $localStatus, ')
          ..write('locallyChangedAt: $locallyChangedAt, ')
          ..write('id: $id, ')
          ..write('dcrId: $dcrId, ')
          ..write('productId: $productId, ')
          ..write('quantity: $quantity, ')
          ..write('feedback: $feedback, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UsersLiteTable extends UsersLite
    with TableInfo<$UsersLiteTable, UsersLiteData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersLiteTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _employeeCodeMeta = const VerificationMeta(
    'employeeCode',
  );
  @override
  late final GeneratedColumn<String> employeeCode = GeneratedColumn<String>(
    'employee_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fullNameMeta = const VerificationMeta(
    'fullName',
  );
  @override
  late final GeneratedColumn<String> fullName = GeneratedColumn<String>(
    'full_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _roleIdMeta = const VerificationMeta('roleId');
  @override
  late final GeneratedColumn<String> roleId = GeneratedColumn<String>(
    'role_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _serverUdtMeta = const VerificationMeta(
    'serverUdt',
  );
  @override
  late final GeneratedColumn<String> serverUdt = GeneratedColumn<String>(
    'server_udt',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    employeeCode,
    fullName,
    email,
    phone,
    roleId,
    serverUdt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users_lite';
  @override
  VerificationContext validateIntegrity(
    Insertable<UsersLiteData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('employee_code')) {
      context.handle(
        _employeeCodeMeta,
        employeeCode.isAcceptableOrUnknown(
          data['employee_code']!,
          _employeeCodeMeta,
        ),
      );
    }
    if (data.containsKey('full_name')) {
      context.handle(
        _fullNameMeta,
        fullName.isAcceptableOrUnknown(data['full_name']!, _fullNameMeta),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('role_id')) {
      context.handle(
        _roleIdMeta,
        roleId.isAcceptableOrUnknown(data['role_id']!, _roleIdMeta),
      );
    }
    if (data.containsKey('server_udt')) {
      context.handle(
        _serverUdtMeta,
        serverUdt.isAcceptableOrUnknown(data['server_udt']!, _serverUdtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UsersLiteData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UsersLiteData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      employeeCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}employee_code'],
      ),
      fullName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}full_name'],
      ),
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      roleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role_id'],
      ),
      serverUdt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_udt'],
      ),
    );
  }

  @override
  $UsersLiteTable createAlias(String alias) {
    return $UsersLiteTable(attachedDatabase, alias);
  }
}

class UsersLiteData extends DataClass implements Insertable<UsersLiteData> {
  final String id;
  final String? employeeCode;
  final String? fullName;
  final String? email;
  final String? phone;
  final String? roleId;
  final String? serverUdt;
  const UsersLiteData({
    required this.id,
    this.employeeCode,
    this.fullName,
    this.email,
    this.phone,
    this.roleId,
    this.serverUdt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || employeeCode != null) {
      map['employee_code'] = Variable<String>(employeeCode);
    }
    if (!nullToAbsent || fullName != null) {
      map['full_name'] = Variable<String>(fullName);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || roleId != null) {
      map['role_id'] = Variable<String>(roleId);
    }
    if (!nullToAbsent || serverUdt != null) {
      map['server_udt'] = Variable<String>(serverUdt);
    }
    return map;
  }

  UsersLiteCompanion toCompanion(bool nullToAbsent) {
    return UsersLiteCompanion(
      id: Value(id),
      employeeCode: employeeCode == null && nullToAbsent
          ? const Value.absent()
          : Value(employeeCode),
      fullName: fullName == null && nullToAbsent
          ? const Value.absent()
          : Value(fullName),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      roleId: roleId == null && nullToAbsent
          ? const Value.absent()
          : Value(roleId),
      serverUdt: serverUdt == null && nullToAbsent
          ? const Value.absent()
          : Value(serverUdt),
    );
  }

  factory UsersLiteData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UsersLiteData(
      id: serializer.fromJson<String>(json['id']),
      employeeCode: serializer.fromJson<String?>(json['employeeCode']),
      fullName: serializer.fromJson<String?>(json['fullName']),
      email: serializer.fromJson<String?>(json['email']),
      phone: serializer.fromJson<String?>(json['phone']),
      roleId: serializer.fromJson<String?>(json['roleId']),
      serverUdt: serializer.fromJson<String?>(json['serverUdt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'employeeCode': serializer.toJson<String?>(employeeCode),
      'fullName': serializer.toJson<String?>(fullName),
      'email': serializer.toJson<String?>(email),
      'phone': serializer.toJson<String?>(phone),
      'roleId': serializer.toJson<String?>(roleId),
      'serverUdt': serializer.toJson<String?>(serverUdt),
    };
  }

  UsersLiteData copyWith({
    String? id,
    Value<String?> employeeCode = const Value.absent(),
    Value<String?> fullName = const Value.absent(),
    Value<String?> email = const Value.absent(),
    Value<String?> phone = const Value.absent(),
    Value<String?> roleId = const Value.absent(),
    Value<String?> serverUdt = const Value.absent(),
  }) => UsersLiteData(
    id: id ?? this.id,
    employeeCode: employeeCode.present ? employeeCode.value : this.employeeCode,
    fullName: fullName.present ? fullName.value : this.fullName,
    email: email.present ? email.value : this.email,
    phone: phone.present ? phone.value : this.phone,
    roleId: roleId.present ? roleId.value : this.roleId,
    serverUdt: serverUdt.present ? serverUdt.value : this.serverUdt,
  );
  UsersLiteData copyWithCompanion(UsersLiteCompanion data) {
    return UsersLiteData(
      id: data.id.present ? data.id.value : this.id,
      employeeCode: data.employeeCode.present
          ? data.employeeCode.value
          : this.employeeCode,
      fullName: data.fullName.present ? data.fullName.value : this.fullName,
      email: data.email.present ? data.email.value : this.email,
      phone: data.phone.present ? data.phone.value : this.phone,
      roleId: data.roleId.present ? data.roleId.value : this.roleId,
      serverUdt: data.serverUdt.present ? data.serverUdt.value : this.serverUdt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UsersLiteData(')
          ..write('id: $id, ')
          ..write('employeeCode: $employeeCode, ')
          ..write('fullName: $fullName, ')
          ..write('email: $email, ')
          ..write('phone: $phone, ')
          ..write('roleId: $roleId, ')
          ..write('serverUdt: $serverUdt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, employeeCode, fullName, email, phone, roleId, serverUdt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UsersLiteData &&
          other.id == this.id &&
          other.employeeCode == this.employeeCode &&
          other.fullName == this.fullName &&
          other.email == this.email &&
          other.phone == this.phone &&
          other.roleId == this.roleId &&
          other.serverUdt == this.serverUdt);
}

class UsersLiteCompanion extends UpdateCompanion<UsersLiteData> {
  final Value<String> id;
  final Value<String?> employeeCode;
  final Value<String?> fullName;
  final Value<String?> email;
  final Value<String?> phone;
  final Value<String?> roleId;
  final Value<String?> serverUdt;
  final Value<int> rowid;
  const UsersLiteCompanion({
    this.id = const Value.absent(),
    this.employeeCode = const Value.absent(),
    this.fullName = const Value.absent(),
    this.email = const Value.absent(),
    this.phone = const Value.absent(),
    this.roleId = const Value.absent(),
    this.serverUdt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsersLiteCompanion.insert({
    required String id,
    this.employeeCode = const Value.absent(),
    this.fullName = const Value.absent(),
    this.email = const Value.absent(),
    this.phone = const Value.absent(),
    this.roleId = const Value.absent(),
    this.serverUdt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<UsersLiteData> custom({
    Expression<String>? id,
    Expression<String>? employeeCode,
    Expression<String>? fullName,
    Expression<String>? email,
    Expression<String>? phone,
    Expression<String>? roleId,
    Expression<String>? serverUdt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (employeeCode != null) 'employee_code': employeeCode,
      if (fullName != null) 'full_name': fullName,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (roleId != null) 'role_id': roleId,
      if (serverUdt != null) 'server_udt': serverUdt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsersLiteCompanion copyWith({
    Value<String>? id,
    Value<String?>? employeeCode,
    Value<String?>? fullName,
    Value<String?>? email,
    Value<String?>? phone,
    Value<String?>? roleId,
    Value<String?>? serverUdt,
    Value<int>? rowid,
  }) {
    return UsersLiteCompanion(
      id: id ?? this.id,
      employeeCode: employeeCode ?? this.employeeCode,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      roleId: roleId ?? this.roleId,
      serverUdt: serverUdt ?? this.serverUdt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (employeeCode.present) {
      map['employee_code'] = Variable<String>(employeeCode.value);
    }
    if (fullName.present) {
      map['full_name'] = Variable<String>(fullName.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (roleId.present) {
      map['role_id'] = Variable<String>(roleId.value);
    }
    if (serverUdt.present) {
      map['server_udt'] = Variable<String>(serverUdt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersLiteCompanion(')
          ..write('id: $id, ')
          ..write('employeeCode: $employeeCode, ')
          ..write('fullName: $fullName, ')
          ..write('email: $email, ')
          ..write('phone: $phone, ')
          ..write('roleId: $roleId, ')
          ..write('serverUdt: $serverUdt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MetadataItemsTable extends MetadataItems
    with TableInfo<$MetadataItemsTable, MetadataItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MetadataItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isEnabledMeta = const VerificationMeta(
    'isEnabled',
  );
  @override
  late final GeneratedColumn<bool> isEnabled = GeneratedColumn<bool>(
    'is_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _serverUdtMeta = const VerificationMeta(
    'serverUdt',
  );
  @override
  late final GeneratedColumn<String> serverUdt = GeneratedColumn<String>(
    'server_udt',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [kind, id, name, isEnabled, serverUdt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'metadata_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<MetadataItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('is_enabled')) {
      context.handle(
        _isEnabledMeta,
        isEnabled.isAcceptableOrUnknown(data['is_enabled']!, _isEnabledMeta),
      );
    }
    if (data.containsKey('server_udt')) {
      context.handle(
        _serverUdtMeta,
        serverUdt.isAcceptableOrUnknown(data['server_udt']!, _serverUdtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {kind, id};
  @override
  MetadataItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MetadataItem(
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      ),
      isEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_enabled'],
      )!,
      serverUdt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_udt'],
      ),
    );
  }

  @override
  $MetadataItemsTable createAlias(String alias) {
    return $MetadataItemsTable(attachedDatabase, alias);
  }
}

class MetadataItem extends DataClass implements Insertable<MetadataItem> {
  final String kind;
  final String id;
  final String? name;
  final bool isEnabled;
  final String? serverUdt;
  const MetadataItem({
    required this.kind,
    required this.id,
    this.name,
    required this.isEnabled,
    this.serverUdt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['kind'] = Variable<String>(kind);
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    map['is_enabled'] = Variable<bool>(isEnabled);
    if (!nullToAbsent || serverUdt != null) {
      map['server_udt'] = Variable<String>(serverUdt);
    }
    return map;
  }

  MetadataItemsCompanion toCompanion(bool nullToAbsent) {
    return MetadataItemsCompanion(
      kind: Value(kind),
      id: Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      isEnabled: Value(isEnabled),
      serverUdt: serverUdt == null && nullToAbsent
          ? const Value.absent()
          : Value(serverUdt),
    );
  }

  factory MetadataItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MetadataItem(
      kind: serializer.fromJson<String>(json['kind']),
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String?>(json['name']),
      isEnabled: serializer.fromJson<bool>(json['isEnabled']),
      serverUdt: serializer.fromJson<String?>(json['serverUdt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'kind': serializer.toJson<String>(kind),
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String?>(name),
      'isEnabled': serializer.toJson<bool>(isEnabled),
      'serverUdt': serializer.toJson<String?>(serverUdt),
    };
  }

  MetadataItem copyWith({
    String? kind,
    String? id,
    Value<String?> name = const Value.absent(),
    bool? isEnabled,
    Value<String?> serverUdt = const Value.absent(),
  }) => MetadataItem(
    kind: kind ?? this.kind,
    id: id ?? this.id,
    name: name.present ? name.value : this.name,
    isEnabled: isEnabled ?? this.isEnabled,
    serverUdt: serverUdt.present ? serverUdt.value : this.serverUdt,
  );
  MetadataItem copyWithCompanion(MetadataItemsCompanion data) {
    return MetadataItem(
      kind: data.kind.present ? data.kind.value : this.kind,
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      isEnabled: data.isEnabled.present ? data.isEnabled.value : this.isEnabled,
      serverUdt: data.serverUdt.present ? data.serverUdt.value : this.serverUdt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MetadataItem(')
          ..write('kind: $kind, ')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isEnabled: $isEnabled, ')
          ..write('serverUdt: $serverUdt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(kind, id, name, isEnabled, serverUdt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MetadataItem &&
          other.kind == this.kind &&
          other.id == this.id &&
          other.name == this.name &&
          other.isEnabled == this.isEnabled &&
          other.serverUdt == this.serverUdt);
}

class MetadataItemsCompanion extends UpdateCompanion<MetadataItem> {
  final Value<String> kind;
  final Value<String> id;
  final Value<String?> name;
  final Value<bool> isEnabled;
  final Value<String?> serverUdt;
  final Value<int> rowid;
  const MetadataItemsCompanion({
    this.kind = const Value.absent(),
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.isEnabled = const Value.absent(),
    this.serverUdt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MetadataItemsCompanion.insert({
    required String kind,
    required String id,
    this.name = const Value.absent(),
    this.isEnabled = const Value.absent(),
    this.serverUdt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : kind = Value(kind),
       id = Value(id);
  static Insertable<MetadataItem> custom({
    Expression<String>? kind,
    Expression<String>? id,
    Expression<String>? name,
    Expression<bool>? isEnabled,
    Expression<String>? serverUdt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (kind != null) 'kind': kind,
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (isEnabled != null) 'is_enabled': isEnabled,
      if (serverUdt != null) 'server_udt': serverUdt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MetadataItemsCompanion copyWith({
    Value<String>? kind,
    Value<String>? id,
    Value<String?>? name,
    Value<bool>? isEnabled,
    Value<String?>? serverUdt,
    Value<int>? rowid,
  }) {
    return MetadataItemsCompanion(
      kind: kind ?? this.kind,
      id: id ?? this.id,
      name: name ?? this.name,
      isEnabled: isEnabled ?? this.isEnabled,
      serverUdt: serverUdt ?? this.serverUdt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (isEnabled.present) {
      map['is_enabled'] = Variable<bool>(isEnabled.value);
    }
    if (serverUdt.present) {
      map['server_udt'] = Variable<String>(serverUdt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MetadataItemsCompanion(')
          ..write('kind: $kind, ')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isEnabled: $isEnabled, ')
          ..write('serverUdt: $serverUdt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OutboxOpsTable extends OutboxOps
    with TableInfo<$OutboxOpsTable, OutboxOp> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OutboxOpsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _seqMeta = const VerificationMeta('seq');
  @override
  late final GeneratedColumn<int> seq = GeneratedColumn<int>(
    'seq',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _mutationIdMeta = const VerificationMeta(
    'mutationId',
  );
  @override
  late final GeneratedColumn<String> mutationId = GeneratedColumn<String>(
    'mutation_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _entityMeta = const VerificationMeta('entity');
  @override
  late final GeneratedColumn<String> entity = GeneratedColumn<String>(
    'entity',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _opMeta = const VerificationMeta('op');
  @override
  late final GeneratedColumn<String> op = GeneratedColumn<String>(
    'op',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _baseServerUdtMeta = const VerificationMeta(
    'baseServerUdt',
  );
  @override
  late final GeneratedColumn<String> baseServerUdt = GeneratedColumn<String>(
    'base_server_udt',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _clientChangedAtMeta = const VerificationMeta(
    'clientChangedAt',
  );
  @override
  late final GeneratedColumn<String> clientChangedAt = GeneratedColumn<String>(
    'client_changed_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _attemptsMeta = const VerificationMeta(
    'attempts',
  );
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
    'attempts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
    'state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    seq,
    mutationId,
    entity,
    entityId,
    op,
    payloadJson,
    baseServerUdt,
    clientChangedAt,
    attempts,
    lastError,
    state,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'outbox_ops';
  @override
  VerificationContext validateIntegrity(
    Insertable<OutboxOp> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('seq')) {
      context.handle(
        _seqMeta,
        seq.isAcceptableOrUnknown(data['seq']!, _seqMeta),
      );
    }
    if (data.containsKey('mutation_id')) {
      context.handle(
        _mutationIdMeta,
        mutationId.isAcceptableOrUnknown(data['mutation_id']!, _mutationIdMeta),
      );
    } else if (isInserting) {
      context.missing(_mutationIdMeta);
    }
    if (data.containsKey('entity')) {
      context.handle(
        _entityMeta,
        entity.isAcceptableOrUnknown(data['entity']!, _entityMeta),
      );
    } else if (isInserting) {
      context.missing(_entityMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('op')) {
      context.handle(_opMeta, op.isAcceptableOrUnknown(data['op']!, _opMeta));
    } else if (isInserting) {
      context.missing(_opMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    if (data.containsKey('base_server_udt')) {
      context.handle(
        _baseServerUdtMeta,
        baseServerUdt.isAcceptableOrUnknown(
          data['base_server_udt']!,
          _baseServerUdtMeta,
        ),
      );
    }
    if (data.containsKey('client_changed_at')) {
      context.handle(
        _clientChangedAtMeta,
        clientChangedAt.isAcceptableOrUnknown(
          data['client_changed_at']!,
          _clientChangedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_clientChangedAtMeta);
    }
    if (data.containsKey('attempts')) {
      context.handle(
        _attemptsMeta,
        attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta),
      );
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    if (data.containsKey('state')) {
      context.handle(
        _stateMeta,
        state.isAcceptableOrUnknown(data['state']!, _stateMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {seq};
  @override
  OutboxOp map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OutboxOp(
      seq: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}seq'],
      )!,
      mutationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mutation_id'],
      )!,
      entity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      op: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}op'],
      )!,
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      )!,
      baseServerUdt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}base_server_udt'],
      ),
      clientChangedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_changed_at'],
      )!,
      attempts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempts'],
      )!,
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state'],
      )!,
    );
  }

  @override
  $OutboxOpsTable createAlias(String alias) {
    return $OutboxOpsTable(attachedDatabase, alias);
  }
}

class OutboxOp extends DataClass implements Insertable<OutboxOp> {
  final int seq;
  final String mutationId;
  final String entity;
  final String entityId;
  final String op;
  final String payloadJson;
  final String? baseServerUdt;
  final String clientChangedAt;
  final int attempts;
  final String? lastError;
  final String state;
  const OutboxOp({
    required this.seq,
    required this.mutationId,
    required this.entity,
    required this.entityId,
    required this.op,
    required this.payloadJson,
    this.baseServerUdt,
    required this.clientChangedAt,
    required this.attempts,
    this.lastError,
    required this.state,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['seq'] = Variable<int>(seq);
    map['mutation_id'] = Variable<String>(mutationId);
    map['entity'] = Variable<String>(entity);
    map['entity_id'] = Variable<String>(entityId);
    map['op'] = Variable<String>(op);
    map['payload_json'] = Variable<String>(payloadJson);
    if (!nullToAbsent || baseServerUdt != null) {
      map['base_server_udt'] = Variable<String>(baseServerUdt);
    }
    map['client_changed_at'] = Variable<String>(clientChangedAt);
    map['attempts'] = Variable<int>(attempts);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    map['state'] = Variable<String>(state);
    return map;
  }

  OutboxOpsCompanion toCompanion(bool nullToAbsent) {
    return OutboxOpsCompanion(
      seq: Value(seq),
      mutationId: Value(mutationId),
      entity: Value(entity),
      entityId: Value(entityId),
      op: Value(op),
      payloadJson: Value(payloadJson),
      baseServerUdt: baseServerUdt == null && nullToAbsent
          ? const Value.absent()
          : Value(baseServerUdt),
      clientChangedAt: Value(clientChangedAt),
      attempts: Value(attempts),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
      state: Value(state),
    );
  }

  factory OutboxOp.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OutboxOp(
      seq: serializer.fromJson<int>(json['seq']),
      mutationId: serializer.fromJson<String>(json['mutationId']),
      entity: serializer.fromJson<String>(json['entity']),
      entityId: serializer.fromJson<String>(json['entityId']),
      op: serializer.fromJson<String>(json['op']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
      baseServerUdt: serializer.fromJson<String?>(json['baseServerUdt']),
      clientChangedAt: serializer.fromJson<String>(json['clientChangedAt']),
      attempts: serializer.fromJson<int>(json['attempts']),
      lastError: serializer.fromJson<String?>(json['lastError']),
      state: serializer.fromJson<String>(json['state']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'seq': serializer.toJson<int>(seq),
      'mutationId': serializer.toJson<String>(mutationId),
      'entity': serializer.toJson<String>(entity),
      'entityId': serializer.toJson<String>(entityId),
      'op': serializer.toJson<String>(op),
      'payloadJson': serializer.toJson<String>(payloadJson),
      'baseServerUdt': serializer.toJson<String?>(baseServerUdt),
      'clientChangedAt': serializer.toJson<String>(clientChangedAt),
      'attempts': serializer.toJson<int>(attempts),
      'lastError': serializer.toJson<String?>(lastError),
      'state': serializer.toJson<String>(state),
    };
  }

  OutboxOp copyWith({
    int? seq,
    String? mutationId,
    String? entity,
    String? entityId,
    String? op,
    String? payloadJson,
    Value<String?> baseServerUdt = const Value.absent(),
    String? clientChangedAt,
    int? attempts,
    Value<String?> lastError = const Value.absent(),
    String? state,
  }) => OutboxOp(
    seq: seq ?? this.seq,
    mutationId: mutationId ?? this.mutationId,
    entity: entity ?? this.entity,
    entityId: entityId ?? this.entityId,
    op: op ?? this.op,
    payloadJson: payloadJson ?? this.payloadJson,
    baseServerUdt: baseServerUdt.present
        ? baseServerUdt.value
        : this.baseServerUdt,
    clientChangedAt: clientChangedAt ?? this.clientChangedAt,
    attempts: attempts ?? this.attempts,
    lastError: lastError.present ? lastError.value : this.lastError,
    state: state ?? this.state,
  );
  OutboxOp copyWithCompanion(OutboxOpsCompanion data) {
    return OutboxOp(
      seq: data.seq.present ? data.seq.value : this.seq,
      mutationId: data.mutationId.present
          ? data.mutationId.value
          : this.mutationId,
      entity: data.entity.present ? data.entity.value : this.entity,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      op: data.op.present ? data.op.value : this.op,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
      baseServerUdt: data.baseServerUdt.present
          ? data.baseServerUdt.value
          : this.baseServerUdt,
      clientChangedAt: data.clientChangedAt.present
          ? data.clientChangedAt.value
          : this.clientChangedAt,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
      state: data.state.present ? data.state.value : this.state,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OutboxOp(')
          ..write('seq: $seq, ')
          ..write('mutationId: $mutationId, ')
          ..write('entity: $entity, ')
          ..write('entityId: $entityId, ')
          ..write('op: $op, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('baseServerUdt: $baseServerUdt, ')
          ..write('clientChangedAt: $clientChangedAt, ')
          ..write('attempts: $attempts, ')
          ..write('lastError: $lastError, ')
          ..write('state: $state')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    seq,
    mutationId,
    entity,
    entityId,
    op,
    payloadJson,
    baseServerUdt,
    clientChangedAt,
    attempts,
    lastError,
    state,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OutboxOp &&
          other.seq == this.seq &&
          other.mutationId == this.mutationId &&
          other.entity == this.entity &&
          other.entityId == this.entityId &&
          other.op == this.op &&
          other.payloadJson == this.payloadJson &&
          other.baseServerUdt == this.baseServerUdt &&
          other.clientChangedAt == this.clientChangedAt &&
          other.attempts == this.attempts &&
          other.lastError == this.lastError &&
          other.state == this.state);
}

class OutboxOpsCompanion extends UpdateCompanion<OutboxOp> {
  final Value<int> seq;
  final Value<String> mutationId;
  final Value<String> entity;
  final Value<String> entityId;
  final Value<String> op;
  final Value<String> payloadJson;
  final Value<String?> baseServerUdt;
  final Value<String> clientChangedAt;
  final Value<int> attempts;
  final Value<String?> lastError;
  final Value<String> state;
  const OutboxOpsCompanion({
    this.seq = const Value.absent(),
    this.mutationId = const Value.absent(),
    this.entity = const Value.absent(),
    this.entityId = const Value.absent(),
    this.op = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.baseServerUdt = const Value.absent(),
    this.clientChangedAt = const Value.absent(),
    this.attempts = const Value.absent(),
    this.lastError = const Value.absent(),
    this.state = const Value.absent(),
  });
  OutboxOpsCompanion.insert({
    this.seq = const Value.absent(),
    required String mutationId,
    required String entity,
    required String entityId,
    required String op,
    required String payloadJson,
    this.baseServerUdt = const Value.absent(),
    required String clientChangedAt,
    this.attempts = const Value.absent(),
    this.lastError = const Value.absent(),
    this.state = const Value.absent(),
  }) : mutationId = Value(mutationId),
       entity = Value(entity),
       entityId = Value(entityId),
       op = Value(op),
       payloadJson = Value(payloadJson),
       clientChangedAt = Value(clientChangedAt);
  static Insertable<OutboxOp> custom({
    Expression<int>? seq,
    Expression<String>? mutationId,
    Expression<String>? entity,
    Expression<String>? entityId,
    Expression<String>? op,
    Expression<String>? payloadJson,
    Expression<String>? baseServerUdt,
    Expression<String>? clientChangedAt,
    Expression<int>? attempts,
    Expression<String>? lastError,
    Expression<String>? state,
  }) {
    return RawValuesInsertable({
      if (seq != null) 'seq': seq,
      if (mutationId != null) 'mutation_id': mutationId,
      if (entity != null) 'entity': entity,
      if (entityId != null) 'entity_id': entityId,
      if (op != null) 'op': op,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (baseServerUdt != null) 'base_server_udt': baseServerUdt,
      if (clientChangedAt != null) 'client_changed_at': clientChangedAt,
      if (attempts != null) 'attempts': attempts,
      if (lastError != null) 'last_error': lastError,
      if (state != null) 'state': state,
    });
  }

  OutboxOpsCompanion copyWith({
    Value<int>? seq,
    Value<String>? mutationId,
    Value<String>? entity,
    Value<String>? entityId,
    Value<String>? op,
    Value<String>? payloadJson,
    Value<String?>? baseServerUdt,
    Value<String>? clientChangedAt,
    Value<int>? attempts,
    Value<String?>? lastError,
    Value<String>? state,
  }) {
    return OutboxOpsCompanion(
      seq: seq ?? this.seq,
      mutationId: mutationId ?? this.mutationId,
      entity: entity ?? this.entity,
      entityId: entityId ?? this.entityId,
      op: op ?? this.op,
      payloadJson: payloadJson ?? this.payloadJson,
      baseServerUdt: baseServerUdt ?? this.baseServerUdt,
      clientChangedAt: clientChangedAt ?? this.clientChangedAt,
      attempts: attempts ?? this.attempts,
      lastError: lastError ?? this.lastError,
      state: state ?? this.state,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (seq.present) {
      map['seq'] = Variable<int>(seq.value);
    }
    if (mutationId.present) {
      map['mutation_id'] = Variable<String>(mutationId.value);
    }
    if (entity.present) {
      map['entity'] = Variable<String>(entity.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (op.present) {
      map['op'] = Variable<String>(op.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (baseServerUdt.present) {
      map['base_server_udt'] = Variable<String>(baseServerUdt.value);
    }
    if (clientChangedAt.present) {
      map['client_changed_at'] = Variable<String>(clientChangedAt.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OutboxOpsCompanion(')
          ..write('seq: $seq, ')
          ..write('mutationId: $mutationId, ')
          ..write('entity: $entity, ')
          ..write('entityId: $entityId, ')
          ..write('op: $op, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('baseServerUdt: $baseServerUdt, ')
          ..write('clientChangedAt: $clientChangedAt, ')
          ..write('attempts: $attempts, ')
          ..write('lastError: $lastError, ')
          ..write('state: $state')
          ..write(')'))
        .toString();
  }
}

class $SyncCursorsTable extends SyncCursors
    with TableInfo<$SyncCursorsTable, SyncCursor> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncCursorsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _entityMeta = const VerificationMeta('entity');
  @override
  late final GeneratedColumn<String> entity = GeneratedColumn<String>(
    'entity',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cursorMeta = const VerificationMeta('cursor');
  @override
  late final GeneratedColumn<String> cursor = GeneratedColumn<String>(
    'cursor',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastPulledAtMeta = const VerificationMeta(
    'lastPulledAt',
  );
  @override
  late final GeneratedColumn<String> lastPulledAt = GeneratedColumn<String>(
    'last_pulled_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [entity, cursor, lastPulledAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_cursors';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncCursor> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('entity')) {
      context.handle(
        _entityMeta,
        entity.isAcceptableOrUnknown(data['entity']!, _entityMeta),
      );
    } else if (isInserting) {
      context.missing(_entityMeta);
    }
    if (data.containsKey('cursor')) {
      context.handle(
        _cursorMeta,
        cursor.isAcceptableOrUnknown(data['cursor']!, _cursorMeta),
      );
    }
    if (data.containsKey('last_pulled_at')) {
      context.handle(
        _lastPulledAtMeta,
        lastPulledAt.isAcceptableOrUnknown(
          data['last_pulled_at']!,
          _lastPulledAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {entity};
  @override
  SyncCursor map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncCursor(
      entity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity'],
      )!,
      cursor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cursor'],
      ),
      lastPulledAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_pulled_at'],
      ),
    );
  }

  @override
  $SyncCursorsTable createAlias(String alias) {
    return $SyncCursorsTable(attachedDatabase, alias);
  }
}

class SyncCursor extends DataClass implements Insertable<SyncCursor> {
  final String entity;
  final String? cursor;
  final String? lastPulledAt;
  const SyncCursor({required this.entity, this.cursor, this.lastPulledAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['entity'] = Variable<String>(entity);
    if (!nullToAbsent || cursor != null) {
      map['cursor'] = Variable<String>(cursor);
    }
    if (!nullToAbsent || lastPulledAt != null) {
      map['last_pulled_at'] = Variable<String>(lastPulledAt);
    }
    return map;
  }

  SyncCursorsCompanion toCompanion(bool nullToAbsent) {
    return SyncCursorsCompanion(
      entity: Value(entity),
      cursor: cursor == null && nullToAbsent
          ? const Value.absent()
          : Value(cursor),
      lastPulledAt: lastPulledAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastPulledAt),
    );
  }

  factory SyncCursor.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncCursor(
      entity: serializer.fromJson<String>(json['entity']),
      cursor: serializer.fromJson<String?>(json['cursor']),
      lastPulledAt: serializer.fromJson<String?>(json['lastPulledAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'entity': serializer.toJson<String>(entity),
      'cursor': serializer.toJson<String?>(cursor),
      'lastPulledAt': serializer.toJson<String?>(lastPulledAt),
    };
  }

  SyncCursor copyWith({
    String? entity,
    Value<String?> cursor = const Value.absent(),
    Value<String?> lastPulledAt = const Value.absent(),
  }) => SyncCursor(
    entity: entity ?? this.entity,
    cursor: cursor.present ? cursor.value : this.cursor,
    lastPulledAt: lastPulledAt.present ? lastPulledAt.value : this.lastPulledAt,
  );
  SyncCursor copyWithCompanion(SyncCursorsCompanion data) {
    return SyncCursor(
      entity: data.entity.present ? data.entity.value : this.entity,
      cursor: data.cursor.present ? data.cursor.value : this.cursor,
      lastPulledAt: data.lastPulledAt.present
          ? data.lastPulledAt.value
          : this.lastPulledAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncCursor(')
          ..write('entity: $entity, ')
          ..write('cursor: $cursor, ')
          ..write('lastPulledAt: $lastPulledAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(entity, cursor, lastPulledAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncCursor &&
          other.entity == this.entity &&
          other.cursor == this.cursor &&
          other.lastPulledAt == this.lastPulledAt);
}

class SyncCursorsCompanion extends UpdateCompanion<SyncCursor> {
  final Value<String> entity;
  final Value<String?> cursor;
  final Value<String?> lastPulledAt;
  final Value<int> rowid;
  const SyncCursorsCompanion({
    this.entity = const Value.absent(),
    this.cursor = const Value.absent(),
    this.lastPulledAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncCursorsCompanion.insert({
    required String entity,
    this.cursor = const Value.absent(),
    this.lastPulledAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : entity = Value(entity);
  static Insertable<SyncCursor> custom({
    Expression<String>? entity,
    Expression<String>? cursor,
    Expression<String>? lastPulledAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (entity != null) 'entity': entity,
      if (cursor != null) 'cursor': cursor,
      if (lastPulledAt != null) 'last_pulled_at': lastPulledAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncCursorsCompanion copyWith({
    Value<String>? entity,
    Value<String?>? cursor,
    Value<String?>? lastPulledAt,
    Value<int>? rowid,
  }) {
    return SyncCursorsCompanion(
      entity: entity ?? this.entity,
      cursor: cursor ?? this.cursor,
      lastPulledAt: lastPulledAt ?? this.lastPulledAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (entity.present) {
      map['entity'] = Variable<String>(entity.value);
    }
    if (cursor.present) {
      map['cursor'] = Variable<String>(cursor.value);
    }
    if (lastPulledAt.present) {
      map['last_pulled_at'] = Variable<String>(lastPulledAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncCursorsCompanion(')
          ..write('entity: $entity, ')
          ..write('cursor: $cursor, ')
          ..write('lastPulledAt: $lastPulledAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MediaCacheEntriesTable extends MediaCacheEntries
    with TableInfo<$MediaCacheEntriesTable, MediaCacheEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MediaCacheEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _objectKeyMeta = const VerificationMeta(
    'objectKey',
  );
  @override
  late final GeneratedColumn<String> objectKey = GeneratedColumn<String>(
    'object_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityMeta = const VerificationMeta('entity');
  @override
  late final GeneratedColumn<String> entity = GeneratedColumn<String>(
    'entity',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _localPathMeta = const VerificationMeta(
    'localPath',
  );
  @override
  late final GeneratedColumn<String> localPath = GeneratedColumn<String>(
    'local_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
    'state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _fetchedAtMeta = const VerificationMeta(
    'fetchedAt',
  );
  @override
  late final GeneratedColumn<String> fetchedAt = GeneratedColumn<String>(
    'fetched_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    objectKey,
    entity,
    entityId,
    localPath,
    state,
    fetchedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'media_cache_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<MediaCacheEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('object_key')) {
      context.handle(
        _objectKeyMeta,
        objectKey.isAcceptableOrUnknown(data['object_key']!, _objectKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_objectKeyMeta);
    }
    if (data.containsKey('entity')) {
      context.handle(
        _entityMeta,
        entity.isAcceptableOrUnknown(data['entity']!, _entityMeta),
      );
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    }
    if (data.containsKey('local_path')) {
      context.handle(
        _localPathMeta,
        localPath.isAcceptableOrUnknown(data['local_path']!, _localPathMeta),
      );
    }
    if (data.containsKey('state')) {
      context.handle(
        _stateMeta,
        state.isAcceptableOrUnknown(data['state']!, _stateMeta),
      );
    }
    if (data.containsKey('fetched_at')) {
      context.handle(
        _fetchedAtMeta,
        fetchedAt.isAcceptableOrUnknown(data['fetched_at']!, _fetchedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {objectKey};
  @override
  MediaCacheEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MediaCacheEntry(
      objectKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}object_key'],
      )!,
      entity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity'],
      ),
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      ),
      localPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_path'],
      ),
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state'],
      )!,
      fetchedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fetched_at'],
      ),
    );
  }

  @override
  $MediaCacheEntriesTable createAlias(String alias) {
    return $MediaCacheEntriesTable(attachedDatabase, alias);
  }
}

class MediaCacheEntry extends DataClass implements Insertable<MediaCacheEntry> {
  final String objectKey;
  final String? entity;
  final String? entityId;
  final String? localPath;
  final String state;
  final String? fetchedAt;
  const MediaCacheEntry({
    required this.objectKey,
    this.entity,
    this.entityId,
    this.localPath,
    required this.state,
    this.fetchedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['object_key'] = Variable<String>(objectKey);
    if (!nullToAbsent || entity != null) {
      map['entity'] = Variable<String>(entity);
    }
    if (!nullToAbsent || entityId != null) {
      map['entity_id'] = Variable<String>(entityId);
    }
    if (!nullToAbsent || localPath != null) {
      map['local_path'] = Variable<String>(localPath);
    }
    map['state'] = Variable<String>(state);
    if (!nullToAbsent || fetchedAt != null) {
      map['fetched_at'] = Variable<String>(fetchedAt);
    }
    return map;
  }

  MediaCacheEntriesCompanion toCompanion(bool nullToAbsent) {
    return MediaCacheEntriesCompanion(
      objectKey: Value(objectKey),
      entity: entity == null && nullToAbsent
          ? const Value.absent()
          : Value(entity),
      entityId: entityId == null && nullToAbsent
          ? const Value.absent()
          : Value(entityId),
      localPath: localPath == null && nullToAbsent
          ? const Value.absent()
          : Value(localPath),
      state: Value(state),
      fetchedAt: fetchedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(fetchedAt),
    );
  }

  factory MediaCacheEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MediaCacheEntry(
      objectKey: serializer.fromJson<String>(json['objectKey']),
      entity: serializer.fromJson<String?>(json['entity']),
      entityId: serializer.fromJson<String?>(json['entityId']),
      localPath: serializer.fromJson<String?>(json['localPath']),
      state: serializer.fromJson<String>(json['state']),
      fetchedAt: serializer.fromJson<String?>(json['fetchedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'objectKey': serializer.toJson<String>(objectKey),
      'entity': serializer.toJson<String?>(entity),
      'entityId': serializer.toJson<String?>(entityId),
      'localPath': serializer.toJson<String?>(localPath),
      'state': serializer.toJson<String>(state),
      'fetchedAt': serializer.toJson<String?>(fetchedAt),
    };
  }

  MediaCacheEntry copyWith({
    String? objectKey,
    Value<String?> entity = const Value.absent(),
    Value<String?> entityId = const Value.absent(),
    Value<String?> localPath = const Value.absent(),
    String? state,
    Value<String?> fetchedAt = const Value.absent(),
  }) => MediaCacheEntry(
    objectKey: objectKey ?? this.objectKey,
    entity: entity.present ? entity.value : this.entity,
    entityId: entityId.present ? entityId.value : this.entityId,
    localPath: localPath.present ? localPath.value : this.localPath,
    state: state ?? this.state,
    fetchedAt: fetchedAt.present ? fetchedAt.value : this.fetchedAt,
  );
  MediaCacheEntry copyWithCompanion(MediaCacheEntriesCompanion data) {
    return MediaCacheEntry(
      objectKey: data.objectKey.present ? data.objectKey.value : this.objectKey,
      entity: data.entity.present ? data.entity.value : this.entity,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      localPath: data.localPath.present ? data.localPath.value : this.localPath,
      state: data.state.present ? data.state.value : this.state,
      fetchedAt: data.fetchedAt.present ? data.fetchedAt.value : this.fetchedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MediaCacheEntry(')
          ..write('objectKey: $objectKey, ')
          ..write('entity: $entity, ')
          ..write('entityId: $entityId, ')
          ..write('localPath: $localPath, ')
          ..write('state: $state, ')
          ..write('fetchedAt: $fetchedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(objectKey, entity, entityId, localPath, state, fetchedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MediaCacheEntry &&
          other.objectKey == this.objectKey &&
          other.entity == this.entity &&
          other.entityId == this.entityId &&
          other.localPath == this.localPath &&
          other.state == this.state &&
          other.fetchedAt == this.fetchedAt);
}

class MediaCacheEntriesCompanion extends UpdateCompanion<MediaCacheEntry> {
  final Value<String> objectKey;
  final Value<String?> entity;
  final Value<String?> entityId;
  final Value<String?> localPath;
  final Value<String> state;
  final Value<String?> fetchedAt;
  final Value<int> rowid;
  const MediaCacheEntriesCompanion({
    this.objectKey = const Value.absent(),
    this.entity = const Value.absent(),
    this.entityId = const Value.absent(),
    this.localPath = const Value.absent(),
    this.state = const Value.absent(),
    this.fetchedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MediaCacheEntriesCompanion.insert({
    required String objectKey,
    this.entity = const Value.absent(),
    this.entityId = const Value.absent(),
    this.localPath = const Value.absent(),
    this.state = const Value.absent(),
    this.fetchedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : objectKey = Value(objectKey);
  static Insertable<MediaCacheEntry> custom({
    Expression<String>? objectKey,
    Expression<String>? entity,
    Expression<String>? entityId,
    Expression<String>? localPath,
    Expression<String>? state,
    Expression<String>? fetchedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (objectKey != null) 'object_key': objectKey,
      if (entity != null) 'entity': entity,
      if (entityId != null) 'entity_id': entityId,
      if (localPath != null) 'local_path': localPath,
      if (state != null) 'state': state,
      if (fetchedAt != null) 'fetched_at': fetchedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MediaCacheEntriesCompanion copyWith({
    Value<String>? objectKey,
    Value<String?>? entity,
    Value<String?>? entityId,
    Value<String?>? localPath,
    Value<String>? state,
    Value<String?>? fetchedAt,
    Value<int>? rowid,
  }) {
    return MediaCacheEntriesCompanion(
      objectKey: objectKey ?? this.objectKey,
      entity: entity ?? this.entity,
      entityId: entityId ?? this.entityId,
      localPath: localPath ?? this.localPath,
      state: state ?? this.state,
      fetchedAt: fetchedAt ?? this.fetchedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (objectKey.present) {
      map['object_key'] = Variable<String>(objectKey.value);
    }
    if (entity.present) {
      map['entity'] = Variable<String>(entity.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (localPath.present) {
      map['local_path'] = Variable<String>(localPath.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (fetchedAt.present) {
      map['fetched_at'] = Variable<String>(fetchedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MediaCacheEntriesCompanion(')
          ..write('objectKey: $objectKey, ')
          ..write('entity: $entity, ')
          ..write('entityId: $entityId, ')
          ..write('localPath: $localPath, ')
          ..write('state: $state, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncConflictsTable extends SyncConflicts
    with TableInfo<$SyncConflictsTable, SyncConflict> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncConflictsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _mutationIdMeta = const VerificationMeta(
    'mutationId',
  );
  @override
  late final GeneratedColumn<String> mutationId = GeneratedColumn<String>(
    'mutation_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityMeta = const VerificationMeta('entity');
  @override
  late final GeneratedColumn<String> entity = GeneratedColumn<String>(
    'entity',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
    'reason',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _clientPayloadJsonMeta = const VerificationMeta(
    'clientPayloadJson',
  );
  @override
  late final GeneratedColumn<String> clientPayloadJson =
      GeneratedColumn<String>(
        'client_payload_json',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _serverRowJsonMeta = const VerificationMeta(
    'serverRowJson',
  );
  @override
  late final GeneratedColumn<String> serverRowJson = GeneratedColumn<String>(
    'server_row_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _resolvedMeta = const VerificationMeta(
    'resolved',
  );
  @override
  late final GeneratedColumn<bool> resolved = GeneratedColumn<bool>(
    'resolved',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("resolved" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    mutationId,
    entity,
    entityId,
    reason,
    clientPayloadJson,
    serverRowJson,
    createdAt,
    resolved,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_conflicts';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncConflict> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('mutation_id')) {
      context.handle(
        _mutationIdMeta,
        mutationId.isAcceptableOrUnknown(data['mutation_id']!, _mutationIdMeta),
      );
    } else if (isInserting) {
      context.missing(_mutationIdMeta);
    }
    if (data.containsKey('entity')) {
      context.handle(
        _entityMeta,
        entity.isAcceptableOrUnknown(data['entity']!, _entityMeta),
      );
    } else if (isInserting) {
      context.missing(_entityMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('reason')) {
      context.handle(
        _reasonMeta,
        reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta),
      );
    }
    if (data.containsKey('client_payload_json')) {
      context.handle(
        _clientPayloadJsonMeta,
        clientPayloadJson.isAcceptableOrUnknown(
          data['client_payload_json']!,
          _clientPayloadJsonMeta,
        ),
      );
    }
    if (data.containsKey('server_row_json')) {
      context.handle(
        _serverRowJsonMeta,
        serverRowJson.isAcceptableOrUnknown(
          data['server_row_json']!,
          _serverRowJsonMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('resolved')) {
      context.handle(
        _resolvedMeta,
        resolved.isAcceptableOrUnknown(data['resolved']!, _resolvedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {mutationId};
  @override
  SyncConflict map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncConflict(
      mutationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mutation_id'],
      )!,
      entity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      reason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason'],
      ),
      clientPayloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_payload_json'],
      ),
      serverRowJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_row_json'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
      resolved: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}resolved'],
      )!,
    );
  }

  @override
  $SyncConflictsTable createAlias(String alias) {
    return $SyncConflictsTable(attachedDatabase, alias);
  }
}

class SyncConflict extends DataClass implements Insertable<SyncConflict> {
  final String mutationId;
  final String entity;
  final String entityId;
  final String? reason;
  final String? clientPayloadJson;
  final String? serverRowJson;
  final String createdAt;
  final bool resolved;
  const SyncConflict({
    required this.mutationId,
    required this.entity,
    required this.entityId,
    this.reason,
    this.clientPayloadJson,
    this.serverRowJson,
    required this.createdAt,
    required this.resolved,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['mutation_id'] = Variable<String>(mutationId);
    map['entity'] = Variable<String>(entity);
    map['entity_id'] = Variable<String>(entityId);
    if (!nullToAbsent || reason != null) {
      map['reason'] = Variable<String>(reason);
    }
    if (!nullToAbsent || clientPayloadJson != null) {
      map['client_payload_json'] = Variable<String>(clientPayloadJson);
    }
    if (!nullToAbsent || serverRowJson != null) {
      map['server_row_json'] = Variable<String>(serverRowJson);
    }
    map['created_at'] = Variable<String>(createdAt);
    map['resolved'] = Variable<bool>(resolved);
    return map;
  }

  SyncConflictsCompanion toCompanion(bool nullToAbsent) {
    return SyncConflictsCompanion(
      mutationId: Value(mutationId),
      entity: Value(entity),
      entityId: Value(entityId),
      reason: reason == null && nullToAbsent
          ? const Value.absent()
          : Value(reason),
      clientPayloadJson: clientPayloadJson == null && nullToAbsent
          ? const Value.absent()
          : Value(clientPayloadJson),
      serverRowJson: serverRowJson == null && nullToAbsent
          ? const Value.absent()
          : Value(serverRowJson),
      createdAt: Value(createdAt),
      resolved: Value(resolved),
    );
  }

  factory SyncConflict.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncConflict(
      mutationId: serializer.fromJson<String>(json['mutationId']),
      entity: serializer.fromJson<String>(json['entity']),
      entityId: serializer.fromJson<String>(json['entityId']),
      reason: serializer.fromJson<String?>(json['reason']),
      clientPayloadJson: serializer.fromJson<String?>(
        json['clientPayloadJson'],
      ),
      serverRowJson: serializer.fromJson<String?>(json['serverRowJson']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      resolved: serializer.fromJson<bool>(json['resolved']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'mutationId': serializer.toJson<String>(mutationId),
      'entity': serializer.toJson<String>(entity),
      'entityId': serializer.toJson<String>(entityId),
      'reason': serializer.toJson<String?>(reason),
      'clientPayloadJson': serializer.toJson<String?>(clientPayloadJson),
      'serverRowJson': serializer.toJson<String?>(serverRowJson),
      'createdAt': serializer.toJson<String>(createdAt),
      'resolved': serializer.toJson<bool>(resolved),
    };
  }

  SyncConflict copyWith({
    String? mutationId,
    String? entity,
    String? entityId,
    Value<String?> reason = const Value.absent(),
    Value<String?> clientPayloadJson = const Value.absent(),
    Value<String?> serverRowJson = const Value.absent(),
    String? createdAt,
    bool? resolved,
  }) => SyncConflict(
    mutationId: mutationId ?? this.mutationId,
    entity: entity ?? this.entity,
    entityId: entityId ?? this.entityId,
    reason: reason.present ? reason.value : this.reason,
    clientPayloadJson: clientPayloadJson.present
        ? clientPayloadJson.value
        : this.clientPayloadJson,
    serverRowJson: serverRowJson.present
        ? serverRowJson.value
        : this.serverRowJson,
    createdAt: createdAt ?? this.createdAt,
    resolved: resolved ?? this.resolved,
  );
  SyncConflict copyWithCompanion(SyncConflictsCompanion data) {
    return SyncConflict(
      mutationId: data.mutationId.present
          ? data.mutationId.value
          : this.mutationId,
      entity: data.entity.present ? data.entity.value : this.entity,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      reason: data.reason.present ? data.reason.value : this.reason,
      clientPayloadJson: data.clientPayloadJson.present
          ? data.clientPayloadJson.value
          : this.clientPayloadJson,
      serverRowJson: data.serverRowJson.present
          ? data.serverRowJson.value
          : this.serverRowJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      resolved: data.resolved.present ? data.resolved.value : this.resolved,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncConflict(')
          ..write('mutationId: $mutationId, ')
          ..write('entity: $entity, ')
          ..write('entityId: $entityId, ')
          ..write('reason: $reason, ')
          ..write('clientPayloadJson: $clientPayloadJson, ')
          ..write('serverRowJson: $serverRowJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('resolved: $resolved')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    mutationId,
    entity,
    entityId,
    reason,
    clientPayloadJson,
    serverRowJson,
    createdAt,
    resolved,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncConflict &&
          other.mutationId == this.mutationId &&
          other.entity == this.entity &&
          other.entityId == this.entityId &&
          other.reason == this.reason &&
          other.clientPayloadJson == this.clientPayloadJson &&
          other.serverRowJson == this.serverRowJson &&
          other.createdAt == this.createdAt &&
          other.resolved == this.resolved);
}

class SyncConflictsCompanion extends UpdateCompanion<SyncConflict> {
  final Value<String> mutationId;
  final Value<String> entity;
  final Value<String> entityId;
  final Value<String?> reason;
  final Value<String?> clientPayloadJson;
  final Value<String?> serverRowJson;
  final Value<String> createdAt;
  final Value<bool> resolved;
  final Value<int> rowid;
  const SyncConflictsCompanion({
    this.mutationId = const Value.absent(),
    this.entity = const Value.absent(),
    this.entityId = const Value.absent(),
    this.reason = const Value.absent(),
    this.clientPayloadJson = const Value.absent(),
    this.serverRowJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.resolved = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncConflictsCompanion.insert({
    required String mutationId,
    required String entity,
    required String entityId,
    this.reason = const Value.absent(),
    this.clientPayloadJson = const Value.absent(),
    this.serverRowJson = const Value.absent(),
    required String createdAt,
    this.resolved = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : mutationId = Value(mutationId),
       entity = Value(entity),
       entityId = Value(entityId),
       createdAt = Value(createdAt);
  static Insertable<SyncConflict> custom({
    Expression<String>? mutationId,
    Expression<String>? entity,
    Expression<String>? entityId,
    Expression<String>? reason,
    Expression<String>? clientPayloadJson,
    Expression<String>? serverRowJson,
    Expression<String>? createdAt,
    Expression<bool>? resolved,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (mutationId != null) 'mutation_id': mutationId,
      if (entity != null) 'entity': entity,
      if (entityId != null) 'entity_id': entityId,
      if (reason != null) 'reason': reason,
      if (clientPayloadJson != null) 'client_payload_json': clientPayloadJson,
      if (serverRowJson != null) 'server_row_json': serverRowJson,
      if (createdAt != null) 'created_at': createdAt,
      if (resolved != null) 'resolved': resolved,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncConflictsCompanion copyWith({
    Value<String>? mutationId,
    Value<String>? entity,
    Value<String>? entityId,
    Value<String?>? reason,
    Value<String?>? clientPayloadJson,
    Value<String?>? serverRowJson,
    Value<String>? createdAt,
    Value<bool>? resolved,
    Value<int>? rowid,
  }) {
    return SyncConflictsCompanion(
      mutationId: mutationId ?? this.mutationId,
      entity: entity ?? this.entity,
      entityId: entityId ?? this.entityId,
      reason: reason ?? this.reason,
      clientPayloadJson: clientPayloadJson ?? this.clientPayloadJson,
      serverRowJson: serverRowJson ?? this.serverRowJson,
      createdAt: createdAt ?? this.createdAt,
      resolved: resolved ?? this.resolved,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (mutationId.present) {
      map['mutation_id'] = Variable<String>(mutationId.value);
    }
    if (entity.present) {
      map['entity'] = Variable<String>(entity.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (clientPayloadJson.present) {
      map['client_payload_json'] = Variable<String>(clientPayloadJson.value);
    }
    if (serverRowJson.present) {
      map['server_row_json'] = Variable<String>(serverRowJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (resolved.present) {
      map['resolved'] = Variable<bool>(resolved.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncConflictsCompanion(')
          ..write('mutationId: $mutationId, ')
          ..write('entity: $entity, ')
          ..write('entityId: $entityId, ')
          ..write('reason: $reason, ')
          ..write('clientPayloadJson: $clientPayloadJson, ')
          ..write('serverRowJson: $serverRowJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('resolved: $resolved, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PresentationRecordsTable extends PresentationRecords
    with TableInfo<$PresentationRecordsTable, PresentationRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PresentationRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _customerTypeMeta = const VerificationMeta(
    'customerType',
  );
  @override
  late final GeneratedColumn<String> customerType = GeneratedColumn<String>(
    'customer_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _customerIdMeta = const VerificationMeta(
    'customerId',
  );
  @override
  late final GeneratedColumn<String> customerId = GeneratedColumn<String>(
    'customer_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _shownAtMeta = const VerificationMeta(
    'shownAt',
  );
  @override
  late final GeneratedColumn<String> shownAt = GeneratedColumn<String>(
    'shown_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productIdsJsonMeta = const VerificationMeta(
    'productIdsJson',
  );
  @override
  late final GeneratedColumn<String> productIdsJson = GeneratedColumn<String>(
    'product_ids_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    customerType,
    customerId,
    shownAt,
    productIdsJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'presentation_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<PresentationRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('customer_type')) {
      context.handle(
        _customerTypeMeta,
        customerType.isAcceptableOrUnknown(
          data['customer_type']!,
          _customerTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_customerTypeMeta);
    }
    if (data.containsKey('customer_id')) {
      context.handle(
        _customerIdMeta,
        customerId.isAcceptableOrUnknown(data['customer_id']!, _customerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_customerIdMeta);
    }
    if (data.containsKey('shown_at')) {
      context.handle(
        _shownAtMeta,
        shownAt.isAcceptableOrUnknown(data['shown_at']!, _shownAtMeta),
      );
    } else if (isInserting) {
      context.missing(_shownAtMeta);
    }
    if (data.containsKey('product_ids_json')) {
      context.handle(
        _productIdsJsonMeta,
        productIdsJson.isAcceptableOrUnknown(
          data['product_ids_json']!,
          _productIdsJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_productIdsJsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PresentationRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PresentationRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      customerType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_type'],
      )!,
      customerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_id'],
      )!,
      shownAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}shown_at'],
      )!,
      productIdsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_ids_json'],
      )!,
    );
  }

  @override
  $PresentationRecordsTable createAlias(String alias) {
    return $PresentationRecordsTable(attachedDatabase, alias);
  }
}

class PresentationRecord extends DataClass
    implements Insertable<PresentationRecord> {
  /// The originating DCR id (stable across devices).
  final String id;
  final String customerType;
  final String customerId;
  final String shownAt;
  final String productIdsJson;
  const PresentationRecord({
    required this.id,
    required this.customerType,
    required this.customerId,
    required this.shownAt,
    required this.productIdsJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['customer_type'] = Variable<String>(customerType);
    map['customer_id'] = Variable<String>(customerId);
    map['shown_at'] = Variable<String>(shownAt);
    map['product_ids_json'] = Variable<String>(productIdsJson);
    return map;
  }

  PresentationRecordsCompanion toCompanion(bool nullToAbsent) {
    return PresentationRecordsCompanion(
      id: Value(id),
      customerType: Value(customerType),
      customerId: Value(customerId),
      shownAt: Value(shownAt),
      productIdsJson: Value(productIdsJson),
    );
  }

  factory PresentationRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PresentationRecord(
      id: serializer.fromJson<String>(json['id']),
      customerType: serializer.fromJson<String>(json['customerType']),
      customerId: serializer.fromJson<String>(json['customerId']),
      shownAt: serializer.fromJson<String>(json['shownAt']),
      productIdsJson: serializer.fromJson<String>(json['productIdsJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'customerType': serializer.toJson<String>(customerType),
      'customerId': serializer.toJson<String>(customerId),
      'shownAt': serializer.toJson<String>(shownAt),
      'productIdsJson': serializer.toJson<String>(productIdsJson),
    };
  }

  PresentationRecord copyWith({
    String? id,
    String? customerType,
    String? customerId,
    String? shownAt,
    String? productIdsJson,
  }) => PresentationRecord(
    id: id ?? this.id,
    customerType: customerType ?? this.customerType,
    customerId: customerId ?? this.customerId,
    shownAt: shownAt ?? this.shownAt,
    productIdsJson: productIdsJson ?? this.productIdsJson,
  );
  PresentationRecord copyWithCompanion(PresentationRecordsCompanion data) {
    return PresentationRecord(
      id: data.id.present ? data.id.value : this.id,
      customerType: data.customerType.present
          ? data.customerType.value
          : this.customerType,
      customerId: data.customerId.present
          ? data.customerId.value
          : this.customerId,
      shownAt: data.shownAt.present ? data.shownAt.value : this.shownAt,
      productIdsJson: data.productIdsJson.present
          ? data.productIdsJson.value
          : this.productIdsJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PresentationRecord(')
          ..write('id: $id, ')
          ..write('customerType: $customerType, ')
          ..write('customerId: $customerId, ')
          ..write('shownAt: $shownAt, ')
          ..write('productIdsJson: $productIdsJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, customerType, customerId, shownAt, productIdsJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PresentationRecord &&
          other.id == this.id &&
          other.customerType == this.customerType &&
          other.customerId == this.customerId &&
          other.shownAt == this.shownAt &&
          other.productIdsJson == this.productIdsJson);
}

class PresentationRecordsCompanion extends UpdateCompanion<PresentationRecord> {
  final Value<String> id;
  final Value<String> customerType;
  final Value<String> customerId;
  final Value<String> shownAt;
  final Value<String> productIdsJson;
  final Value<int> rowid;
  const PresentationRecordsCompanion({
    this.id = const Value.absent(),
    this.customerType = const Value.absent(),
    this.customerId = const Value.absent(),
    this.shownAt = const Value.absent(),
    this.productIdsJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PresentationRecordsCompanion.insert({
    required String id,
    required String customerType,
    required String customerId,
    required String shownAt,
    required String productIdsJson,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       customerType = Value(customerType),
       customerId = Value(customerId),
       shownAt = Value(shownAt),
       productIdsJson = Value(productIdsJson);
  static Insertable<PresentationRecord> custom({
    Expression<String>? id,
    Expression<String>? customerType,
    Expression<String>? customerId,
    Expression<String>? shownAt,
    Expression<String>? productIdsJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (customerType != null) 'customer_type': customerType,
      if (customerId != null) 'customer_id': customerId,
      if (shownAt != null) 'shown_at': shownAt,
      if (productIdsJson != null) 'product_ids_json': productIdsJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PresentationRecordsCompanion copyWith({
    Value<String>? id,
    Value<String>? customerType,
    Value<String>? customerId,
    Value<String>? shownAt,
    Value<String>? productIdsJson,
    Value<int>? rowid,
  }) {
    return PresentationRecordsCompanion(
      id: id ?? this.id,
      customerType: customerType ?? this.customerType,
      customerId: customerId ?? this.customerId,
      shownAt: shownAt ?? this.shownAt,
      productIdsJson: productIdsJson ?? this.productIdsJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (customerType.present) {
      map['customer_type'] = Variable<String>(customerType.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<String>(customerId.value);
    }
    if (shownAt.present) {
      map['shown_at'] = Variable<String>(shownAt.value);
    }
    if (productIdsJson.present) {
      map['product_ids_json'] = Variable<String>(productIdsJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PresentationRecordsCompanion(')
          ..write('id: $id, ')
          ..write('customerType: $customerType, ')
          ..write('customerId: $customerId, ')
          ..write('shownAt: $shownAt, ')
          ..write('productIdsJson: $productIdsJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $KvEntriesTable extends KvEntries
    with TableInfo<$KvEntriesTable, KvEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KvEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'kv_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<KvEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  KvEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KvEntry(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      ),
    );
  }

  @override
  $KvEntriesTable createAlias(String alias) {
    return $KvEntriesTable(attachedDatabase, alias);
  }
}

class KvEntry extends DataClass implements Insertable<KvEntry> {
  final String key;
  final String? value;
  const KvEntry({required this.key, this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    if (!nullToAbsent || value != null) {
      map['value'] = Variable<String>(value);
    }
    return map;
  }

  KvEntriesCompanion toCompanion(bool nullToAbsent) {
    return KvEntriesCompanion(
      key: Value(key),
      value: value == null && nullToAbsent
          ? const Value.absent()
          : Value(value),
    );
  }

  factory KvEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KvEntry(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String?>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String?>(value),
    };
  }

  KvEntry copyWith({
    String? key,
    Value<String?> value = const Value.absent(),
  }) => KvEntry(
    key: key ?? this.key,
    value: value.present ? value.value : this.value,
  );
  KvEntry copyWithCompanion(KvEntriesCompanion data) {
    return KvEntry(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('KvEntry(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KvEntry && other.key == this.key && other.value == this.value);
}

class KvEntriesCompanion extends UpdateCompanion<KvEntry> {
  final Value<String> key;
  final Value<String?> value;
  final Value<int> rowid;
  const KvEntriesCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  KvEntriesCompanion.insert({
    required String key,
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : key = Value(key);
  static Insertable<KvEntry> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  KvEntriesCompanion copyWith({
    Value<String>? key,
    Value<String?>? value,
    Value<int>? rowid,
  }) {
    return KvEntriesCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KvEntriesCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $DoctorsTable doctors = $DoctorsTable(this);
  late final $ChemistsTable chemists = $ChemistsTable(this);
  late final $ProductsTable products = $ProductsTable(this);
  late final $DailyPlansTable dailyPlans = $DailyPlansTable(this);
  late final $DcrsTable dcrs = $DcrsTable(this);
  late final $DcrProductRowsTable dcrProductRows = $DcrProductRowsTable(this);
  late final $UsersLiteTable usersLite = $UsersLiteTable(this);
  late final $MetadataItemsTable metadataItems = $MetadataItemsTable(this);
  late final $OutboxOpsTable outboxOps = $OutboxOpsTable(this);
  late final $SyncCursorsTable syncCursors = $SyncCursorsTable(this);
  late final $MediaCacheEntriesTable mediaCacheEntries =
      $MediaCacheEntriesTable(this);
  late final $SyncConflictsTable syncConflicts = $SyncConflictsTable(this);
  late final $PresentationRecordsTable presentationRecords =
      $PresentationRecordsTable(this);
  late final $KvEntriesTable kvEntries = $KvEntriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    doctors,
    chemists,
    products,
    dailyPlans,
    dcrs,
    dcrProductRows,
    usersLite,
    metadataItems,
    outboxOps,
    syncCursors,
    mediaCacheEntries,
    syncConflicts,
    presentationRecords,
    kvEntries,
  ];
}

typedef $$DoctorsTableCreateCompanionBuilder =
    DoctorsCompanion Function({
      Value<String> status,
      Value<bool> isEnabled,
      Value<String?> serverUdt,
      Value<String> localStatus,
      Value<String?> locallyChangedAt,
      required String id,
      Value<String?> doctorCode,
      Value<String?> doctorType,
      Value<String?> firstName,
      Value<String?> middleName,
      Value<String?> lastName,
      Value<String?> qualification,
      Value<String?> speciality,
      Value<String?> category,
      Value<double?> potential,
      Value<double?> supportValue,
      Value<double?> expectedSupportValue,
      Value<String?> phone,
      Value<String?> email,
      Value<String?> state,
      Value<String?> city,
      Value<String?> area,
      Value<String?> country,
      Value<String?> dob,
      Value<String?> dom,
      Value<int?> experienceYears,
      Value<String?> chemistIds,
      Value<String?> cdt,
      Value<int> rowid,
    });
typedef $$DoctorsTableUpdateCompanionBuilder =
    DoctorsCompanion Function({
      Value<String> status,
      Value<bool> isEnabled,
      Value<String?> serverUdt,
      Value<String> localStatus,
      Value<String?> locallyChangedAt,
      Value<String> id,
      Value<String?> doctorCode,
      Value<String?> doctorType,
      Value<String?> firstName,
      Value<String?> middleName,
      Value<String?> lastName,
      Value<String?> qualification,
      Value<String?> speciality,
      Value<String?> category,
      Value<double?> potential,
      Value<double?> supportValue,
      Value<double?> expectedSupportValue,
      Value<String?> phone,
      Value<String?> email,
      Value<String?> state,
      Value<String?> city,
      Value<String?> area,
      Value<String?> country,
      Value<String?> dob,
      Value<String?> dom,
      Value<int?> experienceYears,
      Value<String?> chemistIds,
      Value<String?> cdt,
      Value<int> rowid,
    });

class $$DoctorsTableFilterComposer
    extends Composer<_$AppDatabase, $DoctorsTable> {
  $$DoctorsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isEnabled => $composableBuilder(
    column: $table.isEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverUdt => $composableBuilder(
    column: $table.serverUdt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localStatus => $composableBuilder(
    column: $table.localStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get locallyChangedAt => $composableBuilder(
    column: $table.locallyChangedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get doctorCode => $composableBuilder(
    column: $table.doctorCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get doctorType => $composableBuilder(
    column: $table.doctorType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get firstName => $composableBuilder(
    column: $table.firstName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get middleName => $composableBuilder(
    column: $table.middleName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastName => $composableBuilder(
    column: $table.lastName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get qualification => $composableBuilder(
    column: $table.qualification,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get speciality => $composableBuilder(
    column: $table.speciality,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get potential => $composableBuilder(
    column: $table.potential,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get supportValue => $composableBuilder(
    column: $table.supportValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get expectedSupportValue => $composableBuilder(
    column: $table.expectedSupportValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get area => $composableBuilder(
    column: $table.area,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get country => $composableBuilder(
    column: $table.country,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dob => $composableBuilder(
    column: $table.dob,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dom => $composableBuilder(
    column: $table.dom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get experienceYears => $composableBuilder(
    column: $table.experienceYears,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get chemistIds => $composableBuilder(
    column: $table.chemistIds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cdt => $composableBuilder(
    column: $table.cdt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DoctorsTableOrderingComposer
    extends Composer<_$AppDatabase, $DoctorsTable> {
  $$DoctorsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isEnabled => $composableBuilder(
    column: $table.isEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverUdt => $composableBuilder(
    column: $table.serverUdt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localStatus => $composableBuilder(
    column: $table.localStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get locallyChangedAt => $composableBuilder(
    column: $table.locallyChangedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get doctorCode => $composableBuilder(
    column: $table.doctorCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get doctorType => $composableBuilder(
    column: $table.doctorType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get firstName => $composableBuilder(
    column: $table.firstName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get middleName => $composableBuilder(
    column: $table.middleName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastName => $composableBuilder(
    column: $table.lastName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get qualification => $composableBuilder(
    column: $table.qualification,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get speciality => $composableBuilder(
    column: $table.speciality,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get potential => $composableBuilder(
    column: $table.potential,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get supportValue => $composableBuilder(
    column: $table.supportValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get expectedSupportValue => $composableBuilder(
    column: $table.expectedSupportValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get area => $composableBuilder(
    column: $table.area,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get country => $composableBuilder(
    column: $table.country,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dob => $composableBuilder(
    column: $table.dob,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dom => $composableBuilder(
    column: $table.dom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get experienceYears => $composableBuilder(
    column: $table.experienceYears,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get chemistIds => $composableBuilder(
    column: $table.chemistIds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cdt => $composableBuilder(
    column: $table.cdt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DoctorsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DoctorsTable> {
  $$DoctorsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<bool> get isEnabled =>
      $composableBuilder(column: $table.isEnabled, builder: (column) => column);

  GeneratedColumn<String> get serverUdt =>
      $composableBuilder(column: $table.serverUdt, builder: (column) => column);

  GeneratedColumn<String> get localStatus => $composableBuilder(
    column: $table.localStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get locallyChangedAt => $composableBuilder(
    column: $table.locallyChangedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get doctorCode => $composableBuilder(
    column: $table.doctorCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get doctorType => $composableBuilder(
    column: $table.doctorType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get firstName =>
      $composableBuilder(column: $table.firstName, builder: (column) => column);

  GeneratedColumn<String> get middleName => $composableBuilder(
    column: $table.middleName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastName =>
      $composableBuilder(column: $table.lastName, builder: (column) => column);

  GeneratedColumn<String> get qualification => $composableBuilder(
    column: $table.qualification,
    builder: (column) => column,
  );

  GeneratedColumn<String> get speciality => $composableBuilder(
    column: $table.speciality,
    builder: (column) => column,
  );

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<double> get potential =>
      $composableBuilder(column: $table.potential, builder: (column) => column);

  GeneratedColumn<double> get supportValue => $composableBuilder(
    column: $table.supportValue,
    builder: (column) => column,
  );

  GeneratedColumn<double> get expectedSupportValue => $composableBuilder(
    column: $table.expectedSupportValue,
    builder: (column) => column,
  );

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<String> get city =>
      $composableBuilder(column: $table.city, builder: (column) => column);

  GeneratedColumn<String> get area =>
      $composableBuilder(column: $table.area, builder: (column) => column);

  GeneratedColumn<String> get country =>
      $composableBuilder(column: $table.country, builder: (column) => column);

  GeneratedColumn<String> get dob =>
      $composableBuilder(column: $table.dob, builder: (column) => column);

  GeneratedColumn<String> get dom =>
      $composableBuilder(column: $table.dom, builder: (column) => column);

  GeneratedColumn<int> get experienceYears => $composableBuilder(
    column: $table.experienceYears,
    builder: (column) => column,
  );

  GeneratedColumn<String> get chemistIds => $composableBuilder(
    column: $table.chemistIds,
    builder: (column) => column,
  );

  GeneratedColumn<String> get cdt =>
      $composableBuilder(column: $table.cdt, builder: (column) => column);
}

class $$DoctorsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DoctorsTable,
          Doctor,
          $$DoctorsTableFilterComposer,
          $$DoctorsTableOrderingComposer,
          $$DoctorsTableAnnotationComposer,
          $$DoctorsTableCreateCompanionBuilder,
          $$DoctorsTableUpdateCompanionBuilder,
          (Doctor, BaseReferences<_$AppDatabase, $DoctorsTable, Doctor>),
          Doctor,
          PrefetchHooks Function()
        > {
  $$DoctorsTableTableManager(_$AppDatabase db, $DoctorsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DoctorsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DoctorsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DoctorsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> status = const Value.absent(),
                Value<bool> isEnabled = const Value.absent(),
                Value<String?> serverUdt = const Value.absent(),
                Value<String> localStatus = const Value.absent(),
                Value<String?> locallyChangedAt = const Value.absent(),
                Value<String> id = const Value.absent(),
                Value<String?> doctorCode = const Value.absent(),
                Value<String?> doctorType = const Value.absent(),
                Value<String?> firstName = const Value.absent(),
                Value<String?> middleName = const Value.absent(),
                Value<String?> lastName = const Value.absent(),
                Value<String?> qualification = const Value.absent(),
                Value<String?> speciality = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<double?> potential = const Value.absent(),
                Value<double?> supportValue = const Value.absent(),
                Value<double?> expectedSupportValue = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> state = const Value.absent(),
                Value<String?> city = const Value.absent(),
                Value<String?> area = const Value.absent(),
                Value<String?> country = const Value.absent(),
                Value<String?> dob = const Value.absent(),
                Value<String?> dom = const Value.absent(),
                Value<int?> experienceYears = const Value.absent(),
                Value<String?> chemistIds = const Value.absent(),
                Value<String?> cdt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DoctorsCompanion(
                status: status,
                isEnabled: isEnabled,
                serverUdt: serverUdt,
                localStatus: localStatus,
                locallyChangedAt: locallyChangedAt,
                id: id,
                doctorCode: doctorCode,
                doctorType: doctorType,
                firstName: firstName,
                middleName: middleName,
                lastName: lastName,
                qualification: qualification,
                speciality: speciality,
                category: category,
                potential: potential,
                supportValue: supportValue,
                expectedSupportValue: expectedSupportValue,
                phone: phone,
                email: email,
                state: state,
                city: city,
                area: area,
                country: country,
                dob: dob,
                dom: dom,
                experienceYears: experienceYears,
                chemistIds: chemistIds,
                cdt: cdt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> status = const Value.absent(),
                Value<bool> isEnabled = const Value.absent(),
                Value<String?> serverUdt = const Value.absent(),
                Value<String> localStatus = const Value.absent(),
                Value<String?> locallyChangedAt = const Value.absent(),
                required String id,
                Value<String?> doctorCode = const Value.absent(),
                Value<String?> doctorType = const Value.absent(),
                Value<String?> firstName = const Value.absent(),
                Value<String?> middleName = const Value.absent(),
                Value<String?> lastName = const Value.absent(),
                Value<String?> qualification = const Value.absent(),
                Value<String?> speciality = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<double?> potential = const Value.absent(),
                Value<double?> supportValue = const Value.absent(),
                Value<double?> expectedSupportValue = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> state = const Value.absent(),
                Value<String?> city = const Value.absent(),
                Value<String?> area = const Value.absent(),
                Value<String?> country = const Value.absent(),
                Value<String?> dob = const Value.absent(),
                Value<String?> dom = const Value.absent(),
                Value<int?> experienceYears = const Value.absent(),
                Value<String?> chemistIds = const Value.absent(),
                Value<String?> cdt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DoctorsCompanion.insert(
                status: status,
                isEnabled: isEnabled,
                serverUdt: serverUdt,
                localStatus: localStatus,
                locallyChangedAt: locallyChangedAt,
                id: id,
                doctorCode: doctorCode,
                doctorType: doctorType,
                firstName: firstName,
                middleName: middleName,
                lastName: lastName,
                qualification: qualification,
                speciality: speciality,
                category: category,
                potential: potential,
                supportValue: supportValue,
                expectedSupportValue: expectedSupportValue,
                phone: phone,
                email: email,
                state: state,
                city: city,
                area: area,
                country: country,
                dob: dob,
                dom: dom,
                experienceYears: experienceYears,
                chemistIds: chemistIds,
                cdt: cdt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DoctorsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DoctorsTable,
      Doctor,
      $$DoctorsTableFilterComposer,
      $$DoctorsTableOrderingComposer,
      $$DoctorsTableAnnotationComposer,
      $$DoctorsTableCreateCompanionBuilder,
      $$DoctorsTableUpdateCompanionBuilder,
      (Doctor, BaseReferences<_$AppDatabase, $DoctorsTable, Doctor>),
      Doctor,
      PrefetchHooks Function()
    >;
typedef $$ChemistsTableCreateCompanionBuilder =
    ChemistsCompanion Function({
      Value<String> status,
      Value<bool> isEnabled,
      Value<String?> serverUdt,
      Value<String> localStatus,
      Value<String?> locallyChangedAt,
      required String id,
      Value<String?> chemistCode,
      Value<String> fullName,
      Value<String?> phone,
      Value<String?> email,
      Value<String?> contactPersonName,
      Value<String?> contactPersonEmail,
      Value<String?> contactPersonDob,
      Value<String?> contactPersonDom,
      Value<String?> state,
      Value<String?> city,
      Value<String?> area,
      Value<String?> country,
      Value<double?> potential,
      Value<double?> supportValue,
      Value<double?> expectedSupportValue,
      Value<String?> cdt,
      Value<int> rowid,
    });
typedef $$ChemistsTableUpdateCompanionBuilder =
    ChemistsCompanion Function({
      Value<String> status,
      Value<bool> isEnabled,
      Value<String?> serverUdt,
      Value<String> localStatus,
      Value<String?> locallyChangedAt,
      Value<String> id,
      Value<String?> chemistCode,
      Value<String> fullName,
      Value<String?> phone,
      Value<String?> email,
      Value<String?> contactPersonName,
      Value<String?> contactPersonEmail,
      Value<String?> contactPersonDob,
      Value<String?> contactPersonDom,
      Value<String?> state,
      Value<String?> city,
      Value<String?> area,
      Value<String?> country,
      Value<double?> potential,
      Value<double?> supportValue,
      Value<double?> expectedSupportValue,
      Value<String?> cdt,
      Value<int> rowid,
    });

class $$ChemistsTableFilterComposer
    extends Composer<_$AppDatabase, $ChemistsTable> {
  $$ChemistsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isEnabled => $composableBuilder(
    column: $table.isEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverUdt => $composableBuilder(
    column: $table.serverUdt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localStatus => $composableBuilder(
    column: $table.localStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get locallyChangedAt => $composableBuilder(
    column: $table.locallyChangedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get chemistCode => $composableBuilder(
    column: $table.chemistCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contactPersonName => $composableBuilder(
    column: $table.contactPersonName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contactPersonEmail => $composableBuilder(
    column: $table.contactPersonEmail,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contactPersonDob => $composableBuilder(
    column: $table.contactPersonDob,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contactPersonDom => $composableBuilder(
    column: $table.contactPersonDom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get area => $composableBuilder(
    column: $table.area,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get country => $composableBuilder(
    column: $table.country,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get potential => $composableBuilder(
    column: $table.potential,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get supportValue => $composableBuilder(
    column: $table.supportValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get expectedSupportValue => $composableBuilder(
    column: $table.expectedSupportValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cdt => $composableBuilder(
    column: $table.cdt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ChemistsTableOrderingComposer
    extends Composer<_$AppDatabase, $ChemistsTable> {
  $$ChemistsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isEnabled => $composableBuilder(
    column: $table.isEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverUdt => $composableBuilder(
    column: $table.serverUdt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localStatus => $composableBuilder(
    column: $table.localStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get locallyChangedAt => $composableBuilder(
    column: $table.locallyChangedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get chemistCode => $composableBuilder(
    column: $table.chemistCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contactPersonName => $composableBuilder(
    column: $table.contactPersonName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contactPersonEmail => $composableBuilder(
    column: $table.contactPersonEmail,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contactPersonDob => $composableBuilder(
    column: $table.contactPersonDob,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contactPersonDom => $composableBuilder(
    column: $table.contactPersonDom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get area => $composableBuilder(
    column: $table.area,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get country => $composableBuilder(
    column: $table.country,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get potential => $composableBuilder(
    column: $table.potential,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get supportValue => $composableBuilder(
    column: $table.supportValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get expectedSupportValue => $composableBuilder(
    column: $table.expectedSupportValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cdt => $composableBuilder(
    column: $table.cdt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ChemistsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChemistsTable> {
  $$ChemistsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<bool> get isEnabled =>
      $composableBuilder(column: $table.isEnabled, builder: (column) => column);

  GeneratedColumn<String> get serverUdt =>
      $composableBuilder(column: $table.serverUdt, builder: (column) => column);

  GeneratedColumn<String> get localStatus => $composableBuilder(
    column: $table.localStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get locallyChangedAt => $composableBuilder(
    column: $table.locallyChangedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get chemistCode => $composableBuilder(
    column: $table.chemistCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fullName =>
      $composableBuilder(column: $table.fullName, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get contactPersonName => $composableBuilder(
    column: $table.contactPersonName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get contactPersonEmail => $composableBuilder(
    column: $table.contactPersonEmail,
    builder: (column) => column,
  );

  GeneratedColumn<String> get contactPersonDob => $composableBuilder(
    column: $table.contactPersonDob,
    builder: (column) => column,
  );

  GeneratedColumn<String> get contactPersonDom => $composableBuilder(
    column: $table.contactPersonDom,
    builder: (column) => column,
  );

  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<String> get city =>
      $composableBuilder(column: $table.city, builder: (column) => column);

  GeneratedColumn<String> get area =>
      $composableBuilder(column: $table.area, builder: (column) => column);

  GeneratedColumn<String> get country =>
      $composableBuilder(column: $table.country, builder: (column) => column);

  GeneratedColumn<double> get potential =>
      $composableBuilder(column: $table.potential, builder: (column) => column);

  GeneratedColumn<double> get supportValue => $composableBuilder(
    column: $table.supportValue,
    builder: (column) => column,
  );

  GeneratedColumn<double> get expectedSupportValue => $composableBuilder(
    column: $table.expectedSupportValue,
    builder: (column) => column,
  );

  GeneratedColumn<String> get cdt =>
      $composableBuilder(column: $table.cdt, builder: (column) => column);
}

class $$ChemistsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChemistsTable,
          Chemist,
          $$ChemistsTableFilterComposer,
          $$ChemistsTableOrderingComposer,
          $$ChemistsTableAnnotationComposer,
          $$ChemistsTableCreateCompanionBuilder,
          $$ChemistsTableUpdateCompanionBuilder,
          (Chemist, BaseReferences<_$AppDatabase, $ChemistsTable, Chemist>),
          Chemist,
          PrefetchHooks Function()
        > {
  $$ChemistsTableTableManager(_$AppDatabase db, $ChemistsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChemistsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChemistsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChemistsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> status = const Value.absent(),
                Value<bool> isEnabled = const Value.absent(),
                Value<String?> serverUdt = const Value.absent(),
                Value<String> localStatus = const Value.absent(),
                Value<String?> locallyChangedAt = const Value.absent(),
                Value<String> id = const Value.absent(),
                Value<String?> chemistCode = const Value.absent(),
                Value<String> fullName = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> contactPersonName = const Value.absent(),
                Value<String?> contactPersonEmail = const Value.absent(),
                Value<String?> contactPersonDob = const Value.absent(),
                Value<String?> contactPersonDom = const Value.absent(),
                Value<String?> state = const Value.absent(),
                Value<String?> city = const Value.absent(),
                Value<String?> area = const Value.absent(),
                Value<String?> country = const Value.absent(),
                Value<double?> potential = const Value.absent(),
                Value<double?> supportValue = const Value.absent(),
                Value<double?> expectedSupportValue = const Value.absent(),
                Value<String?> cdt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChemistsCompanion(
                status: status,
                isEnabled: isEnabled,
                serverUdt: serverUdt,
                localStatus: localStatus,
                locallyChangedAt: locallyChangedAt,
                id: id,
                chemistCode: chemistCode,
                fullName: fullName,
                phone: phone,
                email: email,
                contactPersonName: contactPersonName,
                contactPersonEmail: contactPersonEmail,
                contactPersonDob: contactPersonDob,
                contactPersonDom: contactPersonDom,
                state: state,
                city: city,
                area: area,
                country: country,
                potential: potential,
                supportValue: supportValue,
                expectedSupportValue: expectedSupportValue,
                cdt: cdt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> status = const Value.absent(),
                Value<bool> isEnabled = const Value.absent(),
                Value<String?> serverUdt = const Value.absent(),
                Value<String> localStatus = const Value.absent(),
                Value<String?> locallyChangedAt = const Value.absent(),
                required String id,
                Value<String?> chemistCode = const Value.absent(),
                Value<String> fullName = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> contactPersonName = const Value.absent(),
                Value<String?> contactPersonEmail = const Value.absent(),
                Value<String?> contactPersonDob = const Value.absent(),
                Value<String?> contactPersonDom = const Value.absent(),
                Value<String?> state = const Value.absent(),
                Value<String?> city = const Value.absent(),
                Value<String?> area = const Value.absent(),
                Value<String?> country = const Value.absent(),
                Value<double?> potential = const Value.absent(),
                Value<double?> supportValue = const Value.absent(),
                Value<double?> expectedSupportValue = const Value.absent(),
                Value<String?> cdt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChemistsCompanion.insert(
                status: status,
                isEnabled: isEnabled,
                serverUdt: serverUdt,
                localStatus: localStatus,
                locallyChangedAt: locallyChangedAt,
                id: id,
                chemistCode: chemistCode,
                fullName: fullName,
                phone: phone,
                email: email,
                contactPersonName: contactPersonName,
                contactPersonEmail: contactPersonEmail,
                contactPersonDob: contactPersonDob,
                contactPersonDom: contactPersonDom,
                state: state,
                city: city,
                area: area,
                country: country,
                potential: potential,
                supportValue: supportValue,
                expectedSupportValue: expectedSupportValue,
                cdt: cdt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ChemistsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChemistsTable,
      Chemist,
      $$ChemistsTableFilterComposer,
      $$ChemistsTableOrderingComposer,
      $$ChemistsTableAnnotationComposer,
      $$ChemistsTableCreateCompanionBuilder,
      $$ChemistsTableUpdateCompanionBuilder,
      (Chemist, BaseReferences<_$AppDatabase, $ChemistsTable, Chemist>),
      Chemist,
      PrefetchHooks Function()
    >;
typedef $$ProductsTableCreateCompanionBuilder =
    ProductsCompanion Function({
      Value<String> status,
      Value<bool> isEnabled,
      Value<String?> serverUdt,
      Value<String> localStatus,
      Value<String?> locallyChangedAt,
      required String id,
      Value<String?> productCode,
      Value<String> productName,
      Value<String?> imageUrlsJson,
      Value<String?> primaryImageUrl,
      Value<String?> productMetadataJson,
      Value<int?> displayOrder,
      Value<int> rowid,
    });
typedef $$ProductsTableUpdateCompanionBuilder =
    ProductsCompanion Function({
      Value<String> status,
      Value<bool> isEnabled,
      Value<String?> serverUdt,
      Value<String> localStatus,
      Value<String?> locallyChangedAt,
      Value<String> id,
      Value<String?> productCode,
      Value<String> productName,
      Value<String?> imageUrlsJson,
      Value<String?> primaryImageUrl,
      Value<String?> productMetadataJson,
      Value<int?> displayOrder,
      Value<int> rowid,
    });

class $$ProductsTableFilterComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isEnabled => $composableBuilder(
    column: $table.isEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverUdt => $composableBuilder(
    column: $table.serverUdt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localStatus => $composableBuilder(
    column: $table.localStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get locallyChangedAt => $composableBuilder(
    column: $table.locallyChangedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productCode => $composableBuilder(
    column: $table.productCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrlsJson => $composableBuilder(
    column: $table.imageUrlsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get primaryImageUrl => $composableBuilder(
    column: $table.primaryImageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productMetadataJson => $composableBuilder(
    column: $table.productMetadataJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProductsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isEnabled => $composableBuilder(
    column: $table.isEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverUdt => $composableBuilder(
    column: $table.serverUdt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localStatus => $composableBuilder(
    column: $table.localStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get locallyChangedAt => $composableBuilder(
    column: $table.locallyChangedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productCode => $composableBuilder(
    column: $table.productCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrlsJson => $composableBuilder(
    column: $table.imageUrlsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get primaryImageUrl => $composableBuilder(
    column: $table.primaryImageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productMetadataJson => $composableBuilder(
    column: $table.productMetadataJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProductsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<bool> get isEnabled =>
      $composableBuilder(column: $table.isEnabled, builder: (column) => column);

  GeneratedColumn<String> get serverUdt =>
      $composableBuilder(column: $table.serverUdt, builder: (column) => column);

  GeneratedColumn<String> get localStatus => $composableBuilder(
    column: $table.localStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get locallyChangedAt => $composableBuilder(
    column: $table.locallyChangedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get productCode => $composableBuilder(
    column: $table.productCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imageUrlsJson => $composableBuilder(
    column: $table.imageUrlsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get primaryImageUrl => $composableBuilder(
    column: $table.primaryImageUrl,
    builder: (column) => column,
  );

  GeneratedColumn<String> get productMetadataJson => $composableBuilder(
    column: $table.productMetadataJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => column,
  );
}

class $$ProductsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductsTable,
          Product,
          $$ProductsTableFilterComposer,
          $$ProductsTableOrderingComposer,
          $$ProductsTableAnnotationComposer,
          $$ProductsTableCreateCompanionBuilder,
          $$ProductsTableUpdateCompanionBuilder,
          (Product, BaseReferences<_$AppDatabase, $ProductsTable, Product>),
          Product,
          PrefetchHooks Function()
        > {
  $$ProductsTableTableManager(_$AppDatabase db, $ProductsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> status = const Value.absent(),
                Value<bool> isEnabled = const Value.absent(),
                Value<String?> serverUdt = const Value.absent(),
                Value<String> localStatus = const Value.absent(),
                Value<String?> locallyChangedAt = const Value.absent(),
                Value<String> id = const Value.absent(),
                Value<String?> productCode = const Value.absent(),
                Value<String> productName = const Value.absent(),
                Value<String?> imageUrlsJson = const Value.absent(),
                Value<String?> primaryImageUrl = const Value.absent(),
                Value<String?> productMetadataJson = const Value.absent(),
                Value<int?> displayOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductsCompanion(
                status: status,
                isEnabled: isEnabled,
                serverUdt: serverUdt,
                localStatus: localStatus,
                locallyChangedAt: locallyChangedAt,
                id: id,
                productCode: productCode,
                productName: productName,
                imageUrlsJson: imageUrlsJson,
                primaryImageUrl: primaryImageUrl,
                productMetadataJson: productMetadataJson,
                displayOrder: displayOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> status = const Value.absent(),
                Value<bool> isEnabled = const Value.absent(),
                Value<String?> serverUdt = const Value.absent(),
                Value<String> localStatus = const Value.absent(),
                Value<String?> locallyChangedAt = const Value.absent(),
                required String id,
                Value<String?> productCode = const Value.absent(),
                Value<String> productName = const Value.absent(),
                Value<String?> imageUrlsJson = const Value.absent(),
                Value<String?> primaryImageUrl = const Value.absent(),
                Value<String?> productMetadataJson = const Value.absent(),
                Value<int?> displayOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductsCompanion.insert(
                status: status,
                isEnabled: isEnabled,
                serverUdt: serverUdt,
                localStatus: localStatus,
                locallyChangedAt: locallyChangedAt,
                id: id,
                productCode: productCode,
                productName: productName,
                imageUrlsJson: imageUrlsJson,
                primaryImageUrl: primaryImageUrl,
                productMetadataJson: productMetadataJson,
                displayOrder: displayOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProductsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductsTable,
      Product,
      $$ProductsTableFilterComposer,
      $$ProductsTableOrderingComposer,
      $$ProductsTableAnnotationComposer,
      $$ProductsTableCreateCompanionBuilder,
      $$ProductsTableUpdateCompanionBuilder,
      (Product, BaseReferences<_$AppDatabase, $ProductsTable, Product>),
      Product,
      PrefetchHooks Function()
    >;
typedef $$DailyPlansTableCreateCompanionBuilder =
    DailyPlansCompanion Function({
      Value<String> status,
      Value<bool> isEnabled,
      Value<String?> serverUdt,
      Value<String> localStatus,
      Value<String?> locallyChangedAt,
      required String id,
      Value<String?> userId,
      required String visitDate,
      Value<int> visitStatus,
      Value<String> customerType,
      required String customerId,
      Value<bool> isTeamVisit,
      Value<String?> cdt,
      Value<int> rowid,
    });
typedef $$DailyPlansTableUpdateCompanionBuilder =
    DailyPlansCompanion Function({
      Value<String> status,
      Value<bool> isEnabled,
      Value<String?> serverUdt,
      Value<String> localStatus,
      Value<String?> locallyChangedAt,
      Value<String> id,
      Value<String?> userId,
      Value<String> visitDate,
      Value<int> visitStatus,
      Value<String> customerType,
      Value<String> customerId,
      Value<bool> isTeamVisit,
      Value<String?> cdt,
      Value<int> rowid,
    });

class $$DailyPlansTableFilterComposer
    extends Composer<_$AppDatabase, $DailyPlansTable> {
  $$DailyPlansTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isEnabled => $composableBuilder(
    column: $table.isEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverUdt => $composableBuilder(
    column: $table.serverUdt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localStatus => $composableBuilder(
    column: $table.localStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get locallyChangedAt => $composableBuilder(
    column: $table.locallyChangedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get visitDate => $composableBuilder(
    column: $table.visitDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get visitStatus => $composableBuilder(
    column: $table.visitStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customerType => $composableBuilder(
    column: $table.customerType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isTeamVisit => $composableBuilder(
    column: $table.isTeamVisit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cdt => $composableBuilder(
    column: $table.cdt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DailyPlansTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyPlansTable> {
  $$DailyPlansTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isEnabled => $composableBuilder(
    column: $table.isEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverUdt => $composableBuilder(
    column: $table.serverUdt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localStatus => $composableBuilder(
    column: $table.localStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get locallyChangedAt => $composableBuilder(
    column: $table.locallyChangedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get visitDate => $composableBuilder(
    column: $table.visitDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get visitStatus => $composableBuilder(
    column: $table.visitStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customerType => $composableBuilder(
    column: $table.customerType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isTeamVisit => $composableBuilder(
    column: $table.isTeamVisit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cdt => $composableBuilder(
    column: $table.cdt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DailyPlansTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyPlansTable> {
  $$DailyPlansTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<bool> get isEnabled =>
      $composableBuilder(column: $table.isEnabled, builder: (column) => column);

  GeneratedColumn<String> get serverUdt =>
      $composableBuilder(column: $table.serverUdt, builder: (column) => column);

  GeneratedColumn<String> get localStatus => $composableBuilder(
    column: $table.localStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get locallyChangedAt => $composableBuilder(
    column: $table.locallyChangedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get visitDate =>
      $composableBuilder(column: $table.visitDate, builder: (column) => column);

  GeneratedColumn<int> get visitStatus => $composableBuilder(
    column: $table.visitStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get customerType => $composableBuilder(
    column: $table.customerType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isTeamVisit => $composableBuilder(
    column: $table.isTeamVisit,
    builder: (column) => column,
  );

  GeneratedColumn<String> get cdt =>
      $composableBuilder(column: $table.cdt, builder: (column) => column);
}

class $$DailyPlansTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DailyPlansTable,
          DailyPlan,
          $$DailyPlansTableFilterComposer,
          $$DailyPlansTableOrderingComposer,
          $$DailyPlansTableAnnotationComposer,
          $$DailyPlansTableCreateCompanionBuilder,
          $$DailyPlansTableUpdateCompanionBuilder,
          (
            DailyPlan,
            BaseReferences<_$AppDatabase, $DailyPlansTable, DailyPlan>,
          ),
          DailyPlan,
          PrefetchHooks Function()
        > {
  $$DailyPlansTableTableManager(_$AppDatabase db, $DailyPlansTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyPlansTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyPlansTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailyPlansTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> status = const Value.absent(),
                Value<bool> isEnabled = const Value.absent(),
                Value<String?> serverUdt = const Value.absent(),
                Value<String> localStatus = const Value.absent(),
                Value<String?> locallyChangedAt = const Value.absent(),
                Value<String> id = const Value.absent(),
                Value<String?> userId = const Value.absent(),
                Value<String> visitDate = const Value.absent(),
                Value<int> visitStatus = const Value.absent(),
                Value<String> customerType = const Value.absent(),
                Value<String> customerId = const Value.absent(),
                Value<bool> isTeamVisit = const Value.absent(),
                Value<String?> cdt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailyPlansCompanion(
                status: status,
                isEnabled: isEnabled,
                serverUdt: serverUdt,
                localStatus: localStatus,
                locallyChangedAt: locallyChangedAt,
                id: id,
                userId: userId,
                visitDate: visitDate,
                visitStatus: visitStatus,
                customerType: customerType,
                customerId: customerId,
                isTeamVisit: isTeamVisit,
                cdt: cdt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> status = const Value.absent(),
                Value<bool> isEnabled = const Value.absent(),
                Value<String?> serverUdt = const Value.absent(),
                Value<String> localStatus = const Value.absent(),
                Value<String?> locallyChangedAt = const Value.absent(),
                required String id,
                Value<String?> userId = const Value.absent(),
                required String visitDate,
                Value<int> visitStatus = const Value.absent(),
                Value<String> customerType = const Value.absent(),
                required String customerId,
                Value<bool> isTeamVisit = const Value.absent(),
                Value<String?> cdt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailyPlansCompanion.insert(
                status: status,
                isEnabled: isEnabled,
                serverUdt: serverUdt,
                localStatus: localStatus,
                locallyChangedAt: locallyChangedAt,
                id: id,
                userId: userId,
                visitDate: visitDate,
                visitStatus: visitStatus,
                customerType: customerType,
                customerId: customerId,
                isTeamVisit: isTeamVisit,
                cdt: cdt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DailyPlansTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DailyPlansTable,
      DailyPlan,
      $$DailyPlansTableFilterComposer,
      $$DailyPlansTableOrderingComposer,
      $$DailyPlansTableAnnotationComposer,
      $$DailyPlansTableCreateCompanionBuilder,
      $$DailyPlansTableUpdateCompanionBuilder,
      (DailyPlan, BaseReferences<_$AppDatabase, $DailyPlansTable, DailyPlan>),
      DailyPlan,
      PrefetchHooks Function()
    >;
typedef $$DcrsTableCreateCompanionBuilder =
    DcrsCompanion Function({
      Value<String> status,
      Value<bool> isEnabled,
      Value<String?> serverUdt,
      Value<String> localStatus,
      Value<String?> locallyChangedAt,
      required String id,
      Value<String?> planId,
      Value<String?> userId,
      required String visitDatetime,
      Value<String?> remarks,
      Value<double?> supportValue,
      Value<double?> potential,
      Value<double?> expectedSupportValue,
      Value<String?> productIds,
      Value<String?> productQuantitiesJson,
      Value<String?> cdt,
      Value<int> rowid,
    });
typedef $$DcrsTableUpdateCompanionBuilder =
    DcrsCompanion Function({
      Value<String> status,
      Value<bool> isEnabled,
      Value<String?> serverUdt,
      Value<String> localStatus,
      Value<String?> locallyChangedAt,
      Value<String> id,
      Value<String?> planId,
      Value<String?> userId,
      Value<String> visitDatetime,
      Value<String?> remarks,
      Value<double?> supportValue,
      Value<double?> potential,
      Value<double?> expectedSupportValue,
      Value<String?> productIds,
      Value<String?> productQuantitiesJson,
      Value<String?> cdt,
      Value<int> rowid,
    });

class $$DcrsTableFilterComposer extends Composer<_$AppDatabase, $DcrsTable> {
  $$DcrsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isEnabled => $composableBuilder(
    column: $table.isEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverUdt => $composableBuilder(
    column: $table.serverUdt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localStatus => $composableBuilder(
    column: $table.localStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get locallyChangedAt => $composableBuilder(
    column: $table.locallyChangedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get planId => $composableBuilder(
    column: $table.planId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get visitDatetime => $composableBuilder(
    column: $table.visitDatetime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get remarks => $composableBuilder(
    column: $table.remarks,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get supportValue => $composableBuilder(
    column: $table.supportValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get potential => $composableBuilder(
    column: $table.potential,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get expectedSupportValue => $composableBuilder(
    column: $table.expectedSupportValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productIds => $composableBuilder(
    column: $table.productIds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productQuantitiesJson => $composableBuilder(
    column: $table.productQuantitiesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cdt => $composableBuilder(
    column: $table.cdt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DcrsTableOrderingComposer extends Composer<_$AppDatabase, $DcrsTable> {
  $$DcrsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isEnabled => $composableBuilder(
    column: $table.isEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverUdt => $composableBuilder(
    column: $table.serverUdt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localStatus => $composableBuilder(
    column: $table.localStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get locallyChangedAt => $composableBuilder(
    column: $table.locallyChangedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get planId => $composableBuilder(
    column: $table.planId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get visitDatetime => $composableBuilder(
    column: $table.visitDatetime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remarks => $composableBuilder(
    column: $table.remarks,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get supportValue => $composableBuilder(
    column: $table.supportValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get potential => $composableBuilder(
    column: $table.potential,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get expectedSupportValue => $composableBuilder(
    column: $table.expectedSupportValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productIds => $composableBuilder(
    column: $table.productIds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productQuantitiesJson => $composableBuilder(
    column: $table.productQuantitiesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cdt => $composableBuilder(
    column: $table.cdt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DcrsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DcrsTable> {
  $$DcrsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<bool> get isEnabled =>
      $composableBuilder(column: $table.isEnabled, builder: (column) => column);

  GeneratedColumn<String> get serverUdt =>
      $composableBuilder(column: $table.serverUdt, builder: (column) => column);

  GeneratedColumn<String> get localStatus => $composableBuilder(
    column: $table.localStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get locallyChangedAt => $composableBuilder(
    column: $table.locallyChangedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get planId =>
      $composableBuilder(column: $table.planId, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get visitDatetime => $composableBuilder(
    column: $table.visitDatetime,
    builder: (column) => column,
  );

  GeneratedColumn<String> get remarks =>
      $composableBuilder(column: $table.remarks, builder: (column) => column);

  GeneratedColumn<double> get supportValue => $composableBuilder(
    column: $table.supportValue,
    builder: (column) => column,
  );

  GeneratedColumn<double> get potential =>
      $composableBuilder(column: $table.potential, builder: (column) => column);

  GeneratedColumn<double> get expectedSupportValue => $composableBuilder(
    column: $table.expectedSupportValue,
    builder: (column) => column,
  );

  GeneratedColumn<String> get productIds => $composableBuilder(
    column: $table.productIds,
    builder: (column) => column,
  );

  GeneratedColumn<String> get productQuantitiesJson => $composableBuilder(
    column: $table.productQuantitiesJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get cdt =>
      $composableBuilder(column: $table.cdt, builder: (column) => column);
}

class $$DcrsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DcrsTable,
          Dcr,
          $$DcrsTableFilterComposer,
          $$DcrsTableOrderingComposer,
          $$DcrsTableAnnotationComposer,
          $$DcrsTableCreateCompanionBuilder,
          $$DcrsTableUpdateCompanionBuilder,
          (Dcr, BaseReferences<_$AppDatabase, $DcrsTable, Dcr>),
          Dcr,
          PrefetchHooks Function()
        > {
  $$DcrsTableTableManager(_$AppDatabase db, $DcrsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DcrsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DcrsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DcrsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> status = const Value.absent(),
                Value<bool> isEnabled = const Value.absent(),
                Value<String?> serverUdt = const Value.absent(),
                Value<String> localStatus = const Value.absent(),
                Value<String?> locallyChangedAt = const Value.absent(),
                Value<String> id = const Value.absent(),
                Value<String?> planId = const Value.absent(),
                Value<String?> userId = const Value.absent(),
                Value<String> visitDatetime = const Value.absent(),
                Value<String?> remarks = const Value.absent(),
                Value<double?> supportValue = const Value.absent(),
                Value<double?> potential = const Value.absent(),
                Value<double?> expectedSupportValue = const Value.absent(),
                Value<String?> productIds = const Value.absent(),
                Value<String?> productQuantitiesJson = const Value.absent(),
                Value<String?> cdt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DcrsCompanion(
                status: status,
                isEnabled: isEnabled,
                serverUdt: serverUdt,
                localStatus: localStatus,
                locallyChangedAt: locallyChangedAt,
                id: id,
                planId: planId,
                userId: userId,
                visitDatetime: visitDatetime,
                remarks: remarks,
                supportValue: supportValue,
                potential: potential,
                expectedSupportValue: expectedSupportValue,
                productIds: productIds,
                productQuantitiesJson: productQuantitiesJson,
                cdt: cdt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> status = const Value.absent(),
                Value<bool> isEnabled = const Value.absent(),
                Value<String?> serverUdt = const Value.absent(),
                Value<String> localStatus = const Value.absent(),
                Value<String?> locallyChangedAt = const Value.absent(),
                required String id,
                Value<String?> planId = const Value.absent(),
                Value<String?> userId = const Value.absent(),
                required String visitDatetime,
                Value<String?> remarks = const Value.absent(),
                Value<double?> supportValue = const Value.absent(),
                Value<double?> potential = const Value.absent(),
                Value<double?> expectedSupportValue = const Value.absent(),
                Value<String?> productIds = const Value.absent(),
                Value<String?> productQuantitiesJson = const Value.absent(),
                Value<String?> cdt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DcrsCompanion.insert(
                status: status,
                isEnabled: isEnabled,
                serverUdt: serverUdt,
                localStatus: localStatus,
                locallyChangedAt: locallyChangedAt,
                id: id,
                planId: planId,
                userId: userId,
                visitDatetime: visitDatetime,
                remarks: remarks,
                supportValue: supportValue,
                potential: potential,
                expectedSupportValue: expectedSupportValue,
                productIds: productIds,
                productQuantitiesJson: productQuantitiesJson,
                cdt: cdt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DcrsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DcrsTable,
      Dcr,
      $$DcrsTableFilterComposer,
      $$DcrsTableOrderingComposer,
      $$DcrsTableAnnotationComposer,
      $$DcrsTableCreateCompanionBuilder,
      $$DcrsTableUpdateCompanionBuilder,
      (Dcr, BaseReferences<_$AppDatabase, $DcrsTable, Dcr>),
      Dcr,
      PrefetchHooks Function()
    >;
typedef $$DcrProductRowsTableCreateCompanionBuilder =
    DcrProductRowsCompanion Function({
      Value<String> status,
      Value<bool> isEnabled,
      Value<String?> serverUdt,
      Value<String> localStatus,
      Value<String?> locallyChangedAt,
      required String id,
      Value<String?> dcrId,
      Value<String?> productId,
      Value<int> quantity,
      Value<String?> feedback,
      Value<int> rowid,
    });
typedef $$DcrProductRowsTableUpdateCompanionBuilder =
    DcrProductRowsCompanion Function({
      Value<String> status,
      Value<bool> isEnabled,
      Value<String?> serverUdt,
      Value<String> localStatus,
      Value<String?> locallyChangedAt,
      Value<String> id,
      Value<String?> dcrId,
      Value<String?> productId,
      Value<int> quantity,
      Value<String?> feedback,
      Value<int> rowid,
    });

class $$DcrProductRowsTableFilterComposer
    extends Composer<_$AppDatabase, $DcrProductRowsTable> {
  $$DcrProductRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isEnabled => $composableBuilder(
    column: $table.isEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverUdt => $composableBuilder(
    column: $table.serverUdt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localStatus => $composableBuilder(
    column: $table.localStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get locallyChangedAt => $composableBuilder(
    column: $table.locallyChangedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dcrId => $composableBuilder(
    column: $table.dcrId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get feedback => $composableBuilder(
    column: $table.feedback,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DcrProductRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $DcrProductRowsTable> {
  $$DcrProductRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isEnabled => $composableBuilder(
    column: $table.isEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverUdt => $composableBuilder(
    column: $table.serverUdt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localStatus => $composableBuilder(
    column: $table.localStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get locallyChangedAt => $composableBuilder(
    column: $table.locallyChangedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dcrId => $composableBuilder(
    column: $table.dcrId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get feedback => $composableBuilder(
    column: $table.feedback,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DcrProductRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DcrProductRowsTable> {
  $$DcrProductRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<bool> get isEnabled =>
      $composableBuilder(column: $table.isEnabled, builder: (column) => column);

  GeneratedColumn<String> get serverUdt =>
      $composableBuilder(column: $table.serverUdt, builder: (column) => column);

  GeneratedColumn<String> get localStatus => $composableBuilder(
    column: $table.localStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get locallyChangedAt => $composableBuilder(
    column: $table.locallyChangedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get dcrId =>
      $composableBuilder(column: $table.dcrId, builder: (column) => column);

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get feedback =>
      $composableBuilder(column: $table.feedback, builder: (column) => column);
}

class $$DcrProductRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DcrProductRowsTable,
          DcrProductRow,
          $$DcrProductRowsTableFilterComposer,
          $$DcrProductRowsTableOrderingComposer,
          $$DcrProductRowsTableAnnotationComposer,
          $$DcrProductRowsTableCreateCompanionBuilder,
          $$DcrProductRowsTableUpdateCompanionBuilder,
          (
            DcrProductRow,
            BaseReferences<_$AppDatabase, $DcrProductRowsTable, DcrProductRow>,
          ),
          DcrProductRow,
          PrefetchHooks Function()
        > {
  $$DcrProductRowsTableTableManager(
    _$AppDatabase db,
    $DcrProductRowsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DcrProductRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DcrProductRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DcrProductRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> status = const Value.absent(),
                Value<bool> isEnabled = const Value.absent(),
                Value<String?> serverUdt = const Value.absent(),
                Value<String> localStatus = const Value.absent(),
                Value<String?> locallyChangedAt = const Value.absent(),
                Value<String> id = const Value.absent(),
                Value<String?> dcrId = const Value.absent(),
                Value<String?> productId = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<String?> feedback = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DcrProductRowsCompanion(
                status: status,
                isEnabled: isEnabled,
                serverUdt: serverUdt,
                localStatus: localStatus,
                locallyChangedAt: locallyChangedAt,
                id: id,
                dcrId: dcrId,
                productId: productId,
                quantity: quantity,
                feedback: feedback,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> status = const Value.absent(),
                Value<bool> isEnabled = const Value.absent(),
                Value<String?> serverUdt = const Value.absent(),
                Value<String> localStatus = const Value.absent(),
                Value<String?> locallyChangedAt = const Value.absent(),
                required String id,
                Value<String?> dcrId = const Value.absent(),
                Value<String?> productId = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<String?> feedback = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DcrProductRowsCompanion.insert(
                status: status,
                isEnabled: isEnabled,
                serverUdt: serverUdt,
                localStatus: localStatus,
                locallyChangedAt: locallyChangedAt,
                id: id,
                dcrId: dcrId,
                productId: productId,
                quantity: quantity,
                feedback: feedback,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DcrProductRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DcrProductRowsTable,
      DcrProductRow,
      $$DcrProductRowsTableFilterComposer,
      $$DcrProductRowsTableOrderingComposer,
      $$DcrProductRowsTableAnnotationComposer,
      $$DcrProductRowsTableCreateCompanionBuilder,
      $$DcrProductRowsTableUpdateCompanionBuilder,
      (
        DcrProductRow,
        BaseReferences<_$AppDatabase, $DcrProductRowsTable, DcrProductRow>,
      ),
      DcrProductRow,
      PrefetchHooks Function()
    >;
typedef $$UsersLiteTableCreateCompanionBuilder =
    UsersLiteCompanion Function({
      required String id,
      Value<String?> employeeCode,
      Value<String?> fullName,
      Value<String?> email,
      Value<String?> phone,
      Value<String?> roleId,
      Value<String?> serverUdt,
      Value<int> rowid,
    });
typedef $$UsersLiteTableUpdateCompanionBuilder =
    UsersLiteCompanion Function({
      Value<String> id,
      Value<String?> employeeCode,
      Value<String?> fullName,
      Value<String?> email,
      Value<String?> phone,
      Value<String?> roleId,
      Value<String?> serverUdt,
      Value<int> rowid,
    });

class $$UsersLiteTableFilterComposer
    extends Composer<_$AppDatabase, $UsersLiteTable> {
  $$UsersLiteTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get employeeCode => $composableBuilder(
    column: $table.employeeCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get roleId => $composableBuilder(
    column: $table.roleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverUdt => $composableBuilder(
    column: $table.serverUdt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UsersLiteTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersLiteTable> {
  $$UsersLiteTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get employeeCode => $composableBuilder(
    column: $table.employeeCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get roleId => $composableBuilder(
    column: $table.roleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverUdt => $composableBuilder(
    column: $table.serverUdt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UsersLiteTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersLiteTable> {
  $$UsersLiteTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get employeeCode => $composableBuilder(
    column: $table.employeeCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fullName =>
      $composableBuilder(column: $table.fullName, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get roleId =>
      $composableBuilder(column: $table.roleId, builder: (column) => column);

  GeneratedColumn<String> get serverUdt =>
      $composableBuilder(column: $table.serverUdt, builder: (column) => column);
}

class $$UsersLiteTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UsersLiteTable,
          UsersLiteData,
          $$UsersLiteTableFilterComposer,
          $$UsersLiteTableOrderingComposer,
          $$UsersLiteTableAnnotationComposer,
          $$UsersLiteTableCreateCompanionBuilder,
          $$UsersLiteTableUpdateCompanionBuilder,
          (
            UsersLiteData,
            BaseReferences<_$AppDatabase, $UsersLiteTable, UsersLiteData>,
          ),
          UsersLiteData,
          PrefetchHooks Function()
        > {
  $$UsersLiteTableTableManager(_$AppDatabase db, $UsersLiteTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersLiteTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersLiteTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersLiteTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> employeeCode = const Value.absent(),
                Value<String?> fullName = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> roleId = const Value.absent(),
                Value<String?> serverUdt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersLiteCompanion(
                id: id,
                employeeCode: employeeCode,
                fullName: fullName,
                email: email,
                phone: phone,
                roleId: roleId,
                serverUdt: serverUdt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> employeeCode = const Value.absent(),
                Value<String?> fullName = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> roleId = const Value.absent(),
                Value<String?> serverUdt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersLiteCompanion.insert(
                id: id,
                employeeCode: employeeCode,
                fullName: fullName,
                email: email,
                phone: phone,
                roleId: roleId,
                serverUdt: serverUdt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UsersLiteTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UsersLiteTable,
      UsersLiteData,
      $$UsersLiteTableFilterComposer,
      $$UsersLiteTableOrderingComposer,
      $$UsersLiteTableAnnotationComposer,
      $$UsersLiteTableCreateCompanionBuilder,
      $$UsersLiteTableUpdateCompanionBuilder,
      (
        UsersLiteData,
        BaseReferences<_$AppDatabase, $UsersLiteTable, UsersLiteData>,
      ),
      UsersLiteData,
      PrefetchHooks Function()
    >;
typedef $$MetadataItemsTableCreateCompanionBuilder =
    MetadataItemsCompanion Function({
      required String kind,
      required String id,
      Value<String?> name,
      Value<bool> isEnabled,
      Value<String?> serverUdt,
      Value<int> rowid,
    });
typedef $$MetadataItemsTableUpdateCompanionBuilder =
    MetadataItemsCompanion Function({
      Value<String> kind,
      Value<String> id,
      Value<String?> name,
      Value<bool> isEnabled,
      Value<String?> serverUdt,
      Value<int> rowid,
    });

class $$MetadataItemsTableFilterComposer
    extends Composer<_$AppDatabase, $MetadataItemsTable> {
  $$MetadataItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isEnabled => $composableBuilder(
    column: $table.isEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverUdt => $composableBuilder(
    column: $table.serverUdt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MetadataItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $MetadataItemsTable> {
  $$MetadataItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isEnabled => $composableBuilder(
    column: $table.isEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverUdt => $composableBuilder(
    column: $table.serverUdt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MetadataItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MetadataItemsTable> {
  $$MetadataItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<bool> get isEnabled =>
      $composableBuilder(column: $table.isEnabled, builder: (column) => column);

  GeneratedColumn<String> get serverUdt =>
      $composableBuilder(column: $table.serverUdt, builder: (column) => column);
}

class $$MetadataItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MetadataItemsTable,
          MetadataItem,
          $$MetadataItemsTableFilterComposer,
          $$MetadataItemsTableOrderingComposer,
          $$MetadataItemsTableAnnotationComposer,
          $$MetadataItemsTableCreateCompanionBuilder,
          $$MetadataItemsTableUpdateCompanionBuilder,
          (
            MetadataItem,
            BaseReferences<_$AppDatabase, $MetadataItemsTable, MetadataItem>,
          ),
          MetadataItem,
          PrefetchHooks Function()
        > {
  $$MetadataItemsTableTableManager(_$AppDatabase db, $MetadataItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MetadataItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MetadataItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MetadataItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> kind = const Value.absent(),
                Value<String> id = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<bool> isEnabled = const Value.absent(),
                Value<String?> serverUdt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MetadataItemsCompanion(
                kind: kind,
                id: id,
                name: name,
                isEnabled: isEnabled,
                serverUdt: serverUdt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String kind,
                required String id,
                Value<String?> name = const Value.absent(),
                Value<bool> isEnabled = const Value.absent(),
                Value<String?> serverUdt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MetadataItemsCompanion.insert(
                kind: kind,
                id: id,
                name: name,
                isEnabled: isEnabled,
                serverUdt: serverUdt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MetadataItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MetadataItemsTable,
      MetadataItem,
      $$MetadataItemsTableFilterComposer,
      $$MetadataItemsTableOrderingComposer,
      $$MetadataItemsTableAnnotationComposer,
      $$MetadataItemsTableCreateCompanionBuilder,
      $$MetadataItemsTableUpdateCompanionBuilder,
      (
        MetadataItem,
        BaseReferences<_$AppDatabase, $MetadataItemsTable, MetadataItem>,
      ),
      MetadataItem,
      PrefetchHooks Function()
    >;
typedef $$OutboxOpsTableCreateCompanionBuilder =
    OutboxOpsCompanion Function({
      Value<int> seq,
      required String mutationId,
      required String entity,
      required String entityId,
      required String op,
      required String payloadJson,
      Value<String?> baseServerUdt,
      required String clientChangedAt,
      Value<int> attempts,
      Value<String?> lastError,
      Value<String> state,
    });
typedef $$OutboxOpsTableUpdateCompanionBuilder =
    OutboxOpsCompanion Function({
      Value<int> seq,
      Value<String> mutationId,
      Value<String> entity,
      Value<String> entityId,
      Value<String> op,
      Value<String> payloadJson,
      Value<String?> baseServerUdt,
      Value<String> clientChangedAt,
      Value<int> attempts,
      Value<String?> lastError,
      Value<String> state,
    });

class $$OutboxOpsTableFilterComposer
    extends Composer<_$AppDatabase, $OutboxOpsTable> {
  $$OutboxOpsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get seq => $composableBuilder(
    column: $table.seq,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mutationId => $composableBuilder(
    column: $table.mutationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entity => $composableBuilder(
    column: $table.entity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get op => $composableBuilder(
    column: $table.op,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get baseServerUdt => $composableBuilder(
    column: $table.baseServerUdt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clientChangedAt => $composableBuilder(
    column: $table.clientChangedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OutboxOpsTableOrderingComposer
    extends Composer<_$AppDatabase, $OutboxOpsTable> {
  $$OutboxOpsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get seq => $composableBuilder(
    column: $table.seq,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mutationId => $composableBuilder(
    column: $table.mutationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entity => $composableBuilder(
    column: $table.entity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get op => $composableBuilder(
    column: $table.op,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get baseServerUdt => $composableBuilder(
    column: $table.baseServerUdt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clientChangedAt => $composableBuilder(
    column: $table.clientChangedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OutboxOpsTableAnnotationComposer
    extends Composer<_$AppDatabase, $OutboxOpsTable> {
  $$OutboxOpsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get seq =>
      $composableBuilder(column: $table.seq, builder: (column) => column);

  GeneratedColumn<String> get mutationId => $composableBuilder(
    column: $table.mutationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entity =>
      $composableBuilder(column: $table.entity, builder: (column) => column);

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get op =>
      $composableBuilder(column: $table.op, builder: (column) => column);

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get baseServerUdt => $composableBuilder(
    column: $table.baseServerUdt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get clientChangedAt => $composableBuilder(
    column: $table.clientChangedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => column);

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);

  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);
}

class $$OutboxOpsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OutboxOpsTable,
          OutboxOp,
          $$OutboxOpsTableFilterComposer,
          $$OutboxOpsTableOrderingComposer,
          $$OutboxOpsTableAnnotationComposer,
          $$OutboxOpsTableCreateCompanionBuilder,
          $$OutboxOpsTableUpdateCompanionBuilder,
          (OutboxOp, BaseReferences<_$AppDatabase, $OutboxOpsTable, OutboxOp>),
          OutboxOp,
          PrefetchHooks Function()
        > {
  $$OutboxOpsTableTableManager(_$AppDatabase db, $OutboxOpsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OutboxOpsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OutboxOpsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OutboxOpsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> seq = const Value.absent(),
                Value<String> mutationId = const Value.absent(),
                Value<String> entity = const Value.absent(),
                Value<String> entityId = const Value.absent(),
                Value<String> op = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
                Value<String?> baseServerUdt = const Value.absent(),
                Value<String> clientChangedAt = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<String> state = const Value.absent(),
              }) => OutboxOpsCompanion(
                seq: seq,
                mutationId: mutationId,
                entity: entity,
                entityId: entityId,
                op: op,
                payloadJson: payloadJson,
                baseServerUdt: baseServerUdt,
                clientChangedAt: clientChangedAt,
                attempts: attempts,
                lastError: lastError,
                state: state,
              ),
          createCompanionCallback:
              ({
                Value<int> seq = const Value.absent(),
                required String mutationId,
                required String entity,
                required String entityId,
                required String op,
                required String payloadJson,
                Value<String?> baseServerUdt = const Value.absent(),
                required String clientChangedAt,
                Value<int> attempts = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<String> state = const Value.absent(),
              }) => OutboxOpsCompanion.insert(
                seq: seq,
                mutationId: mutationId,
                entity: entity,
                entityId: entityId,
                op: op,
                payloadJson: payloadJson,
                baseServerUdt: baseServerUdt,
                clientChangedAt: clientChangedAt,
                attempts: attempts,
                lastError: lastError,
                state: state,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OutboxOpsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OutboxOpsTable,
      OutboxOp,
      $$OutboxOpsTableFilterComposer,
      $$OutboxOpsTableOrderingComposer,
      $$OutboxOpsTableAnnotationComposer,
      $$OutboxOpsTableCreateCompanionBuilder,
      $$OutboxOpsTableUpdateCompanionBuilder,
      (OutboxOp, BaseReferences<_$AppDatabase, $OutboxOpsTable, OutboxOp>),
      OutboxOp,
      PrefetchHooks Function()
    >;
typedef $$SyncCursorsTableCreateCompanionBuilder =
    SyncCursorsCompanion Function({
      required String entity,
      Value<String?> cursor,
      Value<String?> lastPulledAt,
      Value<int> rowid,
    });
typedef $$SyncCursorsTableUpdateCompanionBuilder =
    SyncCursorsCompanion Function({
      Value<String> entity,
      Value<String?> cursor,
      Value<String?> lastPulledAt,
      Value<int> rowid,
    });

class $$SyncCursorsTableFilterComposer
    extends Composer<_$AppDatabase, $SyncCursorsTable> {
  $$SyncCursorsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get entity => $composableBuilder(
    column: $table.entity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cursor => $composableBuilder(
    column: $table.cursor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastPulledAt => $composableBuilder(
    column: $table.lastPulledAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncCursorsTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncCursorsTable> {
  $$SyncCursorsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get entity => $composableBuilder(
    column: $table.entity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cursor => $composableBuilder(
    column: $table.cursor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastPulledAt => $composableBuilder(
    column: $table.lastPulledAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncCursorsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncCursorsTable> {
  $$SyncCursorsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get entity =>
      $composableBuilder(column: $table.entity, builder: (column) => column);

  GeneratedColumn<String> get cursor =>
      $composableBuilder(column: $table.cursor, builder: (column) => column);

  GeneratedColumn<String> get lastPulledAt => $composableBuilder(
    column: $table.lastPulledAt,
    builder: (column) => column,
  );
}

class $$SyncCursorsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncCursorsTable,
          SyncCursor,
          $$SyncCursorsTableFilterComposer,
          $$SyncCursorsTableOrderingComposer,
          $$SyncCursorsTableAnnotationComposer,
          $$SyncCursorsTableCreateCompanionBuilder,
          $$SyncCursorsTableUpdateCompanionBuilder,
          (
            SyncCursor,
            BaseReferences<_$AppDatabase, $SyncCursorsTable, SyncCursor>,
          ),
          SyncCursor,
          PrefetchHooks Function()
        > {
  $$SyncCursorsTableTableManager(_$AppDatabase db, $SyncCursorsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncCursorsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncCursorsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncCursorsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> entity = const Value.absent(),
                Value<String?> cursor = const Value.absent(),
                Value<String?> lastPulledAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncCursorsCompanion(
                entity: entity,
                cursor: cursor,
                lastPulledAt: lastPulledAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String entity,
                Value<String?> cursor = const Value.absent(),
                Value<String?> lastPulledAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncCursorsCompanion.insert(
                entity: entity,
                cursor: cursor,
                lastPulledAt: lastPulledAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncCursorsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncCursorsTable,
      SyncCursor,
      $$SyncCursorsTableFilterComposer,
      $$SyncCursorsTableOrderingComposer,
      $$SyncCursorsTableAnnotationComposer,
      $$SyncCursorsTableCreateCompanionBuilder,
      $$SyncCursorsTableUpdateCompanionBuilder,
      (
        SyncCursor,
        BaseReferences<_$AppDatabase, $SyncCursorsTable, SyncCursor>,
      ),
      SyncCursor,
      PrefetchHooks Function()
    >;
typedef $$MediaCacheEntriesTableCreateCompanionBuilder =
    MediaCacheEntriesCompanion Function({
      required String objectKey,
      Value<String?> entity,
      Value<String?> entityId,
      Value<String?> localPath,
      Value<String> state,
      Value<String?> fetchedAt,
      Value<int> rowid,
    });
typedef $$MediaCacheEntriesTableUpdateCompanionBuilder =
    MediaCacheEntriesCompanion Function({
      Value<String> objectKey,
      Value<String?> entity,
      Value<String?> entityId,
      Value<String?> localPath,
      Value<String> state,
      Value<String?> fetchedAt,
      Value<int> rowid,
    });

class $$MediaCacheEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $MediaCacheEntriesTable> {
  $$MediaCacheEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get objectKey => $composableBuilder(
    column: $table.objectKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entity => $composableBuilder(
    column: $table.entity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localPath => $composableBuilder(
    column: $table.localPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MediaCacheEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $MediaCacheEntriesTable> {
  $$MediaCacheEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get objectKey => $composableBuilder(
    column: $table.objectKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entity => $composableBuilder(
    column: $table.entity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localPath => $composableBuilder(
    column: $table.localPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MediaCacheEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MediaCacheEntriesTable> {
  $$MediaCacheEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get objectKey =>
      $composableBuilder(column: $table.objectKey, builder: (column) => column);

  GeneratedColumn<String> get entity =>
      $composableBuilder(column: $table.entity, builder: (column) => column);

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get localPath =>
      $composableBuilder(column: $table.localPath, builder: (column) => column);

  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<String> get fetchedAt =>
      $composableBuilder(column: $table.fetchedAt, builder: (column) => column);
}

class $$MediaCacheEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MediaCacheEntriesTable,
          MediaCacheEntry,
          $$MediaCacheEntriesTableFilterComposer,
          $$MediaCacheEntriesTableOrderingComposer,
          $$MediaCacheEntriesTableAnnotationComposer,
          $$MediaCacheEntriesTableCreateCompanionBuilder,
          $$MediaCacheEntriesTableUpdateCompanionBuilder,
          (
            MediaCacheEntry,
            BaseReferences<
              _$AppDatabase,
              $MediaCacheEntriesTable,
              MediaCacheEntry
            >,
          ),
          MediaCacheEntry,
          PrefetchHooks Function()
        > {
  $$MediaCacheEntriesTableTableManager(
    _$AppDatabase db,
    $MediaCacheEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MediaCacheEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MediaCacheEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MediaCacheEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> objectKey = const Value.absent(),
                Value<String?> entity = const Value.absent(),
                Value<String?> entityId = const Value.absent(),
                Value<String?> localPath = const Value.absent(),
                Value<String> state = const Value.absent(),
                Value<String?> fetchedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MediaCacheEntriesCompanion(
                objectKey: objectKey,
                entity: entity,
                entityId: entityId,
                localPath: localPath,
                state: state,
                fetchedAt: fetchedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String objectKey,
                Value<String?> entity = const Value.absent(),
                Value<String?> entityId = const Value.absent(),
                Value<String?> localPath = const Value.absent(),
                Value<String> state = const Value.absent(),
                Value<String?> fetchedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MediaCacheEntriesCompanion.insert(
                objectKey: objectKey,
                entity: entity,
                entityId: entityId,
                localPath: localPath,
                state: state,
                fetchedAt: fetchedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MediaCacheEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MediaCacheEntriesTable,
      MediaCacheEntry,
      $$MediaCacheEntriesTableFilterComposer,
      $$MediaCacheEntriesTableOrderingComposer,
      $$MediaCacheEntriesTableAnnotationComposer,
      $$MediaCacheEntriesTableCreateCompanionBuilder,
      $$MediaCacheEntriesTableUpdateCompanionBuilder,
      (
        MediaCacheEntry,
        BaseReferences<_$AppDatabase, $MediaCacheEntriesTable, MediaCacheEntry>,
      ),
      MediaCacheEntry,
      PrefetchHooks Function()
    >;
typedef $$SyncConflictsTableCreateCompanionBuilder =
    SyncConflictsCompanion Function({
      required String mutationId,
      required String entity,
      required String entityId,
      Value<String?> reason,
      Value<String?> clientPayloadJson,
      Value<String?> serverRowJson,
      required String createdAt,
      Value<bool> resolved,
      Value<int> rowid,
    });
typedef $$SyncConflictsTableUpdateCompanionBuilder =
    SyncConflictsCompanion Function({
      Value<String> mutationId,
      Value<String> entity,
      Value<String> entityId,
      Value<String?> reason,
      Value<String?> clientPayloadJson,
      Value<String?> serverRowJson,
      Value<String> createdAt,
      Value<bool> resolved,
      Value<int> rowid,
    });

class $$SyncConflictsTableFilterComposer
    extends Composer<_$AppDatabase, $SyncConflictsTable> {
  $$SyncConflictsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get mutationId => $composableBuilder(
    column: $table.mutationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entity => $composableBuilder(
    column: $table.entity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clientPayloadJson => $composableBuilder(
    column: $table.clientPayloadJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverRowJson => $composableBuilder(
    column: $table.serverRowJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get resolved => $composableBuilder(
    column: $table.resolved,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncConflictsTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncConflictsTable> {
  $$SyncConflictsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get mutationId => $composableBuilder(
    column: $table.mutationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entity => $composableBuilder(
    column: $table.entity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clientPayloadJson => $composableBuilder(
    column: $table.clientPayloadJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverRowJson => $composableBuilder(
    column: $table.serverRowJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get resolved => $composableBuilder(
    column: $table.resolved,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncConflictsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncConflictsTable> {
  $$SyncConflictsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get mutationId => $composableBuilder(
    column: $table.mutationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entity =>
      $composableBuilder(column: $table.entity, builder: (column) => column);

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<String> get clientPayloadJson => $composableBuilder(
    column: $table.clientPayloadJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get serverRowJson => $composableBuilder(
    column: $table.serverRowJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get resolved =>
      $composableBuilder(column: $table.resolved, builder: (column) => column);
}

class $$SyncConflictsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncConflictsTable,
          SyncConflict,
          $$SyncConflictsTableFilterComposer,
          $$SyncConflictsTableOrderingComposer,
          $$SyncConflictsTableAnnotationComposer,
          $$SyncConflictsTableCreateCompanionBuilder,
          $$SyncConflictsTableUpdateCompanionBuilder,
          (
            SyncConflict,
            BaseReferences<_$AppDatabase, $SyncConflictsTable, SyncConflict>,
          ),
          SyncConflict,
          PrefetchHooks Function()
        > {
  $$SyncConflictsTableTableManager(_$AppDatabase db, $SyncConflictsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncConflictsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncConflictsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncConflictsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> mutationId = const Value.absent(),
                Value<String> entity = const Value.absent(),
                Value<String> entityId = const Value.absent(),
                Value<String?> reason = const Value.absent(),
                Value<String?> clientPayloadJson = const Value.absent(),
                Value<String?> serverRowJson = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<bool> resolved = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncConflictsCompanion(
                mutationId: mutationId,
                entity: entity,
                entityId: entityId,
                reason: reason,
                clientPayloadJson: clientPayloadJson,
                serverRowJson: serverRowJson,
                createdAt: createdAt,
                resolved: resolved,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String mutationId,
                required String entity,
                required String entityId,
                Value<String?> reason = const Value.absent(),
                Value<String?> clientPayloadJson = const Value.absent(),
                Value<String?> serverRowJson = const Value.absent(),
                required String createdAt,
                Value<bool> resolved = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncConflictsCompanion.insert(
                mutationId: mutationId,
                entity: entity,
                entityId: entityId,
                reason: reason,
                clientPayloadJson: clientPayloadJson,
                serverRowJson: serverRowJson,
                createdAt: createdAt,
                resolved: resolved,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncConflictsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncConflictsTable,
      SyncConflict,
      $$SyncConflictsTableFilterComposer,
      $$SyncConflictsTableOrderingComposer,
      $$SyncConflictsTableAnnotationComposer,
      $$SyncConflictsTableCreateCompanionBuilder,
      $$SyncConflictsTableUpdateCompanionBuilder,
      (
        SyncConflict,
        BaseReferences<_$AppDatabase, $SyncConflictsTable, SyncConflict>,
      ),
      SyncConflict,
      PrefetchHooks Function()
    >;
typedef $$PresentationRecordsTableCreateCompanionBuilder =
    PresentationRecordsCompanion Function({
      required String id,
      required String customerType,
      required String customerId,
      required String shownAt,
      required String productIdsJson,
      Value<int> rowid,
    });
typedef $$PresentationRecordsTableUpdateCompanionBuilder =
    PresentationRecordsCompanion Function({
      Value<String> id,
      Value<String> customerType,
      Value<String> customerId,
      Value<String> shownAt,
      Value<String> productIdsJson,
      Value<int> rowid,
    });

class $$PresentationRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $PresentationRecordsTable> {
  $$PresentationRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customerType => $composableBuilder(
    column: $table.customerType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get shownAt => $composableBuilder(
    column: $table.shownAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productIdsJson => $composableBuilder(
    column: $table.productIdsJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PresentationRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $PresentationRecordsTable> {
  $$PresentationRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customerType => $composableBuilder(
    column: $table.customerType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get shownAt => $composableBuilder(
    column: $table.shownAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productIdsJson => $composableBuilder(
    column: $table.productIdsJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PresentationRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PresentationRecordsTable> {
  $$PresentationRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get customerType => $composableBuilder(
    column: $table.customerType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get shownAt =>
      $composableBuilder(column: $table.shownAt, builder: (column) => column);

  GeneratedColumn<String> get productIdsJson => $composableBuilder(
    column: $table.productIdsJson,
    builder: (column) => column,
  );
}

class $$PresentationRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PresentationRecordsTable,
          PresentationRecord,
          $$PresentationRecordsTableFilterComposer,
          $$PresentationRecordsTableOrderingComposer,
          $$PresentationRecordsTableAnnotationComposer,
          $$PresentationRecordsTableCreateCompanionBuilder,
          $$PresentationRecordsTableUpdateCompanionBuilder,
          (
            PresentationRecord,
            BaseReferences<
              _$AppDatabase,
              $PresentationRecordsTable,
              PresentationRecord
            >,
          ),
          PresentationRecord,
          PrefetchHooks Function()
        > {
  $$PresentationRecordsTableTableManager(
    _$AppDatabase db,
    $PresentationRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PresentationRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PresentationRecordsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$PresentationRecordsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> customerType = const Value.absent(),
                Value<String> customerId = const Value.absent(),
                Value<String> shownAt = const Value.absent(),
                Value<String> productIdsJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PresentationRecordsCompanion(
                id: id,
                customerType: customerType,
                customerId: customerId,
                shownAt: shownAt,
                productIdsJson: productIdsJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String customerType,
                required String customerId,
                required String shownAt,
                required String productIdsJson,
                Value<int> rowid = const Value.absent(),
              }) => PresentationRecordsCompanion.insert(
                id: id,
                customerType: customerType,
                customerId: customerId,
                shownAt: shownAt,
                productIdsJson: productIdsJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PresentationRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PresentationRecordsTable,
      PresentationRecord,
      $$PresentationRecordsTableFilterComposer,
      $$PresentationRecordsTableOrderingComposer,
      $$PresentationRecordsTableAnnotationComposer,
      $$PresentationRecordsTableCreateCompanionBuilder,
      $$PresentationRecordsTableUpdateCompanionBuilder,
      (
        PresentationRecord,
        BaseReferences<
          _$AppDatabase,
          $PresentationRecordsTable,
          PresentationRecord
        >,
      ),
      PresentationRecord,
      PrefetchHooks Function()
    >;
typedef $$KvEntriesTableCreateCompanionBuilder =
    KvEntriesCompanion Function({
      required String key,
      Value<String?> value,
      Value<int> rowid,
    });
typedef $$KvEntriesTableUpdateCompanionBuilder =
    KvEntriesCompanion Function({
      Value<String> key,
      Value<String?> value,
      Value<int> rowid,
    });

class $$KvEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $KvEntriesTable> {
  $$KvEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$KvEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $KvEntriesTable> {
  $$KvEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$KvEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $KvEntriesTable> {
  $$KvEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$KvEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $KvEntriesTable,
          KvEntry,
          $$KvEntriesTableFilterComposer,
          $$KvEntriesTableOrderingComposer,
          $$KvEntriesTableAnnotationComposer,
          $$KvEntriesTableCreateCompanionBuilder,
          $$KvEntriesTableUpdateCompanionBuilder,
          (KvEntry, BaseReferences<_$AppDatabase, $KvEntriesTable, KvEntry>),
          KvEntry,
          PrefetchHooks Function()
        > {
  $$KvEntriesTableTableManager(_$AppDatabase db, $KvEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$KvEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$KvEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$KvEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String?> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => KvEntriesCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                Value<String?> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => KvEntriesCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$KvEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $KvEntriesTable,
      KvEntry,
      $$KvEntriesTableFilterComposer,
      $$KvEntriesTableOrderingComposer,
      $$KvEntriesTableAnnotationComposer,
      $$KvEntriesTableCreateCompanionBuilder,
      $$KvEntriesTableUpdateCompanionBuilder,
      (KvEntry, BaseReferences<_$AppDatabase, $KvEntriesTable, KvEntry>),
      KvEntry,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$DoctorsTableTableManager get doctors =>
      $$DoctorsTableTableManager(_db, _db.doctors);
  $$ChemistsTableTableManager get chemists =>
      $$ChemistsTableTableManager(_db, _db.chemists);
  $$ProductsTableTableManager get products =>
      $$ProductsTableTableManager(_db, _db.products);
  $$DailyPlansTableTableManager get dailyPlans =>
      $$DailyPlansTableTableManager(_db, _db.dailyPlans);
  $$DcrsTableTableManager get dcrs => $$DcrsTableTableManager(_db, _db.dcrs);
  $$DcrProductRowsTableTableManager get dcrProductRows =>
      $$DcrProductRowsTableTableManager(_db, _db.dcrProductRows);
  $$UsersLiteTableTableManager get usersLite =>
      $$UsersLiteTableTableManager(_db, _db.usersLite);
  $$MetadataItemsTableTableManager get metadataItems =>
      $$MetadataItemsTableTableManager(_db, _db.metadataItems);
  $$OutboxOpsTableTableManager get outboxOps =>
      $$OutboxOpsTableTableManager(_db, _db.outboxOps);
  $$SyncCursorsTableTableManager get syncCursors =>
      $$SyncCursorsTableTableManager(_db, _db.syncCursors);
  $$MediaCacheEntriesTableTableManager get mediaCacheEntries =>
      $$MediaCacheEntriesTableTableManager(_db, _db.mediaCacheEntries);
  $$SyncConflictsTableTableManager get syncConflicts =>
      $$SyncConflictsTableTableManager(_db, _db.syncConflicts);
  $$PresentationRecordsTableTableManager get presentationRecords =>
      $$PresentationRecordsTableTableManager(_db, _db.presentationRecords);
  $$KvEntriesTableTableManager get kvEntries =>
      $$KvEntriesTableTableManager(_db, _db.kvEntries);
}
