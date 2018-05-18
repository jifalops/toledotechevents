import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<String> readFile(String name) async {
  try {
    final path = await _localPath;
    final file = new File('$path/$name');

    // Read the file
    String contents = await file.readAsString();

    return contents;
  } catch (e) {
    // If we encounter an error, return null
    return null;
  }
}

Future<File> writeFile(String name, String contents) async {
  final path = await _localPath;
  final file = new File('$path/$name');

  // Write the file
  return file.writeAsString(contents);
}

Future<DateTime> lastModified(String name) async {
  final path = await _localPath;
  final file = new File('$path/$name');
  return file.lastModifiedSync();
}
