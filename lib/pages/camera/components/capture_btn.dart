import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_demo/models/camera.dart';

// 照相按钮
class CaptureBtn extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CaptureBtnState();
}

// 照相按钮内部状态
class _CaptureBtnState extends State<CaptureBtn> {
  bool _capBtnActive = false;

  void _switchCapBtnActive() {
    setState(() {
      _capBtnActive = !_capBtnActive;
    });
  }

  void _handleTapDown(detail) {
    _switchCapBtnActive();
  }

  void _handleLongPressUp() {
    _switchCapBtnActive();
  }

  void _handleTapUp(detail) {
    _switchCapBtnActive();
    Future.delayed(Duration(milliseconds: 400), () {
      Provider.of<CameraModel>(context).takePhoto(detail);
    });
  }

  @override
  Widget build(BuildContext context) {

    return Container(
        width: 90.0,
        height: 90.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(90.0),
          border: Border.all(color: Colors.white, width: 1),
        ),
        child: Center(
          child: GestureDetector(
            onTapDown: _handleTapDown,
            onTapUp: _handleTapUp,
            onLongPressUp: _handleLongPressUp,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 100),
              width: _capBtnActive ? 76.0 : 71.0,
              height: _capBtnActive ? 76.0 : 71.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(79.0),
                color: Colors.white,
              ),
            ),
          ),
        )
    );
  }
}