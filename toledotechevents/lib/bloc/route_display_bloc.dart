import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:toledotechevents/routes.dart';

class RouteDisplayBloc {
  // Output streams for views to listen to.
  final _route = BehaviorSubject<PageRoute>();
  final _display = BehaviorSubject<Display>();
  // StreamControllers are for inputs from the view layer.
  final _routeController = StreamController<PageRoute>();
  final _displayController = StreamController<Display>();

  RouteDisplayBloc() {
    _routeController.stream.listen(_route.add);
    _displayController.stream.listen(_display.add);
  }

  void dispose() {
    _routeController.close();
    _displayController.close();
    _route.close();
    _display.close();
  }

  /// The [PageRoute] [Sink] for signaling a new route should be displayed.
  Sink<PageRoute> get route => _routeController.sink;

  /// The [Display] [Sink] for signaling that the app's screen/window changed.
  Sink<Display> get display => _displayController.sink;

  ///
  Stream<PageRoute> get currentRoute
}
