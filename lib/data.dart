import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'storage.dart';
import 'package:webfeed/webfeed.dart';

const _kVenuesFile = 'venues.json';
const _kEventsFile = 'events.atom';

Future<String> _fetchData(filename) async {
  final response = await http.get('http://toledotechevents.org/$filename');
  var contents;
  if (response.statusCode == 200) {
    contents = response.body;
    print('Caching $filename...');
    await writeFile(filename, contents);
  } else {
    print('Failed to fetch $filename, using cached copy...');
    contents = await readFile(filename);
  }
  return contents; // @Nullable
}

Future<Object> fetchVenues() async {
  final contents = await _fetchData(_kVenuesFile);
  if (contents == null) return null;

  final venues = json.decode(contents);
  print(venues);
  return venues;
}

Future<Object> fetchEvents() async {
  final contents = await _fetchData(_kEventsFile);
  if (contents == null) return null;
  final events = new AtomFeed.parse(contents);
  print(events);
  return events;
}
