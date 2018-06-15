import 'dart:async';
import 'dart:core';
import 'package:xml/xml.dart' as xml;
import 'package:html/parser.dart' show parse, parseFragment;
import 'package:html/dom.dart' as dom;
import 'package:html_unescape/html_unescape.dart';
import 'package:intl/intl.dart';
import 'package:network_resource/network_resource.dart';
import 'package:flutter/material.dart';
import '../theme.dart';
import '../internal/deleter.dart';

/// A ToledoTechEvents event. See http://toledotechevents.org/events.atom.
class Event {
  // Directly parsed values
  final String title, summary, url, contentHtml;
  final DateTime published, updated, startTime, endTime;
  final List<double> _coordinates;
  // Derivative values.
  EventVenue _venue;
  String _descriptionHtml, _rsvpUrl, _googleCalendarUrl;
  int _id;
  Duration _duration;
  List<String> _tags;
  List<Link> _links;
  bool _isOneDay;
  NetworkResource _detailsPage;
  dom.Document _detailsDoc;
  Event(xml.XmlElement e)
      : title = HtmlUnescape()
            .convert(e.findElements('title').first.firstChild.toString()),
        summary = HtmlUnescape()
            .convert(e.findElements('summary').first.firstChild.toString()),
        url = e.findElements('url').first.firstChild.toString(),
        contentHtml = HtmlUnescape()
            .convert(e.findElements('content').first.firstChild.toString()),
        published = DateTime
            .parse(e.findElements('published').first.firstChild.toString())
            .toLocal(),
        updated = DateTime
            .parse(e.findElements('updated').first.firstChild.toString())
            .toLocal(),
        startTime = DateTime
            .parse(e.findElements('start_time').first.firstChild.toString())
            .toLocal(),
        endTime = DateTime
            .parse(e.findElements('end_time').first.firstChild.toString())
            .toLocal(),
        _coordinates = _getCoordinates(e
            .toString()
            .split('<georss:point>')
            .last
            .split('<')
            .first
            .split(' '));

  /// The event id.
  int get id {
    if (_id == null) {
      _id = int.parse(url.split('/').last);
    }
    return _id;
  }

  /// The venue, taken from the event content.
  EventVenue get venue {
    if (_venue == null) {
      _venue = EventVenue(
          parseFragment(contentHtml)..querySelector('.location.vcard'));
    }
    return _venue;
  }

  Duration get duration {
    if (_duration == null) {
      _duration = endTime.difference(startTime);
    }
    return _duration;
  }

  List<String> get tags {
    if (_tags == null) {
      _tags = List<String>();
      contentHtml
          .split('href="/events/tag/')
          .skip(1)
          .forEach((tag) => _tags.add(tag.split('"').first));
    }
    return _tags;
  }

  List<Link> get links {
    if (_links == null) {
      _links = List<Link>();
      contentHtml.split('<a class="url" href="').skip(1).forEach((link) {
        var parts = link.split('">');
        _links.add(Link(parts.first, parts.skip(1).first.split('<').first));
      });
    }
    return _links;
  }

  String get descriptionHtml => _descriptionHtml ??= HtmlUnescape().convert(
      parseFragment(contentHtml).querySelector('.description')?.innerHtml ??
          '');

  String get iCalendarUrl => url + '.ics';
  Future<String> get googleCalendarUrl async {
    if (_googleCalendarUrl == null) {
      var doc = await detailsDoc;
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

  String get editUrl => url + '/edit';
  String get cloneUrl => url + '/clone';

  double get latitude => _coordinates[0];
  double get longitude => _coordinates[1];

  NetworkResource get detailsPage {
    return _detailsPage ??= NetworkResource(
        url: url, filename: 'event_$id.html', maxAge: Duration(hours: 24));
  }

  Future<dom.Document> get detailsDoc async =>
      _detailsDoc ??= parse((await detailsPage.get()).data);

  Future<String> get rsvpUrl async {
    if (_rsvpUrl == null) {
      var doc = await detailsDoc;
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
  String toString() {
    return '''
Event $id:
$title
$summary
$url
edit: $editUrl
clone: $cloneUrl
ical: $iCalendarUrl
published: $published
updated: $updated
$startTime - $endTime ($duration)
[$latitude, $longitude]
tags: $tags
links: $links
$venue
$descriptionHtml
''';
  }

  bool get isOneDay {
    return _isOneDay ??= startOfDay(startTime) == startOfDay(endTime);
  }

  bool occursOnDay(DateTime day) {
    var min = startOfDay(day);
    var max = startOfDay(day.add(Duration(days: 1)));
    return endTime.isAfter(min) && startTime.isBefore(max);
  }

  /// true if the event occurs on or after [startDay] but *before* [endDay]
  bool occursOnDayInRange(DateTime startDay, DateTime endDay) {
    return endTime.isAfter(startOfDay(startDay)) &&
        startTime.isBefore(startOfDay(endDay));
  }

  bool occursOnOrAfterDay(DateTime day) {
    return endTime.isAfter(startOfDay(day));
  }

  void delete(BuildContext context) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
                title: Text('Confirm'),
                content: Text('Delete event $id?\nThis cannot be undone.'),
                actions: <Widget>[
                  TertiaryButton('DELETE', () async {
                    Navigator.pop(ctx);
                    Deleter.delete(event: this, context: context);
                  })
                ]));
  }

  static Event findById(List<Event> events, int id) {
    try {
      return events.firstWhere((e) => e.id == id, orElse: null);
    } catch (e) {
      return null;
    }
  }

  static String getTagUrl(String tag) =>
      'http://toledotechevents.org/events/tag/${Uri.encodeComponent(tag)}';
}

class Link {
  final String url, text;
  Link(this.url, this.text);
  @override
  String toString() => '$text => $url';
}

class EventVenue {
  final String url, title;
  final dom.Element _addressElement;
  int _id;
  String _address, _street, _city, _state, _zip;

  EventVenue(dom.DocumentFragment v)
      : url =
            (v.querySelector('a.url')?.attributes?.containsKey('href') ?? false)
                ? v.querySelector('a.url').attributes['href']
                : '',
        title = v.querySelector('.fn.org')?.text ?? 'Venue TBD',
        _addressElement = v.querySelector('div.adr');

  String get mapUrl =>
      'http://maps.google.com/maps?q=${Uri.encodeComponent(address)}';

  int get id {
    if (_id == null) {
      try {
        _id = int.parse(url.split('/').last);
      } catch (e) {
        _id = 0;
      }
    }
    return _id;
  }

  String get street => _street ??= _parseAddress('.street-address');
  String get city => _city ??= _parseAddress('.locality');
  String get state => _state ??= _parseAddress('.region');
  String get zip => _zip ??= _parseAddress('.postal-code');
  String get address => '$street, $city, $state $zip';

  @override
  String toString() => '''
Event Venue $id:
$title
$address
$url
$mapUrl
''';

  String _parseAddress(String selector) =>
      _addressElement?.querySelector(selector)?.text ?? '';
}

String _format(DateTime date, String pattern) =>
    date != null ? DateFormat(pattern).format(date) : '';

String formatDay(DateTime date, {pattern: 'EEEE'}) => _format(date, pattern);
String formatDate(DateTime date, {pattern: 'MMMM d'}) => _format(date, pattern);
String formatTime(DateTime date, {ampm: false, pattern: 'h:mm'}) =>
    _format(date, pattern + (ampm ? 'a' : ''));

DateTime startOfDay(DateTime dt) => dt
    .subtract(Duration(hours: dt.hour))
    .subtract(Duration(minutes: dt.minute))
    .subtract(Duration(seconds: dt.second))
    .subtract(Duration(milliseconds: dt.millisecond));

List<double> _getCoordinates(coords) {
  if (coords.length == 2) {
    return [double.parse(coords[0]), double.parse(coords[1])];
  }
  return [0.0, 0.0];
}

/*
 Example entry XML:

 <entry>
    <id>tag:toledotechevents.org,2005:Calagator::Event/3612</id>
    <published>2018-04-19T08:36:47-04:00</published>
    <updated>2018-04-19T08:37:54-04:00</updated>
    <link rel="alternate" type="text/html" href="http://toledotechevents.org/events/3612"/>
    <title>Agile and Beyond 2018</title>
    <summary>Wednesday, May 16, 2018 at 8am through Friday, May 18, 2018 at 5pm at Eagle Crest Resort (Ypsilanti, MI)</summary>
    <url>http://toledotechevents.org/events/3612</url>
    <link rel="enclosure" type="text/calendar" href="http://toledotechevents.org/events/3612.ics"/>
    <start_time>2018-05-16T08:00:00-04:00</start_time>
    <end_time>2018-05-18T17:00:00-04:00</end_time>
    <content type="html">&lt;div class="vevent"&gt;
  &lt;h1 class="summary"&gt;Agile and Beyond 2018&lt;/h1&gt;
  &lt;div class='date'&gt;&lt;time class="dtstart dt-start" title="2018-05-16T08:00:00" datetime="2018-05-16T08:00:00"&gt;Wednesday, May 16, 2018 at 8am&lt;/time&gt; through &lt;time class="dtend dt-end" title="2018-05-18T17:00:00" datetime="2018-05-18T17:00:00"&gt;Friday, May 18, 2018 at 5pm&lt;/time&gt;&lt;/div&gt;

    &lt;div class="location vcard"&gt;
    &lt;a href='/venues/468' class='url'&gt;
        &lt;span class='fn org'&gt;Eagle Crest Resort (Ypsilanti, MI)&lt;/span&gt;
    &lt;/a&gt;
    &lt;div class="adr"&gt;
        &lt;div class="street-address"&gt;1275 S Huron St&lt;/div&gt;
        &lt;span class="locality"&gt;Ypsilanti&lt;/span&gt;
        , &lt;span class="region"&gt;MI&lt;/span&gt;
        &lt;span class="postal-code"&gt;48197&lt;/span&gt;
        &lt;div class='country-name'&gt;US&lt;div&gt;
        (&lt;a href='http://maps.google.com/maps?q=1275%20S%20Huron%20St,%20Ypsilanti%20MI%2048197%20US'&gt;map&lt;/a&gt;)
    &lt;/div&gt;
    &lt;/div&gt;

  &lt;div class="description"&gt;
    &lt;p&gt;Agile &amp;amp; Beyond is a grassroots, volunteer run conference that helps people learn about agile principles and practices as well as covers topics that help make people and companies awesome. With pre-conference workshops and over 100 conference sessions, there is a wide variety of topics for the agile newbie all the way to the agile expert.&lt;/p&gt;
  &lt;/div&gt;

  &lt;h3&gt;Links&lt;/h3&gt;
  &lt;ul&gt;
    &lt;li&gt;&lt;a class="url" href="http://www.agileandbeyond.com/2018/"&gt;Website&lt;/a&gt;&lt;/li&gt;
  &lt;/ul&gt;

  &lt;div class="tags"&gt;
    &lt;h3&gt;Tags&lt;/h3&gt;
    &lt;p&gt;&lt;a class="p-category" href="/events/tag/agilebeyond"&gt;agilebeyond&lt;/a&gt;&lt;/p&gt;
  &lt;/div&gt;

  &lt;div class='single_view_right'&gt;
    &lt;a href='http://toledotechevents.org/events/3612.ics'&gt;Download to iCal&lt;/a&gt;
    &lt;div id='edit_link'&gt;
      &lt;p&gt;You can &lt;a href="http://toledotechevents.org/events/3612/edit"&gt;edit this event&lt;/a&gt;.&lt;/p&gt;
    &lt;/div&gt;
    &lt;div id='metadata'&gt;
      This item was added directly to Toledo Tech Events &lt;br /&gt;&lt;strong&gt;Thursday, April 19, 2018 at 8:36am&lt;/strong&gt; and last updated &lt;br /&gt;&lt;strong&gt;Thursday, April 19, 2018 at 8:37am&lt;/strong&gt;.
    &lt;/div&gt;
  &lt;/div&gt;
&lt;/div&gt;
</content>
    <georss:point>42.2235 -83.6177</georss:point>
  </entry>
*/
