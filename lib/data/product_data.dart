import 'package:mad_assignment/models/product.dart';

class ProductData {

  final List<Product> productList = [

    Product(
      brand: "Rolex",
      model: "Submariner Automatic",
      code: "RX123",
      diameter: "40mm",
      type: "Men",
      material: "Stainless Steel",
      strap: "Oyster Bracelet",
      waterResistence: "300m",
      calibre: "3235",
      price: 12000.50,
      image: "assets/images/rolex.webp",
    ),

    Product(
      brand: "Omega",
      model: "Speedmaster",
      code: "OM456",
      diameter: "42mm",
      type: "Men",
      material: "Stainless Steel",
      strap: "Leather Strap",
      waterResistence: "50m",
      calibre: "1861",
      price: 6500.00,
      image: "assets/images/omega.png",
    ),

    Product(
      brand: "Tag Heuer",
      model: "Carrera",
      code: "TH789",
      diameter: "43mm",
      type: "Men",
      material: "Stainless Steel",
      strap: "Rubber Strap",
      waterResistence: "100m",
      calibre: "Heuer 02",
      price: 5200.75,
      image: "assets/images/Tag.jpg",
    ),

    Product(
      brand: "Seiko",
      model: "Prospex Diver",
      code: "SKX007",
      diameter: "42mm",
      type: "Men",
      material: "Stainless Steel",
      strap: "Silicone Strap",
      waterResistence: "200m",
      calibre: "4R36",
      price: 450.99,
      image:"assets/images/seiko.webp",
    ),

    Product(
      brand: "Casio",
      model: "G-Shock Quartz",
      code: "GA2100",
      diameter: "45mm",
      type: "Men",
      material: "Resin",
      strap: "Resin Strap",
      waterResistence: "200m",
      calibre: "Module 5611",
      price: 120.00,
      image: "assets/images/casio.webp",
    ),
  ];

}
