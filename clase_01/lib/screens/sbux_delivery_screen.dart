import 'dart:io';

import 'package:clase_01/models/order_items.dart';
import 'package:clase_01/models/order_model.dart' as order_model;
import 'package:clase_01/models/product_model.dart';
import 'package:flutter/material.dart';

class SbuxDeliveryScreen extends StatefulWidget {
  const SbuxDeliveryScreen({super.key});

  @override
  State<SbuxDeliveryScreen> createState() => _SbuxDeliveryScreenState();
}

class _SbuxDeliveryScreenState extends State<SbuxDeliveryScreen> {
  int index = 0; // 0 == Delivery , 1 == TAKE AWAY
  double shippingCharges = 5.0;

  @override
  Widget build(BuildContext context) {
    //Label Section
    Widget _buildLabelSection(String section, double labelFontSize,
        double labelHeight, Color labelColor) {
      return IntrinsicWidth(
        child: Container(
          height: labelHeight,
          decoration: BoxDecoration(
            color: labelColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
              child: Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Text(
              section,
              style: TextStyle(
                  fontFamily: "Poppins_bold",
                  color: Colors.white,
                  fontSize: labelFontSize),
            ),
          )),
        ),
      );
    }

    // Widget reutilizable para los circulos 1 y L
    Widget _circleTag(String text, Color color) {
      return Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      );
    }

    Widget _getImageWidget(String imagePath) {
      if (imagePath.startsWith('assets')) {
        return Image.asset(
          imagePath,
          width: 30,
          height: 66,
        );
      } else {
        return Image.file(
          File(imagePath),
          width: 30,
          height: 66,
        );
      }
    }

    void _removeOrderItem(OrderItem item) {
      setState(() {
        order_model.orderItems
            .removeWhere((order) => order.item_id == item.item_id);
      });
    }

    Widget _buildDrinkDetails(OrderItem item) {
      return Dismissible(
        key: Key(item.item_id.toString()), // Necesita una key única
        background: Container(
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(30),
          ),
          child: const Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.only(right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.delete, color: Colors.white, size: 30),
                  SizedBox(width: 8),
                  Text('Delete',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                ],
              ),
            ),
          ),
        ),
        direction: DismissDirection.endToStart, // Solo deslizar a la izquierda
        onDismissed: (direction) {
          _removeOrderItem(item);
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.only(left: 15, right: 15),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300, width: 1.5),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            children: [
              _getImageWidget(item.product!.image_path),
              const SizedBox(width: 5),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.product!.product_name,
                      style: TextStyle(
                        fontFamily: "Poppins",
                        color: Color.fromARGB(255, 0, 98, 59),
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      item.size,
                      style: TextStyle(
                        fontFamily: "Poppins",
                        color: Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      "\$${item.subtotal}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Column(children: [
                Row(
                  children: [
                    _circleTag(item.quantity.toString(),
                        Color.fromARGB(255, 0, 98, 59)),
                    const SizedBox(width: 8),
                    _circleTag("L", Color.fromARGB(255, 222, 135, 55)),
                  ],
                ),
                const SizedBox(height: 12),
                _buildLabelSection(" -5★ ", 8.0, 12, Colors.black)
              ]),
              const SizedBox(width: 10),
              const Icon(
                Icons.bookmark,
                color: Color.fromARGB(255, 217, 208, 126),
                size: 20,
              ),
            ],
          ),
        ),
      );
    }

    //CARD Delivery Details
    final deliveryLocations = Card(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Image.asset('assets/sbux_assets/icon_pin.png'),
              ),
              //child: Image.asset('assets/sbux_assets/icon_pin.png'),
              // Icon(Icons.circle, color: Color.fromARGB(255, 217, 208, 126) , size: 10 ,)

              const Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Starbucks drive thru Celaya Norte",
                      style: TextStyle(
                          color: Color.fromARGB(255, 0, 98, 59),
                          fontFamily: "Poppins_bold",
                          fontSize: 16),
                      overflow: TextOverflow.ellipsis),
                  Text(
                      "Celaya-Dolores Hidalgo 2179, Cd Industrial de Celaya, 38010 Celaya, Gto.")
                ],
              )),
              IconButton(
                  onPressed: () {
                    print("PRESSED");
                  },
                  icon: Icon(
                    Icons.edit_square,
                    color: Color.fromARGB(255, 0, 98, 59),
                  )),
            ],
          ),
          //Validar si index es 1 o 0
          // ... spread Operator
          if (index == 0) ...{
            const Divider(
              color: Color.fromARGB(51, 0, 0, 0),
              thickness: 1,
              height: 20,
              indent: 40,
              endIndent: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 18, right: 20),
                  child: Icon(
                    Icons.circle,
                    color: Color.fromARGB(255, 217, 208, 126),
                    size: 10,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const SizedBox(
                            width: 175,
                            child: Text(
                                "Instituto Tecnologico Nacional de México en Celaya Campus 2 ",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 0, 98, 59),
                                    fontFamily: "Poppins_bold",
                                    fontSize: 16),
                                overflow: TextOverflow.ellipsis),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 15),
                            child: _buildLabelSection("Primary", 10.0, 14.0,
                                Color.fromARGB(255, 222, 135, 55)),
                          ),
                        ],
                      ),
                      Text(
                          "Antonio García Cubas 600, Fovissste, 38010 Celaya, Gto.")
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    print("PRESSED");
                  },
                  icon: Icon(
                    Icons.edit_square,
                    color: Color.fromARGB(255, 0, 98, 59),
                  ),
                ),
              ],
            ),
          }
        ],
      ),
    );

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: AppBar(
          backgroundColor: Color.fromARGB(255, 0, 98, 59),
          leadingWidth: 60,
          leading: Padding(
              padding: const EdgeInsets.only(left: 5, top: 10),
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Image.asset('assets/sbux_assets/icon_back_left.png'),
              )),
          title: Center(
              child:
                  Image.asset('assets/sbux_assets/icon_starbucks_white.png')),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: IconButton(
                onPressed: () {
                  setState(() {});
                },
                icon: Image.asset(
                  'assets/sbux_assets/icon_filter_delivery.png',
                ),
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 40,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        index = 0;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: index == 0
                            ? Color.fromARGB(255, 217, 208, 126)
                            : Color.fromARGB(255, 0, 98, 59),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        )),
                    child: const Text(
                      "DELIVERY",
                      style: TextStyle(
                          fontFamily: "Poppins_bold", color: Colors.white),
                    ),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        index = 1;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: index == 1
                          ? Color.fromARGB(255, 217, 208, 126)
                          : Color.fromARGB(255, 0, 98, 59),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    child: const Text(
                      "TAKE AWAY",
                      style: TextStyle(
                          fontFamily: "Poppins_bold", color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            child: Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 30),
              child: deliveryLocations,
            ),
          ),
          if (index == 1) ...[
            Padding(
              padding: EdgeInsets.only(top: 30, left: 30, right: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildLabelSection("Available at", 14.0, 25.0,
                      Color.fromARGB(255, 0, 98, 59)),
                  const Text(
                    "14:45",
                    style: TextStyle(
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Color.fromARGB(255, 222, 135, 55)),
                  )
                ],
              ),
            ),
            const Padding(
                padding: EdgeInsets.only(right: 30),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Saturday, 28th October 2025",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Color.fromARGB(255, 222, 135, 55)),
                  ),
                ))
          ],
          Padding(
            padding: EdgeInsets.only(top: 30, left: 30, right: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildLabelSection(
                    "Your order", 14.0, 25.0, Color.fromARGB(255, 0, 98, 59)),
                GestureDetector(
                  onTap: () {
                    Navigator.popAndPushNamed(context, "/sbux_home");
                  },
                  child: const Text(
                    "add more",
                    style: TextStyle(
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Color.fromARGB(255, 222, 135, 55)),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 30, right: 30, top: 10),
            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: order_model.myOrder.items!.length,
              itemBuilder: (context, index) {
                return Padding(
                    padding: EdgeInsets.only(top: 5, bottom: 5),
                    child: _buildDrinkDetails(
                      order_model.myOrder.items![index],
                    ));
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 30, right: 200, top: 10),
            child: _buildLabelSection(
                "Payment method", 14.0, 25.0, Color.fromARGB(255, 0, 98, 59)),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 30, top: 5),
            child: Text(
              "You will get 2 stars pay with your Starbucks Card",
              style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 12.0,
                  color: Color.fromARGB(255, 217, 208, 126)),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 30, right: 30, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset("assets/sbux_assets/sbux_card.png"),
                const SizedBox(
                  width: 135,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "4567 **** **** 2367",
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      Text(
                        "Erick Acevedo",
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 10.0,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey),
                      ),
                      Text(
                        "\$256.50",
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 10.0,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 0, 98, 59)),
                      )
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Container(
                    width: 48,
                    height: 48,
                    child: Image.asset("assets/sbux_assets/icon_next.png"),
                  ),
                  iconSize: 24,
                  padding: EdgeInsets.all(8),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 30, right: 30, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset("assets/sbux_assets/icon_tag.png"),
                    SizedBox(
                      width: 2,
                    ),
                    const Text(
                      "Voucher",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 14.0,
                          color: Color.fromARGB(255, 0, 98, 59)),
                    )
                  ],
                ),
                const Text(
                  "Choose",
                  style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 12.0,
                      color: Color.fromARGB(255, 217, 208, 126)),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 30, right: 30, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset("assets/sbux_assets/icon_ship.png"),
                    SizedBox(
                      width: 2,
                    ),
                    const Text(
                      "Shipping by",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 14.0,
                          color: Color.fromARGB(255, 0, 98, 59)),
                    )
                  ],
                ),
                const Text(
                  "Juan - \$2.00",
                  style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 12.0,
                      color: Color.fromARGB(255, 217, 208, 126)),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 30, right: 240, top: 10),
            child: _buildLabelSection(
                "Amount Detail", 14.0, 25.0, Color.fromARGB(255, 0, 98, 59)),
          ),
          Padding(
              padding: EdgeInsets.only(left: 30, right: 30, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Price",
                    style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 12.0,
                        color: Colors.grey.shade500),
                  ),
                  Text(
                    "\$${order_model.myOrder.get_total}",
                    style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 12.0,
                        color: Color.fromARGB(255, 217, 208, 126)),
                  )
                ],
              )),
          Padding(
              padding: EdgeInsets.only(left: 30, right: 30, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Shipping Charges",
                    style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 12.0,
                        color: Colors.grey.shade500),
                  ),
                  Text(
                    "\$${shippingCharges}",
                    style: const TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 12.0,
                        color: Color.fromARGB(255, 217, 208, 126)),
                  ),
                ],
              )),
          Padding(
              padding: EdgeInsets.only(left: 30, right: 30, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total",
                    style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 0, 98, 59)),
                  ),
                  Text(
                    "\$${order_model.myOrder.get_total + shippingCharges}",
                    style: const TextStyle(
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                        color: Color.fromARGB(255, 0, 98, 59)),
                  )
                ],
              )),
          Padding(
            padding: EdgeInsets.only(top: 20, left: 200, right: 30, bottom: 30),
            child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/sbux_pin");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 0, 98, 59),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                ),
                child: const Text(
                  "Pay now",
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: "Poppins",
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                )),
          ),
        ],
      ),
    );
  }
}
