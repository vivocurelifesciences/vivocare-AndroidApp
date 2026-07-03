import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/common.dart';
import 'package:sqlite3/open.dart' as sqlite3_open;
import 'package:sqlite3/sqlite3.dart' as sqlite3_lib;
import 'package:sqlcipher_flutter_libs/sqlcipher_flutter_libs.dart';
import 'package:uuid/uuid.dart';
import 'package:vivocure/core/db/tables.dart';

part 'app_database.g.dart';

const String _dbFileName = 'vivocure_offline.db';
const String _dbKeyStorageKey = 'vivocure_db_cipher_key';

@DriftDatabase(
  tables: [
    Doctors,
    Chemists,
    Products,
    DailyPlans,
    Dcrs,
    DcrProductRows,
    UsersLite,
    MetadataItems,
    OutboxOps,
    SyncCursors,
    MediaCacheEntries,
    SyncConflicts,
    PresentationRecords,
    KvEntries,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  /// Durable keystore for the cipher key. `encryptedSharedPreferences` on
  /// Android (AndroidX Security) survives force-kill / background far more
  /// reliably than the default backend; `first_unlock` keeps the key readable
  /// on iOS while the app runs in the background. Losing this key makes the
  /// encrypted database unreadable, so durability matters most here.
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  /// The original default-options keystore the key used to live in. Read only
  /// to migrate existing installs to [_secureStorage] without losing their DB.
  static const FlutterSecureStorage _legacyStorage = FlutterSecureStorage();

  /// Opens (and on first run creates) the encrypted database.
  static Future<AppDatabase> open({FlutterSecureStorage? secureStorage}) async {
    final String key = await _resolveCipherKey(override: secureStorage);
    final Directory dir = await getApplicationSupportDirectory();
    final File file = File(p.join(dir.path, _dbFileName));
    return AppDatabase(_openExecutor(file, key));
  }

  /// In-memory unencrypted database for widget/unit tests.
  static AppDatabase forTesting() => AppDatabase(NativeDatabase.memory());

  static String _generateCipherKey() =>
      const Uuid().v4().replaceAll('-', '') +
      const Uuid().v4().replaceAll('-', '');

  /// Reads the persisted cipher key, generating one only when none has ever
  /// existed. The Android keystore can briefly throw right after a cold start
  /// or force-kill, so transient failures are retried with backoff rather than
  /// regenerating the key — regenerating over an existing database is what
  /// produces the "file is not a database" (code 26) crash. Existing installs
  /// whose key still lives in the legacy keystore are migrated in place.
  static Future<String> _resolveCipherKey({
    FlutterSecureStorage? override,
  }) async {
    final FlutterSecureStorage storage = override ?? _secureStorage;
    Object? lastError;
    for (int attempt = 0; attempt < 4; attempt++) {
      try {
        final String? existing = await storage.read(key: _dbKeyStorageKey);
        if (existing != null && existing.isNotEmpty) {
          return existing;
        }
        if (override == null) {
          // One-time migration so existing databases keep working.
          final String? legacy = await _legacyStorage.read(
            key: _dbKeyStorageKey,
          );
          if (legacy != null && legacy.isNotEmpty) {
            await storage.write(key: _dbKeyStorageKey, value: legacy);
            return legacy;
          }
        }
        // Genuinely absent (read returned null, did not throw): first run or
        // the key is permanently lost. Generate once and confirm it persisted.
        final String created = _generateCipherKey();
        await storage.write(key: _dbKeyStorageKey, value: created);
        final String? confirmed = await storage.read(key: _dbKeyStorageKey);
        if (confirmed != null && confirmed.isNotEmpty) {
          return confirmed;
        }
        lastError = StateError('cipher key did not persist after write');
      } catch (error) {
        lastError = error;
      }
      await Future<void>.delayed(Duration(milliseconds: 200 * (attempt + 1)));
    }
    throw StateError('Unable to access the secure key store: $lastError');
  }

  static QueryExecutor _openExecutor(File file, String cipherKey) {
    return LazyDatabase(() async {
      if (Platform.isAndroid) {
        sqlite3_open.open.overrideFor(
          sqlite3_open.OperatingSystem.android,
          openCipherOnAndroid,
        );
        // Workaround for apps that also ship plain sqlite3 via Flutter engine.
        await applyWorkaroundToOpenSqlCipherOnOldAndroidVersions();
      }
      // Self-heal: if the file exists but can't be decrypted with this key
      // (lost/rotated key, or a half-written file from a force-kill), drop it
      // so a fresh encrypted DB is created and the app re-syncs from the
      // server — instead of crashing on launch with SQLite code 26.
      await _recoverIfUnreadable(file, cipherKey);
      return NativeDatabase.createInBackground(
        file,
        isolateSetup: () async {
          if (Platform.isAndroid) {
            sqlite3_open.open.overrideFor(
              sqlite3_open.OperatingSystem.android,
              openCipherOnAndroid,
            );
            // The DB is actually opened on this isolate, so SQLCipher must be
            // loaded here too — otherwise plain sqlite3 reads the encrypted
            // file as garbage (code 26).
            await applyWorkaroundToOpenSqlCipherOnOldAndroidVersions();
          }
        },
        setup: (CommonDatabase db) => _applyCipherPragmas(db, cipherKey),
      );
    });
  }

  static void _applyCipherPragmas(CommonDatabase db, String cipherKey) {
    final String escaped = cipherKey.replaceAll("'", "''");
    db.execute("PRAGMA key = '$escaped';");
    // Fail fast if the binary is not SQLCipher (cipher_version is empty on
    // plain sqlite3) — avoids silently writing unencrypted data.
    final result = db.select('PRAGMA cipher_version;');
    if (result.isEmpty) {
      debugPrint('[DB] WARNING: SQLCipher not active, using plain SQLite');
    }
    db.execute('PRAGMA foreign_keys = ON;');
  }

  /// Probes the existing database file with [cipherKey]. If it cannot be read
  /// (wrong key / corruption), deletes the database (and its WAL/journal side
  /// files) so a clean encrypted DB is created on the next open.
  static Future<void> _recoverIfUnreadable(File file, String cipherKey) async {
    if (!file.existsSync()) {
      return; // First run — nothing to validate.
    }
    try {
      final sqlite3_lib.Database probe = sqlite3_lib.sqlite3.open(file.path);
      try {
        _applyCipherPragmas(probe, cipherKey);
        // Touches page 1; throws SqliteException(26) when the key is wrong.
        probe.select('PRAGMA user_version;');
      } finally {
        probe.dispose();
      }
    } catch (error) {
      debugPrint('[DB] Encrypted database unreadable ($error) — recreating.');
      _deleteDatabaseFiles(file);
    }
  }

  static void _deleteDatabaseFiles(File file) {
    for (final String suffix in const <String>[
      '',
      '-wal',
      '-shm',
      '-journal',
    ]) {
      final File sideFile = File('${file.path}$suffix');
      if (sideFile.existsSync()) {
        try {
          sideFile.deleteSync();
        } catch (error) {
          debugPrint('[DB] Could not delete ${sideFile.path}: $error');
        }
      }
    }
  }

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
      await _createIndexes();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2) {
        await m.createTable(presentationRecords);
        await _createIndexes();
      }
      if (from < 3) {
        // Sample quantities per product, recorded at DCR creation.
        await m.addColumn(dcrs, dcrs.productQuantitiesJson);
      }
    },
  );

  /// Covering indexes for the hot read paths (home day view, DCR lookups,
  /// per-customer history, outbox draining).
  Future<void> _createIndexes() async {
    const List<String> statements = <String>[
      'CREATE INDEX IF NOT EXISTS idx_plans_date ON daily_plans (visit_date)',
      'CREATE INDEX IF NOT EXISTS idx_plans_customer '
          'ON daily_plans (customer_type, customer_id)',
      'CREATE INDEX IF NOT EXISTS idx_dcrs_visit ON dcrs (visit_datetime)',
      'CREATE INDEX IF NOT EXISTS idx_dcrs_plan ON dcrs (plan_id)',
      'CREATE INDEX IF NOT EXISTS idx_outbox_state ON outbox_ops (state, seq)',
      'CREATE INDEX IF NOT EXISTS idx_presentation_customer '
          'ON presentation_records (customer_type, customer_id, shown_at)',
      'CREATE INDEX IF NOT EXISTS idx_products_enabled '
          'ON products (is_enabled, display_order)',
    ];
    for (final String statement in statements) {
      await customStatement(statement);
    }
  }

  // ----------------------------------------------------------- KV helpers

  Future<String?> getKv(String key) async {
    final KvEntry? row = await (select(
      kvEntries,
    )..where((t) => t.key.equals(key))).getSingleOrNull();
    return row?.value;
  }

  Future<void> setKv(String key, String? value) =>
      into(kvEntries).insertOnConflictUpdate(KvEntry(key: key, value: value));

  /// Stable per-install device id used for push idempotency attribution.
  Future<String> deviceId() async {
    String? id = await getKv('device_id');
    if (id == null || id.isEmpty) {
      id = const Uuid().v4();
      await setKv('device_id', id);
    }
    return id;
  }

  /// Wipes all entity + sync data (keeps device id). Used by logout and
  /// full-resync.
  Future<void> clearAllData({bool keepDeviceId = true}) async {
    final String? device = keepDeviceId ? await getKv('device_id') : null;
    await transaction(() async {
      for (final TableInfo<Table, dynamic> table in allTables) {
        await delete(table).go();
      }
      if (device != null) {
        await setKv('device_id', device);
      }
    });
  }
}
