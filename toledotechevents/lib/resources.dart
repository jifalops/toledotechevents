import 'dart:async';
import 'package:async_resource/async_resource.dart';
import 'package:meta/meta.dart';
import 'package:html/dom.dart' as dom;
import 'package:toledotechevents/model/events.dart';
import 'package:toledotechevents/model/venues.dart';
import 'package:toledotechevents/model/about_section.dart';
import 'package:toledotechevents/model/auth_token.dart';

export 'package:async_resource/async_resource.dart';
export 'package:toledotechevents/model/events.dart';
export 'package:toledotechevents/model/venues.dart';
export 'package:toledotechevents/model/about_section.dart';
export 'package:toledotechevents/model/auth_token.dart';

/// The resources required by the app.
abstract class Resources {
  Resources(
      {@required this.theme,
      @required this.eventList,
      @required this.venueList,
      @required this.about,
      @required this.authToken});

  final LocalResource<String> theme;
  final NetworkResource<EventList> eventList;
  final NetworkResource<VenueList> venueList;
  final NetworkResource<AboutSection> about;
  final NetworkResource<AuthToken> authToken;

  NetworkResource<dom.Document> eventDetails(int id);
  NetworkResource<dom.Document> venueDetails(int id);

  static EventList parseEvents(contents) =>
      contents == null ? null : EventList(contents);

  static VenueList parseVenues(contents) =>
      contents == null ? null : VenueList(contents);

  static AboutSection parseAboutSection(contents) =>
      contents == null ? null : AboutSection(contents);

  static AuthToken parseAuthToken(contents) =>
      contents == null ? null : AuthToken(contents);

  /// Perform an initial fetch on the data, once per app run. This lets the
  /// app have resources in memory for fast execution.
  ///
  /// On the first run, this will fetch everything from the network.
  /// Even though this approach doesn't scale, the relatively small amount
  /// of data being fetched here is acceptable. Grouping network requests may
  /// also allow the underlying platform to optimize them.
  ///
  /// On subsequent runs, only expired data will be requested from the network
  /// since each resource uses [CacheStrategy.cacheFirst]. If the network is
  /// unavailable, the cached copy will be used and the app won't skip a beat.
  Stream init([bool forceReload = false]) async* {
    yield await theme
        .get(forceReload: forceReload)
        .then((theme) => print('Init resources: Theme: "$theme".'));
    yield await eventList
        .get(forceReload: forceReload)
        .then((list) => print('Init resources: Events: "${list?.length}".'));
    yield await venueList
        .get(forceReload: forceReload)
        .then((list) => print('Init resources: Venues: "${list?.length}".'));
    yield await about.get(forceReload: forceReload).then(
        (about) => print('Init resources: About: "${about?.html?.length}".'));
    yield await authToken.get(forceReload: forceReload).then(
        (token) => print('Init resources: AuthToken: "${token?.value}".'));
  }
}
