import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';

import 'package:flutter_demo/utils/route.dart';
import 'package:flutter_demo/models/camera.dart';
import 'package:flutter_demo/models/preview.dart';
import 'components/album_btn.dart';
import 'components/bottom_btn.dart';
import 'components/matting_handler.dart';
import 'components/emoji_handler.dart';
import 'components/more_btn.dart';

class buildView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cameraModel = Provider.of<CameraModel>(context);
    final previewModel = Provider.of<PreviewModel>(context);

    var currentPage = previewModel.currentPage + 1;

    // WillPopScope是路由跳转中间件
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
    super.deactivate();
  }

  @override
  void initState() {
    // 显示状态栏
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.initState();
  }

  void _handleEmoji(context) async {
    emojiHandler(context);
  }

  void _handleAIMatting(context) async {
    try {
      mattingHandler(context);
    } on PlatformException catch (e) {
      print(e.message);
    }
  }

  void _handleStyleMigrate() {}

  @override
  Widget build(BuildContext context) {
    final cameraModel = Provider.of<CameraModel>(context);
    final previewModel = Provider.of<PreviewModel>(context);
    final tmp = MediaQuery.of(context).size;
    var screenW = math.min(tmp.height, tmp.width);

    return ProgressHUD(
      borderColor: Colors.transparent,
      child: Builder(
        builder: (context) => Stack(
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
                          onPressed: () { _handleEmoji(context); },
                        ),
                        BottomBtn(
                          icon: Icon(Icons.compare),
                          text: Text("AI抠图"),
                          onPressed: () { _handleAIMatting(context); },
                        ),
//                        BottomBtn(
//                          icon: Icon(Icons.tune ),
//                          text: Text("风格迁移"),
//                          onPressed: _handleStyleMigrate,
//                        ),
                        MoreBtn(),
                      ],
                    )
                )
            )

          ],
        ),
      ),
    );
  }
}
