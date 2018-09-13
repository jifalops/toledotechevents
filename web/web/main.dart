import 'dart:html';
import 'package:angular/angular.dart';
import 'package:toledotechevents/build_config.dart';
import 'package:toledotechevents_web/app_component.template.dart' as ng;
import 'package:pwa/client.dart' as pwa;
import 'package:toledotechevents/bloc/splash_bloc.dart';
import 'package:toledotechevents_web/resources.dart';

const DEBUG = true;

void main() {
  print('Main started');
  BuildConfig.init(
      flavor: BuildFlavor.production,
      baseUrl: 'http://toledotechevents.org',
      cacheName: 'toledotechevents');
  // BuildConfig.init(
  //     flavor: BuildFlavor.development,
  //     baseUrl: 'http://dev.toledotechevents.org',
  //     cacheName: 'toledotechevents_dev');
  assert(config != null);

  handleLoadingScreen();

  // Registers service worker.
  pwa.Client();

}

void handleLoadingScreen() async {
  resources.splash.get().then((showSplash) {
    print('showsplash: $showSplash');
    if (showSplash) {
      final bloc = SplashBloc(resources, forceReload: !DEBUG);
      final divs = querySelectorAll('.loading');
      bloc.percent.listen((percent) => divs.forEach((div) => div.text = '$percent%'));
      bloc.loaded.listen((_) {
        runApp(ng.AppComponentNgFactory);
      });
    } else {
      runApp(ng.AppComponentNgFactory);
    }
  });


}
