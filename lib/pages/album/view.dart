import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_demo/models/camera.dart';
import 'package:flutter_demo/models/preview.dart';
import 'package:provider/provider.dart';
import 'package:flutter_demo/utils/route.dart';

class buildView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(title: Text("相册")),
        body: _MainPage(),
      ),
      // ignore: missing_return
      onWillPop: () { requestPop(context); },
    );
  }
}

class _MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends State<_MainPage>{

  void _handleTap(int index) {
    Provider.of<PreviewModel>(context).onPageChanged(index);
    Navigator.of(context).popAndPushNamed("/preview");
  }

  @override
  Widget build(BuildContext context) {
    final cameraModel = Provider.of<CameraModel>(context);

    return GridView.count(
      crossAxisCount: 4,
      children: List.generate(cameraModel.photos.length, (index) {
        return GestureDetector(
          onTap: () {_handleTap(index);},
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: FileImage(File(cameraModel.photos[index])),
                    fit: BoxFit.cover
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}