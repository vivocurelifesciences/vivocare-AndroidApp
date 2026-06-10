import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/common.dart';
import 'package:sqlite3/open.dart' as sqlite3_open;
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
    KvEntries,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  /// Opens (and on first run creates) the encrypted database. The cipher key
  /// is generated once and kept in the platform keystore via secure storage.
  static Future<AppDatabase> open({FlutterSecureStorage? secureStorage}) async {
    final FlutterSecureStorage storage =
        secureStorage ?? const FlutterSecureStorage();
    String? key = await storage.read(key: _dbKeyStorageKey);
    if (key == null || key.isEmpty) {
      key = const Uuid().v4().replaceAll('-', '') +
          const Uuid().v4().replaceAll('-', '');
      await storage.write(key: _dbKeyStorageKey, value: key);
    }
    final Directory dir = await getApplicationSupportDirectory();
    final File file = File(p.join(dir.path, _dbFileName));
    return AppDatabase(_openExecutor(file, key));
  }

  /// In-memory unencrypted database for widget/unit tests.
  static AppDatabase forTesting() =>
      AppDatabase(NativeDatabase.memory());

  static QueryExecutor _openExecutor(File file, String cipherKey) {
    return LazyDatabase(() async {
      if (Platform.isAndroid) {
        sqlite3_open.open.overrideFor(
            sqlite3_open.OperatingSystem.android, openCipherOnAndroid);
        // Workaround for apps that also ship plain sqlite3 via Flutter engine.
        await applyWorkaroundToOpenSqlCipherOnOldAndroidVersions();
      }
      return NativeDatabase.createInBackground(
        file,
        isolateSetup: () async {
          if (Platform.isAndroid) {
            sqlite3_open.open.overrideFor(
                sqlite3_open.OperatingSystem.android, openCipherOnAndroid);
          }
        },
        setup: (CommonDatabase db) {
          final String escaped = cipherKey.replaceAll("'", "''");
          db.execute("PRAGMA key = '$escaped';");
          // Fail fast if the binary is not SQLCipher (cipher_version is empty
          // on plain sqlite3) — avoids silently writing unencrypted data.
          final result = db.select('PRAGMA cipher_version;');
          if (result.isEmpty) {
            debugPrint('[DB] WARNING: SQLCipher not active, using plain SQLite');
          }
          db.execute('PRAGMA foreign_keys = ON;');
        },
      );
    });
  }

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
          await customStatement(
            'CREATE INDEX IF NOT EXISTS idx_plans_date ON daily_plans (visit_date)');
          await customStatement(
            'CREATE INDEX IF NOT EXISTS idx_dcrs_visit ON dcrs (visit_datetime)');
          await customStatement(
            'CREATE INDEX IF NOT EXISTS idx_outbox_state ON outbox_ops (state, seq)');
        },
      );

  // ----------------------------------------------------------- KV helpers

  Future<String?> getKv(String key) async {
    final KvEntry? row = await (select(kvEntries)
          ..where((t) => t.key.equals(key)))
        .getSingleOrNull();
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
