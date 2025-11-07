import 'package:clase_01/services/api_catholic.dart';
import 'package:clase_01/utils/app_string.dart';
import 'package:flutter/material.dart';

class ListSeriesScreen extends StatefulWidget {
  const ListSeriesScreen({super.key});

  @override
  State<ListSeriesScreen> createState() => _ListSeriesScreenState();
}

class _ListSeriesScreenState extends State<ListSeriesScreen> {
  ApiCatholic apiCatholic = ApiCatholic();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Series Screen"),
      ),
      body: FutureBuilder(
        future: apiCatholic.getAllCategories(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print("##################################");

            print("##################################");

            print("##################################");
            print('${AppString.urlbase}${snapshot.data![2].thumbUrl}');

            print("##################################");

            print("##################################");

            print("##################################");
            return GridView.builder(
              itemCount: snapshot.data!.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: .7,
                  crossAxisSpacing: 10),
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(
                              '${AppString.urlbase}${snapshot.data![index].thumbUrl}'))),
                );
              },
            );
          } else {
            if (snapshot.hasError) {
              return Center(
                child:
                    Text("Something went wrong ${snapshot.error.toString()}"),
              );
            } else {
              return CircularProgressIndicator();
            }
          }
        },
      ),
    );
  }
}
