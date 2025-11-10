import 'package:clase_01/database/product_database.dart';
import 'package:clase_01/models/order_items.dart';
import 'package:clase_01/models/order_model.dart';
import 'package:flutter/material.dart';

class OrderExpansionWidget extends StatefulWidget {
  final String date;
  const OrderExpansionWidget({super.key, required this.date});

  @override
  State<OrderExpansionWidget> createState() => _OrderExpansionWidgetState();
}

class _OrderExpansionWidgetState extends State<OrderExpansionWidget> {
  final ProductDatabase productsDB = ProductDatabase();
  List<OrderModel> orders = [];
  List<bool> isExpandedList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  @override
  void didUpdateWidget(OrderExpansionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.date != widget.date) {
      _loadOrders();
    }
  }

  void _loadOrders() async {
    setState(() {
      isLoading = true;
    });

    try {
      final orders = await productsDB.SELECT_orders_byDate(widget.date);

      setState(() {
        this.orders = orders;
        isExpandedList = List.filled(orders.length, false);
        isLoading = false;
      });
    } catch (e) {
      print('Error loading orders: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (orders.isEmpty) {
      return Center(child: Text('No orders for this date'));
    }

    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      child: SingleChildScrollView(
        child: ExpansionPanelList(
          expansionCallback: (int index, bool isExpanded) {
            setState(() {
              isExpandedList[index] = !isExpandedList[index];
            });
          },
          animationDuration: Duration(milliseconds: 300), // Agregar esto
          children: [
            for (int i = 0; i < orders.length; i++)
              ExpansionPanel(
                headerBuilder: (context, isExpanded) {
                  final order = orders[i];
                  return ListTile(
                    title: Text('Order #${order.order_id}'),
                    subtitle: Text('\$${order.total} • ${order.status}'),
                    trailing: Text('⭐${order.star_points}'),
                  );
                },
                body: _buildOrderDetails(orders[i]),
                isExpanded: isExpandedList[i],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderDetails(OrderModel order) {
    return FutureBuilder<List<OrderItem>>(
      future: productsDB.SELECT_ItemsByOrder(order.order_id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Padding(
            padding: EdgeInsets.all(16),
            child: Text('Error loading items: ${snapshot.error}'),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Padding(
            padding: EdgeInsets.all(16),
            child: Text('No products in this order'),
          );
        }

        return Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              for (final item in snapshot.data!)
                ListTile(
                  title: Text('Product ${item.product_id}'),
                  subtitle: Text('${item.size} x ${item.quantity}'),
                  trailing: Text('\$${item.subtotal}'),
                ),
            ],
          ),
        );
      },
    );
  }
}
