import 'package:flutter/material.dart';

Widget AlbumBtn(BuildContext context) {
  return FlatButton.icon(
    icon: Icon(Icons.collections),
    label: Text('相册'),
    onPressed: () => Navigator.of(context).popAndPushNamed("/album"),
  );
}