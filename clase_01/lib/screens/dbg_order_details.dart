import 'package:clase_01/database/product_database.dart';
import 'package:clase_01/models/order_items.dart';
import 'package:clase_01/models/order_model.dart';
import 'package:flutter/material.dart';

class DbgOrderDetails extends StatelessWidget {
  final ProductDatabase productsDB = ProductDatabase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Historial de Órdenes')),
      body: FutureBuilder<List<OrderModel>>(
        future: productsDB.SELECT_AllOrders(), // Necesitarás crear este método
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay órdenes'));
          }

          final orders = snapshot.data!;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return Card(
                margin: EdgeInsets.all(8),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Cabecera de la orden
                      Text('Orden ID: ${order.order_id}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                      Text('Fecha: ${order.date}'),
                      Text('Estado: ${order.status}'),
                      Text('Total: \$${order.total}'),
                      Text('Estrellas: ⭐${order.star_points}'),
                      Text('Items: ${order.itemCount}'),

                      SizedBox(height: 16),
                      Text('Productos:',
                          style: TextStyle(fontWeight: FontWeight.bold)),

                      // FutureBuilder anidado para los items de esta orden
                      FutureBuilder<List<OrderItem>>(
                        future: productsDB.SELECT_ItemsByOrder(
                            order.order_id), // Crear este método
                        builder: (context, itemsSnapshot) {
                          if (itemsSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Padding(
                              padding: EdgeInsets.all(8),
                              child: Text('Cargando productos...'),
                            );
                          }

                          if (!itemsSnapshot.hasData ||
                              itemsSnapshot.data!.isEmpty) {
                            return Padding(
                              padding: EdgeInsets.all(8),
                              child: Text('No hay productos en esta orden'),
                            );
                          }

                          final items = itemsSnapshot.data!;

                          return Column(
                            children: [
                              for (final item in items)
                                Padding(
                                  padding: EdgeInsets.only(left: 16, top: 8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('• Producto ID: ${item.product_id}'),
                                      Text('  Tamaño: ${item.size}'),
                                      Text('  Cantidad: ${item.quantity}'),
                                      Text('  Subtotal: \$${item.subtotal}'),
                                      SizedBox(height: 8),
                                    ],
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
