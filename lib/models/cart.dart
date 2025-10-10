import 'package:mad_assignment/models/product.dart';

class Cart {
  //  private constructor
  Cart._privateConstructor();

  
  static final Cart _instance = Cart._privateConstructor();

  static Cart get instance => _instance;

  // list to hold added products
  final List<Product> _items = [];

  // add product
  void addItem(Product product) {
    _items.add(product);
  }

  // remove product
  void removeItem(Product product) {
    _items.remove(product);
  }

  //  get all items
  List<Product> get items => _items;

  // get total price
  double get totalPrice => _items.fold(0, (sum, item) => sum + item.price);

  //  clear the cart
  void clearCart() {
    _items.clear();
  }
}

