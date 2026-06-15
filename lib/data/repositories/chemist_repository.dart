import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'package:vivocure/core/db/app_database.dart';
import 'package:vivocure/core/sync/outbox_service.dart';
import 'package:vivocure/data/repositories/sync_triggers.dart';

/// Local-first chemist data access (same contract as DoctorRepository).
class ChemistRepository {
  ChemistRepository(this._db) : _outbox = OutboxService(_db);

  final AppDatabase _db;
  final OutboxService _outbox;

  Future<List<Chemist>> searchChemists({
    String? searchText,
    int limit = 50,
    int offset = 0,
  }) {
    final query = _db.select(_db.chemists)
      ..where((t) => t.isEnabled.equals(true));
    final String? needle = searchText?.trim();
    if (needle != null && needle.isNotEmpty) {
      final String like = '%$needle%';
      query.where(
        (t) =>
            t.fullName.like(like) |
            t.chemistCode.like(like) |
            t.phone.like(like) |
            t.email.like(like) |
            t.contactPersonName.like(like) |
            t.city.like(like) |
            t.area.like(like) |
            t.state.like(like),
      );
    }
    query
      ..orderBy([(t) => OrderingTerm.desc(t.cdt)])
      ..limit(limit, offset: offset);
    return query.get();
  }

  Stream<List<Chemist>> watchChemists() =>
      (_db.select(_db.chemists)
            ..where((t) => t.isEnabled.equals(true))
            ..orderBy([(t) => OrderingTerm.desc(t.cdt)]))
          .watch();

  Future<Chemist?> getById(String id) => (_db.select(
    _db.chemists,
  )..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<Chemist>> byIds(List<String> ids) => ids.isEmpty
      ? Future.value(<Chemist>[])
      : (_db.select(_db.chemists)..where((t) => t.id.isIn(ids))).get();

  Future<List<Chemist>> dropdownOptions() =>
      (_db.select(_db.chemists)
            ..where((t) => t.isEnabled.equals(true))
            ..orderBy([(t) => OrderingTerm.asc(t.fullName)]))
          .get();

  Future<String> createChemist(Map<String, dynamic> fields) async {
    final String id = const Uuid().v7();
    final String now = DateTime.now().toUtc().toIso8601String();
    await _db.transaction(() async {
      await _db
          .into(_db.chemists)
          .insert(
            ChemistsCompanion.insert(
              id: id,
              fullName: Value((fields['full_name'] ?? '') as String),
              phone: Value(fields['phone'] as String?),
              email: Value(fields['email'] as String?),
              contactPersonName: Value(
                fields['contact_person_name'] as String?,
              ),
              contactPersonEmail: Value(
                fields['contact_person_email'] as String?,
              ),
              contactPersonDob: Value(fields['contact_person_dob'] as String?),
              contactPersonDom: Value(fields['contact_person_dom'] as String?),
              state: Value(fields['state'] as String?),
              city: Value(fields['city'] as String?),
              area: Value(fields['area'] as String?),
              country: Value(fields['country'] as String?),
              potential: Value(_d(fields['potential'])),
              supportValue: Value(_d(fields['support_value'])),
              expectedSupportValue: Value(_d(fields['expected_support_value'])),
              cdt: Value(now),
              localStatus: const Value('pending_create'),
              locallyChangedAt: Value(now),
            ),
          );
      await _outbox.enqueue(
        entity: 'chemists',
        entityId: id,
        op: 'create',
        payload: fields,
      );
    });
    SyncTriggers.mutated();
    return id;
  }

  Future<void> updateChemist(String id, Map<String, dynamic> fields) async {
    final Chemist? existing = await getById(id);
    if (existing == null) {
      throw StateError('Chemist not found locally: $id');
    }
    final String now = DateTime.now().toUtc().toIso8601String();
    await _db.transaction(() async {
      await (_db.update(_db.chemists)..where((t) => t.id.equals(id))).write(
        ChemistsCompanion(
          fullName: fields.containsKey('full_name')
              ? Value((fields['full_name'] ?? '') as String)
              : const Value.absent(),
          phone: _sv(fields, 'phone'),
          email: _sv(fields, 'email'),
          contactPersonName: _sv(fields, 'contact_person_name'),
          contactPersonEmail: _sv(fields, 'contact_person_email'),
          contactPersonDob: _sv(fields, 'contact_person_dob'),
          contactPersonDom: _sv(fields, 'contact_person_dom'),
          state: _sv(fields, 'state'),
          city: _sv(fields, 'city'),
          area: _sv(fields, 'area'),
          country: _sv(fields, 'country'),
          potential: fields.containsKey('potential')
              ? Value(_d(fields['potential']))
              : const Value.absent(),
          supportValue: fields.containsKey('support_value')
              ? Value(_d(fields['support_value']))
              : const Value.absent(),
          expectedSupportValue: fields.containsKey('expected_support_value')
              ? Value(_d(fields['expected_support_value']))
              : const Value.absent(),
          localStatus: Value(
            existing.localStatus == 'pending_create'
                ? 'pending_create'
                : 'pending_update',
          ),
          locallyChangedAt: Value(now),
        ),
      );
      final Chemist updated = (await getById(id))!;
      await _outbox.enqueue(
        entity: 'chemists',
        entityId: id,
        op: existing.localStatus == 'pending_create' ? 'create' : 'update',
        payload: _fullPayload(updated),
        baseServerUdt: existing.serverUdt,
      );
    });
    SyncTriggers.mutated();
  }

  Future<void> deleteChemist(String id) async {
    final Chemist? existing = await getById(id);
    if (existing == null) {
      return;
    }
    await _db.transaction(() async {
      await (_db.update(_db.chemists)..where((t) => t.id.equals(id))).write(
        const ChemistsCompanion(
          isEnabled: Value(false),
          status: Value('deleted'),
          localStatus: Value('pending_delete'),
        ),
      );
      await _outbox.enqueue(
        entity: 'chemists',
        entityId: id,
        op: 'delete',
        payload: const <String, dynamic>{},
        baseServerUdt: existing.serverUdt,
      );
      if (existing.localStatus == 'pending_create') {
        await (_db.delete(_db.chemists)..where((t) => t.id.equals(id))).go();
      }
    });
    SyncTriggers.mutated();
  }

  Map<String, dynamic> _fullPayload(Chemist c) => <String, dynamic>{
    'full_name': c.fullName,
    'phone': c.phone,
    'email': c.email,
    'contact_person_name': c.contactPersonName,
    'contact_person_email': c.contactPersonEmail,
    'contact_person_dob': c.contactPersonDob,
    'contact_person_dom': c.contactPersonDom,
    'state': c.state,
    'city': c.city,
    'area': c.area,
    'country': c.country,
    'potential': c.potential,
    'support_value': c.supportValue,
    'expected_support_value': c.expectedSupportValue,
  };

  static double? _d(dynamic v) =>
      v == null ? null : (v is num ? v.toDouble() : double.tryParse('$v'));
  static Value<String?> _sv(Map<String, dynamic> fields, String key) =>
      fields.containsKey(key)
      ? Value(fields[key] as String?)
      : const Value.absent();
}
