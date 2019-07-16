import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_extend/share_extend.dart';

import 'package:flutter_demo/models/camera.dart';
import 'package:flutter_demo/models/preview.dart';

class MoreBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: PopupMenuButton<String>(
        onSelected: (String value) { _handleSelected(value, context);},
        offset: Offset(0, -120.0),
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          PopupMenuItem(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Icon(Icons.close),
                Text('删除')
              ],
            ),
            value: "delete",
          ),
          PopupMenuItem(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Icon(Icons.share),
                Text('分享')
              ],
            ),
            value: "share",
          )
        ],
        child: Container(
          child: Column(
            children: <Widget>[
              Icon(Icons.more_horiz),
              Text('更多')
            ],
          ),
        ),
      ),
    );
  }

}

void _handleSelected(String value, BuildContext context) {
  switch(value) {
    case "delete":
      _handleDelete(context);
      break;
    case "share":
      _handleShare(context);
      break;
  }
}

void _handleDelete(context) async {
  final cameraModel = Provider.of<CameraModel>(context);
  final previewModel = Provider.of<PreviewModel>(context);
  int currentPage = previewModel.currentPage;
  String currentPath = cameraModel.photos[currentPage];

  await File(currentPath).delete();
  await cameraModel.getFileList();
}

void _handleShare(context) async {
  final cameraModel = Provider.of<CameraModel>(context);
  final previewModel = Provider.of<PreviewModel>(context);
  int currentPage = previewModel.currentPage;
  String currentPath = cameraModel.photos[currentPage];

  ShareExtend.share(currentPath, "image");
}