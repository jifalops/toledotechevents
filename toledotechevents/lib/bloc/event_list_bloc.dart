import 'dart:async';
import 'dart:collection';

import 'package:rxdart/rxdart.dart';

import '../pages.dart';
import '../theme.dart';
import '../layout.dart';
import '../util/display.dart';
import '../model/event.dart';

export '../pages.dart';
export '../theme.dart';
export '../layout.dart';
export '../util/display.dart';
export '../model/event.dart';

/// Represents data from the network or disk such as a native I/O File, browser
/// service-worker cache, or browser local storage.
class Resource<T> {
  Future<T> get({forceReload: false}) async => null;
  Future<void> save(T value) async => null;
}

/// Listens for signals to get or refresh an [Event] list.
class EventListBloc {
  final _eventsController = StreamController<bool>();
  final _events = BehaviorSubject<List<Event>>();

  final Resource<List<Event>> _eventsResource;

  EventListBloc(Resource<List<Event>> eventsResource)
      : _eventsResource = eventsResource {
    _eventsController.stream.listen((refresh) async =>
        _updateEvents(await _eventsResource.get(forceReload: refresh)));
  }

  void dispose() {
    _eventsController.close();
    _events.close();
  }

  void _updateEvents(List<Event> events) {
    if (events != null) {
      _events.add(events);
    }
  }

  /// The input stream for signaling the output stream should be refreshed.
  Sink<bool> get fetch => _eventsController.sink;

  /// Platform-agnostic output stream for presenting pages to the user.
  Stream<List<Event>> get events => _events.stream;
}
