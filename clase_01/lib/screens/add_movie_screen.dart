import 'package:clase_01/database/movies_database.dart';
import 'package:clase_01/models/movie_dao.dart';
import 'package:flutter/material.dart';

class AddMovieScreen extends StatefulWidget {
  const AddMovieScreen({super.key});

  @override
  State<AddMovieScreen> createState() => _AddMovieScreenState();
}

class _AddMovieScreenState extends State<AddMovieScreen> {
  //PASO 1 crear obj Database
  MoviesDatabase? moviesDB;

  DateTime selectedDate = DateTime.now();

  //PASO 3 crear text fields y controladores
  TextEditingController conTitle = TextEditingController();
  TextEditingController conTime = TextEditingController();
  TextEditingController conRelease = TextEditingController();

  @override
  void initState() {
    // PASO 2: Instancias objeto
    super.initState();
    moviesDB = MoviesDatabase();
  }

  @override
  Widget build(BuildContext context) {
    MovieDao? obj;
    if (ModalRoute.of(context)!.settings.arguments != null) {
      obj = ModalRoute.of(context)!.settings.arguments as MovieDao;
      conTitle.text = obj.nameMovie!;
      conTime.text = obj.time!;
      conRelease.text = obj.dateRelease!;
    }

    conRelease.text = selectedDate.toString();

    final txtTitle = TextFormField(
      controller: conTitle,
      decoration: InputDecoration(hintText: "Titulo de la Pelicula"),
    );

    final txtTime = TextFormField(
      controller: conTime,
      decoration: InputDecoration(hintText: "Duración de la Pelicula"),
    );

    final txtRelease = TextFormField(
      controller: conRelease,
      onTap: () => _selectedDate(context),
      decoration: InputDecoration(hintText: "Fecha de lanzamiento"),
    );

    final btnGuardar = ElevatedButton(
        onPressed: () {
          if (obj == null) {
            moviesDB!.INSERT("tblMovies", {
              "nameMovie": conTitle.text,
              "time": conTime.text,
              "dateRelease": conRelease.text,
            }).then(
              (value) => Navigator.pop(context),
            );
          } else {
            moviesDB!.UPDATE("tblMovies", {
              "idMovie": obj.idMovie,
              "nameMovie": conTitle.text,
              "time": conTime.text,
              "dateRelease": conRelease.text,
            }).then(
              (value) => Navigator.pop(context),
            );
          }
        },
        child: Text("Guardar"));

    //PASO 4 esto debe ser Scaffold
    return Scaffold(
      appBar: AppBar(
        title: const Text('Insertar Pelicula'),
      ),
      body: ListView(
        //shrinkWrap para limitar el tamaño de la lista
        shrinkWrap: true,
        children: [txtTitle, txtTime, txtRelease, btnGuardar],
      ),
    );
  }

  _selectedDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2025));

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }
}
