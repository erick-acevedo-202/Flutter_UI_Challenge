import 'package:clase_01/screens/home_screen.dart';
import 'package:clase_01/screens/login_screen.dart';
import 'package:clase_01/screens/register_screen.dart';
import 'package:clase_01/utils/theme_app.dart';
import 'package:clase_01/utils/value_listener.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

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
                "/sign_in": (context) => RegisterScreen()
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