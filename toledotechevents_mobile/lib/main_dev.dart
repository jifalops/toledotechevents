import 'package:flutter/material.dart';
import 'package:toledotechevents/build_config.dart';
import 'app.dart';

void main() {
  BuildConfig.init(
      flavor: BuildFlavor.development,
      baseUrl: 'http://dev.toledotechevents.org',
      cacheName: 'toledotechevents_dev');
  assert(config != null);
  runApp(App());
}
