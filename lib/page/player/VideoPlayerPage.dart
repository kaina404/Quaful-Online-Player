import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_simple_video_player/flutter_simple_video_player.dart';

class VideoPlayerPage extends StatelessWidget {
  final String url;

  const VideoPlayerPage({Key key, this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SimpleViewPlayer(
        url,
        isFullScreen: false,
      ),
      floatingActionButton: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
