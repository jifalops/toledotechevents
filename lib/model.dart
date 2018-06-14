import 'dart:async';
import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:xml/xml.dart' as xml;
import 'package:flutter/material.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;
import 'package:network_resource/network_resource.dart';
import 'model/event.dart';
import 'model/venue.dart';

export 'model/event.dart';
export 'model/venue.dart';

// Top-level URLs
const kSubscribeGoogleCalenderUrl =
    'http://www.google.com/calendar/render?cid=http%3A%2F%2Ftoledotechevents.org%2Fevents.ics';
const kSubscribeICalendarUrl = 'webcal://toledotechevents.org/events.ics';
const kFileIssueUrl = 'http://github.com/jifalops/toledotechevents/issues';
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

final _aboutPageResource = NetworkResource(
  url: 'http://toledotechevents.org/about.html',
  filename: 'about.html',
  maxAge: Duration(hours: 24),
);

final _newEventPageResource = NetworkResource(
  url: 'http://toledotechevents.org/events/new.html',
  filename: 'new_event.html',
  maxAge: Duration(hours: 24),
);

List<Event> _events;
List<Venue> _venues;
String _aboutSectionHtml;
String _newEventAuthToken;
// String _newEventForm; // Just rendering the html for now

/// Fetch events from the server or local cache.
Future<List<Event>> getEvents({bool forceReload = false}) async {
  if (_events == null || forceReload) {
    _events = List<Event>();
    final data = await _eventsResource.get(forceReload: forceReload);
    if (data.data != null && data.data.isNotEmpty) {
      xml
          .parse(data.data)
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
    if (data.data != null && data.data.isNotEmpty) {
      json.decode(data.data).forEach((item) => _venues.add(Venue(item)));
    }
  }
  return _venues;
}

Future<String> getAboutSectionHtml({bool forceReload = false}) async {
  if (_aboutSectionHtml == null || forceReload) {
    final page = await _aboutPageResource.get(forceReload: forceReload);
    if (page.data != null) {
      _aboutSectionHtml =
          parse(page.data)?.querySelector('.about-us')?.outerHtml ?? '';
    }
  }
  return _aboutSectionHtml;
}

Future<String> getNewEventAuthToken({bool forceReload = false}) async {
  if (_newEventAuthToken == null || forceReload) {
    final page = await _newEventPageResource.get(forceReload: forceReload);
    if (page.data != null) {
      final search = 'name="authenticity_token" value="';
      final start = page.data.indexOf(search) + search.length;
      _newEventAuthToken = page.data.substring(start, page.data.indexOf('"', start));
    }
  }
  return _newEventAuthToken;
}

// Future<String> getNewEventForm({bool forceReload = false}) async {
//   if (_newEventForm == null || forceReload) {
//     final page = await _newEventPageResource.get(forceReload: forceReload);
//     if (page != null) {
//       print('new event page length=${page.length}');
//       _newEventForm = parse(page)?.getElementById('new_event')?.outerHtml ?? '';
//     }
//   }
//   return _newEventForm;
// }

class NullWidget extends Container {
  NullWidget() : super(width: 0.0, height: 0.0);
}
