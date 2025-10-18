import 'package:clase_01/database/users_database.dart';
import 'package:clase_01/firebase/fire_auth.dart';
import 'package:clase_01/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final conUser = TextEditingController();
  final conPwd = TextEditingController();
  bool isValidating = false;
  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');

  FireAuth? fireAuth;

  @override
  void initState() {
    super.initState();
    fireAuth = FireAuth();
  }

  @override
  Widget build(BuildContext context) {
    final txtUser = TextField(
      keyboardType: TextInputType.emailAddress,
      controller: conUser,
      decoration: InputDecoration(hintText: "Correo electrónico"),
    );

    final txtPwd = TextField(
      obscureText: true,
      controller: conPwd,
      decoration: InputDecoration(hintText: "Contraseña"),
    );

    final btnLogin = IconButton(
        onPressed: () {
          _onLogin(context);
          /*isValidating = true;
          //Cambio de variable, debo renderizar otra vez
          setState(() {
            print(isValidating);
          });
          Future.delayed(Duration(milliseconds: 3000)).then(
            (value) => Navigator.pushNamed(context, '/home'),
          );*/
        },
        icon: Icon(
          Icons.login,
          size: 40,
        ));

    final btnRegister = ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(context, '/sign_in');
      },
      child: const Text("Sign In"),
    );

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage("assets/fondo_minecraft.jpg"))),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Positioned(
              top: 200,
              child: Text(
                "Login Minecraft",
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 35,
                    fontFamily: "Minecraft"),
              ),
            ),
            Positioned(
                bottom: 80,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.2,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(30)),
                  child: Column(children: [
                    txtUser,
                    txtPwd,
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(child: btnLogin),
                          SizedBox(
                              width: 10), // espacio entre botones (opcional)
                          Expanded(child: btnRegister),
                        ],
                      ),
                    )
                  ]),
                )),
            Positioned(
              top: 300,
              child: isValidating
                  ? Lottie.asset('assets/loading2.json', height: 200)
                  : Container(),
            )
          ],
        ),
      ),
    );
  }

  void _showMessage(BuildContext context, String text, [Color? color]) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text), backgroundColor: color),
    );
  }

  Future<void> _onLogin(BuildContext context) async {
    final email = conUser.text.trim();
    final password = conPwd.text;

    try {
      /*final currentUser = await UsersDatabase().validateLogin(email, password);
      if (currentUser != null) {
        _showMessage(context, "Iniciando Sesión", Colors.green);
        Future.delayed(Duration(milliseconds: 2000)).then(
          (value) => Navigator.pushNamed(context, '/home'),
        );
      }
      else {
        _showMessage(context, "Credenciales Incorrectas", Colors.red);
      }
       */
      final user = await fireAuth!.loginUser(email, password);
      //Cuando reciba el usuario lo voy a enviar como parametro al home
      if (user!.uid != "") {
        _showMessage(context, "Iniciando Sesión Firebase", Colors.green);
        Navigator.pushNamed(context, '/home');
      }

      ;
    } catch (e) {
      _showMessage(context, "Error: $e", Colors.red);
    }
  }
}
