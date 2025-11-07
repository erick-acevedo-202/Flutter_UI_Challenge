import 'package:flutter/material.dart';

class SongsWidget extends StatefulWidget {
  //constructor que recibe como parametro un mapa de una cancion
  SongsWidget(this.song, {super.key});

  Map<String, dynamic> song;

  @override
  State<SongsWidget> createState() => _SongsWidgetState();
}

class _SongsWidgetState extends State<SongsWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueGrey),
        color: Colors.grey[50],
      ),
      child: Row(
        children: [
          FadeInImage(
            placeholder: AssetImage("assets/gif_loading.gif"),
            //fadeInDuration: Duration(seconds: 4),
            image: NetworkImage(widget.song['cover']),
          ),
          /*ListTile(
            title: Text(widget.song['title']),
            subtitle: Text(widget.song['artist']),
          )*/
          Column(
            children: [
              Text(widget.song['title']),
              Text(widget.song['artist']),
            ],
          ),
          IconButton(onPressed: () {}, icon: Icon(Icons.abc)),
        ],
      ),
    );
  }
}
