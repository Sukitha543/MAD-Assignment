import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import '../services/database_helper.dart';

class ProductController with ChangeNotifier {
  //TOKEN STORAGE
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  List<Product> _products = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  ProductController() {
    _init();
  }

  Future<void> _init() async {
    await fetchProducts();
  }

  //FETCH PRODUCTS
  Future<void> fetchProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      String? token = await storage.read(key: 'token');

      // Attempt API fetch
      if (token != null) {
        final response = await ApiService.get('products', token: token);

        _products = response
            .map<Product>((json) => Product.fromJson(json))
            .toList();

        // Sync with Local DB
        // Optionally clear old products first or just upsert
        await DatabaseHelper.instance.clearProducts();
        await DatabaseHelper.instance.insertProducts(_products);
      } else {
        // No token, maybe load from DB if we want to allow guest viewing of cached data?
        // Or throw error. For now, let's assume valid session required.
        // But if offline, we might still have a token in storage.
        throw Exception("No authentication token found.");
      }
    } catch (e) {
      debugPrint("API Error, loading products from DB: $e");
      // Fallback to local DB
      try {
        _products = await DatabaseHelper.instance.getProducts();
        if (_products.isNotEmpty) {
          // If we have cached products, clear the error so the UI shows them
          _errorMessage = null;
        } else {
          // Only show error if we have NO data to show
          _errorMessage = e.toString().replaceAll('Exception: ', '');
        }
      } catch (dbError) {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
        _products = [];
      }
    }

    _isLoading = false;
    notifyListeners();
  }
}
