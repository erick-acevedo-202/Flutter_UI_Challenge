class ProductModel {
  final int product_id;
  final String product_name;
  final String image_path;
  final double price;
  final bool is_favorite;
  final double stars;
  final String category;
  final String description;

  ProductModel(
      {required this.product_id,
      required this.product_name,
      required this.image_path,
      required this.price,
      required this.is_favorite,
      required this.stars,
      required this.category,
      required this.description});
}

final chocolateFrap = ProductModel(
    product_id: 1,
    product_name: "Chocolate Frappuccino",
    image_path: "assets/sbux_assets/chocolate_frap.png",
    price: 20.0,
    is_favorite: true,
    stars: 4.5,
    category: "Coffee",
    description:
        "Bebida Fría a hecha con helado de Cacao importado de Oaxxaca por WillyWonka, incluye crema batida y chocolate Hershy's");

final teaFrap = ProductModel(
    product_id: 2,
    product_name: "Tea Frappuccino",
    image_path: "assets/sbux_assets/tea_frap.png",
    price: 15.0,
    is_favorite: false,
    stars: 3.5,
    category: "Tea",
    description:
        "Cremosa bebida fría de Mate argentino con extra clorofila llena de antioxidantes con crema batida deslactosada semidescremada nutrileche");

final strawberryFrap = ProductModel(
    product_id: 3,
    product_name: "Strawberry Frappuccino",
    image_path: "assets/sbux_assets/strawberry_frap.png",
    price: 30.0,
    is_favorite: true,
    stars: 5.0,
    category: "Drink",
    description:
        "Fresas frescas extraidas de La Comarca, combinados con nieve del Monte Everest con crema batida y mermelada de fresa");

List<ProductModel> productList = [chocolateFrap, teaFrap, strawberryFrap];
