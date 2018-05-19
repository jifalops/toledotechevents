import 'dart:async';
import 'dart:convert';

import 'package:xml/xml.dart' as xml;

import 'model/event.dart';
import 'model/venue.dart';
import 'util/network_resource.dart';

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

Future<List<Event>> getEvents() async {
  final events = List<Event>();
  final data = await _eventsResource.get();
  if (data != null) {
    xml
        .parse(data)
        .findAllElements('entry')
        .forEach((entry) => events.add(Event(entry)));
  }
  return events;
}

Future<List<Venue>> getVenues() async {
  final venues = List<Venue>();
  final data = await _venuesResource.get();
  if (data != null) {
    json.decode(data).forEach((item) => venues.add(Venue(item)));

    // list.sort((a, b) {
    //   return (b['events_count'] ?? 0) - (a['events_count'] ?? 0);
    // });

    // print('~~~ Top 10 Venues ~~~');
    // list.take(10).forEach((venue) {
    //   print('${venue['events_count']}: ${venue['title']}');
    // });
  }
  return venues;
}
