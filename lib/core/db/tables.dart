import 'package:drift/drift.dart';

/// Local mirror of server entities (columns named after the Postgres schema)
/// plus per-row sync metadata:
///  - [serverUdt]   server's `udt` at last pull/push ack (null = never synced)
///  - [localStatus] 'synced' | 'pending_create' | 'pending_update' | 'pending_delete'
///
/// Dates/timestamps are stored as ISO-8601 TEXT so payload mapping with the
/// sync API is lossless and trivial.

mixin SyncColumns on Table {
  TextColumn get status => text().withDefault(const Constant('active'))();
  BoolColumn get isEnabled => boolean().withDefault(const Constant(true))();
  TextColumn get serverUdt => text().nullable()();
  TextColumn get localStatus => text().withDefault(const Constant('synced'))();
  TextColumn get locallyChangedAt => text().nullable()();
}

class Doctors extends Table with SyncColumns {
  TextColumn get id => text()();
  TextColumn get doctorCode => text().nullable()();
  TextColumn get doctorType => text().nullable()();
  TextColumn get firstName => text().nullable()();
  TextColumn get middleName => text().nullable()();
  TextColumn get lastName => text().nullable()();
  TextColumn get qualification => text().nullable()();
  TextColumn get speciality => text().nullable()();
  TextColumn get category => text().nullable()();
  RealColumn get potential => real().nullable()();
  RealColumn get supportValue => real().nullable()();
  RealColumn get expectedSupportValue => real().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get state => text().nullable()();
  TextColumn get city => text().nullable()();
  TextColumn get area => text().nullable()();
  TextColumn get country => text().nullable()();
  TextColumn get dob => text().nullable()();
  TextColumn get dom => text().nullable()();
  IntColumn get experienceYears => integer().nullable()();
  TextColumn get chemistIds => text().nullable()();
  TextColumn get cdt => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Chemists extends Table with SyncColumns {
  TextColumn get id => text()();
  TextColumn get chemistCode => text().nullable()();
  TextColumn get fullName => text().withDefault(const Constant(''))();
  TextColumn get phone => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get contactPersonName => text().nullable()();
  TextColumn get contactPersonEmail => text().nullable()();
  TextColumn get contactPersonDob => text().nullable()();
  TextColumn get contactPersonDom => text().nullable()();
  TextColumn get state => text().nullable()();
  TextColumn get city => text().nullable()();
  TextColumn get area => text().nullable()();
  TextColumn get country => text().nullable()();
  RealColumn get potential => real().nullable()();
  RealColumn get supportValue => real().nullable()();
  RealColumn get expectedSupportValue => real().nullable()();
  TextColumn get cdt => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Products extends Table with SyncColumns {
  TextColumn get id => text()();
  TextColumn get productCode => text().nullable()();
  TextColumn get productName => text().withDefault(const Constant(''))();

  /// JSON list of {metadata, object_key, url} entries from the sync payload.
  TextColumn get imageUrlsJson => text().nullable()();
  TextColumn get primaryImageUrl => text().nullable()();
  TextColumn get productMetadataJson => text().nullable()();
  IntColumn get displayOrder => integer().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class DailyPlans extends Table with SyncColumns {
  TextColumn get id => text()();
  TextColumn get userId => text().nullable()();
  TextColumn get visitDate => text()(); // yyyy-MM-dd
  IntColumn get visitStatus => integer().withDefault(const Constant(1))();
  TextColumn get customerType => text().withDefault(const Constant('doctor'))();
  TextColumn get customerId => text()();
  BoolColumn get isTeamVisit => boolean().withDefault(const Constant(false))();
  TextColumn get cdt => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Dcrs extends Table with SyncColumns {
  TextColumn get id => text()();
  TextColumn get planId => text().nullable()();
  TextColumn get userId => text().nullable()();
  TextColumn get visitDatetime => text()();
  TextColumn get remarks => text().nullable()();
  RealColumn get supportValue => real().nullable()();
  RealColumn get potential => real().nullable()();
  RealColumn get expectedSupportValue => real().nullable()();
  TextColumn get productIds => text().nullable()();
  TextColumn get cdt => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class DcrProductRows extends Table with SyncColumns {
  TextColumn get id => text()();
  TextColumn get dcrId => text().nullable()();
  TextColumn get productId => text().nullable()();
  IntColumn get quantity => integer().withDefault(const Constant(0))();
  TextColumn get feedback => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Own profile (single row) + any other users referenced by synced rows.
class UsersLite extends Table {
  TextColumn get id => text()();
  TextColumn get employeeCode => text().nullable()();
  TextColumn get fullName => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get roleId => text().nullable()();
  TextColumn get serverUdt => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Master-data dropdowns: user_roles, doctor_categories, visit_status_master,
/// product_priorities, customer_types — one table, discriminated by [kind].
class MetadataItems extends Table {
  TextColumn get kind => text()();
  TextColumn get id => text()();
  TextColumn get name => text().nullable()();
  BoolColumn get isEnabled => boolean().withDefault(const Constant(true))();
  TextColumn get serverUdt => text().nullable()();

  @override
  Set<Column> get primaryKey => {kind, id};
}

/// Outbox: one row per local mutation, pushed strictly in [seq] order.
/// Payload is full-row state (not a diff) so ops coalesce and the server
/// applies idempotent upserts.
class OutboxOps extends Table {
  IntColumn get seq => integer().autoIncrement()();
  TextColumn get mutationId => text().unique()();
  TextColumn get entity => text()();
  TextColumn get entityId => text()();
  TextColumn get op => text()(); // create | update | delete
  TextColumn get payloadJson => text()();
  TextColumn get baseServerUdt => text().nullable()();
  TextColumn get clientChangedAt => text()();
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  TextColumn get lastError => text().nullable()();
  TextColumn get state => text().withDefault(const Constant('pending'))();
  // pending | inflight | done | conflict
}

class SyncCursors extends Table {
  TextColumn get entity => text()();
  TextColumn get cursor => text().nullable()();
  TextColumn get lastPulledAt => text().nullable()();

  @override
  Set<Column> get primaryKey => {entity};
}

/// Downloaded media (product images, presentation assets), keyed by the
/// stable R2 object key — presigned URLs expire, object keys don't.
class MediaCacheEntries extends Table {
  TextColumn get objectKey => text()();
  TextColumn get entity => text().nullable()();
  TextColumn get entityId => text().nullable()();
  TextColumn get localPath => text().nullable()();
  TextColumn get state => text().withDefault(const Constant('pending'))();
  // pending | downloaded | failed
  TextColumn get fetchedAt => text().nullable()();

  @override
  Set<Column> get primaryKey => {objectKey};
}

/// Push results that need user attention (rejected ops, adopted duplicates).
class SyncConflicts extends Table {
  TextColumn get mutationId => text()();
  TextColumn get entity => text()();
  TextColumn get entityId => text()();
  TextColumn get reason => text().nullable()();
  TextColumn get clientPayloadJson => text().nullable()();
  TextColumn get serverRowJson => text().nullable()();
  TextColumn get createdAt => text()();
  BoolColumn get resolved => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {mutationId};
}

/// Permanent per-customer presentation history: one row per visit on which
/// products were shown. Written when a DCR is created on this device and
/// backfilled from pulled DCRs, but — unlike the DCR mirror — never pruned,
/// so "what has this doctor already seen" survives any history window.
class PresentationRecords extends Table {
  /// The originating DCR id (stable across devices).
  TextColumn get id => text()();
  TextColumn get customerType => text()(); // doctor | chemist
  TextColumn get customerId => text()();
  TextColumn get shownAt => text()(); // ISO-8601 visit datetime
  TextColumn get productIdsJson => text()(); // JSON array of product ids

  @override
  Set<Column> get primaryKey => {id};
}

/// Small key-value store: device_id, bootstrap_done, last_sync_at, …
class KvEntries extends Table {
  TextColumn get key => text()();
  TextColumn get value => text().nullable()();

  @override
  Set<Column> get primaryKey => {key};
}
