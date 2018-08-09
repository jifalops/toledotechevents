import 'package:intl/intl.dart';
import 'package:toledotechevents/util/form.dart';

final eventForm = EventForm._();

class EventInput {
  static final name = TrimmingFormInput(
    label: ([_]) => 'Event name',
    validator: (value) => (value == null || value.trim().length < 3)
        ? 'The event name is required.'
        : null,
  );

  static final venue = TrimmingFormInput(
    label: ([_]) => 'Venue',
    helperText: ([address]) => address,
  );

  static final startTime = FormInput<DateTime>(
    label: ([_]) => 'Start time',
    validator: (value) => value == null ? 'Invalid start time.' : null,
    onChanged: (value) {
      if (value != null && EventInput.endTime.value == null) {
        EventInput.endTime.value = value.add(Duration(hours: 1));
      }
    },
  );

  static final endTime = FormInput<DateTime>(
    label: ([_]) => 'End time',
    validator: (value) => value == null
        ? 'Invalid end time.'
        : (EventInput.startTime.value != null
            ? (EventInput.startTime.value.isBefore(value)
                ? null
                : 'Event must end after it starts.')
            : null),
    onChanged: (value) {
      if (value != null && EventInput.startTime.value == null) {
        EventInput.startTime.value = value.subtract(Duration(hours: 1));
      }
    },
  );

  static final rsvp = TrimmingFormInput(
    label: ([_]) => 'RSVP / register URL',
    validator: (value) => (value == null || Uri.tryParse(value.trim()) == null)
        ? 'Invalid URL'
        : null,
  );

  static final website = TrimmingFormInput(
    label: ([_]) => 'Website / more Info URL',
    validator: (value) => (value == null || Uri.tryParse(value.trim()) == null)
        ? 'Invalid URL'
        : null,
  );

  static final description = TrimmingFormInput(
    label: ([_]) => 'Description',
    helperText: ([_]) => 'Markdown and some HTML supported.',
  );

  static final venueDetails = TrimmingFormInput(
    label: ([_]) => 'Venue details',
    helperText: ([_]) => 'Event-specific details like the room number.',
  );

  static final tags = TrimmingFormInput(
    label: ([_]) => 'Tags',
    helperText: ([_]) => 'Comma-separated keywords.',
  );

  static final authToken = FormInput<String>(hidden: true);

  static final values = <FormInput>[
    name,
    venue,
    startTime,
    endTime,
    rsvp,
    website,
    description,
    venueDetails,
    tags,
    authToken
  ];
}

class EventForm extends Form {
  EventForm._() : super(EventInput.values);

  static final date = DateFormat("MMMM d, yyyy 'at' h:mma");
  static final serverDate = DateFormat('yyyy-MM-dd');
  static final serverTime = DateFormat('h:mm a');

  //   final response =
  //     await http.post('http://toledotechevents.org/events', body: {
  //   'utf8': '✓',
  //   'authenticity_token': widget.authToken,
  //   'event[title]': eventData.name,
  //   'venue_name': eventData.venueTitle,
  //   'event[venue_id]': '${eventData.venue?.id ?? ''}',
  //   'start_date': DateFormat('yyyy-MM-dd').format(eventData.startTime),
  //   'start_time': DateFormat('h:mm a').format(eventData.startTime),
  //   'end_date': DateFormat('yyyy-MM-dd').format(eventData.endTime),
  //   'end_time': DateFormat('h:mm a').format(eventData.endTime),
  //   'event[url]': eventData.websiteUrl,
  //   'event[rsvp_url]': eventData.rsvpUrl,
  //   'event[description]': eventData.description,
  //   'event[venue_details]': eventData.venueDetails,
  //   'event[tag_list]': eventData.tags,
  // });

}
