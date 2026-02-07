import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class AuthController with ChangeNotifier {
  final FlutterSecureStorage storage = FlutterSecureStorage();
  User? _user;
  User? get user => _user;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  bool _isCheckingAuth = true;
  bool get isCheckingAuth => _isCheckingAuth;

  //CUSTOMER REGISTRATION
  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final data = {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': password,
      };

      final response = await ApiService.post('register', data);
      await _saveToken(response['token']);
      _user = User.fromJson(response['user']);
      await _saveUser(_user!);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  //CUSTOMER LOGIN
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final data = {'email': email, 'password': password};

      final response = await ApiService.post('login', data);
      await _saveToken(response['token']);
      _user = User.fromJson(response['user']);
      await _saveUser(_user!);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  //LOGOUT
  Future<void> logout() async {
    await storage.delete(key: 'token');
    await _clearUser();
    _user = null;
    _isLoggedIn = false;
    notifyListeners();
  }

  Future<void> _saveToken(String token) async {
    print('AuthController: Saving token: $token');
    await storage.write(key: 'token', value: token);
    _isLoggedIn = true;
    notifyListeners();
  }

  Future<String?> getToken() async {
    return await storage.read(key: 'token');
  }

  Future<void> checkLoginStatus() async {
    try {
      String? token = await storage.read(key: 'token');
      String? userJson = await storage.read(key: 'user');

      if (token != null && userJson != null) {
        _isLoggedIn = true;
        _user = User.fromJson(jsonDecode(userJson));
      } else {
        _isLoggedIn = false;
        _user = null;
      }
    } catch (e) {
      print('Error checking login status: $e');
      _isLoggedIn = false;
      _user = null;
    } finally {
      _isCheckingAuth = false;
      notifyListeners();
    }
  }

  Future<void> _saveUser(User user) async {
    await storage.write(key: 'user', value: jsonEncode(user.toJson()));
  }

  Future<void> _clearUser() async {
    await storage.delete(key: 'user');
  }
}
