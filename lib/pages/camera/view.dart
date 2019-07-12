import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'package:provider/provider.dart';
import 'package:flutter_demo/models/camera.dart';
import 'components/capture_btn.dart';
import 'components/album_btn.dart';
import 'components/switch_btn.dart';

Widget buildView() {
  // 隐藏状态栏
  return Scaffold(
    body: _MainPage(),
  );
}

class _MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() =>  _MainPageState();
}

class _MainPageState extends State<_MainPage> with WidgetsBindingObserver{

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    Provider.of<CameraModel>(context, listen: false).initCamera();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final cameraModel = Provider.of<CameraModel>(context, listen: false);

    if (state == AppLifecycleState.inactive) {
      cameraModel.disposeCamera();
    } else if (state == AppLifecycleState.resumed) {
      cameraModel.initCamera();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cameraModel = Provider.of<CameraModel>(context);

    // 计算屏幕宽高
    var tmp = MediaQuery.of(context).size;
    var screenH = math.max(tmp.height, tmp.width);
    var screenW = math.min(tmp.height, tmp.width);

    // 计算相机宽高
    tmp = cameraModel.controller?.value?.previewSize;
    var previewH = tmp != null ? math.max(tmp.height, tmp.width) : screenH;
    var previewW = tmp != null ? math.min(tmp.height, tmp.width) : screenW;

    // 屏幕、相机比例
    var screenRatio = screenH / screenW;
    var previewRatio = previewH / previewW;

    var cameraView;
    if (cameraModel.controller == null || !cameraModel.controller.value.isInitialized) {
      cameraView = Container(
        height: screenH,
      );
    } else {
      cameraView = CameraPreview(cameraModel.controller);
    }

    return OverflowBox(
      maxHeight:
      // 若屏幕比例宽于相机比例，使用屏幕宽度、根据屏幕：相机高度比重新计算的高度。
      screenRatio > previewRatio ? screenH : screenW / previewW * previewH,
      maxWidth:
      screenRatio > previewRatio ? screenH / previewH * previewW : screenW,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          cameraView,

          Positioned(
            bottom: 0,
            child: Container(
              width: screenW,
              decoration: BoxDecoration(
                color: Color.fromRGBO(0, 0, 0, 0.5),
              ),
              padding: EdgeInsets.symmetric(vertical: 55, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  // 相册按钮
                  AlbumBtn(),
                  // 照相按钮
                  CaptureBtn(),
                  // 前后摄切换按钮
                  SwitchBtn(),
                ],
              )
            )
          ),

          Positioned(
              top: 0,
              child: Container(
                  width: screenW,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(0, 0, 0, 0.5),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Icon(Icons.person_outline),
                      Icon(Icons.dehaze),
                    ],
                  )
              )
          ),

        ],
      ),
    );
  }
}
