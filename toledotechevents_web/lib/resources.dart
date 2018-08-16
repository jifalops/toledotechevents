import 'dart:async';
import 'package:async_resource/browser_resource.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' show parse;
import 'package:toledotechevents/build_config.dart';
import 'package:toledotechevents/resources.dart';

export 'package:toledotechevents/resources.dart';

final resources = WebResources._();

class WebResources extends Resources {
  WebResources._()
      : super(
            theme: StorageEntry(key: 'theme'),
            eventList: ServiceWorkerResource<EventList>(
              cache: ServiceWorkerCacheEntry(
                  name: config.cacheName,
                  url: config.urls.eventList,
                  parser: Resources.parseEvents,
                  maxAge: Duration(minutes: 60)),
              strategy: CacheStrategy.cacheFirst,
            ),
            venueList: ServiceWorkerResource<VenueList>(
              cache: ServiceWorkerCacheEntry(
                name: config.cacheName,
                url: config.urls.venueList,
                parser: Resources.parseVenues,
                maxAge: Duration(minutes: 60),
              ),
              strategy: CacheStrategy.cacheFirst,
            ),
            about: ServiceWorkerResource<AboutSection>(
              cache: ServiceWorkerCacheEntry(
                  name: config.cacheName,
                  url: config.urls.aboutPage,
                  parser: Resources.parseAboutSection,
                  maxAge: Duration(hours: 24)),
              strategy: CacheStrategy.cacheFirst,
            ),
            authToken: ServiceWorkerResource<AuthToken>(
              cache: ServiceWorkerCacheEntry(
                  name: config.cacheName,
                  url: config.urls.newEventPage,
                  parser: Resources.parseAuthToken,
                  maxAge: Duration(hours: 24)),
              strategy: CacheStrategy.cacheFirst,
            ));
  final String path;

  @override
  NetworkResource<dom.Document> eventDetails(int id) =>
      ServiceWorkerResource<dom.Document>(
        cache: ServiceWorkerCacheEntry(
            name: config.cacheName,
            url: config.urls.event(id),
            parser: (contents) => parse(contents),
            maxAge: Duration(hours: 24)),
        strategy: CacheStrategy.cacheFirst,
      );

  @override
  NetworkResource<dom.Document> venueDetails(int id) =>
      ServiceWorkerResource<dom.Document>(
        cache: ServiceWorkerCacheEntry(
            name: config.cacheName,
            url: config.urls.venue(id),
            parser: (contents) => parse(contents),
            maxAge: Duration(hours: 24)),
        strategy: CacheStrategy.cacheFirst,
      );
}
