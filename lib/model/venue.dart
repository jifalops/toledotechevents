/**
 * A ToledoTechEvents venue. See http://toledotechevents.org/venues.json.
 */
class Venue {
  final String title, description, address, url, email, phone, notes;
  final int id, eventCount, sourceId, duplicateOfId;
  final double latitude, longitude;
  final bool isClosed, hasWifi;
  final DateTime created, updated;
  Venue(Map v)
      : title = v['title'],
        description = v['description'],
        address = _getAddress(v['address'], v['street_address'], v['locality'],
            v['region'], v['postal_code']),
        url = v['url'],
        email = v['email'],
        phone = v['telephone'],
        notes = v['access_notes'],
        id = v['id'],
        eventCount = v['events_count'] ?? 0,
        sourceId = v['source_id'] ?? 0,
        duplicateOfId = v['duplicate_of_id'] ?? 0,
        latitude = double.parse(v['latitude'] ?? '0'),
        longitude = double.parse(v['longitude'] ?? '0'),
        isClosed = v['closed'],
        hasWifi = v['wifi'],
        created = DateTime.parse(v['created_at']),
        updated = DateTime.parse(v['updated_at']);

  String get iCalendarUrl => url + '.ics';
  String get subscribeUrl => iCalendarUrl.replaceAll('http', 'webcal');
  String get editUrl => url + '/edit';

  @override
  String toString() {
    return '''
  Venue $id:
  $title
  events: $eventCount
  $description
  $address
  $url
  $email
  $phone
  $notes
  $sourceId
  $duplicateOfId
  [$latitude, $longitude]
  created: $created
  updated: $updated
  Closed: $isClosed
  Wifi: $hasWifi
''';
  }
}

String _getAddress(full, addr, city, state, zip) {
  if (full == null || full.isEmpty) {
    full = '$addr, $city, $state $zip';
  }
  return full;
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
