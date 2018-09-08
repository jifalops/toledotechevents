import 'dart:async';
import 'dart:io';
import 'package:sass/sass.dart' as sass;
import 'package:toledotechevents/theme.dart';

void main() async {
  await _generateThemeScss();
//  await _compileScss();
}

Future<void> _generateThemeScss() async {
  final sb = StringBuffer();
  sb.writeln('// GENERATED FILE, CHANGES WILL BE LOST.');
  sb.writeln("@import 'package:angular_components/css/material/material';");
//  sb.writeln("@import 'package:angular_components/css/mdc_web/theme/mixins';");
  sb.writeln(r'$themes: (');
  Theme.values.forEach((theme) {
    final name = theme.name.toLowerCase();
    sb.writeln('// $name theme.');
    sb.writeln('$name: ${theme.toScssMap()},');
    sb.writeln('');
  });
  sb.writeln(');');
  final file = File('lib/_themes.scss');
  await file.writeAsString(sb.toString(), flush: true);
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
