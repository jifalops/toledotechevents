import 'dart:async';
import 'package:async_resource/file_resource.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' show parse;
import 'package:toledotechevents/build_config.dart';
import 'package:toledotechevents/resources.dart';
import 'package:toledotechevents_mobile/util/shared_prefs_resource.dart';

export 'package:toledotechevents/resources.dart';

MobileResources _resources;
final http.Client _client = http.Client();

class MobileResources extends Resources {
  static Future<MobileResources> init(String path) async =>
      _resources ??= MobileResources._(path);

  MobileResources._(this.path)
      : super(
            splash: BoolPrefsResource('splash', parser: Resources.parseSplash),
            theme: StringPrefsResource('theme'),
            eventList: HttpNetworkResource<EventList>(
              client: _client,
              url: config.urls.eventList,
              parser: Resources.parseEvents,
              cache: FileResource(File('$path/events.atom')),
              maxAge: Duration(minutes: 60),
              strategy: CacheStrategy.cacheFirst,
            ),
            venueList: HttpNetworkResource<VenueList>(
              client: _client,
              url: config.urls.venueList,
              parser: Resources.parseVenues,
              cache: FileResource(File('$path/venues.json')),
              maxAge: Duration(minutes: 60),
              strategy: CacheStrategy.cacheFirst,
            ),
            about: HttpNetworkResource<AboutSection>(
              client: _client,
              url: config.urls.aboutPage,
              parser: Resources.parseAboutSection,
              cache: FileResource(File('$path/about.html')),
              maxAge: Duration(hours: 24),
              strategy: CacheStrategy.cacheFirst,
            ),
            authToken: HttpNetworkResource<AuthToken>(
              client: _client,
              url: config.urls.newEventPage,
              parser: Resources.parseAuthToken,
              cache: FileResource(File('$path/new_event.html')),
              maxAge: Duration(hours: 24),
              strategy: CacheStrategy.cacheFirst,
            ));
  final String path;

  @override
  NetworkResource<dom.Document> eventDetails(int id) =>
      HttpNetworkResource<dom.Document>(
        client: _client,
        url: config.urls.event(id),
        parser: (contents) => parse(contents),
        cache: FileResource(File('$path/event_$id.html')),
        maxAge: Duration(hours: 24),
        strategy: CacheStrategy.cacheFirst,
      );

  @override
  NetworkResource<dom.Document> venueDetails(int id) =>
      HttpNetworkResource<dom.Document>(
        client: _client,
        url: config.urls.venue(id),
        parser: (contents) => parse(contents),
        cache: FileResource(File('$path/venue_$id.html')),
        maxAge: Duration(hours: 24),
        strategy: CacheStrategy.cacheFirst,
      );
}
