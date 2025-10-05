import 'package:mad_assignment/models/product.dart';

class Cart {
  // Singleton pattern
  static final Cart _instance = Cart._internal();
  factory Cart() => _instance;
  Cart._internal();

  // List of products in cart
  final List<Product> _items = [];

  List<Product> get items => _items;

  double get totalPrice => _items.fold(0, (sum, item) => sum + item.price);

  void addProduct(Product product) {
    _items.add(product);
  }

  void removeProduct(Product product) {
    _items.remove(product);
  }

  void clearCart() {
    _items.clear();
  }
}
