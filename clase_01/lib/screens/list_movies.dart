import 'package:clase_01/database/movies_database.dart';
import 'package:flutter/material.dart';

class ListMovies extends StatefulWidget {
  const ListMovies({super.key});

  @override
  State<ListMovies> createState() => _ListMoviesState();
}

class _ListMoviesState extends State<ListMovies> {
  MoviesDatabase? moviesDB;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    moviesDB = MoviesDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Peliculas :) "),
        actions: [
          IconButton(
              onPressed: () => Navigator.pushNamed(context, "/add")
                      .
                      //cuando regrese aplico un SET STATE para volver a renderizar la lista
                      then(
                    (value) => setState(() {}),
                  ),
              icon: Icon(Icons.add))
        ],
      ),
      body: FutureBuilder(
          future: moviesDB!.SELECT(),
          builder: (context, snapshot) {
            //Primero se verifica si tiene error, por que si no tiene
            //significa que ya ejecuto la consulta correctametane
            if (snapshot.hasError) {
              Center(
                child: Text("Something Went Wrong"),
              );
            }
            if (snapshot.hasData) {
              //Operador Ternario para ver si tiene data
              return snapshot.data!.isNotEmpty
                  ? ListView.builder(
                      itemBuilder: (context, index) {
                        final objM = snapshot.data![index];
                        return Container(
                          height: 100,
                          color: Colors.black,
                          child: Text(objM.nameMovie!),
                        );
                      },
                    )
                  : Center(
                      child: Text("Empty Data"),
                    );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
