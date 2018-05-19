import 'package:xml/xml.dart';
import 'package:html/parser.dart' show parseFragment;
import 'package:html/dom.dart';
import 'package:html_unescape/html_unescape.dart';

/**
 * A ToledoTechEvents event. See http://toledotechevents.org/events.atom.
 */
class Event {
  final String title, summary, url, contentHtml;
  final DateTime published, updated, startTime, endTime;
  final List<double> _coordinates;
  EventVenue _venue;
  String _descriptionHtml;
  int _id;
  Duration _duration;
  List<String> _tags;
  List<Link> _links;
  Event(XmlElement e)
      : title = e.findElements('title').first.firstChild.toString(),
        summary = e.findElements('summary').first.firstChild.toString(),
        url = e.findElements('url').first.firstChild.toString(),
        contentHtml = HtmlUnescape()
            .convert(e.findElements('content').first.firstChild.toString()),
        published = DateTime
            .parse(e.findElements('published').first.firstChild.toString()),
        updated = DateTime
            .parse(e.findElements('updated').first.firstChild.toString()),
        startTime = DateTime
            .parse(e.findElements('start_time').first.firstChild.toString()),
        endTime = DateTime
            .parse(e.findElements('end_time').first.firstChild.toString()),
        _coordinates = _getCoordinates(e
            .toString()
            .split('<georss:point>')
            .last
            .split('<')
            .first
            .split(' '));

  int get id {
    if (_id == null) {
      _id = int.parse(url.split('/').last);
    }
    return _id;
  }

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

  String get descriptionHtml {
    if (_descriptionHtml == null) {
      _descriptionHtml =
          parseFragment(contentHtml).querySelector('.description').innerHtml;
    }
    return _descriptionHtml;
  }

  String get iCalendarUrl => url + '.ics';
  String get editUrl => url + '/edit';

  double get latitude => _coordinates[0];
  double get longitude => _coordinates[1];

  @override
  String toString() {
    return '''
Event $id:
$title
$summary
$url
edit: $editUrl
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
}

class Link {
  final String url, text;
  Link(this.url, this.text);
  @override
  String toString() => '$text => $url';
}

class EventVenue {
  final String url, title, address;
  int _id;

  EventVenue(DocumentFragment v)
      : url = v.querySelector('a.url').attributes['href'],
        title = v.querySelector('.fn.org')?.text ?? 'Unknown Venue',
        address = _getAddress(v.querySelector('div.adr'));

  String get mapUrl => 'http://maps.google.com/maps?q=$address';

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

  @override
  String toString() => '''
Event Venue $id:
$title
$address
$url
$mapUrl
''';
}

String _getAddress(Element e) {
  if (e == null) return '-';
  var addr = e.querySelector('.street-address')?.text ?? '';
  var city = e.querySelector('.locality')?.text ?? '';
  var state = e.querySelector('.region')?.text ?? '';
  var zip = e.querySelector('.postal-code')?.text ?? '';
  return '$addr, $city, $state $zip';
}

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
