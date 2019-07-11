import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_demo/models/camera.dart';
import 'dart:io';

// 相册按钮
class AlbumBtn extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AlbumBtnState();
}

// 相册按钮状态
class _AlbumBtnState extends State<AlbumBtn> {

  void _handleTap() {
    final cameraModel = Provider.of<CameraModel>(context);
    if (cameraModel.photos.length > 0) {
      Navigator.of(context).pushNamed("/preview");
    }
  }

  @override
  Widget build(BuildContext context) {
    final cameraModel = Provider.of<CameraModel>(context);

    return GestureDetector(
      onTap: _handleTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: Colors.white, width: 1),
          image:  DecorationImage(
            image: FileImage(File(cameraModel.photos.length > 0 ? cameraModel.photos.first : '')),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}