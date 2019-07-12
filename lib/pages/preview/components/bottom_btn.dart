import 'package:flutter/material.dart';

class BottomBtn extends StatelessWidget {
  VoidCallback _onPressed;
  Icon _icon;
  Text _text;

  BottomBtn({
    VoidCallback onPressed,
    Icon icon,
    Text text,
  }):_onPressed = onPressed,
    _icon = icon,
    _text = text;

  @override
  Widget build(BuildContext context) {

    return MaterialButton(
      padding: EdgeInsets.all(10.0),
      onPressed: _onPressed,
      child: Column(
        children: <Widget>[ _icon, _text ],
      ),
    );
  }
}