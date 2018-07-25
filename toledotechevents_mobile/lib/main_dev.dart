import 'package:flutter/material.dart';
import 'package:toledotechevents/env.dart';
import 'app.dart';

void main() {
  AppConfig.init(
      flavor: BuildFlavor.development, baseUrl: 'http://dev.example.com');
  assert(config != null);
  runApp(App());
}
