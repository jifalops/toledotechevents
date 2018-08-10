import 'package:intl/intl.dart';
import 'package:toledotechevents/util/form.dart';

final eventForm = EventForm._();

class EventInput {
  static final name = TrimmedStringInput(
    label: ([_]) => 'Event name',
    validator: (value) => (value == null || value.trim().length < 3)
        ? 'The event name is required.'
        : null,
  );

  static final venue = TrimmedStringInput(
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

  static final rsvp = TrimmedStringInput(
    label: ([_]) => 'RSVP / register URL',
    validator: (value) => (value == null || Uri.tryParse(value.trim()) == null)
        ? 'Invalid URL'
        : null,
  );

  static final website = TrimmedStringInput(
    label: ([_]) => 'Website / more Info URL',
    validator: (value) => (value == null || Uri.tryParse(value.trim()) == null)
        ? 'Invalid URL'
        : null,
  );

  static final description = TrimmedStringInput(
    label: ([_]) => 'Description',
    helperText: ([_]) => 'Markdown and some HTML supported.',
  );

  static final venueDetails = TrimmedStringInput(
    label: ([_]) => 'Venue details',
    helperText: ([_]) => 'Event-specific details like the room number.',
  );

  static final tags = TrimmedStringInput(
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

  @override
  void submit() {
    // TODO: implement submit
  }

  // void _postEvent() async {
  //   print('posting event...');
  //   final response =
  //       await http.post('http://toledotechevents.org/events', body: {
  //     'utf8': '✓',
  //     'authenticity_token': widget.authToken,
  //     'event[title]': eventData.name,
  //     'venue_name': eventData.venueTitle,
  //     'event[venue_id]': '${eventData.venue?.id ?? ''}',
  //     'start_date': DateFormat('yyyy-MM-dd').format(eventData.startTime),
  //     'start_time': DateFormat('h:mm a').format(eventData.startTime),
  //     'end_date': DateFormat('yyyy-MM-dd').format(eventData.endTime),
  //     'end_time': DateFormat('h:mm a').format(eventData.endTime),
  //     'event[url]': eventData.websiteUrl,
  //     'event[rsvp_url]': eventData.rsvpUrl,
  //     'event[description]': eventData.description,
  //     'event[venue_details]': eventData.venueDetails,
  //     'event[tag_list]': eventData.tags,
  //   });

  //   print("Response status: ${response?.statusCode}");
  //   // print("Response body: ${response?.body}");
  //   if (response?.statusCode == 302) {
  //     int id;
  //     try {
  //       id = int.parse(
  //           response.body.split('.org/events/').last.split('"').first);
  //     } catch (e) {
  //       try {
  //         id = int.parse(
  //             response.body.split('from_event=').last.split('"').first);
  //         // A venue was also created
  //         await getVenues(forceReload: true);
  //       } catch (e) {
  //         print('Failed to find new event.');
  //         _showSnackBar(context, 'Created new event.');
  //         final events = await getEvents(forceReload: true);
  //         // Navigator.push(context, MaterialPageRoute(builder: (_) {
  //         //   return EventList(events);
  //         // }));
  //       }
  //     }

  //     if (id != null) {
  //       _showSnackBar(context, 'Created event $id');
  //       final events = await getEvents(forceReload: true);
  //       final event = Event.findById(events, id);
  //       if (event != null) {
  //         Navigator.push(context, MaterialPageRoute(builder: (_) {
  //           return EventDetails(event);
  //         }));
  //       } else {
  //         // TODO events created in the past wont be available in the atom feed.
  //         // They could be constructed based on their ID but this is a rare
  //         // situation not currently supported
  //         print(
  //             'Failed to get newly created event $id. Is the event already over?');
  //         // Navigator.push(context, MaterialPageRoute(builder: (_) {
  //         //   return EventList(events);
  //         // }));
  //       }
  //     } else {}
  //   } else {
  //     _showSnackBar(context,
  //         'Problem submitting form. Please report this if it continues to happen');
  //   }
  // }

}
