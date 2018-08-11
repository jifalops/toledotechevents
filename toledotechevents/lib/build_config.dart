import 'package:meta/meta.dart';
import 'package:intl/intl.dart';

/// Shorthand for [BuildConfig.instance].
BuildConfig get config => BuildConfig.instance;

/// Configuration for the current flavor of the app
/// (e.g. production, development, staging).
class BuildConfig {
  const BuildConfig._(
      {@required this.flavor,
      @required this.title,
      @required this.baseUrl,
      @required this.cacheName});

  /// Sets up the top-level [config] getter on the first call only.
  static void init(
          {@required BuildFlavor flavor,
          @required String title,
          @required String baseUrl,
          @required String cacheName}) =>
      instance ??= BuildConfig._(
          flavor: flavor, title: title, baseUrl: baseUrl, cacheName: cacheName);

  final BuildFlavor flavor;

  /// The app's name/title
  final String title;

  /// The backend server.
  final String baseUrl;

  /// The name of the service worker cache.
  final String cacheName;

  static BuildConfig instance;

  // Top-level URLs
  static const subscribeGoogleCalenderUrl =
      'http://www.google.com/calendar/render?cid=http%3A%2F%2Ftoledotechevents.org%2Fevents.ics';
  static const fileIssueUrl =
      'http://github.com/jifalops/toledotechevents/issues';
  static const forumUrl = 'http://groups.google.com/group/tol-calagator/';

  String get subscribeICalendarUrl =>
      baseUrl.replaceAll(RegExp(r'https?://'), 'webcal://') + '/events.ics';

  /// Past events, starting from 90 days ago.
  String get pastEventsUrl {
    var now = DateTime.now();
    var fmt = DateFormat('yyyy-MM-dd');
    return '$baseUrl/events?utf8=%E2%9C%93&date%5Bstart%5D=' +
        fmt.format(now.subtract(Duration(days: 90))) +
        '&date%5Bend%5D=' +
        fmt.format(now) +
        '&time%5Bstart%5D=&time%5Bend%5D=&commit=Filter';
  }

  String get newEventUrl => '$baseUrl/events';
  String eventUrl(int id) => '$baseUrl/events/$id';
  String eventEditUrl(int id) => eventUrl(id) + '/edit';
  String eventCloneUrl(int id) => eventUrl(id) + '/clone';
  String venueUrl(int id) => '$baseUrl/venues/$id';
  String venueEditUrl(int id) => venueUrl(id) + '/edit';
  String venueCloneUrl(int id) => venueUrl(id) + '/clone';
  String venueICalendarUrl(int id) => venueUrl(id) + '.ics';
  String venueSubscribeUrl(int id) =>
      venueICalendarUrl(id).replaceAll(RegExp(r'https?://'), 'webcal://');

  String tagUrl(String tag) =>
      '$baseUrl/events/tag/${Uri.encodeComponent(tag)}';
}

enum BuildFlavor { production, development, staging }
