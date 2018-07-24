import 'package:flutter/material.dart';
import 'env.dart';
import 'app.dart';

void main() {
  BuildEnvironment.init(
      flavor: BuildFlavor.production, baseUrl: 'http://example.com');
  assert(env != null);
  runApp(App());
}
