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
    final themeName = await theme.get(forceReload: forceReload);
    print('Init resources: Theme: "$themeName".');
    yield themeName;
    final events = await eventList.get(forceReload: forceReload);
    print('Init resources: Events: "${events?.length}".');
    yield events;
    final venues = await venueList.get(forceReload: forceReload);
    print('Init resources: Venues: "${venues?.length}".');
    yield venues;
    final aboutSection = await about.get(forceReload: forceReload);
    print('Init resources: About: "${aboutSection?.html?.length}".');
    yield aboutSection;
    final token = await authToken.get(forceReload: forceReload);
    print('Init resources: AuthToken: "${token?.value}".');
    yield token;
  }
}
