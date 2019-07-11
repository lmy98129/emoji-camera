import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void requestPop(BuildContext context) {
  Navigator.pop(context);
  if (!Navigator.canPop(context)) {
    SystemChrome.setEnabledSystemUIOverlays([]);
  }
}