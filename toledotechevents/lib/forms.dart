import 'package:toledotechevents/util/form.dart';

final eventForm = EventForm._();

class EventForm extends Form {
  EventForm._() : super(EventFormInput.values);

  @override
  List<String> validate() {
    final errors = super.validate();
    if (errors.isEmpty) {
      DateTime startTime = getValue(EventFormInput.startTime);
      DateTime endTime = getValue(EventFormInput.endTime);
      if (!endTime.isAfter(startTime)) {
        errors.add('Event must end after it starts.');
      }
    }
    return errors;
  }
}

class EventFormInput<T> extends FormInput<T> {
  EventFormInput._(FormInput<T> input) : super.clone(input);

  static final name = EventFormInput._(FormInput<String>(
    label: 'Event name',
    validator: (value) => (value == null || value.trim().length < 3)
        ? 'The event name is required.'
        : null,
  ));

  static final venue = EventFormInput._(FormInput<String>(label: 'Venue'));

  static final startTime = EventFormInput._(FormInput<DateTime>(
    label: 'Start time',
    validator: (value) => value == null ? 'Invalid start time.' : null,
  ));

  static final endTime = EventFormInput._(FormInput<DateTime>(
    label: 'End time',
    validator: (value) => value == null ? 'Invalid end time.' : null,
  ));

  static final rsvp = EventFormInput._(FormInput<String>(
    label: 'RSVP / register URL',
    validator: (value) => (value == null || Uri.tryParse(value.trim()) == null)
        ? 'Invalid URL'
        : null,
  ));

  static final website = EventFormInput._(FormInput<String>(
    label: 'Website / more Info URL',
    validator: (value) => (value == null || Uri.tryParse(value.trim()) == null)
        ? 'Invalid URL'
        : null,
  ));

  static final description = EventFormInput._(FormInput<String>(
    label: 'Description',
    helperText: 'Markdown and some HTML supported.',
  ));

  static final venueDetails = EventFormInput._(FormInput<String>(
    label: 'Venue details',
    helperText: 'Event-specific details like the room number.',
  ));

  static final tags = EventFormInput._(FormInput<String>(
    label: 'Tags',
    helperText: 'Comma-separated keywords.',
  ));

  static final authToken = EventFormInput._(FormInput<String>(hidden: true));

  static final values = <EventFormInput>[
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
