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
      {@required this.splash,
      @required this.theme,
      @required this.eventList,
      @required this.venueList,
      @required this.about,
      @required this.authToken});

  final LocalResource<bool> splash;
  final LocalResource<String> theme;
  final NetworkResource<EventList> eventList;
  final NetworkResource<VenueList> venueList;
  final NetworkResource<AboutSection> about;
  final NetworkResource<AuthToken> authToken;

  NetworkResource<dom.Document> eventDetails(int id);
  NetworkResource<dom.Document> venueDetails(int id);

  static bool parseSplash(contents) => contents == 'true';

  static EventList parseEvents(contents) {
    return contents == null ? null : EventList(contents);
  }

  static VenueList parseVenues(contents) =>
      contents == null ? null : VenueList(contents);

  static AboutSection parseAboutSection(contents) =>
      contents == null ? null : AboutSection(contents);

  static AuthToken parseAuthToken(contents) =>
      contents == null ? null : AuthToken(contents);
}
