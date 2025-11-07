import 'package:clase_01/services/api_movies_services.dart';
import 'package:clase_01/widgets/movie_widget.dart';
import 'package:flutter/material.dart';

class ListApiMovies extends StatefulWidget {
  const ListApiMovies({super.key});

  @override
  State<ListApiMovies> createState() => _ListApiMoviesState();
}

class _ListApiMoviesState extends State<ListApiMovies> {
  ApiMoviesServices? apiMovies = ApiMoviesServices();
  //MovieWidget movieWidget = MovieWidget(apiMoviesModel: apiMovies)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('API Movies'),
        ),
        body: FutureBuilder(
            future: apiMovies!.getMovies(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return CustomScrollView(
                  slivers: [
                    SliverGrid.builder(
                      itemCount: snapshot.data!.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 10,
                              childAspectRatio: .7),
                      itemBuilder: (context, index) {
                        return MovieWidget(
                            apiMoviesModel: snapshot.data![index]);
                      },
                    )
                  ],
                );
              } else {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }

              /*GridView.builder(
              itemCount: snapshot.data!.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, mainAxisSpacing: 10, childAspectRatio: .7),
              itemBuilder: (context, index) {
                return MovieWidget(apiMoviesModel: snapshot.data![index]);
              },
            );
          
          }
        },
      ),
    );*/
            }));
  }
}
