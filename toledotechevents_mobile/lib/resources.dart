import 'package:async_resource/file_resource.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' show parse;
import 'package:toledotechevents/build_config.dart';
import 'package:toledotechevents/resources.dart';
import 'package:toledotechevents_mobile/util/shared_prefs_resource.dart';

export 'package:toledotechevents/resources.dart';

final resources = MobileResources._();

class MobileResources extends Resources {
  MobileResources._()
      : super(
            theme: StringPrefsResource('theme'),
            eventList: HttpNetworkResource<EventList>(
              url: config.baseUrl + '/events.atom',
              cache: FileResource(
                File('events.atom'),
                parser: Resources.parseEvents,
              ),
              maxAge: Duration(minutes: 60),
              strategy: CacheStrategy.cacheFirst,
            ),
            venueList: HttpNetworkResource<VenueList>(
              url: config.baseUrl + '/venues.json',
              cache: FileResource(
                File('venues.json'),
                parser: Resources.parseVenues,
              ),
              maxAge: Duration(minutes: 60),
              strategy: CacheStrategy.cacheFirst,
            ),
            about: HttpNetworkResource<AboutSection>(
              url: config.baseUrl + '/about.html',
              cache: FileResource(
                File('about.html'),
                parser: Resources.parseAboutSection,
              ),
              maxAge: Duration(hours: 24),
              strategy: CacheStrategy.cacheFirst,
            ),
            authToken: HttpNetworkResource<AuthToken>(
              url: config.baseUrl + '/events/new.html',
              cache: FileResource(
                File('new_event.html'),
                parser: Resources.parseAuthToken,
              ),
              maxAge: Duration(hours: 24),
              strategy: CacheStrategy.cacheFirst,
            ));

  @override
  NetworkResource<dom.Document> eventDetails(int id) =>
      HttpNetworkResource<dom.Document>(
        url: config.eventUrl(id),
        cache: FileResource(
          File('event_$id.html'),
          parser: (contents) => parse(contents),
        ),
        maxAge: Duration(hours: 24),
        strategy: CacheStrategy.cacheFirst,
      );

  @override
  NetworkResource<dom.Document> venueDetails(int id) =>
      HttpNetworkResource<dom.Document>(
        url: config.venueUrl(id),
        cache: FileResource(
          File('venue_$id.html'),
          parser: (contents) => parse(contents),
        ),
        maxAge: Duration(hours: 24),
        strategy: CacheStrategy.cacheFirst,
      );
}
