import 'package:clase_01/models/order_items.dart';
import 'package:clase_01/models/order_model.dart';
import 'package:clase_01/models/product_model.dart';
import 'package:flutter/material.dart';

class SbuxProductDetails extends StatefulWidget {
  final ProductModel product;

  const SbuxProductDetails(this.product);

  @override
  State<SbuxProductDetails> createState() => _SbuxProductDetailsState();
}

class _SbuxProductDetailsState extends State<SbuxProductDetails> {
  int quantity = 1;
  int prevQuantity = 1;
  bool _isIncrementing = true;
  int _currentDrinkIndex = 1;
  double total = 0;
  double extra_cost = 0;

  double getTotal() {
    return (widget.product.price + extra_cost) * quantity;
  }

  @override
  Widget build(BuildContext context) {
    double currentTotal = getTotal();

    // CONTADOR DE CANTIDAD
    final Widget _quantityLabel = Text(
      quantity.toString(),
      key: ValueKey<int>(quantity),
      style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 0, 98, 59)),
    );

    final Widget _quantityCounter = Container(
      height: 30,
      width: 90,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            radius: 15,
            backgroundColor: Color.fromARGB(255, 0, 98, 59),
            child: IconButton(
              onPressed: () {
                if (quantity > 1) {
                  setState(() {
                    prevQuantity = quantity;
                    quantity = quantity - 1;
                    _isIncrementing = false; // Decremento

                    print(getTotal());
                  });
                }
              },
              icon: Icon(Icons.remove, color: Colors.white, size: 14),
              padding: EdgeInsets.zero,
            ),
          ),
          SizedBox(
            width: 30,
            height: 30,
            child: Center(
                child: ClipRRect(
                    child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 100),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: Offset(0, _isIncrementing ? 1.0 : -1.0),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          );
                        },
                        child: _quantityLabel))),
          ),
          CircleAvatar(
            radius: 15,
            backgroundColor: Color.fromARGB(255, 0, 98, 59),
            child: IconButton(
              onPressed: () {
                if (quantity < 9) {
                  setState(() {
                    prevQuantity = quantity;
                    quantity = quantity + 1;
                    _isIncrementing = true; // Incremento

                    print(getTotal());
                  });
                }
              },
              icon: Icon(Icons.add, color: Colors.white, size: 14),
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );

    // Botones para el tamaño de la bebida
    Widget _btnDrinkSize(int drinkIndex, String drink_size, String icon_name,
        double drink_extra_cost) {
      final isSelected = _currentDrinkIndex == drinkIndex;
      return Container(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _currentDrinkIndex = drinkIndex;
                  extra_cost = drink_extra_cost;

                  print(getTotal());
                });
              },
              style: ElevatedButton.styleFrom(
                  shadowColor: Colors.white,
                  elevation: 0,
                  minimumSize: Size.square(80),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  backgroundColor: isSelected
                      ? Color.fromARGB(255, 0, 98, 59)
                      : Color.fromARGB(255, 242, 242, 242),
                  foregroundColor: isSelected
                      ? Colors.white
                      : Color.fromARGB(255, 77, 77, 77)),
              child: isSelected
                  ? Image.asset("assets/sbux_assets/${icon_name}_on.png")
                  : Image.asset("assets/sbux_assets/${icon_name}.png"),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Center(
                child: Text(
                  drink_size,
                  style: isSelected
                      ? TextStyle(color: Color.fromARGB(255, 0, 98, 59))
                      : TextStyle(color: Color.fromARGB(100, 76, 76, 76)),
                ),
              ),
            )
          ],
        ),
      );
    }

    List<Widget> _drinkSizeList = [
      _btnDrinkSize(1, "Tall", 'icon_tall', 0),
      _btnDrinkSize(2, "Grande", 'icon_grande', 5),
      _btnDrinkSize(3, "Venti", 'icon_venti', 10)
    ];

    return Scaffold(
        appBar: AppBar(
          leadingWidth: 60,
          leading: Padding(
              padding: const EdgeInsets.only(left: 5),
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Image.asset('assets/sbux_assets/icon_return.png'),
              )),
          title: Center(
              child: Image.asset('assets/sbux_assets/icon_starbucks.png')),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: ValueListenableBuilder<bool>(
                valueListenable: widget.product.is_favorite,
                builder: (context, isFavorite, child) {
                  return IconButton(
                    onPressed: () {
                      widget.product.is_favorite.value =
                          !widget.product.is_favorite.value;
                    },
                    icon: isFavorite
                        ? Image.asset("assets/sbux_assets/vector_like.png")
                        : Image.asset("assets/sbux_assets/vector_like_off.png"),
                  );
                },
              ),
            )
          ],
        ),
        body: Column(
          children: [
            SizedBox(height: 20),
            Center(
              child: Card(
                color: Color.fromARGB(255, 243, 241, 237),
                child: SizedBox(
                  height: 330,
                  width: 330,
                  child: Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        Hero(
                          tag: widget.product.product_name,
                          child: Image.asset(
                            widget.product.image_path,
                            height: 200,
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        _quantityCounter,
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
                height: 50,
                width: 350,
                child: Padding(
                  padding: EdgeInsets.only(left: 10, top: 15),
                  child: Text(
                    widget.product.category,
                    style: const TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold),
                  ),
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Text(
                    widget.product.product_name,
                    style: const TextStyle(
                        fontFamily: "Raleway_italic",
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(right: 40),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        Text(
                          widget.product.stars.toString(),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Color.fromARGB(255, 191, 191, 191)),
                        )
                      ],
                    )),
              ],
            ),
            SizedBox(
              width: 330,
              height: 90,
              child: Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  widget.product.description,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 109, 109, 109),
                    fontSize: 14.0,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 350,
              height: 110,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _drinkSizeList[0],
                  _drinkSizeList[1],
                  _drinkSizeList[2],
                  const VerticalDivider(
                      thickness: 2,
                      width: 15,
                      indent: 30,
                      endIndent: 30,
                      color: Color.fromARGB(150, 181, 181, 181)),
                  Text(
                    "\$${getTotal().toStringAsFixed(2)}",
                    style: const TextStyle(
                        fontFamily: "Raleway_italic",
                        fontWeight: FontWeight.normal,
                        fontSize: 20,
                        color: Color.fromARGB(255, 0, 98, 59)),
                  )
                ],
              ),
            ),
            SizedBox(
              width: 330,
              height: 60,
              child: Padding(
                padding: EdgeInsets.only(top: 20),
                child: ElevatedButton(
                    onPressed: () {
                      String currentSize = _currentDrinkIndex == 1
                          ? "Tall"
                          : _currentDrinkIndex == 2
                              ? "Grande"
                              : "Venti";
                      //Add Order Item
                      OrderItem currItem = OrderItem(
                          product: widget.product,
                          size: currentSize,
                          quantity: quantity,
                          subtotal: currentTotal);
                      orderItems.add(currItem);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Item Added to Cart"),
                            backgroundColor: Color.fromARGB(255, 0, 98, 59)),
                      );

                      Navigator.pushNamed(context, "/sbux_delivery");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 0, 98, 59),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                    ),
                    child: const Text(
                      "Add to bag",
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: "Raleway",
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    )),
              ),
            )
          ],
        ));
  }
}
