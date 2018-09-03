import 'dart:async';
import 'dart:io';
import 'package:sass/sass.dart' as sass;
import 'package:toledotechevents/theme.dart';

void main() async {
  await _generateThemeScss();
  await _compileScss();
}

const _materialStylesPath =
    '/home/jacob/.pub-cache/hosted/pub.dartlang.org/angular_components-0.9.0/lib';
// 'package:angular_components';

Future<void> _generateThemeScss() async {
  final sb = StringBuffer();
  sb.writeln('// GENERATED FILE, CHANGES WILL BE LOST.');
  sb.writeln("@import '${_materialStylesPath}/css/material/material.scss';");
  sb.writeln("@import '${_materialStylesPath}/css/mdc_web/theme/mixins.scss';");
  Theme.values.forEach((theme) {
    final name = '${theme.name.toLowerCase()}-theme';
    sb.writeln('@mixin $name { ${theme.toScss().join(' ')} }');
    // sb.writeln('.$name { @include $name; }');
  });
  final file = File('lib/src/_theme.scss');
  await file.writeAsString(sb.toString(), flush: true);
  await Future.delayed(Duration(seconds: 3));
}

Future<void> _compileScss() async {
  final dir = Directory('.');
  final list = await dir.list(recursive: true).toList();
  for (FileSystemEntity fse in list) {
    if (fse is File &&
        fse.path.endsWith('.scss') &&
        !fse.path.endsWith('_theme.scss')) {
      await File(fse.path
              .replaceRange(fse.path.length - 5, fse.path.length, '.css'))
          .writeAsString(sass.compile(fse.path), flush: true);
    }
  }
}