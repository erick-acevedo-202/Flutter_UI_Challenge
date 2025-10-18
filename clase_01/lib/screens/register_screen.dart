import 'dart:io';

import 'package:clase_01/database/users_database.dart';
import 'package:clase_01/firebase/fire_auth.dart';
import 'package:clase_01/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _imagePath;
  final usrDb = UsersDatabase();

  //Controladores para extraer los datos de los TextFields
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');

  FireAuth? fireAuth;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fireAuth = FireAuth();
  }

  @override
  void dispose() {
    //  LIBERAR MEMORIA
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  //METOOS para la FOTO

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      // Obtener directorio de documentos
      final directory = await getApplicationDocumentsDirectory();
      // Crear carpeta 'images' si no existe
      final folder = Directory('${directory.path}/images');
      if (!await folder.exists()) {
        await folder.create(recursive: true);
      }

      // Copiar imagen a la carpeta
      final fileName = basename(pickedFile.path);
      final savedImage =
          await File(pickedFile.path).copy('${folder.path}/$fileName');

      setState(() {
        _imagePath = savedImage.path;
      });

      print('Imagen guardada en: $_imagePath');
    }
  }

  void _showImagePickerOptions(Context) {
    showModalBottomSheet(
      context: Context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.camera),
                title: Text('Tomar foto'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Seleccionar de galería'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Register"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Create Account",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: "User Full Name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  // BOTON PARA SELECCIONAR IMAGEN
                  ElevatedButton(
                    onPressed: () => _showImagePickerOptions(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.camera_alt),
                        SizedBox(width: 10),
                        Text('Select Image'),
                      ],
                    ),
                  ),

                  // Mostrar imagen seleccionada si existe
                  if (_imagePath != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Image.file(File(_imagePath!), height: 150),
                    ),

                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        _onRegister(context);
                      },
                      child: const Text("Register")),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account? "),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context); // vuelve al login
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  )
                ],
              ),
            )));
  }

  void _showMessage(BuildContext context, String text, [Color? color]) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text), backgroundColor: color),
    );
  }

  Future<void> _onRegister(BuildContext context) async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final avatarPath = _imagePath;

    //Validaciones manuales
    if (name.isEmpty) {
      _showMessage(context, "El nombre es obligatorio", Colors.red);
      return;
    }
    if (email.isEmpty) {
      _showMessage(context, "El email es obligatorio", Colors.red);
      return;
    }
    if (!emailRegex.hasMatch(email)) {
      _showMessage(context, "El email no tiene un formato válido", Colors.red);
      return;
    }
    if (password.isEmpty) {
      _showMessage(context, "La contraseña es obligatoria", Colors.red);
      return;
    }
    if (avatarPath == null) {
      _showMessage(context, "Debes seleccionar un Avatar", Colors.red);
      return;
    }

    // Guardar en DB
    final newUser = UserModel(
      name: name,
      email: email,
      password: password,
      avatarPath: avatarPath,
    );

    //Registrar con Firebase
    fireAuth!.registerUser(newUser.email, newUser.password).then((newUser) {
      try {
        if (newUser != null) {
          _showMessage(context, "Usuario registrado en Firebase con exito",
              Colors.green);
        }
      } catch (e) {
        _showMessage(context, "Error: $e", Colors.red);
      }
    });

    /* BASE DE DATOS LOCAL
    
    try {
      await UsersDatabase().insertUser(newUser);
      _showMessage(context, "Usuario registrado con exito", Colors.green);
      Future.delayed(Duration(milliseconds: 2000)).then(
        (value) => Navigator.pushNamed(context, '/home'),
      );
    } catch (e) {
      _showMessage(context, "Error: $e", Colors.red);
    }*/
  }
}
