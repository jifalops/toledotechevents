import 'dart:async';
import 'package:rxdart/rxdart.dart';
import '../model/event.dart';

export '../model/event.dart';

/// Selects an event from a list.
class EventDetailsBloc {
  final _eventsController = StreamController<List<Event>>();
  final _idController = StreamController<int>();
  final _event = BehaviorSubject<Event>();

  EventDetailsBloc() {
    _eventsController.stream.listen((events) async =>
        _updateEvent(events, await _idController.stream.last));
  }

  void dispose() {
    _eventsController.close();
    _idController.close();
    _event.close();
  }

  void _updateEvent(List<Event> events, int id) {
    if (events != null && id != null) {
      _event.add(Event.findById(events, id));
    }
  }

  /// The input stream for signaling the output stream should be refreshed.
  Sink<List<Event>> get events => _eventsController.sink;

  Sink<int> get id => _idController.sink;

  /// Platform-agnostic output stream for presenting pages to the user.
  Stream<Event> get event => _event.stream;
}
