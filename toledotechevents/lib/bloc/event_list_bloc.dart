import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:async_resource/async_resource.dart';
import 'package:toledotechevents/model/events.dart';

export 'package:toledotechevents/model/events.dart';

/// Listens for signals to get or refresh an [Event] list.
class EventListBloc {
  final _fetchController = StreamController<bool>();
  final _events = BehaviorSubject<EventList>();

  final NetworkResource<EventList> _eventsResource;

  EventListBloc(NetworkResource<EventList> eventsResource)
      : _eventsResource = eventsResource {
    _fetchController.stream.listen((refresh) async =>
        _updateEvents(await _eventsResource.get(forceReload: refresh)));

    fetch.add(false);
  }

  void dispose() {
    _fetchController.close();
    _events.close();
  }

  void _updateEvents(EventList events) {
    if (events != null) {
      _events.add(events);
    }
  }

  /// The input stream for signaling the output stream should be refreshed.
  Sink<bool> get fetch => _fetchController.sink;

  /// Platform-agnostic output stream for presenting pages to the user.
  Stream<EventList> get events => _events.stream;
}
