import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<File> localFile(String name) async {
  final path = await _localPath;
  return File('$path/$name');
}

Future<String> readLocalFile(String name) async {
  try {
    final file = await localFile(name);
    return file.readAsString();
  } catch (e) {
    print('Exception while reading local file $name:');
    print(e);
    return null;
  }
}

Future<File> writeLocalFile(String name, String contents) async {
  final file = await localFile(name);
  return file.writeAsString(contents);
}
