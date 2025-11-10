import 'package:clase_01/models/order_model.dart';
import 'package:flutter/material.dart';

class SbuxPaymentFeedback extends StatefulWidget {
  const SbuxPaymentFeedback({super.key});

  @override
  State<SbuxPaymentFeedback> createState() => _SbuxPaymentFeedbackState();
}

class _SbuxPaymentFeedbackState extends State<SbuxPaymentFeedback> {
  @override
  Widget build(BuildContext context) {
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
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Texto superior
              const Text(
                "Payment Successful",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 25),

              // Imagen compuesta (mano + estrella/gif)
              Stack(
                alignment: Alignment.topCenter,
                clipBehavior: Clip.none,
                children: [
                  Image.asset(
                    'assets/sbux_assets/star_2.gif',
                    height: 300,
                  ),
                  Positioned(
                      bottom: -100,
                      left: -60,
                      child: Image.asset(
                        'assets/sbux_assets/hand.png',
                      )),
                ],
              ),

              const SizedBox(height: 30),

              const Text(
                "THANK YOU",
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF00623B),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),

              RichText(
                text: TextSpan(
                  text: "You get ",
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.orangeAccent,
                  ),
                  children: [
                    TextSpan(
                      text: " ${myOrder.star_points} Star Points ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: "reward"),
                  ],
                ),
              ),

              const SizedBox(height: 15),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  "Your order was delivered successfully. For more details, check History under Portfolio Tab",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                    height: 1.4,
                  ),
                ),
              ),

              const SizedBox(height: 35),

              ElevatedButton(
                onPressed: () {
                  Navigator.popAndPushNamed(context, '/history_calendar');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00623B),
                  minimumSize: const Size(200, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "History",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // HOME
              OutlinedButton(
                onPressed: () {
                  Navigator.popUntil(
                      context, ModalRoute.withName('/sbux_home'));
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF00623B), width: 2),
                  minimumSize: const Size(200, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Home",
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF00623B),
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
