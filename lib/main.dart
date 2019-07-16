import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/camera.dart';
import 'models/preview.dart';
import 'pages/camera/view.dart' as camera;
import 'pages/preview/view.dart' as preview;
import 'pages/album/view.dart' as album;
import 'pages/settings/view.dart' as settings;

void main() async {
  await _init();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(builder: (_) => CameraModel(),),
        ChangeNotifierProvider(builder: (_) => PreviewModel(),)
      ],
      child: Consumer2<CameraModel, PreviewModel>(
        builder: (context, _, __, ___) {
          return MaterialApp(
            title: 'Emo Cam',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                primarySwatch: Colors.amber,
                brightness: Brightness.dark
            ),
            home: camera.buildView(),
            routes: <String, WidgetBuilder> {
              '/preview': (BuildContext context) => preview.buildView(),
              '/album': (BuildContext context) => album.buildView(),
              '/settings': (BuildContext context) => settings.buildView(),
            },
          );
        },
      ),
    );


  }
}

void _init() async {
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.getBool(IS_AUTO_FRONT_CAMERA) == null) {
    await prefs.setBool(IS_AUTO_FRONT_CAMERA, false);
  }

  if (prefs.getBool(IS_AUTO_EMOJI_SWITCH_FACE) == null) {
    await prefs.setBool(IS_AUTO_EMOJI_SWITCH_FACE, false);
  }

  if (prefs.getString(DEFAULT_EMOJI_MODE) == null) {
    await prefs.setString(DEFAULT_EMOJI_MODE, EMOJI_MODE_COVER);
  }
}


