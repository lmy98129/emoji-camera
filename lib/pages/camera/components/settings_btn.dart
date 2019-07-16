import 'package:flutter/material.dart';

// 相册按钮
class SettingsBtn extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingsBtnState();
}

// 相册按钮状态
class _SettingsBtnState extends State<SettingsBtn> {

  void _handleTap() {
      Navigator.of(context).pushNamed("/settings");
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: Icon(Icons.dehaze),
    );
  }
}