import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> _connectionStatusController =
      StreamController<bool>.broadcast();

  Stream<bool> get connectionStatus => _connectionStatusController.stream;

  ConnectivityService() {
    // Listen for connectivity changes
    _connectivity.onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      _checkInternetConnection(results);
    });
  }

  // Check initial connection status
  Future<void> initialize() async {
    List<ConnectivityResult> results = await _connectivity.checkConnectivity();
    await _checkInternetConnection(results);
  }

  Future<void> _checkInternetConnection(
    List<ConnectivityResult> results,
  ) async {
    bool isConnected = false;

    // Check if any interface is connected (mobile, wifi, ethernet, etc.)
    // connectivity_plus now returns a List<ConnectivityResult>
    bool hasConnection = results.any(
      (result) =>
          result != ConnectivityResult.none && result != ConnectivityResult.vpn,
    );

    if (hasConnection) {
      try {
        final verify = await InternetAddress.lookup('google.com');
        if (verify.isNotEmpty && verify[0].rawAddress.isNotEmpty) {
          isConnected = true;
        }
      } on SocketException catch (_) {
        isConnected = false;
      }
    }

    _connectionStatusController.add(isConnected);
  }

  void dispose() {
    _connectionStatusController.close();
  }
}
