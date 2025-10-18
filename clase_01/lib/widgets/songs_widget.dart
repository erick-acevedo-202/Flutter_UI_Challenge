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
      height: 150,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          FadeInImage(
            placeholder: AssetImage("assets/gif_loading.gif"),
            image: NetworkImage(widget.song['conver']),
          ),
        ],
      ),
    );
  }
}
