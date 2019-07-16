import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_demo/models/camera.dart';

void defaultEmojiModeHandler(context) async {
  
  showDialog(
    context: context,
    builder: (context) {
      return _EmojiModeDialog();
    }
  );
}

class _EmojiModeDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _EmojiModeDialogState();
}

class _EmojiModeDialogState extends State<_EmojiModeDialog> {
  String _mode;

  @override
  void initState() {
    SharedPreferences.getInstance().then((SharedPreferences prefs) {
      String mode = prefs.getString(DEFAULT_EMOJI_MODE);
      if (mode == null) {
        mode = EMOJI_MODE_COVER;
        prefs.setString(DEFAULT_EMOJI_MODE, EMOJI_MODE_COVER);
        setState(() {
          _mode = EMOJI_MODE_COVER;
        });
      } else {
        setState(() {
          _mode = mode;
        });
      }
    });
    super.initState();
  }

  void _changeHandler(String mode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(DEFAULT_EMOJI_MODE, mode);
    setState(() {
      _mode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => AlertDialog(
        title: Text("选择Emoji换脸的样式"),
        content: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              RadioListTile<String>(
                value: EMOJI_MODE_COVER,
                groupValue: _mode,
                title: Text("替换脸部"),
                onChanged: _changeHandler,
              ),
              RadioListTile<String>(
                value: EMOJI_MODE_CIRCLE,
                groupValue: _mode,
                title: Text("环绕脸部"),
                onChanged: _changeHandler,
              )
            ],
          ),
        ),
      ),
    );
  }
}
