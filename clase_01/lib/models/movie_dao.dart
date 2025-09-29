class MovieDao {
  int? idMovie;
  String? nameMovie;
  String? time;
  String? dateRelease;

  MovieDao({this.idMovie, this.nameMovie, this.time, this.dateRelease});

  //FACTORY permite utilizar un contructor nombrada para retornar otro constructor
  factory MovieDao.fromMap(Map<String, dynamic> mapa) {
    return MovieDao(
        idMovie: mapa['idMovie'],
        nameMovie: mapa['nameMovie'],
        time: mapa['time'],
        dateRelease: mapa['dateRelease']);
  }
}
