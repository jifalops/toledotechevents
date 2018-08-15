import 'package:angular/angular.dart';
import 'package:toledotechevents_web/app_component.template.dart' as ng;
import 'package:pwa/client.dart' as pwa;

void main() {
  // Registers service worker.
  pwa.Client();
  runApp(ng.AppComponentNgFactory);
}
