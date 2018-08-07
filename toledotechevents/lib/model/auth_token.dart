import 'package:toledotechevents/model/venues.dart';

class NewEvent {
  NewEvent(String newEventPage) : value = _findToken(newEventPage);

  final String value;
}

String _findToken(String page) {
  if (page == null) return '';
  final search = 'name="authenticity_token" value="';
  final start = page.indexOf(search) + search.length;
  return page.substring(start, page.indexOf('"', start));
}

class EventFormData {
  String name, venueTitle, rsvpUrl, websiteUrl, description, venueDetails, tags;
  VenueListItem _tappedVenue;
  DateTime startTime, endTime;

  VenueListItem get tappedVenue => _tappedVenue;
  void set tappedVenue(VenueListItem value) {
    _tappedVenue = value;
    venueTitle = value?.title;
  }

  /// Validate relationships between [EventFormInput]s.
  ///
  /// Returns a list of error descriptions.
  List<String> validate() {
    final errors = List<String>();
    if (!(endTime?.isAfter(startTime) ?? false)) {
      errors.add('Event must end after it starts.');
    }
    return errors;
  }

  String toStringDeep() => '''
$name
$venueTitle
$rsvpUrl
$websiteUrl
$description
$venueDetails
$startTime
$endTime
$tags
$tappedVenue
''';
}

class EventFormInput {
  const EventFormInput._(this.label, this.validator);

  final String label;
  final String Function(dynamic value) validator;

  static final name = EventFormInput._(
      'Event name',
      (value) => (value == null || value.trim().length < 3)
          ? 'The event name is required.'
          : null);

  static final startTime = EventFormInput._(
      'Start time', (value) => value == null ? 'Invalid start time.' : null);

  static final endTime = EventFormInput._(
      'End time', (value) => value == null ? 'Invalid start time.' : null);

  static final rsvpRegister = EventFormInput._(
      'RSVP / Register URL',
      (value) => (value == null || Uri.tryParse(value.trim()) == null)
          ? 'Invalid URL'
          : null);

  static final website = EventFormInput._(
      'Website / More Info URL',
      (value) => (value == null || Uri.tryParse(value.trim()) == null)
          ? 'Invalid URL'
          : null);
}
