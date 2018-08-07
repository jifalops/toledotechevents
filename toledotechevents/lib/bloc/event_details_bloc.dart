import 'dart:async';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:async_resource/async_resource.dart';
import 'package:html/dom.dart' as dom;
import 'package:toledotechevents/model/events.dart';

export 'package:toledotechevents/model/events.dart';

/// Selects an event from a list.
class EventDetailsBloc {
  final _requestController = StreamController<Map<String, dynamic>>();
  final _details = BehaviorSubject<EventDetails>();

  EventDetailsBloc() {
    _requestController.stream.listen((request) async => _updateEvent(request));
  }

  void dispose() {
    _requestController.close();
    _details.close();
  }

  void _updateEvent(Map<String, dynamic> args) {
    if (args != null && args['resource'] is NetworkResource<dom.Document>) {
      if (args['event'] is EventListItem) {
        _details.add(EventDetails(args['event'], args['resource']));
      } else {
        EventDetails.request(args['resource'])
            .then((details) => details == null ? null : _details.add(details));
      }
    }
  }

  /// The input stream for signaling the output stream should be refreshed.
  Sink<Map<String, dynamic>> get args => _requestController.sink;

  /// Platform-agnostic output stream for presenting pages to the user.
  Stream<EventDetails> get details => _details.stream;
}
