import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:async_resource/async_resource.dart';
import '../model/event.dart';

export '../model/event.dart';

/// Listens for signals to get or refresh an [Event] list.
class EventListBloc {
  final _fetchController = StreamController<bool>();
  final _events = BehaviorSubject<List<Event>>();

  final NetworkResource<List<Event>> _eventsResource;

  EventListBloc(NetworkResource<List<Event>> eventsResource)
      : _eventsResource = eventsResource {
    _fetchController.stream.listen((refresh) async =>
        _updateEvents(await _eventsResource.get(forceReload: refresh)));

    fetch.add(false);
  }

  void dispose() {
    _fetchController.close();
    _events.close();
  }

  void _updateEvents(List<Event> events) {
    if (events != null) {
      _events.add(events);
    }
  }

  /// The input stream for signaling the output stream should be refreshed.
  Sink<bool> get fetch => _fetchController.sink;

  /// Platform-agnostic output stream for presenting pages to the user.
  Stream<List<Event>> get events => _events.stream;
}
