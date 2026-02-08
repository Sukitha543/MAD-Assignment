class Product {
  final int id;
  final String brand;
  final String model;
  final String diameter;
  final String type;
  final String material;
  final String strap;
  final String waterResistance;
  final String caliber;
  final double price;
  final String image;

  Product({
    required this.id,
    required this.brand,
    required this.model,
    required this.diameter,
    required this.type,
    required this.material,
    required this.strap,
    required this.waterResistance,
    required this.caliber,
    required this.price,
    required this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      brand: json['brand'],
      model: json['model'],
      diameter: json['diameter'],
      type: json['type'],
      material: json['material'],
      strap: json['strap'],
      waterResistance: json['water_resistance'],
      caliber: json['caliber'],
      price: double.parse(json['price'].toString()),
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'brand': brand,
      'model': model,
      'diameter': diameter,
      'type': type,
      'material': material,
      'strap': strap,
      'water_resistance': waterResistance,
      'caliber': caliber,
      'price': price,
      'image': image,
    };
  }
}
