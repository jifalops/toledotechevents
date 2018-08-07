import 'dart:async';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:async_resource/async_resource.dart';
import 'package:html/dom.dart' as dom;
import 'package:toledotechevents/model/venues.dart';

export 'package:toledotechevents/model/venues.dart';

/// Selects an venue from a list.
class VenueDetailsBloc {
  final _requestController = StreamController<Map<String, dynamic>>();
  final _details = BehaviorSubject<VenueDetails>();

  VenueDetailsBloc() {
    _requestController.stream.listen((request) async => _updateVenue(request));
  }

  void dispose() {
    _requestController.close();
    _details.close();
  }

  void _updateVenue(Map<String, dynamic> args) {
    if (args != null && args['resource'] is NetworkResource<dom.Document>) {
      if (args['venue'] is VenueListItem) {
        _details.add(VenueDetails(args['venue'], args['resource']));
      } else {
        VenueDetails.request(args['resource'])
            .then((details) => details == null ? null : _details.add(details));
      }
    }
  }

  /// The input stream for signaling the output stream should be refreshed.
  Sink<Map<String, dynamic>> get args => _requestController.sink;

  /// Platform-agnostic output stream for presenting pages to the user.
  Stream<VenueDetails> get details => _details.stream;
}
