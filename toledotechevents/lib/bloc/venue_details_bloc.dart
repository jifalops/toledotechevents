import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:async_resource/async_resource.dart';
import 'package:html/dom.dart' as dom;
import 'package:toledotechevents/model/venues.dart';

export 'package:toledotechevents/model/venues.dart';

/// Selects a venue from a list.
class VenueDetailsBloc {
  final _requestController = StreamController<VenueDetailsRequest>();
  final _details = BehaviorSubject<VenueDetails>();

  VenueDetailsBloc() {
    _requestController.stream.listen((request) async => _updateVenue(request));
  }

  void dispose() {
    _requestController.close();
    _details.close();
  }

  void _updateVenue(VenueDetailsRequest request) {
    if (request != null && request.resource != null) {
      if (request.venue != null) {
        _details.add(VenueDetails(request.venue, request.resource));
      } else if (request.id != null) {
        VenueDetails.request(request.id, request.resource)
            .then((details) => details == null ? null : _details.add(details));
      }
    }
  }

  /// The input stream for signaling the output stream should be refreshed.
  Sink<VenueDetailsRequest> get request => _requestController.sink;

  /// Platform-agnostic output stream for presenting pages to the user.
  Stream<VenueDetails> get details => _details.stream;
}

class VenueDetailsRequest {
  final VenueListItem venue;
  final int id;
  final NetworkResource<dom.Document> resource;
  VenueDetailsRequest.fromVenue(this.venue, this.resource) : id = null;
  VenueDetailsRequest.fromId(this.id, this.resource) : venue = null;
}
