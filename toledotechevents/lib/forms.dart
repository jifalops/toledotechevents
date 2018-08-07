import 'package:toledotechevents/util/form.dart';

// class EventFormData {
//   String name, venueTitle, rsvpUrl, websiteUrl, description, venueDetails, tags;
//   VenueListItem _tappedVenue;
//   DateTime startTime, endTime;

//   VenueListItem get tappedVenue => _tappedVenue;
//   void set tappedVenue(VenueListItem value) {
//     _tappedVenue = value;
//     venueTitle = value?.title;
//   }

//   /// Validate relationships between [EventFormInput]s.
//   ///
//   /// Returns a list of error descriptions.
//   List<String> validate() {
//     final errors = List<String>();
//     if (!(endTime?.isAfter(startTime) ?? false)) {
//       errors.add('Event must end after it starts.');
//     }
//     return errors;
//   }

//   String toStringDeep() => '''
// $name
// $venueTitle
// $rsvpUrl
// $websiteUrl
// $description
// $venueDetails
// $startTime
// $endTime
// $tags
// $tappedVenue
// ''';
// }

// class EventFormInput2 {
//   const EventFormInput2._(this.label, this.validator);

//   final String label;
//   final String Function(dynamic value) validator;

//   static final name = EventFormInput._(
//       '',
//

//   static final startTime = EventFormInput._(
//       'Start time', (value) => value == null ? 'Invalid start time.' : null);

//   static final endTime = EventFormInput._(
//       'End time', (value) => value == null ? 'Invalid start time.' : null);

//   static final rsvpRegister = EventFormInput._(
//       'RSVP / Register URL',
//       (value) => (value == null || Uri.tryParse(value.trim()) == null)
//           ? 'Invalid URL'
//           : null);

//   static final website = EventFormInput._(
//       'Website / More Info URL',
//       (value) => (value == null || Uri.tryParse(value.trim()) == null)
//           ? 'Invalid URL'
//           : null);
// }

class EventFormInput<T> {
  const EventFormInput._(this.name, this.input);
  // final String name;
  final FormInput<T> input;

  static final name = EventFormInput._('name',
  FormInput<String>(label: 'Event name',
   validator: (value) => (value == null || value.trim().length < 3)
          ? 'The event name is required.'
          : null)));
}
enum X {}

final eventForm = Form(UnmodifiableListView(X.val));
