import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  
  final StreamController<bool> _connectionController = 
      StreamController<bool>.broadcast();

  Stream<bool> get connectionStream => _connectionController.stream;

  bool _isConnected = true;
  bool get isConnected => _isConnected;

  Future<void> init() async {
    // Check initial connectivity status
    final result = await _connectivity.checkConnectivity();
    _updateConnectionStatus(result);

    // Listen for connectivity changes
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      _updateConnectionStatus,
    );
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    final wasConnected = _isConnected;
    _isConnected = results.any((result) => result != ConnectivityResult.none);
    
    if (wasConnected != _isConnected) {
      _connectionController.add(_isConnected);
    }
  }

  Future<bool> checkConnection() async {
    final result = await _connectivity.checkConnectivity();
    return result.any((r) => r != ConnectivityResult.none);
  }

  void dispose() {
    _connectivitySubscription?.cancel();
    _connectionController.close();
  }
}
