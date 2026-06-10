import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'package:vivocure/core/db/app_database.dart';
import 'package:vivocure/core/sync/outbox_service.dart';
import 'package:vivocure/data/repositories/sync_triggers.dart';

/// Local-first doctor data access. Reads come from Drift; writes update Drift
/// and enqueue an outbox op in the same transaction. No network calls here.
class DoctorRepository {
  DoctorRepository(this._db) : _outbox = OutboxService(_db);

  final AppDatabase _db;
  final OutboxService _outbox;

  // ------------------------------------------------------------------ reads

  Future<List<Doctor>> searchDoctors({
    String? searchText,
    int limit = 50,
    int offset = 0,
  }) {
    final query = _db.select(_db.doctors)
      ..where((t) => t.isEnabled.equals(true));
    final String? needle = searchText?.trim();
    if (needle != null && needle.isNotEmpty) {
      final String like = '%$needle%';
      query.where((t) =>
          t.firstName.like(like) |
          t.middleName.like(like) |
          t.lastName.like(like) |
          t.doctorCode.like(like) |
          t.speciality.like(like) |
          t.qualification.like(like) |
          t.phone.like(like) |
          t.email.like(like) |
          t.city.like(like) |
          t.area.like(like) |
          t.state.like(like));
    }
    query
      ..orderBy([(t) => OrderingTerm.desc(t.cdt)])
      ..limit(limit, offset: offset);
    return query.get();
  }

  Stream<List<Doctor>> watchDoctors() => (_db.select(_db.doctors)
        ..where((t) => t.isEnabled.equals(true))
        ..orderBy([(t) => OrderingTerm.desc(t.cdt)]))
      .watch();

  Future<Doctor?> getById(String id) =>
      (_db.select(_db.doctors)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<List<Doctor>> byIds(List<String> ids) => ids.isEmpty
      ? Future.value(<Doctor>[])
      : (_db.select(_db.doctors)..where((t) => t.id.isIn(ids))).get();

  /// Options for plan creation / linking, shaped like the old dropdown API.
  Future<List<Doctor>> dropdownOptions() => (_db.select(_db.doctors)
        ..where((t) => t.isEnabled.equals(true))
        ..orderBy([(t) => OrderingTerm.asc(t.firstName)]))
      .get();

  // ----------------------------------------------------------------- writes

  /// Creates a doctor locally with a client-minted UUIDv7. The business code
  /// stays null (UI shows "PENDING") until the first successful push returns
  /// the server-assigned DA#### code.
  Future<String> createDoctor(Map<String, dynamic> fields) async {
    final String id = const Uuid().v7();
    final String now = DateTime.now().toUtc().toIso8601String();
    await _db.transaction(() async {
      await _db.into(_db.doctors).insert(DoctorsCompanion.insert(
            id: id,
            doctorType: Value(fields['doctor_type'] as String? ?? 'PRESCRIBER'),
            firstName: Value(fields['first_name'] as String?),
            middleName: Value(fields['middle_name'] as String?),
            lastName: Value(fields['last_name'] as String?),
            qualification: Value(fields['qualification'] as String?),
            speciality: Value(fields['speciality'] as String?),
            category: Value(fields['category'] as String?),
            potential: Value(_d(fields['potential'])),
            supportValue: Value(_d(fields['support_value'])),
            expectedSupportValue: Value(_d(fields['expected_support_value'])),
            phone: Value(fields['phone'] as String?),
            email: Value(fields['email'] as String?),
            state: Value(fields['state'] as String?),
            city: Value(fields['city'] as String?),
            area: Value(fields['area'] as String?),
            country: Value(fields['country'] as String?),
            dob: Value(fields['dob'] as String?),
            dom: Value(fields['dom'] as String?),
            experienceYears: Value(_i(fields['experience_years'])),
            chemistIds: Value(fields['chemist_ids'] as String?),
            cdt: Value(now),
            localStatus: const Value('pending_create'),
            locallyChangedAt: Value(now),
          ));
      await _outbox.enqueue(
        entity: 'doctors',
        entityId: id,
        op: 'create',
        payload: fields,
      );
    });
    SyncTriggers.mutated();
    return id;
  }

  Future<void> updateDoctor(String id, Map<String, dynamic> fields) async {
    final Doctor? existing = await getById(id);
    if (existing == null) {
      throw StateError('Doctor not found locally: $id');
    }
    final String now = DateTime.now().toUtc().toIso8601String();
    await _db.transaction(() async {
      await (_db.update(_db.doctors)..where((t) => t.id.equals(id)))
          .write(DoctorsCompanion(
        doctorType: _sv(fields, 'doctor_type'),
        firstName: _sv(fields, 'first_name'),
        middleName: _sv(fields, 'middle_name'),
        lastName: _sv(fields, 'last_name'),
        qualification: _sv(fields, 'qualification'),
        speciality: _sv(fields, 'speciality'),
        category: _sv(fields, 'category'),
        potential: fields.containsKey('potential')
            ? Value(_d(fields['potential']))
            : const Value.absent(),
        supportValue: fields.containsKey('support_value')
            ? Value(_d(fields['support_value']))
            : const Value.absent(),
        expectedSupportValue: fields.containsKey('expected_support_value')
            ? Value(_d(fields['expected_support_value']))
            : const Value.absent(),
        phone: _sv(fields, 'phone'),
        email: _sv(fields, 'email'),
        state: _sv(fields, 'state'),
        city: _sv(fields, 'city'),
        area: _sv(fields, 'area'),
        country: _sv(fields, 'country'),
        dob: _sv(fields, 'dob'),
        dom: _sv(fields, 'dom'),
        experienceYears: fields.containsKey('experience_years')
            ? Value(_i(fields['experience_years']))
            : const Value.absent(),
        chemistIds: _sv(fields, 'chemist_ids'),
        localStatus: Value(existing.localStatus == 'pending_create'
            ? 'pending_create'
            : 'pending_update'),
        locallyChangedAt: Value(now),
      ));
      final Doctor updated = (await getById(id))!;
      await _outbox.enqueue(
        entity: 'doctors',
        entityId: id,
        op: existing.localStatus == 'pending_create' ? 'create' : 'update',
        payload: _fullPayload(updated),
        baseServerUdt: existing.serverUdt,
      );
    });
    SyncTriggers.mutated();
  }

  Future<void> deleteDoctor(String id) async {
    final Doctor? existing = await getById(id);
    if (existing == null) {
      return;
    }
    await _db.transaction(() async {
      await (_db.update(_db.doctors)..where((t) => t.id.equals(id)))
          .write(const DoctorsCompanion(
        isEnabled: Value(false),
        status: Value('deleted'),
        localStatus: Value('pending_delete'),
      ));
      await _outbox.enqueue(
        entity: 'doctors',
        entityId: id,
        op: 'delete',
        payload: const <String, dynamic>{},
        baseServerUdt: existing.serverUdt,
      );
      if (existing.localStatus == 'pending_create') {
        // Never reached the server: outbox coalescing removed both ops; the
        // local tombstone row can go entirely.
        await (_db.delete(_db.doctors)..where((t) => t.id.equals(id))).go();
      }
    });
    SyncTriggers.mutated();
  }

  /// Full server-field payload for outbox coalescing (state-based push).
  Map<String, dynamic> _fullPayload(Doctor d) => <String, dynamic>{
        'doctor_type': d.doctorType,
        'first_name': d.firstName,
        'middle_name': d.middleName,
        'last_name': d.lastName,
        'qualification': d.qualification,
        'speciality': d.speciality,
        'category': d.category,
        'potential': d.potential,
        'support_value': d.supportValue,
        'expected_support_value': d.expectedSupportValue,
        'phone': d.phone,
        'email': d.email,
        'state': d.state,
        'city': d.city,
        'area': d.area,
        'country': d.country,
        'dob': d.dob,
        'dom': d.dom,
        'experience_years': d.experienceYears,
        'chemist_ids': d.chemistIds,
      };

  static double? _d(dynamic v) =>
      v == null ? null : (v is num ? v.toDouble() : double.tryParse('$v'));
  static int? _i(dynamic v) =>
      v == null ? null : (v is num ? v.toInt() : int.tryParse('$v'));
  static Value<String?> _sv(Map<String, dynamic> fields, String key) =>
      fields.containsKey(key)
          ? Value(fields[key] as String?)
          : const Value.absent();
}
