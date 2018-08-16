import 'package:meta/meta.dart';
import 'package:intl/intl.dart';

/// Shorthand for [BuildConfig.instance].
BuildConfig get config => BuildConfig.instance;

/// Configuration for the current flavor of the app
/// (e.g. production, development, staging).
class BuildConfig {
  /// Sets up the top-level [config] getter on the first call only.
  static void init({
    @required BuildFlavor flavor,
    @required String baseUrl,
    @required String cacheName,
    String title: 'Toledo Tech Events',
    String issuesUrl: 'http://github.com/jifalops/toledotechevents/issues',
    String forumUrl: 'http://groups.google.com/group/tol-calagator/',
  }) =>
      instance ??= BuildConfig._(
          flavor: flavor,
          title: title,
          baseUrl: baseUrl,
          cacheName: cacheName,
          issuesUrl: issuesUrl,
          forumUrl: forumUrl);

  BuildConfig._(
      {@required this.flavor,
      @required this.baseUrl,
      @required this.cacheName,
      @required this.title,
      @required this.issuesUrl,
      @required this.forumUrl})
      : urls = BuildConfigUrls._(baseUrl);

  final BuildFlavor flavor;

  /// The app's name/title
  final String title;

  /// The backend server.
  final String baseUrl;

  /// The name of the service worker cache.
  final String cacheName;

  /// For users to report a problem.
  final String issuesUrl;

  /// For users to join the discussion.
  final String forumUrl;

  /// A collection of URLs dependent on [baseUrl].
  final BuildConfigUrls urls;

  static BuildConfig instance;
}

enum BuildFlavor { production, development, staging }

class BuildConfigUrls {
  BuildConfigUrls._(this._base)
      : eventList = '$_base/events.atom',
        venueList = '$_base/venues.json',
        aboutPage = '$_base/about.html',
        newEventPage = '$_base/events/new.html',
        eventsICal = '$_base/events.ics',
        eventFormAction = '$_base/events';

  final String _base,
      eventList,
      venueList,
      aboutPage,
      newEventPage,
      eventsICal,
      eventFormAction;
  String _subscribeEventsGoogle, _subscribeEventsICal, _pastEvents;

  String get subscribeEventsGoogle =>
      _subscribeEventsGoogle ??= 'http://www.google.com/calendar/render?cid=' +
          Uri.encodeQueryComponent(eventsICal);

  String get subscribeEventsICal => _subscribeEventsICal ??=
      eventsICal.replaceAll(RegExp(r'https?://'), 'webcal://');

  /// Past events, starting from 90 days ago.
  String get pastEvents {
    if (_pastEvents == null) {
      var now = DateTime.now();
      var fmt = DateFormat('yyyy-MM-dd');
      _pastEvents = '$_base/events?utf8=%E2%9C%93&date%5Bstart%5D=' +
          fmt.format(now.subtract(Duration(days: 90))) +
          '&date%5Bend%5D=' +
          fmt.format(now) +
          '&time%5Bstart%5D=&time%5Bend%5D=&commit=Filter';
    }
    return _pastEvents;
  }

  String event(int id) => '$_base/events/$id';
  String eventEdit(int id) => event(id) + '/edit';
  String eventClone(int id) => event(id) + '/clone';
  String venue(int id) => '$_base/venues/$id';
  String venueEdit(int id) => venue(id) + '/edit';
  String venueClone(int id) => venue(id) + '/clone';
  String venueICal(int id) => venue(id) + '.ics';
  String venueSubscribe(int id) =>
      venueICal(id).replaceAll(RegExp(r'https?://'), 'webcal://');

  String tag(String tag) => '$_base/events/tag/${Uri.encodeComponent(tag)}';
}
