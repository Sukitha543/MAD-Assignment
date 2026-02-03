import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class ProductController with ChangeNotifier {
  List<Product> _products = [];
  bool _isLoading = false;
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  String? _errorMessage;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      print('ProductController: Fetching products...');
      String? token = await storage.read(key: 'token');
      print('ProductController: Token read from storage: $token');

      if (token == null) {
        throw Exception("No authentication token found. Please log in again.");
      }

      final response = await ApiService.get('products', token: token);
      print('ProductController: Got response with ${response.length} items');

      _products = response.map<Product>((json) {
        try {
          return Product.fromJson(json);
        } catch (parseError) {
          print('Error parsing product: $json\nError: $parseError');
          rethrow;
        }
      }).toList();

      print('ProductController: Parsed successfully');
    } catch (e) {
      print('ProductController Error: $e');
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _products = [];
    }

    _isLoading = false;
    notifyListeners();
  }
}
