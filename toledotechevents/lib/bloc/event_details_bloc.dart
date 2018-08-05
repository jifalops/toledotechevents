import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:async_resource/async_resource.dart';
import 'package:html/dom.dart' as dom;
import 'package:toledotechevents/model/events.dart';

export 'package:toledotechevents/model/events.dart';

/// Selects an event from a list.
class EventDetailsBloc {
  final _requestController = StreamController<EventDetailsRequest>();
  final _details = BehaviorSubject<EventDetails>();

  EventDetailsBloc() {
    _requestController.stream.listen((request) async => _updateEvent(request));
  }

  void dispose() {
    _requestController.close();
    _details.close();
  }

  void _updateEvent(EventDetailsRequest request) {
    if (request != null && request.resource != null) {
      if (request.event != null) {
        _details.add(EventDetails(request.event, request.resource));
      } else if (request.id != null) {
        EventDetails.request(request.id, request.resource)
            .then((details) => details == null ? null : _details.add(details));
      }
    }
  }

  /// The input stream for signaling the output stream should be refreshed.
  Sink<EventDetailsRequest> get request => _requestController.sink;

  /// Platform-agnostic output stream for presenting pages to the user.
  Stream<EventDetails> get details => _details.stream;
}

class EventDetailsRequest {
  final EventListItem event;
  final int id;
  final NetworkResource<dom.Document> resource;
  EventDetailsRequest.fromEvent(this.event, this.resource) : id = null;
  EventDetailsRequest.fromId(this.id, this.resource) : event = null;
}
