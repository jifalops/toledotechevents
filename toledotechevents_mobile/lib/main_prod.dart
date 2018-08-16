import 'package:flutter/material.dart';
import 'package:toledotechevents/build_config.dart';
import 'app.dart';

void main() {
  BuildConfig.init(
      flavor: BuildFlavor.production,
      baseUrl: 'http://toledotechevents.org',
      cacheName: 'toledotechevents');
  assert(config != null);
  runApp(App());
}
