import 'package:clase_01/models/api_movies_model.dart';
import 'package:flutter/material.dart';

class MovieWidget extends StatelessWidget {
  MovieWidget({super.key, required this.apiMoviesModel});
  ApiMoviesModel apiMoviesModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      child: FadeInImage(
          placeholder: AssetImage('assets/loading.gif'),
          image: NetworkImage(
              'https://image.tmdb.org/t/p/w500/${apiMoviesModel.posterPath}')),
    );
  }
}
