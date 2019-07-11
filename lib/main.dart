import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'models/camera.dart';
import 'models/preview.dart';
import 'package:flutter_demo/pages/camera/view.dart' as camera;
import 'package:flutter_demo/pages/preview/view.dart' as preview;
import 'package:flutter_demo/pages/album/view.dart' as album;

void main() async {
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
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
            title: 'Emo-Cam',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                primarySwatch: Colors.amber,
                brightness: Brightness.dark
            ),
            home: camera.buildView(),
            routes: <String, WidgetBuilder> {
              '/preview': (BuildContext context) => preview.buildView(),
              '/album': (BuildContext context) => album.buildView(),
            },
          );
        },
      ),
    );


  }
}



