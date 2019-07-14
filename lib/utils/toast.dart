import 'package:toast/toast.dart';
import 'package:flutter/material.dart';

void showToast(msg, context) {
  Toast.show(msg, context,
    backgroundColor: Theme.of(context).primaryColor,
    gravity: Toast.BOTTOM,
    duration: 2
  );
}