import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_demo/utils/route.dart';
import 'components/default_emoji_mode_handler.dart';
import 'package:flutter_demo/models/camera.dart';

class buildView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    // WillPopScope是路由跳转中间件
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text("设置"),
        ),
        body: _MainPage(),
      ),
      // ignore: missing_return
      onWillPop: () {
        requestPop(context);
      },
    );
  }
}

class _MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends State<_MainPage> {
  bool _isAutoFrontCamera;
  bool _isAutoEmojiSwitchFace;

  @override
  void initState() {
    // 显示状态栏
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    SharedPreferences.getInstance().then((SharedPreferences prefs) {
      bool isAutoFontCamera = prefs.getBool(IS_AUTO_FRONT_CAMERA);
      setState(() {
        if (isAutoFontCamera == null) {
          _isAutoFrontCamera = false;
        } else {
          _isAutoFrontCamera = isAutoFontCamera;
        }
      });

      bool isAutoEmojiSwitchFace = prefs.getBool(IS_AUTO_EMOJI_SWITCH_FACE);
      setState(() {
        if (isAutoEmojiSwitchFace == null) {
          _isAutoEmojiSwitchFace = false;
        } else {
          _isAutoEmojiSwitchFace = isAutoEmojiSwitchFace;
        }
      });
    });
    super.initState();
  }

  void _handleAutoFrontCamera(bool isAutoFrontCamera) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(IS_AUTO_FRONT_CAMERA, isAutoFrontCamera);
    setState(() {
      _isAutoFrontCamera = isAutoFrontCamera;
    });
  }

  void _handleAutoSwitchFace(bool isAutoEmojiSwitchFace) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(IS_AUTO_EMOJI_SWITCH_FACE, isAutoEmojiSwitchFace);
    setState(() {
      _isAutoEmojiSwitchFace = isAutoEmojiSwitchFace;
    });
  }

  void _handleDefaultEmojiMode() {
    defaultEmojiModeHandler(context);
  }

  @override
  Widget build(BuildContext context) {

    return ListView(
      children: <Widget>[
        ListTile(
          title: Text("启动时默认为前摄"),
          trailing: Switch(
            value: _isAutoFrontCamera,
            onChanged: _handleAutoFrontCamera
          ),
        ),
        ListTile(
          title: Text("拍照时自动生成emoji换脸"),
          trailing: Switch(
            value: _isAutoEmojiSwitchFace,
            onChanged: _handleAutoSwitchFace,
          ),
        ),
        ListTile(
          title: Text("选择Emoji换脸的默认样式"),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: _handleDefaultEmojiMode,
        )
      ],
    );
  }

}