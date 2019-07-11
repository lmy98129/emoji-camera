import 'dart:io';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';

final String ALBUM_PATH = "pages.album";

// 是否创建了album目录
Future<String> dirCheck(String path) async {
  Directory dir = Directory(
      join((await getExternalStorageDirectory()).path, path)
  );

  if (! (await dir.exists())) {
    dir.createSync();
  }

  return dir.path;
}

// 获取文件列表
Future<List<FileSystemEntity>> getFileList() async {
  var dir = await dirCheck(ALBUM_PATH);
  Directory directory = Directory(dir);
  Stream<FileSystemEntity> entityList = await directory.list(recursive: false, followLinks: false);
  List<FileSystemEntity> files = await entityList.toList();
  files.sort((FileSystemEntity a, FileSystemEntity b) {
    DateTime dateA = File(a.path).lastModifiedSync();
    DateTime dateB = File(b.path).lastModifiedSync();
    return dateB.difference(dateA).inMilliseconds;
  });

  return files;
}