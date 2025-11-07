import 'package:clase_01/firebase/songs_firebase.dart';
import 'package:clase_01/widgets/songs_widget.dart';
import 'package:flutter/material.dart';

class ListSongsScreen extends StatefulWidget {
  const ListSongsScreen({super.key});

  @override
  State<ListSongsScreen> createState() => _ListSongsScreenState();
}

class _ListSongsScreenState extends State<ListSongsScreen> {
  SongsFirebase songsFirebase = SongsFirebase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Lista Canciones"),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/add_song").then(
                    (value) => setState(() {}),
                  );
                },
                icon: Icon(Icons.add))
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(30),
          child: StreamBuilder(
            stream: songsFirebase.selectAllSongs(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    //return Text(snapshot.data!.docs[index].get("title"));
                    return SongsWidget(snapshot.data!.docs[index].data()
                        as Map<String, dynamic>);
                  },
                );
              } else {
                if (snapshot.hasError) {
                  return Center(
                    child: Text("Something went wrong"),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }
            },
          ),
        ));
  }
}
