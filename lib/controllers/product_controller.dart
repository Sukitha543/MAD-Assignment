import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class ProductController with ChangeNotifier {
  //TOKEN STORAGE
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  List<Product> _products = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  //FETCH PRODUCTS
  Future<void> fetchProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      String? token = await storage.read(key: 'token');

      if (token == null) {
        throw Exception("No authentication token found. Please log in again.");
      }

      final response = await ApiService.get('products', token: token);

      _products = response
          .map<Product>((json) => Product.fromJson(json))
          .toList();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _products = [];
    }

    _isLoading = false;
    notifyListeners();
  }
}
