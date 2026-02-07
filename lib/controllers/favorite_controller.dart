import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/favorite.dart';
import '../services/api_service.dart';

class FavoriteController with ChangeNotifier {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  List<FavoriteItem> _favorites = [];
  bool _isLoading = false;

  List<FavoriteItem> get favorites => _favorites;
  bool get isLoading => _isLoading;

  Future<String?> _getToken() async {
    return await _storage.read(key: 'token');
  }

  // GET /api/favorites
  Future<void> fetchFavorites() async {
    _isLoading = true;
    notifyListeners();

    try {
      final token = await _getToken();
      if (token == null) {
        _favorites = [];
        _isLoading = false;
        notifyListeners();
        return;
      }

      final response = await ApiService.getFull('favorites', token: token);

      // Response: { success: true, favorites: [...] }
      if (response['favorites'] != null) {
        _favorites = (response['favorites'] as List)
            .map<FavoriteItem>((json) => FavoriteItem.fromJson(json))
            .toList();
      }
    } catch (e) {
      debugPrint('Fetch favorites error: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  // POST /api/favorites/add/{product}
  Future<String> addFavorite(int productId) async {
    try {
      final token = await _getToken();
      if (token == null) {
        return 'unauthenticated';
      }

      try {
        await ApiService.post('favorites/add/$productId', {}, token: token);

        await fetchFavorites();
        return 'added';
      } catch (e) {
        if (e.toString().contains('Product already in favorites')) {
          return 'exists';
        }
        rethrow;
      }
    } catch (e) {
      debugPrint('Add to favorites error: $e');
      return 'error';
    }
  }

  // DELETE /api/favorites/{favorite}
  Future<void> removeFavorite(int favoriteId) async {
    try {
      final token = await _getToken();
      if (token == null) return;

      await ApiService.delete('favorites/$favoriteId', token: token);

      // Optimistically remove from list or refetch
      _favorites.removeWhere((item) => item.id == favoriteId);
      notifyListeners();

      // Also refetch to be sure
      // await fetchFavorites();
    } catch (e) {
      debugPrint('Remove favorite error: $e');
      // On error, revert optimistic update if we did one, or just refetch
      await fetchFavorites();
    }
  }

  bool isFavorite(int productId) {
    return _favorites.any((item) => item.product.id == productId);
  }

  void clearFavoritesLocally() {
    _favorites = [];
    notifyListeners();
  }
}
