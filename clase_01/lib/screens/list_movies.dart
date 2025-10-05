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

  Widget _buildDialog(int id_movie) {
    return AlertDialog(
      title: Text('Confirmación'),
      content: Text('Desea borrar la pelicula con el ID: $id_movie'),
      actions: [
        TextButton(
          onPressed: () => moviesDB!.DELETE("tblMovies", id_movie).then(
            (value) {
              var msj = "";

              if (value > 0) {
                msj = "Registro borrado exitosamente";
                setState(() {});
              } else {
                msj = "No se eliminó el registro";
              }
              final snackbar = SnackBar(content: Text(msj));
              Navigator.pop(context);
            },
          ),
          child: Text('Aceptar', style: TextStyle(color: Colors.green)),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancelar', style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(children: [Text('Movies '), Icon(Icons.movie)]),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/add',
              ).then((onValue) => setState(() {}));
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: moviesDB!.SELECT('tblMovies'),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Hubo un error. \n${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!.length == 0) {
            return Center(child: Text('No hay pelis'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final obj = snapshot.data![index];
              return Container(
                height: 111,
                color: const Color.fromARGB(255, 47, 128, 20),
                child: Column(
                  children: [
                    Text(obj.nameMovie!),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/add', arguments: obj)
                                .then(
                              (value) => setState(() {}),
                            );
                          },
                          icon: Icon(Icons.update),
                          style: ButtonStyle(),
                        ),
                        //Expanded(child: Container(),),
                        IconButton(
                          onPressed: () async {
                            return showDialog(
                              context: context,
                              builder: (context) => _buildDialog(obj.idMovie!),
                            );
                          },
                          icon: Icon(Icons.delete),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
