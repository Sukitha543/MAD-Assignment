import 'product.dart';

class FavoriteItem {
  final int id;
  final Product product;

  FavoriteItem({required this.id, required this.product});

  factory FavoriteItem.fromJson(Map<String, dynamic> json) {
    return FavoriteItem(
      id: json['id'],
      product: Product.fromJson(json['product']),
    );
  }
}
