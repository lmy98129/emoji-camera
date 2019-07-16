import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';

import 'package:flutter_demo/models/preview.dart';
import 'package:flutter_demo/models/camera.dart';
import 'package:flutter_demo/utils/toast.dart';
import 'package:flutter_demo/utils/file.dart';

void mattingHandler(context) {
  final previewModel = Provider.of<PreviewModel>(context);

  showDialog(
      context: context,
      builder: (context) {
        return ProgressHUD(
          borderColor: Colors.transparent,
          padding: EdgeInsets.all(20.0),
          child: Builder(
            builder: (context) => AlertDialog(
              title: Text("请选择抠图背景"),
              content: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    RadioListTile<String>(
                      value: "image",
                      groupValue: previewModel.mattingMode,
                      title: OutlineButton.icon(
                        borderSide: BorderSide(color: Colors.grey),
                        icon: Icon(Icons.image),
                        label: Text(previewModel.selectStatus),
                        onPressed: () async {
                          List<Asset> imageList = await MultiImagePicker.pickImages(
                              maxImages: 1,
                              materialOptions: MaterialOptions(
                                actionBarColor: "#ff212121",
                                statusBarColor: "#ff212121",
                                allViewTitle: "选择图片",
                                startInAllView: true,
                                selectionLimitReachedText: "最多选择一张",
                              ));
                          if (imageList.length > 0) {
                            previewModel.setSelectStatus(true,
                                path: imageList[0]);
                          }
                        },
                      ),
                      onChanged: previewModel.setMattingMode,
                    ),
                    RadioListTile<String>(
                      groupValue: previewModel.mattingMode,
                      value: "none",
                      title: Text("无背景"),
                      onChanged:previewModel.setMattingMode,
                    )
                  ],
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    '取消',
                    style: TextStyle(color: Colors.white70),
                  ),
                  onPressed: () {
                    _closeDialog(context);
                  },
                ),
                FlatButton(
                  child: Text('确定'),
                  onPressed: () { _handleConfirm(context);},
                )
              ],
            ),
          )
        );
      });
}

void _closeDialog(context) {
  final previewModel = Provider.of<PreviewModel>(context);

  previewModel.setMattingMode(DEFAULT_MATTING_MODE);
  previewModel.setSelectStatus(false);
  Navigator.of(context).pop(1);
}

void _handleConfirm(context) async {
  final progress = ProgressHUD.of(context);
  final cameraModel = Provider.of<CameraModel>(context);
  final previewModel = Provider.of<PreviewModel>(context);

  if (!previewModel.isSelect &&
      previewModel.mattingMode == DEFAULT_MATTING_MODE) {
    showToast("请选择一张图片", context, toast: Toast.CENTER);
    return;
  }

  progress.showWithText("AI抠图中");

  Asset selectedBgImage = previewModel.selectedBgImage;

  String selectedImgPath = cameraModel.photos[previewModel.currentPage];
  Map<String, String> imgPathMap = getPathNameSuffix(selectedImgPath);
  String imgName = imgPathMap['name'];
  String imgSuffix = imgPathMap['suffix'];

  FormData formData;

  if (previewModel.mattingMode == DEFAULT_MATTING_MODE) {
    String selectedBgPath = selectedBgImage.identifier;
    Map<String, String> bgPathMap = getPathNameSuffix(selectedBgPath);
    String bgName = bgPathMap['name'];
    String bgSuffix = bgPathMap['suffix'];
    ByteData selectedBgBytes = await selectedBgImage.requestOriginal();
    formData = FormData.from({
      'background': UploadFileInfo.fromBytes(selectedBgBytes.buffer.asUint8List(), bgName,
          contentType: ContentType.parse("image/$bgSuffix")),
      'upload': UploadFileInfo(File(selectedImgPath), imgName,
          contentType: ContentType.parse("image/$imgSuffix")),
      'is_front': imgName.indexOf("FRONT") >= 0
          ? true
          : imgName.indexOf("BACK") >= 0 ? false : null,
      'is_background': previewModel.mattingMode == DEFAULT_MATTING_MODE,
    });
  } else {
    formData = FormData.from({
      'upload': UploadFileInfo(File(selectedImgPath), imgName,
          contentType: ContentType.parse("image/$imgSuffix")),
      'is_front': imgName.indexOf("FRONT") >= 0
          ? true
          : imgName.indexOf("BACK") >= 0 ? false : true,
      'is_background': previewModel.mattingMode == DEFAULT_MATTING_MODE,
    });
  }

  try {
    var response = await Dio()
        .post<String>("http://47.93.202.244:8081/matting", data: formData);

    if (response.statusCode == 200) {
      Map<String, dynamic> res = jsonDecode(response.data);
      if (!res['success']) {
        showToast(res['res'], context);
      } else {
        showToast("AI抠图成功，图片生成中", context);
        print(res['res']);

        String resImgPath = res['res']['res_img_path'];
        Map<String, String> resImgPathMap = getPathNameSuffix(resImgPath);
        String resImgName = resImgPathMap['name'];

        String newPath =
            "${await dirCheck(ALBUM_PATH)}/ai_matting_${DateTime.now()}_$resImgName";
        String uri = "http://47.93.202.244:8081$resImgPath";
        print(uri);
        var resp = await Dio().download(uri, newPath);
        print("${resp.statusCode}, ${resp.statusMessage}");
        print(previewModel.currentPage);
        cameraModel.insertPhoto(previewModel.currentPage, newPath);
        print(cameraModel.photos);
      }
    }
  } on DioError catch (error) {
    print(error);
    showToast("提示：请求出错", context);
  } finally {
    progress.dismiss();
  }

  _closeDialog(context);


}
