import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/cart.dart';
import '../services/api_service.dart';

class CartController with ChangeNotifier {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  List<CartItem> _cartItems = [];
  double _total = 0.0;
  bool _isLoading = false;

  // Getters
  List<CartItem> get cartItems => _cartItems;
  double get total => _total;
  bool get isLoading => _isLoading;

  // Read token
  Future<String?> _getToken() async {
    return await _storage.read(key: 'token');
  }

  //GET /api/cart
  Future<void> fetchCart() async {
    _isLoading = true;
    notifyListeners();

    try {
      final token = await _getToken();
      if (token == null) {
        // Not authenticated, maybe clear cart?
        _cartItems = [];
        _total = 0.0;
        _isLoading = false;
        notifyListeners();
        return;
      }

      final response = await ApiService.getFull('cart', token: token);

      // Response expected: { success: true, cart_items: [...], total: 123 }
      if (response['cart_items'] != null) {
        _cartItems = (response['cart_items'] as List)
            .map<CartItem>((json) => CartItem.fromJson(json))
            .toList();
      }

      if (response['total'] != null) {
        _total = double.tryParse(response['total'].toString()) ?? 0.0;
      }
    } catch (e) {
      debugPrint('Fetch cart error: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  //POST /api/cart/add/{product}
  Future<String> addToCart(int productId) async {
    try {
      final token = await _getToken();
      if (token == null) {
        return 'unauthenticated';
      }

      try {
        await ApiService.post('cart/add/$productId', {}, token: token);

        // If successful, refresh cart
        await fetchCart();
        return 'added';
      } catch (e) {
        // ApiService throws exception with message. The message for 409 is 'Item already in cart'
        if (e.toString().contains('Item already in cart')) {
          return 'exists';
        }
        rethrow;
      }
    } catch (e) {
      debugPrint('Add to cart error: $e');
      return 'error';
    }
  }

  //DELETE /api/cart/{cartItem}
  Future<void> removeFromCart(int cartItemId) async {
    try {
      final token = await _getToken();
      if (token == null) return;

      await ApiService.delete('cart/$cartItemId', token: token);

      await fetchCart();
    } catch (e) {
      debugPrint('Remove cart item error: $e');
    }
  }

  // Clear local cart
  void clearCartLocally() {
    _cartItems = [];
    _total = 0;
    notifyListeners();
  }
}
