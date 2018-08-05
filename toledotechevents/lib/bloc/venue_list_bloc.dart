import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:async_resource/async_resource.dart';
import 'package:toledotechevents/model/venues.dart';

export 'package:toledotechevents/model/venues.dart';

/// Listens for signals to get or refresh an [Venue] list.
class VenueListBloc {
  final _fetchController = StreamController<bool>();
  final _venues = BehaviorSubject<VenueList>();

  final NetworkResource<VenueList> _venuesResource;

  VenueListBloc(NetworkResource<VenueList> venuesResource)
      : _venuesResource = venuesResource {
    _fetchController.stream.listen((refresh) async =>
        _updateVenues(await _venuesResource.get(forceReload: refresh)));

    fetch.add(false);
  }

  void dispose() {
    _fetchController.close();
    _venues.close();
  }

  void _updateVenues(VenueList venues) {
    if (venues != null) {
      _venues.add(venues);
    }
  }

  /// The input stream for signaling the output stream should be refreshed.
  Sink<bool> get fetch => _fetchController.sink;

  /// Platform-agnostic output stream for presenting pages to the user.
  Stream<VenueList> get venues => _venues.stream;
}
