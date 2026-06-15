import 'package:vivocure/core/connectivity/connectivity_service.dart';
import 'package:vivocure/core/db/app_database.dart';
import 'package:vivocure/core/media/media_cache_service.dart';
import 'package:vivocure/core/network/api_client.dart';
import 'package:vivocure/core/sync/sync_engine.dart';
import 'package:vivocure/data/repositories/chemist_repository.dart';
import 'package:vivocure/data/repositories/dcr_repository.dart';
import 'package:vivocure/data/repositories/doctor_repository.dart';
import 'package:vivocure/data/repositories/plan_repository.dart';
import 'package:vivocure/data/repositories/product_repository.dart';
import 'package:vivocure/data/repositories/sync_triggers.dart';

/// App-wide singletons, initialized once in main() before runApp.
///
/// The app's existing style instantiates collaborators directly inside
/// screens; this locator gives those call sites one stable place to get the
/// shared database/sync instances instead of constructing duplicates.
class AppServices {
  AppServices._();

  static late final AppDatabase db;
  static late final ApiClient api;
  static late final ConnectivityService connectivity;
  static late final SyncEngine syncEngine;
  static late final MediaCacheService mediaCache;

  static late final DoctorRepository doctors;
  static late final ChemistRepository chemists;
  static late final PlanRepository plans;
  static late final DcrRepository dcrs;
  static late final ProductRepository products;

  static bool _initialized = false;
  static bool get isInitialized => _initialized;

  static Future<void> init() async {
    if (_initialized) {
      return;
    }
    db = await AppDatabase.open();
    api = ApiClient();
    connectivity = ConnectivityService();
    syncEngine = SyncEngine(db: db, api: api, connectivity: connectivity);
    mediaCache = MediaCacheService(db);

    doctors = DoctorRepository(db);
    chemists = ChemistRepository(db);
    plans = PlanRepository(db);
    dcrs = DcrRepository(db);
    products = ProductRepository(db);

    // Sync is manual-only: local mutations do NOT schedule an automatic sync.
    // The rep's changes stay queued in the outbox until they tap Sync.
    SyncTriggers.onLocalMutation = null;
    _initialized = true;
  }

  /// Logout: clears all local entity/sync data and media (server keeps the
  /// system of record; next login re-bootstraps).
  static Future<void> clearLocalDataOnLogout() async {
    await db.clearAllData();
    await mediaCache.clearAll();
  }
}
