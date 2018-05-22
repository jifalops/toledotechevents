import 'dart:async';
import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:xml/xml.dart' as xml;

import 'util/network_resource.dart';
import 'model/event.dart';
import 'model/venue.dart';

export 'model/event.dart';
export 'model/venue.dart';

// Top-level URLs
const kSubscribeGoogleCalenderUrl =
    'http://www.google.com/calendar/render?cid=http%3A%2F%2Ftoledotechevents.org%2Fevents.ics';
const kSubscribeICalendarUrl = 'webcal://toledotechevents.org/events.ics';
const kFileIssueUrl = 'http://github.com/jmslagle/calagator/issues';
const kForumUrl = 'http://groups.google.com/group/tol-calagator/';

/// Past events, starting from 30 days ago.
String pastEventsUrl() {
  var now = DateTime.now();
  var fmt = DateFormat('yyyy-MM-dd');
  return 'http://toledotechevents.org/events?utf8=%E2%9C%93&date%5Bstart%5D=' +
      fmt.format(now.subtract(Duration(days: 30))) +
      '&date%5Bend%5D=' +
      fmt.format(now) +
      '&time%5Bstart%5D=&time%5Bend%5D=&commit=Filter';
}

final _eventsResource = NetworkResource(
  url: 'http://toledotechevents.org/events.atom',
  filename: 'events.atom',
  maxAge: Duration(minutes: 60),
);

final _venuesResource = NetworkResource(
  url: 'http://toledotechevents.org/venues.json',
  filename: 'venues.json',
  maxAge: Duration(minutes: 60),
);

List<Event> _events;
List<Venue> _venues;

/// Fetch events from the server or local cache.
Future<List<Event>> getEvents({bool forceReload = false}) async {
  if (_events == null || forceReload) {
    _events = List<Event>();
    final data = await _eventsResource.get(forceReload: forceReload);
    if (data != null) {
      xml
          .parse(data)
          .findAllElements('entry')
          .forEach((entry) => _events.add(Event(entry)));
    }
  }
  return _events;
}

/// Fetch venues from the server or local cache.
Future<List<Venue>> getVenues({bool forceReload = false}) async {
  if (_venues == null || forceReload) {
    _venues = List<Venue>();
    final data = await _venuesResource.get(forceReload: forceReload);
    if (data != null) {
      json.decode(data).forEach((item) => _venues.add(Venue(item)));
    }
  }
  return _venues;
}
