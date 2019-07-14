import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' show join;
import 'package:camera/camera.dart';
import 'package:flutter_demo/utils/file.dart' as fileUtil;

class CameraModel with ChangeNotifier {
  List<CameraDescription> _cameras = List<CameraDescription>();
  CameraController _controller;
  bool _isFrontCamera = true;
  List<String> _photos = List<String>();

  get cameras => _cameras;
  get controller => _controller;
  get isFrontCamera => _isFrontCamera;
  List<String> get photos => _photos;

  void initCamera () async {
    await getFileList();
    _cameras = await availableCameras();
    var index = _isFrontCamera? 1 : 0;
    _controller = CameraController(cameras[index], ResolutionPreset.high);
    await _controller.initialize();
    notifyListeners();
  }

  Future<Null> getFileList() async {
    List<FileSystemEntity> files = await fileUtil.getFileList();
    _photos.clear();
    files.forEach((entity) {
      if (Platform.isIOS) {
        if (entity.path.endsWith('.png')) {
          _photos.add(entity.path);
        }
      } else {
        if (entity.path.endsWith('.jpeg')) {
          _photos.add(entity.path);
        }
      }
    });
    notifyListeners();
  }

  void disposeCamera() {
    _controller.dispose();
    notifyListeners();
  }

  void switchFrontCamera() {
    _isFrontCamera = !_isFrontCamera;
  }

  void insertPhoto(index, newPath) {
    _photos.insert(index, newPath);
    notifyListeners();
  }

  void takePhoto(detail) async {
    var dir = await fileUtil.dirCheck(fileUtil.ALBUM_PATH);
    var cameraTag = _isFrontCamera ? "FRONT" : "BACK";
    var fileName = '${cameraTag}_${DateTime.now()}.jpeg';

    if (Platform.isIOS) {
      fileName = '${cameraTag}_${DateTime.now()}.png';
    }

    var path = join(dir, fileName);

    await _controller.takePicture(path);

//    TODO: 优化前摄镜像图像处理
//    if (_isFrontCamera) {
//      Im.Image im;
//      List<int> bytes = await File(path).readAsBytes();
//
//      var timer1 = DateTime.now();
//      if (Platform.isIOS) {
//        im = Im.decodePng(bytes);
//      } else {
//        im = Im.decodeJpg(bytes);
//      }
//      print(DateTime.now().difference(timer1).inSeconds);
//
//
//      Im.Image newIm = Im.flipVertical(im);
//
//      await File(path).delete();
//      await File(path).create();
//      if (Platform.isIOS) {
//        await File(path).writeAsBytes(Im.encodePng(newIm));
//      } else {
//        await File(path).writeAsBytes(Im.encodeJpg(newIm));
//      }
//
//    }
//
    insertPhoto(0, path);
  }

  void switchCamera() async {
    switchFrontCamera();
    await _controller.dispose();
    initCamera();
  }

}