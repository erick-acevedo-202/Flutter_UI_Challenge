import 'package:clase_01/models/order_items.dart';

class OrderModel {
  final int order_id;
  final DateTime date;
  String status;
  double total;
  int itemCount;
  int star_points;

  List<OrderItem>? items;
  double get get_total => items!.fold(0, (sum, item) => sum + item.subtotal);
  int get get_itemCount => items!.fold(0, (sum, item) => sum + item.quantity);

  OrderModel(
      {required this.order_id,
      required this.date,
      this.items = null,
      this.status = 'pending',
      this.total = 0.0,
      this.itemCount = 0,
      this.star_points = 0});

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
        order_id: map['order_id'],
        date: DateTime.parse(map['date']),
        status: map['status'],
        total: map['total'],
        itemCount: map['itemCount'],
        star_points: map['star_points']);
  }

  Map<String, dynamic> toMap() {
    return {
      "date": date.toIso8601String(),
      "status": status,
      "total": total,
      "itemCount": itemCount,
      "star_points": star_points
    };
  }

  void cleanOrder() {
    orderItems = [];
    myOrder = OrderModel(order_id: 1, items: orderItems, date: DateTime.now());
  }
}

//PROVICIONAL solo para manejar los items en tiempo de ejecucion
List<OrderItem> orderItems = [];

OrderModel myOrder =
    OrderModel(order_id: 1, items: orderItems, date: DateTime.now());
