import 'dart:io';
import 'package:toledotechevents/theme.dart';

void main() async {
  final file = File('lib/_themes.scss');
  await file.writeAsString(Theme.combineThemestoScss(), flush: true);
}
