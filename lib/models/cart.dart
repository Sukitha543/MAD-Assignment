import 'package:mad_assignment/models/product.dart';

class Cart {
  // Step 1: create a private constructor
  Cart._privateConstructor();

  // Step 2: create a single instance
  static final Cart _instance = Cart._privateConstructor();

  // Step 3: access that instance using a getter
  static Cart get instance => _instance;

  // Step 4: list to hold added products
  final List<Product> _items = [];

  // Step 5: add product
  void addItem(Product product) {
    _items.add(product);
  }

  // Step 6: remove product
  void removeItem(Product product) {
    _items.remove(product);
  }

  // Step 7: get all items
  List<Product> get items => _items;

  // Step 8: get total price
  double get totalPrice => _items.fold(0, (sum, item) => sum + item.price);

  // Step 9: clear the cart
  void clearCart() {
    _items.clear();
  }
}

