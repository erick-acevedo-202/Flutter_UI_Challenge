import 'package:clase_01/firebase/songs_firebase.dart';
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
                  Navigator.pushNamed(context, "/add_song");
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
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return Text(snapshot.data!.docs[index].get("title"));
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
