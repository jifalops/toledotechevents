import 'dart:async';
import 'dart:io';
import 'package:sass/sass.dart' as sass;
import 'package:toledotechevents/theme.dart';

void main() async {
  await _generateThemeScss();
//  await _compileScss();
}

Future<void> _generateThemeScss() async {
  final file = File('lib/_themes.scss');
  await file.writeAsString(Theme.combineThemestoScss(), flush: true);
  await Future.delayed(Duration(seconds: 3));
}

Future<void> _compileScss() async {
  final dir = Directory('.');
  final list = await dir.list(recursive: true).toList();
  for (FileSystemEntity fse in list) {
    if (fse is File &&
        fse.path.endsWith('.scss') &&
        !fse.path.endsWith('_themes.scss')) {
      await File(fse.path
              .replaceRange(fse.path.length - 5, fse.path.length, '.css'))
          .writeAsString(sass.compile(fse.path), flush: true);
    }
  }
}
