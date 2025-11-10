import 'package:clase_01/firebase_options.dart';
import 'package:clase_01/screens/dbg_order_details.dart';
import 'package:clase_01/screens/history_calendar.dart';
import 'package:clase_01/screens/list_series_screen.dart';
import 'package:clase_01/screens/upd_category_screen.dart';
import 'package:clase_01/screens/add_movie_screen.dart';
import 'package:clase_01/screens/add_product_screen.dart';
import 'package:clase_01/screens/add_song_screen.dart';
import 'package:clase_01/screens/home_screen.dart';
import 'package:clase_01/screens/list_api_movies.dart';
import 'package:clase_01/screens/list_movies.dart';
import 'package:clase_01/screens/list_songs_screen.dart';
import 'package:clase_01/screens/login_screen.dart';
import 'package:clase_01/screens/register_screen.dart';
import 'package:clase_01/screens/sbux_delivery_screen.dart';
import 'package:clase_01/screens/sbux_home_screen.dart';
import 'package:clase_01/screens/sbux_payment_feedback.dart';
import 'package:clase_01/screens/sbux_pin_screen.dart';
import 'package:clase_01/utils/theme_app.dart';
import 'package:clase_01/utils/value_listener.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: ValueListener.isDarkTheme,
        builder: (context, value, _) {
          return Builder(builder: (context) {
            return MaterialApp(
              theme: value ? ThemeApp.darkTheme() : ThemeApp.lightTheme(),
              routes: {
                "/home": (context) => HomeScreen(),
                "/sign_in": (context) => RegisterScreen(),
                "/listdb": (context) => ListMovies(),
                "/add": (context) => const AddMovieScreen(),
                "/sbux_home": (context) => const SbuxHomeScreen(),
                "/sbux_delivery": (context) => const SbuxDeliveryScreen(),
                "/sbux_pin": (context) => const SbuxPinScreen(),
                "/sbux_pay_feed": (context) => const SbuxPaymentFeedback(),
                "/list_songs": (context) => const ListSongsScreen(),
                "/add_song": (context) => const AddSongScreen(),
                "/add_product": (context) => const AddProductScreen(),
                "/upd_category": (context) => const UpdCategoryScreen(),
                "/api_movies": (context) => const ListApiMovies(),
                "/api_series": (context) => const ListSeriesScreen(),
                "/dbg_order_details": (context) => DbgOrderDetails(),
                "/history_calendar": (context) => HistoryCalendar()
              },
              title: "Material App",
              home: LoginScreen(),
            );
          });
        });
  }
}



/*    STATEFULL EXAMPLE
import 'package:clase_01/utils/colors_app.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int contador = 0;
  //va afuera del build para renderizar un numero diferente cada iteracion
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Practica 1 "),
          backgroundColor: Colors.green[600],
        ),
        body: Container(
          child: Center(
              child: Text(
            "Contador $contador",
            style: TextStyle(
                fontSize: 25.0,
                fontFamily: "Minecraft",
                color: ColorsApp.txtColor),
          )),
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.plus_one),
            onPressed: () {
              contador++;
              print(contador);
              setState(() {});
            }),
      ),
    );
  }

  miEvento() {}
}

*/

/* STATELESS EXAMPLE

import 'package:clase_01/utils/colors_app.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  MyApp({super.key});
  int contador =
      0; //va afuera del build para renderizar un numero diferente cada iteracion

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Practica 1 "),
          backgroundColor: Colors.green[600],
        ),
        body: Container(
          child: Center(
              child: Text(
            "Contador $contador",
            style: TextStyle(
                fontSize: 25.0,
                fontFamily: "Minecraft",
                color: ColorsApp.txtColor),
          )),
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.plus_one),
            onPressed: () {
              contador++;
              print(contador);
            }),
      ),
    );
  }

  miEvento() {}
}





*/