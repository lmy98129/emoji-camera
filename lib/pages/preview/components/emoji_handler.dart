import 'dart:io';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_demo/models/camera.dart';
import 'package:flutter_demo/models/preview.dart';
import 'package:flutter_demo/utils/file.dart';
import 'package:flutter_demo/utils/toast.dart';
import 'package:flutter_demo/pages/settings/view.dart' show DEFAULT_EMOJI_MODE;


void emojiHandler(context, { bool isShowProgress = true }) async {
  final progress = ProgressHUD.of(context);
  if (isShowProgress) {
    progress.showWithText("照片换脸中");
  }

  final cameraModel = Provider.of<CameraModel>(context);
  final previewModel = Provider.of<PreviewModel>(context);
  String path = cameraModel.photos[previewModel.currentPage];
  Map<String, String> pathMap = getPathNameSuffix(path);
  String name = pathMap['name'];
  String suffix = pathMap['suffix'];

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String mode = prefs.getString(DEFAULT_EMOJI_MODE);

  FormData formData = FormData.from({
    'upload': UploadFileInfo(File(path), name,
        contentType: ContentType.parse("image/$suffix")),
    'is_front': name.indexOf("FRONT") >= 0
        ? true
        : name.indexOf("BACK") >= 0 ? false : null,
    'mode': mode
  });

  try {
    var response = await Dio()
        .post<String>("http://47.93.202.244:8081/emoji", data: formData);

    if (response.statusCode == 200) {
      Map<String, dynamic> res = jsonDecode(response.data);
      if (!res['success']) {
        showToast(res['res'], context);
      } else {
        if (isShowProgress) {
          showToast("检测人脸成功，图片生成中", context);
        }
        print(res['res']);
        String imgPath = res['res']['img_path'];

        String newPath =
            "${await dirCheck(ALBUM_PATH)}/emoji_switched_${DateTime.now()}_$name";
        String uri = "http://47.93.202.244:8081$imgPath";
        print(uri);
        var resp = await Dio().download(uri, newPath);
        print("${resp.statusCode}, ${resp.statusMessage}");
        print(previewModel.currentPage);
        cameraModel.insertPhoto(previewModel.currentPage, newPath);
        print(cameraModel.photos);
      }
    }
  } on DioError catch (error) {
    if (isShowProgress) {
      showToast("提示：请求出错", context);
    }
  } finally {
    if (isShowProgress) {
      progress.dismiss();
    }
  }
}
