import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

/// Debounced connectivity watcher. `onlineAgain` fires once per offline→online
/// transition (debounced 5s) — the sync engine subscribes to it.
class ConnectivityService extends ChangeNotifier {
  ConnectivityService({Connectivity? connectivity})
    : _connectivity = connectivity ?? Connectivity() {
    _subscription = _connectivity.onConnectivityChanged.listen(_handleChange);
    _init();
  }

  final Connectivity _connectivity;
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  Timer? _debounce;

  bool _isOnline = true;
  bool get isOnline => _isOnline;

  final StreamController<void> _onlineAgainController =
      StreamController<void>.broadcast();

  /// Emits when connectivity returns after an offline period.
  Stream<void> get onlineAgain => _onlineAgainController.stream;

  Future<void> _init() async {
    _handleChange(await _connectivity.checkConnectivity());
  }

  void _handleChange(List<ConnectivityResult> results) {
    final bool nowOnline = results.any((r) => r != ConnectivityResult.none);
    if (nowOnline == _isOnline) {
      return;
    }
    if (!nowOnline) {
      _debounce?.cancel();
      _isOnline = false;
      notifyListeners();
      return;
    }
    // Debounce flapping networks before announcing "online".
    _debounce?.cancel();
    _debounce = Timer(const Duration(seconds: 5), () {
      _isOnline = true;
      notifyListeners();
      _onlineAgainController.add(null);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _subscription?.cancel();
    _onlineAgainController.close();
    super.dispose();
  }
}
