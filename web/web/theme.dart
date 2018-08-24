import 'dart:io';
import 'package:sass/sass.dart' as sass;
import 'package:toledotechevents/theme.dart';

void main() {
  final sb = StringBuffer();
  sb.writeln('// GENERATED FILE, CHANGES WILL BE LOST.');
  sb.writeln(
      "@import 'package:angular_components/css/material/material.scss';");
  sb.writeln(
      "@import 'package:angular_components/css/mdc_web/theme/mixins.scss';");
  Theme.values.forEach((theme) {
    sb.writeln(
        '@mixin ${theme.name.toLowerCase()}-theme { ${theme.toScss().join(' ')} }');
  });
  final file = File('lib/themes.scss');
  file.writeAsString(sb.toString());
}
