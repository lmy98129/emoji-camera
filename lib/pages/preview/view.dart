import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/models/camera.dart';
import 'package:flutter_demo/models/preview.dart';
import 'package:provider/provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'components/album_btn.dart';
import 'components/bottom_btn.dart';
import 'package:flutter_demo/utils/route.dart';
import 'dart:math' as math;

class buildView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cameraModel = Provider.of<CameraModel>(context);
    final previewModel = Provider.of<PreviewModel>(context);

    var currentPage = previewModel.currentPage + 1;

    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text("预览 ${currentPage}/${cameraModel.photos.length}"),
          actions: <Widget>[
            AlbumBtn(context),
          ],
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

class _MainPage extends StatefulWidget with WidgetsBindingObserver {
  @override
  State<StatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends State<_MainPage> {
  @override
  void deactivate() {
    final previewModel = Provider.of<PreviewModel>(context);
    previewModel.resetPage();
    // 隐藏状态栏
    super.deactivate();
  }

  @override
  void initState() {
    // 显示状态栏
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.initState();
  }

  void _handleDelete() async {
    final cameraModel = Provider.of<CameraModel>(context);
    final previewModel = Provider.of<PreviewModel>(context);
    int currentPage = previewModel.currentPage;

    String currentPath = cameraModel.photos[currentPage];
    await File(currentPath).delete();
    await cameraModel.getFileList();
    if (currentPage > 0) {
      previewModel.onPageChanged(currentPage - 1);
    } else {
      previewModel.onPageChanged(0);
    }
  }

  void _handleEmoji() {}

  void _handleCrop() {}

  void _handleStyleMigrate() {}

  @override
  Widget build(BuildContext context) {
    final cameraModel = Provider.of<CameraModel>(context);
    final previewModel = Provider.of<PreviewModel>(context);
    final tmp = MediaQuery.of(context).size;
    var screenW = math.min(tmp.height, tmp.width);

    return Stack(
      children: <Widget>[
        Container(
          child: PhotoViewGallery.builder(
            scrollPhysics: BouncingScrollPhysics(),
            builder: (context, int index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: FileImage(File(cameraModel.photos[index])),
                initialScale: PhotoViewComputedScale.contained,
                heroTag: index,
                minScale: PhotoViewComputedScale.contained,
              );
            },
            itemCount: cameraModel.photos.length,
            onPageChanged: previewModel.onPageChanged,
            pageController: PageController(
              initialPage: previewModel.currentPage,
              keepPage: false,
            ),
          ),
        ),
        Positioned(
            bottom: 0,
            child: Container(
                width: screenW,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.7),
                ),
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    BottomBtn(
                      icon: Icon(Icons.sentiment_very_satisfied),
                      text: Text("Emoji"),
                      onPressed: _handleEmoji,
                    ),
                    BottomBtn(
                      icon: Icon(Icons.compare),
                      text: Text("AI抠图"),
                      onPressed: _handleCrop,
                    ),
//                    BottomBtn(
//                      icon: Icon(Icons.tune ),
//                      text: Text("风格迁移"),
//                      onPressed: _handleStyleMigrate,
//                    ),
                    BottomBtn(
                      icon: Icon(Icons.close),
                      text: Text("删除"),
                      onPressed: _handleDelete,
                    ),
                  ],
                )))
      ],
    );
  }
}
