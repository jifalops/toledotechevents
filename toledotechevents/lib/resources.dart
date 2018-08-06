import 'package:async_resource/async_resource.dart';
import 'package:meta/meta.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' show parse;
import 'package:toledotechevents/build_config.dart';
import 'package:toledotechevents/model/events.dart';
import 'package:toledotechevents/model/venues.dart';
import 'package:toledotechevents/model/about_section.dart';
import 'package:toledotechevents/model/auth_token.dart';

export 'package:toledotechevents/model/events.dart';
export 'package:toledotechevents/model/venues.dart';
export 'package:toledotechevents/model/about_section.dart';
export 'package:toledotechevents/model/auth_token.dart';

abstract class Resources {
  Resources(
      {@required this.theme,
      @required this.eventList,
      @required this.venueList,
      @required this.aboutPage,
      @required this.newEvent});
  final LocalResource<String> theme;
  final NetworkResource<EventList> eventList;
  final NetworkResource<VenueList> venueList;
  final NetworkResource<AboutSection> aboutPage;
  final NetworkResource<AuthToken> newEvent;
}

NetworkResource<dom.Document>


abstract class DetailsResource extends NetworkResource<dom.Document> {
  DetailsResource(
      {@required String url,
      @required LocalResource<dom.Document> cache,
      @required CacheStrategy strategy,
      Duration maxAge})
      : super(
            url: url,
            cache: cache,
            maxAge: maxAge ?? Duration(hours: 24),
            strategy: strategy);
}

abstract class EventDetailsResource extends NetworkResource<dom.Document> {
  EventDetailsResource(int id,
      {@required LocalResource<dom.Document> cache,
      @required CacheStrategy strategy,
      Duration maxAge})
      : super(
            url: config.eventUrl(id),
            cache: cache,
            maxAge: maxAge ?? Duration(hours: 24),
            strategy: CacheStrategy.cacheFirst);
}

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
