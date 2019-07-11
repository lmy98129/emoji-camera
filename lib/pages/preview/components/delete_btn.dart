import 'package:flutter/material.dart';

class DeleteBtn extends StatelessWidget {
  VoidCallback _onPressed;

  DeleteBtn({
    VoidCallback onPressed
  }):_onPressed = onPressed;

  @override
  Widget build(BuildContext context) {

    return MaterialButton(
      padding: EdgeInsets.all(10.0),
      onPressed: _onPressed,
      child: Column(
        children: <Widget>[
          Icon(Icons.delete),
          Text('删除'),
        ],
      ),
    );
  }
}