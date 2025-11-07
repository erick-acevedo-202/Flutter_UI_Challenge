class ApiMoviesModel {
  bool adult;
  String backdropPath;
  List<int> genreIds;
  int id;
  String originalLanguage;
  String originalTitle;
  String overview;
  double popularity;
  String posterPath;
  String releaseDate;
  String title;
  double voteAverage;
  int voteCount;

  ApiMoviesModel({
    required this.adult,
    required this.backdropPath,
    required this.genreIds,
    required this.id,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.releaseDate,
    required this.title,
    required this.voteAverage,
    required this.voteCount,
  });

  factory ApiMoviesModel.fromMap(Map<String, dynamic> map) {
    return ApiMoviesModel(
      adult: map['adult'],
      backdropPath: map['backdrop_path'] ?? '',
      genreIds: map['genre_ids'].cast<int>(),
      id: map['id'],
      originalLanguage: map['original_language'],
      originalTitle: map['original_title'],
      overview: map['overview'],
      popularity: map['popularity'],
      posterPath: map['poster_path'] ?? '',
      releaseDate: map['release_date'],
      title: map['title'],
      voteAverage: map['vote_average'] ?? '',
      voteCount: map['vote_count'] ?? '',
    );
  }
}
