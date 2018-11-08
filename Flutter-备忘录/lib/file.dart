import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';

Future<File> _getLocalFile(path) async {
  // get the path to the document directory.
  String dir = (await getApplicationDocumentsDirectory()).path;
  return new File('$dir/$path');
}

class FileOperation {

  static Future<String> readFile(path) async {
    try {
      File file = await _getLocalFile(path);
      String contents = await file.readAsString();
      return contents;
    } on FileSystemException {
      print('读取文件失败');
      return '';
    }
  }

  static Future<Null> saveFile(path, content) async {
    print('写入文件');
    await (await _getLocalFile(path)).writeAsString(content);
  }

}