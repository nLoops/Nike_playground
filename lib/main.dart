import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:playground/src/ui/nike_store/nike_store.dart';

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nike Store',
      home: NikeStore(),
    );
  }
}

