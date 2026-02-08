import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/favorite.dart';
import '../models/product.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('favorites.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 3,
      onCreate: _crateDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE products (
          id INTEGER PRIMARY KEY,
          brand TEXT,
          model TEXT,
          diameter TEXT,
          type TEXT,
          material TEXT,
          strap TEXT,
          water_resistance TEXT,
          caliber TEXT,
          price REAL,
          image TEXT
        )
      ''');
    }

    if (oldVersion < 3) {
      await db.execute('''
        CREATE TABLE pending_add_favorites (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          product_id INTEGER UNIQUE
        )
      ''');

      await db.execute('''
        CREATE TABLE pending_remove_favorites (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          favorite_id INTEGER UNIQUE
        )
      ''');
    }
  }

  Future _crateDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE favorites (
        id INTEGER PRIMARY KEY,
        product_id INTEGER,
        brand TEXT,
        model TEXT,
        diameter TEXT,
        type TEXT,
        material TEXT,
        strap TEXT,
        water_resistance TEXT,
        caliber TEXT,
        price REAL,
        image TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE products (
        id INTEGER PRIMARY KEY,
        brand TEXT,
        model TEXT,
        diameter TEXT,
        type TEXT,
        material TEXT,
        strap TEXT,
        water_resistance TEXT,
        caliber TEXT,
        price REAL,
        image TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE pending_add_favorites (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        product_id INTEGER UNIQUE
      )
    ''');

    await db.execute('''
      CREATE TABLE pending_remove_favorites (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        favorite_id INTEGER UNIQUE
      )
    ''');
  }

  // ... (existing methods for favorites and products)

  // Pending Actions Methods
  Future<void> addPendingAdd(int productId) async {
    final db = await instance.database;
    await db.insert('pending_add_favorites', {
      'product_id': productId,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<int>> getPendingAdds() async {
    final db = await instance.database;
    final result = await db.query('pending_add_favorites');
    return result.map((e) => e['product_id'] as int).toList();
  }

  Future<void> removePendingAdd(int productId) async {
    final db = await instance.database;
    await db.delete(
      'pending_add_favorites',
      where: 'product_id = ?',
      whereArgs: [productId],
    );
  }

  Future<void> addPendingRemove(int favoriteId) async {
    final db = await instance.database;
    await db.insert('pending_remove_favorites', {
      'favorite_id': favoriteId,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<int>> getPendingRemoves() async {
    final db = await instance.database;
    final result = await db.query('pending_remove_favorites');
    return result.map((e) => e['favorite_id'] as int).toList();
  }

  Future<void> removePendingRemove(int favoriteId) async {
    final db = await instance.database;
    await db.delete(
      'pending_remove_favorites',
      where: 'favorite_id = ?',
      whereArgs: [favoriteId],
    );
  }

  Future<Product?> getProductById(int id) async {
    final db = await instance.database;
    final result = await db.query(
      'products',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return Product.fromJson(result.first);
    }
    return null;
  }

  // ... (existing favorites methods)

  Future<void> insertProduct(Product product) async {
    final db = await instance.database;
    await db.insert(
      'products',
      product.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertProducts(List<Product> products) async {
    final db = await instance.database;
    final batch = db.batch();
    for (var product in products) {
      batch.insert(
        'products',
        product.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  Future<List<Product>> getProducts() async {
    final db = await instance.database;
    final result = await db.query('products');

    return result.map((json) => Product.fromJson(json)).toList();
  }

  Future<void> clearProducts() async {
    final db = await instance.database;
    await db.delete('products');
  }

  Future<void> insertFavorite(FavoriteItem item) async {
    final db = await instance.database;
    // We override the product ID as `product_id` and remove it from the productMap
    // so we can insert the favorite's ID as `id` if needed.
    // However, the `product.toMap()` includes 'id' as the product ID.
    // Let's adjust the map for the table structure.

    final Map<String, dynamic> row = {
      'id': item.id, // Favorite ID
      'product_id': item.product.id,
      'brand': item.product.brand,
      'model': item.product.model,
      'diameter': item.product.diameter,
      'type': item.product.type,
      'material': item.product.material,
      'strap': item.product.strap,
      'water_resistance': item.product.waterResistance,
      'caliber': item.product.caliber,
      'price': item.product.price,
      'image': item.product.image,
    };

    await db.insert(
      'favorites',
      row,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<FavoriteItem>> getFavorites() async {
    final db = await instance.database;
    final result = await db.query('favorites');

    return result.map((json) {
      // Reconstruct Product object
      final product = Product(
        id: json['product_id'] as int,
        brand: json['brand'] as String,
        model: json['model'] as String,
        diameter: json['diameter'] as String,
        type: json['type'] as String,
        material: json['material'] as String,
        strap: json['strap'] as String,
        waterResistance: json['water_resistance'] as String,
        caliber: json['caliber'] as String,
        price: (json['price'] as num).toDouble(),
        image: json['image'] as String,
      );

      // Reconstruct FavoriteItem
      return FavoriteItem(id: json['id'] as int, product: product);
    }).toList();
  }

  Future<void> removeFavorite(int id) async {
    final db = await instance.database;
    await db.delete('favorites', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearFavorites() async {
    final db = await instance.database;
    await db.delete('favorites');
  }
}
