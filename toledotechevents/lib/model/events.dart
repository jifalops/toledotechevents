import 'dart:async';
import 'dart:core';
import 'dart:collection';
import 'package:xml/xml.dart' as xml;
import 'package:html/parser.dart' show parse, parseFragment;
import 'package:html/dom.dart' as dom;
import 'package:html_unescape/html_unescape.dart';
import 'package:intl/intl.dart';
import 'package:async_resource/async_resource.dart';
import 'package:meta/meta.dart';
import 'package:toledotechevents/internal/deleter.dart';

class EventList extends UnmodifiableListView<EventListItem> {
  EventList(String xmlString)
      : super(xml
            .parse(xmlString)
            .findAllElements('entry')
            .map((entry) => EventListItem.fromXml(entry)));

  EventListItem selectedItem;

  EventListItem findById(int id) => firstWhere((e) => e.id == id, orElse: null);
}

class EventListItem {
  EventListItem(
      {@required this.title,
      @required this.summary,
      @required this.url,
      @required this.contentHtml,
      @required this.published,
      @required this.updated,
      @required this.startTime,
      @required this.endTime,
      @required List<double> coordinates})
      : _coordinates = coordinates;

  EventListItem.clone(EventListItem other)
      : title = other.title,
        summary = other.summary,
        url = other.url,
        contentHtml = other.contentHtml,
        published = other.published,
        updated = other.updated,
        startTime = other.startTime,
        endTime = other.endTime,
        _coordinates = other._coordinates;

  EventListItem.fromXml(xml.XmlElement e)
      : title = HtmlUnescape()
            .convert(e.findElements('title').first.firstChild.toString()),
        summary = HtmlUnescape()
            .convert(e.findElements('summary').first.firstChild.toString()),
        url = e.findElements('url').first.firstChild.toString(),
        contentHtml = HtmlUnescape()
            .convert(e.findElements('content').first.firstChild.toString()),
        published = DateTime.parse(
                e.findElements('published').first.firstChild.toString())
            .toLocal(),
        updated = DateTime.parse(
                e.findElements('updated').first.firstChild.toString())
            .toLocal(),
        startTime = DateTime.parse(
                e.findElements('start_time').first.firstChild.toString())
            .toLocal(),
        endTime = DateTime.parse(
                e.findElements('end_time').first.firstChild.toString())
            .toLocal(),
        _coordinates = _parseCoords(e
            .toString()
            .split('<georss:point>')
            .last
            .split('<')
            .first
            .split(' '));

  // Directly parsed values
  final String title, summary, url, contentHtml;
  final DateTime published, updated, startTime, endTime;
  final List<double> _coordinates;
  // Derivative values.
  int _id;
  String _descriptionHtml;
  Duration _duration;
  List<String> _tags;
  List<Link> _links;
  bool _isOneDay;
  EventListEventVenue _venue;

  /// The event id.
  int get id => _id ??= int.tryParse(url.split('/').last);

  /// The venue info parsed from [contentHtml].
  EventListEventVenue get venue => _venue ??= EventListEventVenue(
      parseFragment(contentHtml)..querySelector('.location.vcard'));

  Duration get duration => _duration ??= endTime.difference(startTime);

  /// Tags parsed from [contentHtml].
  List<String> get tags => _tags ??= contentHtml
      .split('href="/events/tag/')
      .skip(1)
      .map((tag) => tag.split('"').first);

  /// URL links parsed from [contentHtml].
  List<Link> get links =>
      _links ??= contentHtml.split('<a class="url" href="').skip(1).map((link) {
        var parts = link.split('">');
        return Link(parts.first, parts.skip(1).first.split('<').first);
      });

  /// The description, including markup (markdown is **not** parsed).
  String get descriptionHtml => _descriptionHtml ??= HtmlUnescape().convert(
      parseFragment(contentHtml).querySelector('.description')?.innerHtml ??
          '');

  String get iCalendarUrl => '$url.ics';
  String get editUrl => '$url/edit';
  String get cloneUrl => '$url/clone';

  double get latitude => _coordinates[0];
  double get longitude => _coordinates[1];

  bool get isOneDay =>
      _isOneDay ??= startOfDay(startTime) == startOfDay(endTime);

  bool occursOnDay(DateTime day) {
    var min = startOfDay(day);
    var max = startOfDay(day.add(Duration(days: 1)));
    return endTime.isAfter(min) && startTime.isBefore(max);
  }

  /// `true` if the event occurs on or after [startDay] but *before* [endDay].
  bool occursOnDayInRange(DateTime startDay, DateTime endDay) {
    return endTime.isAfter(startOfDay(startDay)) &&
        startTime.isBefore(startOfDay(endDay));
  }

  bool occursOnOrAfterDay(DateTime day) {
    return endTime.isAfter(startOfDay(day));
  }

  void delete() => Deleter.delete(event: this);
// TODO move elsewhere
  // void delete(BuildContext context) {
  //   showDialog(
  //       context: context,
  //       builder: (ctx) => AlertDialog(
  //               title: Text('Confirm'),
  //               content: Text('Delete event $id?\nThis cannot be undone.'),
  //               actions: <Widget>[
  //                 TertiaryButton('DELETE', () async {
  //                   Navigator.pop(ctx);
  //                   Deleter.delete(event: this, context: context);
  //                 })
  //               ]));
  // }

  @override
  String toString() => '${super.toString()} id: $id';

  String toStringDeep() => '''
${toString()}:
$title
$summary
$url
$startTime - $endTime ($duration)
published: $published
updated: $updated
coords: [$latitude, $longitude]

oneDay: $isOneDay
edit: $editUrl
clone: $cloneUrl
ical: $iCalendarUrl
tags: $tags
links: $links
$venue
$descriptionHtml
''';
}

List<double> _parseCoords(List<String> coords) {
  if (coords.length == 2) {
    return [double.parse(coords[0]), double.parse(coords[1])];
  }
  return [0.0, 0.0];
}

/// A ToledoTechEvents event. See http://toledotechevents.org/events.atom.
class EventDetails extends EventListItem {
  EventDetails(EventListItem from, this.resource) : super.clone(from);

  final NetworkResource<dom.Document> resource;
  String _rsvpUrl, _googleCalendarUrl;

  Future<String> get googleCalendarUrl async {
    if (_googleCalendarUrl == null) {
      var doc = await resource.get();
      if (doc != null) {
        try {
          _googleCalendarUrl =
              doc.getElementById('google_calendar_export').attributes['href'];
        } catch (e) {
          // Doesnt exist
          _googleCalendarUrl = '';
        }
      }
    }
    return _googleCalendarUrl;
  }

  Future<String> get rsvpUrl async {
    if (_rsvpUrl == null) {
      var doc = await resource.get();
      if (doc != null) {
        try {
          _rsvpUrl = doc.querySelector('.rsvp').attributes['href'];
        } catch (e) {
          // Event does not have an RSVP url.
          _rsvpUrl = '';
        }
      }
    }
    return _rsvpUrl;
  }

  @override
  String toStringDeep() {
    return '''${super.toStringDeep()}
$_rsvpUrl
$_googleCalendarUrl
''';
  }

  static Future<EventDetails> request(
      NetworkResource<dom.Document> resource) async {
    // TODO implement fetch by id.
    return null;
  }
}

class Link {
  const Link(this.url, this.text);
  final String url, text;
  @override
  String toString() => 'Link ($text => $url)';
}

class EventListEventVenue {
  EventListEventVenue(dom.DocumentFragment v)
      : url =
            (v.querySelector('a.url')?.attributes?.containsKey('href') ?? false)
                ? v.querySelector('a.url').attributes['href']
                : '',
        title = v.querySelector('.fn.org')?.text ?? 'Venue TBD',
        _addressElement = v.querySelector('div.adr');

  final String url, title;
  final dom.Element _addressElement;
  int _id;
  String _street, _city, _state, _zip;

  String get mapUrl =>
      'http://maps.google.com/maps?q=${Uri.encodeComponent(address)}';

  int get id => _id ??= int.tryParse(url.split('/').last) ?? 0;

  String get street => _street ??= _parseAddress('.street-address');
  String get city => _city ??= _parseAddress('.locality');
  String get state => _state ??= _parseAddress('.region');
  String get zip => _zip ??= _parseAddress('.postal-code');
  String get address => '$street, $city, $state $zip';

  String _parseAddress(String selector) =>
      _addressElement?.querySelector(selector)?.text ?? '';

  @override
  String toString() => '${super.toString()} id: $id';

  String toStringDeep() => '''
${toString()}
$title
$address
$url
$mapUrl
''';
}

String _format(DateTime date, String pattern) =>
    date != null ? DateFormat(pattern).format(date) : '';

String formatDay(DateTime date, {pattern: 'EEEE'}) => _format(date, pattern);
String formatDate(DateTime date, {pattern: 'MMMM d'}) => _format(date, pattern);
String formatTime(DateTime date, {ampm: false, pattern: 'h:mm'}) =>
    _format(date, pattern + (ampm ? 'a' : ''));

DateTime startOfDay(DateTime date) => DateTime(date.year, date.month, date.day);
