import 'package:clase_01/models/order_items.dart';

class OrderModel {
  final String orderId;
  final List<OrderItem> items;
  final DateTime date;
  final String status;

  double get total => items.fold(0, (sum, item) => sum + item.subtotal);
  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  OrderModel({
    required this.orderId,
    required this.items,
    required this.date,
    this.status = 'pending',
  });
}

//PROVICIONAL solo para manejar los items en tiempo de ejecucion
List<OrderItem> orderItems = [];

OrderModel myOrder =
    OrderModel(orderId: "ORD-1", items: orderItems, date: DateTime.now());
