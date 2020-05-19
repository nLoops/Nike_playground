import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:playground/src/ui/music_player/size_config.dart';
import 'package:playground/src/ui/music_player/song_screen.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(builder: (context, orientation) {
        Responsive().init(constraints, orientation);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Music Player',
          home: SongScreen(),
        );
      });
    });
  }
}

