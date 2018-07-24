import 'package:flutter/material.dart';
import 'env.dart';
import 'app.dart';

void main() {
  BuildEnvironment.init(
      flavor: BuildFlavor.development, baseUrl: 'http://dev.example.com');
  assert(env != null);
  runApp(App());
}
