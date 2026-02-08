import 'package:flutter/material.dart';
import '../services/connectivity_service.dart';

class NetworkController with ChangeNotifier {
  final ConnectivityService _connectivityService = ConnectivityService();
  bool _isConnected = true; // Assume connected initially

  bool get isConnected => _isConnected;

  NetworkController() {
    _connectivityService.initialize();
    _connectivityService.connectionStatus.listen((status) {
      if (_isConnected != status) {
        _isConnected = status;
        notifyListeners();
      }
    });
  }

  // Future method to manually check connection if needed
  Future<void> checkConnection() async {
    await _connectivityService.initialize();
  }
}
