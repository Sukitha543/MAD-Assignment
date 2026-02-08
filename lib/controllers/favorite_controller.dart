import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/favorite.dart';
import '../services/api_service.dart';

import '../services/database_helper.dart';

class FavoriteController with ChangeNotifier {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  List<FavoriteItem> _favorites = [];
  bool _isLoading = false;

  List<FavoriteItem> get favorites => _favorites;
  bool get isLoading => _isLoading;

  Future<String?> _getToken() async {
    return await _storage.read(key: 'token');
  }

  // Sync pending offline actions
  Future<void> _syncPendingChanges(String token) async {
    // 1. Process Pending Adds
    final pendingAdds = await DatabaseHelper.instance.getPendingAdds();
    for (int productId in pendingAdds) {
      try {
        await ApiService.post('favorites/add/$productId', {}, token: token);
        await DatabaseHelper.instance.removePendingAdd(productId);
      } catch (e) {
        debugPrint('Sync Add Error for product $productId: $e');
        // Keep in queue if it's a network error, remove if 404/400?
        // simple logic: keep trying until success or manual intervention
      }
    }

    // 2. Process Pending Removes
    final pendingRemoves = await DatabaseHelper.instance.getPendingRemoves();
    for (int favoriteId in pendingRemoves) {
      try {
        await ApiService.delete('favorites/$favoriteId', token: token);
        await DatabaseHelper.instance.removePendingRemove(favoriteId);
      } catch (e) {
        debugPrint('Sync Remove Error for favorite $favoriteId: $e');
      }
    }
  }

  // GET /api/favorites
  Future<void> fetchFavorites() async {
    _isLoading = true;
    notifyListeners();

    try {
      final token = await _getToken();
      if (token == null) {
        _favorites = [];
        await DatabaseHelper.instance.clearFavorites();
        _isLoading = false;
        notifyListeners();
        return;
      }

      // Try to sync first if online
      try {
        await _syncPendingChanges(token);

        final response = await ApiService.getFull('favorites', token: token);

        // Response: { success: true, favorites: [...] }
        if (response['favorites'] != null) {
          _favorites = (response['favorites'] as List)
              .map<FavoriteItem>((json) => FavoriteItem.fromJson(json))
              .toList();

          // Sync with DB (overwrite local cache with fresh server data)
          await DatabaseHelper.instance.clearFavorites();
          for (var item in _favorites) {
            await DatabaseHelper.instance.insertFavorite(item);
          }
        }
      } catch (e) {
        debugPrint('API Error, loading from DB: $e');
        // Load from DB if API fails
        _favorites = await DatabaseHelper.instance.getFavorites();
      }
    } catch (e) {
      debugPrint('Fetch favorites error: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  // POST /api/favorites/add/{product}
  Future<String> addFavorite(int productId) async {
    // Check if already in favorites (prevents duplicates offline & saves API call)
    if (isFavorite(productId)) {
      return 'exists';
    }

    try {
      final token = await _getToken();
      if (token == null) {
        return 'unauthenticated';
      }

      // Try API first
      try {
        await ApiService.post('favorites/add/$productId', {}, token: token);
        await fetchFavorites(); // Refresh list to get the real ID from server
        return 'added';
      } catch (e) {
        if (e.toString().contains('Product already in favorites')) {
          return 'exists';
        }

        // If network error (offline), simulate add locally
        debugPrint('Offline Add: $e');

        // 1. Get product details locally
        final product = await DatabaseHelper.instance.getProductById(productId);
        if (product != null) {
          // 2. Create temporary favorite item (Negative ID)
          final tempId = -DateTime.now().millisecondsSinceEpoch;
          final newItem = FavoriteItem(id: tempId, product: product);

          // 3. Save to local favorites DB
          await DatabaseHelper.instance.insertFavorite(newItem);

          // 4. Add to pending add queue
          await DatabaseHelper.instance.addPendingAdd(productId);

          // 5. Update UI list manually
          _favorites.add(newItem);
          notifyListeners();

          return 'added';
        }

        return 'error';
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

      // Find the item locally first to get details needed for offline logic
      final index = _favorites.indexWhere((item) => item.id == favoriteId);
      final FavoriteItem? itemToRemove = index != -1 ? _favorites[index] : null;

      try {
        // Try API
        await ApiService.delete('favorites/$favoriteId', token: token);

        // Optimistically remove from list and DB
        if (index != -1) {
          _favorites.removeAt(index);
          notifyListeners();
        }
        await DatabaseHelper.instance.removeFavorite(favoriteId);
      } catch (e) {
        debugPrint('Offline Remove: $e');

        if (itemToRemove != null) {
          // 1. Remove from local list and DB immediately
          _favorites.removeWhere((item) => item.id == favoriteId);
          notifyListeners();
          await DatabaseHelper.instance.removeFavorite(favoriteId);

          // 2. Handle queues
          if (favoriteId < 0) {
            // It was a pending add. Remove the pending add request where product_id matches.
            // Since itemToRemove has the product, we use it.
            await DatabaseHelper.instance.removePendingAdd(
              itemToRemove.product.id,
            );
          } else {
            // It's a real server favorite. Add to pending remove queue.
            await DatabaseHelper.instance.addPendingRemove(favoriteId);
          }
        }
      }
    } catch (e) {
      debugPrint('Remove favorite error: $e');
    }
  }

  bool isFavorite(int productId) {
    return _favorites.any((item) => item.product.id == productId);
  }

  void clearFavoritesLocally() async {
    _favorites = [];
    await DatabaseHelper.instance.clearFavorites();
    notifyListeners();
  }
}
