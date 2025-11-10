import 'dart:async';
import 'package:clase_01/database/product_database.dart';
import 'package:clase_01/models/order_items.dart';
import 'package:clase_01/models/order_model.dart';
import 'package:pinput/pinput.dart';
import 'package:flutter/material.dart';

class SbuxPinScreen extends StatefulWidget {
  const SbuxPinScreen({super.key});

  @override
  State<SbuxPinScreen> createState() => _SbuxPinScreenState();
}

class _SbuxPinScreenState extends State<SbuxPinScreen> {
  int _secondsRemaining = 30;
  Timer? _timer;
  Color _counterColor = Colors.grey.shade600;
  ProductDatabase? productsDB;

  @override
  void initState() {
    super.initState();
    _startCountdown();
    productsDB = ProductDatabase();
  }

  void _showMessage(BuildContext context, String text, [Color? color]) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text), backgroundColor: color),
    );
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _secondsRemaining == 0
        ? _counterColor = Colors.blueAccent
        : _counterColor = Colors.grey.shade600;

    final defaultPinTheme = PinTheme(
      width: 60,
      height: 60,
      textStyle: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
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
        title: Padding(
          padding: EdgeInsets.only(left: 90),
          child: Image.asset('assets/sbux_assets/icon_starbucks.png'),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Insert your Starbucks App PIN",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 30),

              // PIN INPUT
              Pinput(
                length: 4,
                defaultPinTheme: defaultPinTheme,
                obscureText: true,
              ),

              const SizedBox(height: 25),

              // TIMER TEXT
              GestureDetector(
                onTap: () {
                  if (_secondsRemaining == 0) {
                    _counterColor = Colors.grey.shade600;
                    _secondsRemaining = 30;
                    _startCountdown();
                  }
                },
                child: Text(
                  _secondsRemaining > 0
                      ? "Resend in 00:${_secondsRemaining.toString().padLeft(2, '0')}"
                      : "Resend",
                  style: TextStyle(
                    fontSize: 14,
                    color: _counterColor,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // OK BUTTON
              ElevatedButton(
                onPressed: () {
                  myOrder.total = myOrder.get_total;
                  myOrder.itemCount = myOrder.get_itemCount;
                  //Si gastas más de 100 pesos en compras, obtienes estrellas
                  if (myOrder.total > 100) {
                    myOrder.star_points = myOrder.total ~/ 100; //350 -> 3
                  }

                  print("###### GLOBAL ORDER ####${myOrder.toMap()}");

                  productsDB!.INSERT('tblOrder', myOrder.toMap()).then(
                    (order_id) {
                      print("NEW ORDER ID ${order_id}");
                      int completed = 0;
                      for (OrderItem item in orderItems) {
                        item.order_id = order_id;
                        productsDB!.INSERT('tblItems', item.toMap()).then((_) {
                          completed++;
                          if (completed == orderItems.length) {
                            myOrder.cleanOrder;
                            _showMessage(
                                context, "Orden Solicitada!", Colors.green);
                            Navigator.pushNamed(context, "/sbux_pay_feed");
                          }
                        });
                      }
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00623B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  minimumSize: const Size(200, 50),
                ),
                child: const Text(
                  "OK",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
