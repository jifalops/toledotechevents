import 'dart:core';
import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:html/dom.dart' as dom;
import 'package:async_resource/async_resource.dart';
import 'package:english_words/english_words.dart' as words;
import 'package:html_unescape/html_unescape.dart';
import 'package:meta/meta.dart';
import 'package:toledotechevents/build_config.dart';
import 'package:toledotechevents/util/extendable_list.dart';

class VenueList extends ExtendableList<VenueListItem> {
  VenueList(String jsonString)
      : super.from(
            json.decode(jsonString).map((dict) => VenueListItem.fromMap(dict)),
            growable: false);

  VenueList.from(Iterable<VenueListItem> elements)
      : super.from(elements, growable: false);

  VenueListItem selectedItem;
  VenuesOrder _sortOrder = VenuesOrder.popular;
  bool _sortReverse = false;

  VenueList _spam;

  VenueListItem findById(int id) => firstWhere((e) => e.id == id, orElse: null);

  VenueListItem findByTitle(String title) {
    try {
      final results = where((v) => v.title == title).toList();
      results.sort((a, b) {
        return b.eventCount - a.eventCount;
      });
      return results.first;
    } catch (e) {
      return null;
    }
  }

  VenueList findSpam() {
    if (_spam == null) {
      bool hasEnglishWord(String string) {
        bool found = false;
        string.split(' ').forEach((word) {
          if (words.all.contains(word.toLowerCase())) {
            found = true;
            return;
          }
        });
        return found;
      }

      final list = List<VenueListItem>();
      forEach((venue) {
        if (!hasEnglishWord(venue.title)) list.add(venue);
      });
      _spam = VenueList.from(list);
    }
    return _spam;
  }

  String indicatorFor(VenuesOrder order) =>
      _sortOrder == order ? (_sortReverse ? ' ↑' : ' ↓') : '';

  bool get isReversed => _sortReverse;

  VenuesOrder get sortOrder => _sortOrder;

  void setOrder(VenuesOrder value) {
    if (_sortOrder == order)
      _sortReverse = !_sortReverse;
    else {
      _sortOrder = order;
      _sortReverse = false;
    }
    sort();
  }

  @override
  sort([int Function(VenueListItem a, VenueListItem b) ignored]) {
    switch (_sortOrder) {
      case VenuesOrder.popular:
        _sortReverse
            ? super.sort((a, b) => a.eventCount.compareTo(b.eventCount))
            : super.sort((a, b) => b.eventCount.compareTo(a.eventCount));
        break;
      case VenuesOrder.newest:
        _sortReverse
            ? super.sort((a, b) => a.created.compareTo(b.created))
            : super.sort((a, b) => b.created.compareTo(a.created));
        break;
      case VenuesOrder.hot:
        final now = DateTime.now();
        double hotness(VenueListItem v) {
          return v.eventCount /
              (now.millisecondsSinceEpoch - v.created.millisecondsSinceEpoch);
        }
        _sortReverse
            ? super.sort((a, b) => hotness(a).compareTo(hotness(b)))
            : super.sort((a, b) => hotness(b).compareTo(hotness(a)));
        break;
    }
  }
}

enum VenuesOrder {
  popular,
  newest,
  hot
  // Can't do recent without list of *past* events
}

class VenueListItem {
  VenueListItem(
      {@required this.title,
      @required this.description,
      @required this.homepage,
      @required this.email,
      @required this.phone,
      @required this.accessNotes,
      @required this.id,
      @required this.eventCount,
      @required this.sourceId,
      @required this.duplicateOfId,
      @required this.latitude,
      @required this.longitude,
      @required this.isClosed,
      @required this.hasWifi,
      @required this.created,
      @required this.updated,
      @required String address,
      @required String street,
      @required String city,
      @required String state,
      @required String zip})
      : _address = address,
        _street = street,
        _city = city,
        _state = state,
        _zip = zip;

  VenueListItem.clone(VenueListItem other)
      : title = other.title,
        description = other.description,
        homepage = other.homepage,
        email = other.email,
        phone = other.phone,
        accessNotes = other.accessNotes,
        id = other.id,
        eventCount = other.eventCount,
        sourceId = other.sourceId,
        duplicateOfId = other.duplicateOfId,
        latitude = other.latitude,
        longitude = other.longitude,
        isClosed = other.isClosed,
        hasWifi = other.hasWifi,
        created = other.created,
        updated = other.updated,
        _address = other._address,
        _street = other._street,
        _city = other._city,
        _state = other._state,
        _zip = other._zip;

  VenueListItem.fromMap(Map<String, dynamic> v)
      : title = v['title'] ?? '',
        description = v['description'] ?? '',
        _address = v['address'] ?? '',
        _street = v['street_address'] ?? '',
        _city = v['locality'] ?? '',
        _state = v['region'] ?? '',
        _zip = v['postal_code'] ?? '',
        homepage = v['url'] ?? '',
        email = v['email'] ?? '',
        phone = v['telephone'] ?? '',
        accessNotes = v['access_notes'] ?? '',
        id = v['id'] ?? '',
        eventCount = v['events_count'] ?? 0,
        sourceId = v['source_id'] ?? 0,
        duplicateOfId = v['duplicate_of_id'] ?? 0,
        latitude = double.parse(v['latitude'] ?? '0'),
        longitude = double.parse(v['longitude'] ?? '0'),
        isClosed = v['closed'] ?? false,
        hasWifi = v['wifi'] ?? false,
        created = DateTime.parse(v['created_at'] ?? '').toLocal(),
        updated = DateTime.parse(v['updated_at'] ?? '').toLocal();

  // Directly parsed values
  final String title,
      description,
      _address,
      _street,
      _city,
      _state,
      _zip,
      homepage,
      email,
      phone,
      accessNotes;
  final int id, eventCount, sourceId, duplicateOfId;
  final double latitude, longitude;
  final bool isClosed, hasWifi;
  final DateTime created, updated;
  // Derivative values.
  _Address __addressComposed;

  String get url => config.venueUrl(id);
  String get iCalendarUrl => config.venueICalendarUrl(id);
  String get subscribeUrl => config.venueSubscribeUrl(id);
  String get editUrl => config.venueEditUrl(id);
  String get mapUrl => 'http://maps.google.com/maps?q=$address';
  String get phoneUrl => 'tel://$phone';
  String get emailUrl => 'mailto:$email';

  _Address get _addressComposed => __addressComposed ??= _Address(
      title, _address, _street, _city, _state, _zip, latitude, longitude);

  String get address => _addressComposed.address;
  String get street => _addressComposed.street;
  String get city => _addressComposed.city;
  String get state => _addressComposed.state;
  String get zip => _addressComposed.zip;

  @override
  String toString() => '${super.toString()} id: $id';

  String toStringDeep() => '''
${toString()}
$title
events: $eventCount
$description
$address
$street
$city
$state
$zip
$homepage
$url
$email
$phone
$accessNotes
$sourceId
$duplicateOfId
[$latitude, $longitude]
created: $created
updated: $updated
Closed: $isClosed
Wifi: $hasWifi
''';

  static final formatter = DateFormat('MMM yyyy');
}

/// A ToledoTechEvents venue. See http://toledotechevents.org/venues.json.
class VenueDetails extends VenueListItem {
  VenueDetails(VenueListItem from, this.resource) : super.clone(from);

  final NetworkResource<dom.Document> resource;
  List<VenueEvent> _pastEvents, _futureEvents;

  Future<List<VenueEvent>> get pastEvents async {
    if (_pastEvents == null) {
      _pastEvents = List<VenueEvent>();
      (await resource.get())
          .querySelector('#past_events')
          .querySelectorAll('tr')
          .forEach((tableRow) {
        if (tableRow.className != 'blank_list')
          _pastEvents.add(VenueEvent(tableRow));
      });
    }
    return _pastEvents;
  }

  Future<List<VenueEvent>> get futureEvents async {
    if (_futureEvents == null) {
      _futureEvents = List<VenueEvent>();
      (await resource.get())
          .querySelector('#future_events')
          .querySelectorAll('tr')
          .forEach((tableRow) {
        if (tableRow.className != 'blank_list')
          _futureEvents.add(VenueEvent(tableRow));
      });
    }
    return _futureEvents;
  }

  // void delete(BuildContext context) {
  //   showDialog(
  //       context: context,
  //       builder: (ctx) => AlertDialog(
  //             title: Font('Confirm'),
  //             content: Font('Delete venue $id?\nThis cannot be undone.'),
  //             actions: <Widget>[
  //               TertiaryButton('DELETE', () async {
  //                 Navigator.pop(ctx);
  //                 Deleter.delete(venue: this, context: context);
  //               }),
  //             ],
  //           ));
  // }

  static Future<VenueDetails> request(
      NetworkResource<dom.Document> resource) async {
    // TODO implement fetch by id.
    return null;
  }

  static final formatter = DateFormat(' MMMM dd, yyyy');
}

class _Address {
  String address, street, city, state, zip;
  _Address(
      String title, String _address, _street, _city, _state, _zip, lat, lng) {
    final bool hasLatLng = lat != 0.0 && lng != 0.0;
    if (_street.isNotEmpty && _street != 'null') {
      street = _street;
      city = _city ?? '';
      state = _state ?? '';
      zip = _zip ?? '';
      address = _composed(street, city, state, zip);
    } else if (_address.isNotEmpty) {
      address = _address;
      _address = _address.replaceAll(',', '');
      var words = _address.split(' ');
      try {
        zip = words.last;
        state = words[words.length - 2];
        if (words.length == 5) {
          street = words[0] + ' ' + words[1];
          city = words[2];
        } else if (words.length == 6) {
          street = words[0] + ' ' + words[1] + words[2];
          city = words[3];
        } else {
          var parts = _address.split('[,.]');
          var cityIndex = parts.length - 1;
          city = parts[cityIndex];
          street = _address.substring(0, cityIndex);
        }
      } catch (e) {}
    } else {
      street = title;
      city = _city.isEmpty ? (hasLatLng ? '$lat, $lng' : 'Toledo') : _city;
      state = _state.isEmpty ? (hasLatLng ? '' : 'OH') : _state;
      zip = _zip ?? '';
      address = _composed(street, city, state, zip);
    }
  }
  _composed(_street, _city, _state, _zip) => '$_street, $_city, $_state $_zip';
}

class VenueEvent {
  VenueEvent(dom.Element tableRow)
      :
        // .querySelectorAll()
        //         .forEach((anchor) => _pastEvents.add(VenueEvent(
        //             anchor.attributes['href'], HtmlUnescape().convert(anchor.text))));

        url =
            tableRow.querySelector('.summary.p-name.u-url').attributes['href'],
        title = HtmlUnescape()
            .convert(tableRow.querySelector('.summary.p-name.u-url').text);

  final String url, title;
  int _id;

  int get id => _id ??= int.parse(url.split('/').last);
}
