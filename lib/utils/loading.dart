import 'package:flutter/material.dart';

void showLoading(msg, context) {
  showDialog(
      context: context,
      builder: (context) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(),
                SizedBox(height: 10),
                Text(msg),
              ],
            ),
          ),
        );
      }
  );
}

void hideLoading(context) {
  Navigator.of(context, rootNavigator: true).pop();
}