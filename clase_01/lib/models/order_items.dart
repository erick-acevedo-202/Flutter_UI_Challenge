import 'package:clase_01/models/product_model.dart';

class OrderItem {
  final ProductModel product;
  String size;
  int quantity;
  double subtotal;

  OrderItem({
    required this.product,
    required this.size,
    required this.quantity,
    this.subtotal = 0.0,
  });
}
