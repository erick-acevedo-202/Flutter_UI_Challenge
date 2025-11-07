import 'package:clase_01/models/seriesDAO.dart';
import 'package:clase_01/utils/app_string.dart';
import 'package:dio/dio.dart';
import 'package:async/async.dart';

class ApiCatholic {
  Dio dio = Dio();

  Future<List<SeriesDAO>> getCategory(int idCategoriy) async {
    String URL = "${AppString.urlbase}/json/categories/$idCategoriy.json";
    final respose = await dio.get(URL);
    final series = respose.data['series'] as List;

    return series.map((serie) => SeriesDAO.fromMap(serie)).toList();
  }

  Future<List<SeriesDAO>> getAllCategories() async {
    final FutureGroup<List<SeriesDAO>> futureGroup =
        FutureGroup<List<SeriesDAO>>();
    futureGroup.add(getCategory(2));
    futureGroup.add(getCategory(3));
    futureGroup.add(getCategory(4));
    futureGroup.add(getCategory(5));
    futureGroup.add(getCategory(6));
    futureGroup.close();

    List<SeriesDAO> listSeries = List<SeriesDAO>.empty(growable: true);
    final List<List<SeriesDAO>> results = await futureGroup.future;
    for (var result in results) {
      listSeries.addAll(result);
    }
    return listSeries;
  }
}
