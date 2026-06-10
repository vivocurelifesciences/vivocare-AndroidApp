import 'package:flutter/widgets.dart';
import 'package:vivocure/app/app.dart';
import 'package:vivocure/core/app_services.dart';
import 'package:vivocure/core/auth/auth_storage.dart';
import 'package:vivocure/core/sync/background_sync.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // One-time move of tokens out of SharedPreferences into secure storage;
  // unconditionally deletes the legacy plaintext password.
  await AuthStorage.migrateFromSharedPreferences();
  await AppServices.init();
  await BackgroundSync.register();
  runApp(const VivocureApp());
}
