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
            splash: StorageEntry<bool>('splash',
                parser: (contents) => contents == null ? true : contents == 'true'),
            theme: StorageEntry<String>('theme'),
            eventList: ServiceWorkerResource<EventList>(
              strategy: CacheStrategy.cacheFirst,
                cache: ServiceWorkerCacheEntry(
                    name: config.cacheName,
                    url: config.urls.eventList,
                    parser: Resources.parseEvents,
                    maxAge: Duration(minutes: 60))),
            venueList: ServiceWorkerResource<VenueList>(
                strategy: CacheStrategy.cacheFirst,
                cache: ServiceWorkerCacheEntry(
                    name: config.cacheName,
                    url: config.urls.venueList,
                    parser: Resources.parseVenues,
                    maxAge: Duration(minutes: 60))),
            about: ServiceWorkerResource<AboutSection>(
                strategy: CacheStrategy.cacheFirst,
                cache: ServiceWorkerCacheEntry(
                    name: config.cacheName,
                    url: config.urls.aboutPage,
                    parser: Resources.parseAboutSection,
                    maxAge: Duration(hours: 24))),
            authToken: ServiceWorkerResource<AuthToken>(
                strategy: CacheStrategy.cacheFirst,
                cache: ServiceWorkerCacheEntry(
                    name: config.cacheName,
                    url: config.urls.newEventPage,
                    parser: Resources.parseAuthToken,
                    maxAge: Duration(hours: 24))));

  @override
  NetworkResource<dom.Document> eventDetails(int id) =>
      ServiceWorkerResource<dom.Document>(
        strategy: CacheStrategy.cacheFirst,
        cache: ServiceWorkerCacheEntry(
            name: config.cacheName,
            url: config.urls.event(id),
            parser: (contents) => parse(contents),
            maxAge: Duration(hours: 24)),
      );

  @override
  NetworkResource<dom.Document> venueDetails(int id) =>
      ServiceWorkerResource<dom.Document>(
        strategy: CacheStrategy.cacheFirst,
        cache: ServiceWorkerCacheEntry(
            name: config.cacheName,
            url: config.urls.venue(id),
            parser: (contents) => parse(contents),
            maxAge: Duration(hours: 24)),
      );
}
