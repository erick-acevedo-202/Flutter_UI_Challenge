import 'package:clase_01/models/product_model.dart';

class OrderItem {
  final int item_id;
  final int product_id;
  int order_id;
  String size;
  int quantity;
  double subtotal;

  ProductModel? product;

  OrderItem({
    required this.item_id,
    required this.product_id,
    required this.order_id,
    required this.size,
    required this.quantity,
    this.product = null,
    this.subtotal = 0.0,
  });

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      item_id: map['item_id'],
      product_id: map['product_id'],
      order_id: map['order_id'],
      size: map['size'],
      quantity: map['quantity'],
      subtotal: map['subtotal'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "product_id": product_id,
      "order_id": order_id,
      "size": size,
      "quantity": quantity,
      "subtotal": subtotal,
    };
  }
}
