/**
 * A ToledoTechEvents venue. See http://toledotechevents.org/venues.json.
 */
class Venue {
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
  _Address __addressComposed;
  Venue(Map v)
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

  String get url => 'http://toledotechevents.org/venues/$id';
  String get iCalendarUrl => url + '.ics';
  String get subscribeUrl => iCalendarUrl.replaceAll('http://', 'webcal://');
  String get editUrl => url + '/edit';
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
  String toString() {
    return '''
  Venue $id:
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
  }

  static Venue findById(List<Venue> venues, int id) {
    try {
      return venues.firstWhere((v) => v.id == id, orElse: null);
    } catch (e) {
      return null;
    }
  }

  static Venue findByTitle(List<Venue> venues, String title) {
    try {
      final results = venues.where((v) => v.title == title).toList();
      results.sort((a, b) {
        return b.eventCount - a.eventCount;
      });
      return results.first;
    } catch (e) {
      return null;
    }
  }
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

/*
Example venue JSON:
  {
    "id": 82,
    "title": "Seed Coworking",
    "description": "",
    "address": "25 South Saint Clair Street, Toledo, OH 43604",
    "url": "http://seedcoworking.com/",
    "created_at": "2012-04-18T22:58:30.000-04:00",
    "updated_at": "2012-04-18T22:59:32.000-04:00",
    "street_address": "25 South Saint Clair Street",
    "locality": "Toledo",
    "region": "OH",
    "postal_code": "43604",
    "country": "US",
    "latitude": "41.6467",
    "longitude": "-83.5385",
    "email": "",
    "telephone": "",
    "source_id": null,
    "duplicate_of_id": null,
    "closed": false,
    "wifi": false,
    "access_notes": "",
    "events_count": 204
  },
  */
