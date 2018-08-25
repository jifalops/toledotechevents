import 'package:angular/angular.dart';
import 'package:toledotechevents/build_config.dart';
import 'package:toledotechevents_web/app_component.template.dart' as ng;
import 'package:pwa/client.dart' as pwa;

void main() {
  BuildConfig.init(
      flavor: BuildFlavor.production,
      baseUrl: 'http://toledotechevents.org',
      cacheName: 'toledotechevents');
  assert(config != null);
  // Registers service worker.
  pwa.Client();
  runApp(ng.AppComponentNgFactory);
}
