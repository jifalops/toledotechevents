import 'package:async_resource/file_resource.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' show parse;
import 'package:toledotechevents/build_config.dart';
import 'package:toledotechevents/model/events.dart';
import 'package:toledotechevents/model/venues.dart';
import 'package:toledotechevents/model/about_section.dart';
import 'package:toledotechevents/model/auth_token.dart';
import 'package:toledotechevents_mobile/util/shared_prefs_resource.dart';

export 'package:toledotechevents/model/events.dart';
export 'package:toledotechevents/model/venues.dart';
export 'package:toledotechevents/model/about_section.dart';
export 'package:toledotechevents/model/auth_token.dart';

final themeResource = StringPrefsResource('theme');

final eventListResource = HttpNetworkResource<EventList>(
  url: config.baseUrl + '/events.atom',
  cache: FileResource(
    File('events.atom'),
    parser: (contents) => contents == null ? null : EventList(contents),
  ),
  maxAge: Duration(minutes: 60),
  strategy: CacheStrategy.cacheFirst,
);

final venueListResource = HttpNetworkResource<VenueList>(
  url: config.baseUrl + '/venues.json',
  cache: FileResource(
    File('venues.json'),
    parser: (contents) => contents == null ? null : VenueList(contents),
  ),
  maxAge: Duration(minutes: 60),
  strategy: CacheStrategy.cacheFirst,
);

final aboutPageResource = HttpNetworkResource<AboutSection>(
  url: config.baseUrl + '/about.html',
  cache: FileResource(
    File('about.html'),
    parser: (contents) => AboutSection(contents),
  ),
  maxAge: Duration(hours: 24),
  strategy: CacheStrategy.cacheFirst,
);

final newEventPageResource = HttpNetworkResource<AuthToken>(
  url: config.baseUrl + '/events/new.html',
  cache: FileResource(
    File('new_event.html'),
    parser: (contents) => AuthToken(contents),
  ),
  maxAge: Duration(hours: 24),
  strategy: CacheStrategy.cacheFirst,
);

class EventDetailsResource extends HttpNetworkResource<dom.Document> {
  EventDetailsResource(int id)
      : super(
          url: config.eventUrl(id),
          cache: FileResource(
            File('event_$id.html'),
            parser: (contents) => parse(contents),
          ),
          maxAge: Duration(hours: 24),
          strategy: CacheStrategy.cacheFirst,
        );
}

class VenueDetailsResource extends HttpNetworkResource<dom.Document> {
  VenueDetailsResource(int id)
      : super(
          url: config.venueUrl(id),
          cache: FileResource(
            File('venue_$id.html'),
            parser: (contents) => parse(contents),
          ),
          maxAge: Duration(hours: 24),
          strategy: CacheStrategy.cacheFirst,
        );
}
