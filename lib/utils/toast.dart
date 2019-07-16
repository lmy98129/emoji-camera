import 'package:toast/toast.dart';
import 'package:flutter/material.dart';

void showToast(msg, context, { int toast = 0 }) {
  Toast.show(msg, context,
    backgroundColor: Theme.of(context).primaryColor,
    gravity: toast,
    duration: 2
  );
}