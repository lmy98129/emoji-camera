import 'package:flutter/material.dart';
import 'package:flutter_demo/models/camera.dart';
import 'package:provider/provider.dart';

// 前后摄切换按钮
class SwitchBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cameraModel = Provider.of<CameraModel>(context);

    return GestureDetector(
      onTap: cameraModel.switchCamera,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: Colors.white, width: 1),
        ),
        child: Transform.rotate(
          angle: 90,
          origin: Offset(0, 0),
          child: Icon(Icons.sync),
        ),
      ),
    );
  }
}