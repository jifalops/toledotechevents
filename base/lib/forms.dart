import 'dart:async';
import 'package:meta/meta.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:toledotechevents/build_config.dart';
import 'package:toledotechevents/util/form.dart';
import 'package:toledotechevents/resources.dart';

class EventForm extends DynamicForm {
  EventForm() {
    // Inputs that affect one another cannot be `final` unless they are `static`.
    // However, making them static makes their value static as well, which
    // should be avoided.

    inputs.addAll([
      name,
      venue,
      _startTime = FormInput<DateTime>(
        label: ([_]) => 'Start time',
        validator: (value) => value == null ? 'Invalid start time.' : null,
        onChanged: (value) {
          if (value != null && endTime.value == null) {
            endTime.value = value.add(Duration(hours: 1));
          }
        },
      ),
      _endTime = FormInput<DateTime>(
        label: ([_]) => 'End time',
        validator: (value) => value == null
            ? 'Invalid end time.'
            : (startTime.value != null
                ? (startTime.value.isBefore(value)
                    ? null
                    : 'Event must end after it starts.')
                : null),
        onChanged: (value) {
          if (value != null && startTime.value == null) {
            startTime.value = value.subtract(Duration(hours: 1));
          }
        },
      ),
      rsvp,
      website,
      description,
      venueDetails,
      tags,
      authToken
    ]);
  }

  final name = TrimmedStringInput(
    label: ([_]) => 'Event name',
    validator: (value) => (value == null || value.trim().length < 3)
        ? 'The event name is required.'
        : null,
  );

  final venue = TrimmedStringInput(
    label: ([_]) => 'Venue',
    helperText: ([address]) => address,
  );

  FormInput<DateTime> _startTime;
  FormInput<DateTime> get startTime => _startTime;

  FormInput<DateTime> _endTime;
  FormInput<DateTime> get endTime => _endTime;

  final rsvp = TrimmedStringInput(
    label: ([_]) => 'RSVP / register URL',
    validator: (value) => (value == null || Uri.tryParse(value.trim()) == null)
        ? 'Invalid URL'
        : null,
  );

  final website = TrimmedStringInput(
    label: ([_]) => 'Website / more Info URL',
    validator: (value) => (value == null || Uri.tryParse(value.trim()) == null)
        ? 'Invalid URL'
        : null,
  );

  final description = TrimmedStringInput(
    label: ([_]) => 'Description',
    helperText: ([_]) => 'Markdown and some HTML supported.',
  );

  final venueDetails = TrimmedStringInput(
    label: ([_]) => 'Venue details',
    helperText: ([_]) => 'Event-specific details like the room number.',
  );

  final tags = TrimmedStringInput(
    label: ([_]) => 'Tags',
    helperText: ([_]) => 'Comma-separated keywords.',
  );

  final authToken = TrimmedStringInput(hidden: true);

  static final date = DateFormat("MMMM d, yyyy 'at' h:mma");
  static final serverDate = DateFormat('yyyy-MM-dd');
  static final serverTime = DateFormat('h:mm a');

  @override
  Future<EventFormResult> submit(
      {@required int venueId,
      @required NetworkResource<EventList> eventsResource,
      @required NetworkResource<VenueList> venuesResource}) async {
    print('posting event...');
    final response = await http.post(config.urls.eventFormAction, body: {
      'utf8': '✓',
      'authenticity_token': authToken.value,
      'event[title]': name.value,
      'venue_name': venue.value,
      'event[venue_id]': '${venueId ?? ''}',
      'start_date': serverDate.format(startTime.value),
      'start_time': serverTime.format(startTime.value),
      'end_date': serverDate.format(endTime.value),
      'end_time': serverTime.format(endTime.value),
      'event[url]': website.value,
      'event[rsvp_url]': rsvp.value,
      'event[description]': description.value,
      'event[venue_details]': venueDetails.value,
      'event[tag_list]': tags.value,
    });

    print("Response status: ${response?.statusCode}");
    // print("Response body: ${response?.body}");
    if (response?.statusCode == 302) {
      int id;
      try {
        id = int.parse(
            response.body.split('.org/events/').last.split('"').first);
      } catch (e) {
        try {
          id = int.parse(
              response.body.split('from_event=').last.split('"').first);
          // A venue was also created
          await venuesResource.get(forceReload: true);
        } catch (e) {
          print('Event created but failed to parse response.');
          eventsResource.get(forceReload: true);
        }
      }

      if (id != null) {
        final events = await eventsResource.get(forceReload: true);
        final event = events.findById(id);
        if (event != null) {
          return EventFormResult(
              message: 'Created new event',
              events: events,
              created: true,
              id: id,
              foundInFeed: true);
        } else {
          // TODO events created in the past wont be available in the atom feed.
          // They could be constructed based on their ID but this is not
          // currently supported
          print(
              'Failed to get newly created event $id. Is the event already over?');
          return EventFormResult(
              message: 'Created new event',
              events: events,
              created: true,
              id: id,
              foundInFeed: false);
        }
      } else {
        return EventFormResult(
            message: 'Created new event',
            created: true,
            id: -1,
            foundInFeed: false);
      }
    } else {
      return EventFormResult(
          message: 'Problem submitting form.',
          created: false,
          id: -1,
          foundInFeed: false);
    }
  }
}

class EventFormResult {
  EventFormResult(
      {@required this.message,
      @required this.created,
      @required this.id,
      @required this.foundInFeed,
      this.events});
  final EventList events;
  final String message;
  final bool created;
  final int id;
  final bool foundInFeed;
}
