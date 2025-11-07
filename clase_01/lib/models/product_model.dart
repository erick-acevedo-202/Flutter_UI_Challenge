import 'package:flutter/material.dart';

class ProductModel {
  final int product_id;
  final String product_name;
  final String image_path;
  final double price;
  ValueNotifier<int> is_favorite;
  final double stars;
  int? category_id;
  //final String category;
  final String description;

  ProductModel({
    required this.product_id,
    required this.product_name,
    required this.image_path,
    required this.price,
    required int is_favorite,
    required this.stars,
    this.category_id,
    //required this.category,
    required this.description,
  }) : is_favorite = ValueNotifier<int>(is_favorite);

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
        product_id: map['product_id'],
        product_name: map['product_name'],
        image_path: map['image_path'],
        price: map['price'],
        is_favorite: map['is_favorite'],
        stars: map['stars'],
        category_id: map['category_id'],
        description: map['description']);
  }

  Map<String, dynamic> toMap() {
    return {
      "product_id": product_id,
      "product_name": product_name,
      "image_path": image_path,
      "price": price,
      "is_favorite": is_favorite.value,
      "stars": stars,
      "category_id": category_id,
      "description": description
    };
  }
}

/*
final chocolateFrap = ProductModel(
  product_id: 1,
  product_name: "Chocolate Frappuccino",
  image_path: "assets/sbux_assets/chocolate_frap.png",
  price: 20.0,
  is_favorite: true,
  stars: 4.5,
  //category: "Coffee",
  description:
      "Bebida Fría a hecha con helado de Cacao importado de Oaxxaca por WillyWonka, incluye crema batida y chocolate Hershy's",
);

final teaFrap = ProductModel(
  product_id: 2,
  product_name: "Tea Frappuccino",
  image_path: "assets/sbux_assets/tea_frap.png",
  price: 15.0,
  is_favorite: false,
  stars: 3.5,
  //category: "Tea",
  description:
      "Cremosa bebida fría de Mate argentino con extra clorofila llena de antioxidantes con crema batida deslactosada semidescremada nutrileche",
);

final strawberryFrap = ProductModel(
  product_id: 3,
  product_name: "Strawberry Frappuccino",
  image_path: "assets/sbux_assets/strawberry_frap.png",
  price: 30.0,
  is_favorite: true,
  stars: 5.0,
  //category: "Drink",
  description:
      "Fresas frescas extraidas de La Comarca, combinados con nieve del Monte Everest con crema batida y mermelada de fresa",
);
List<ProductModel> productList = [chocolateFrap, teaFrap, strawberryFrap];
*/

List<ProductModel> myOrder = [];
