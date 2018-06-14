import 'dart:async';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:simple_autocomplete_formfield/simple_autocomplete_formfield.dart';
import '../model.dart';
import '../theme.dart';
import 'event_details.dart';

class CreateEventForm extends StatefulWidget {
  final String authToken;
  CreateEventForm(this.authToken);

  @override
  _CreateEventFormState createState() {
    return _CreateEventFormState();
  }
}

class EventData {
  String name, venueTitle, rsvpUrl, websiteUrl, description, venueDetails, tags;
  Venue venue;
  DateTime startTime, endTime;
  @override
  String toString() => '''
$name
$venueTitle
$venue
$rsvpUrl
$websiteUrl
$description
$venueDetails
$startTime
$endTime
$tags
''';
}

class _CreateEventFormState extends State<CreateEventForm> {
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  final eventData = EventData();
  final format = DateFormat("MMMM d, yyyy 'at' h:mma");
  final venueController = TextEditingController();
  // final venuFocusNode = FocusNode();
  final startTimeController = TextEditingController();
  final endTimeController = TextEditingController();

  // bool showVenueSuggestions = false;
  bool autovalidate = false;
  List<Venue> venues;

  String venueHelperText;

  // _CreateEventFormState() {
  //   venueController.addListener(() {
  //     setState(
  //         () => showVenueSuggestions = venueController.text.trim().isNotEmpty);
  //   });
  //   venuFocusNode.addListener(() {
  //     if (!venuFocusNode.hasFocus) {
  //       setState(() => showVenueSuggestions = false);
  //     }
  //   });
  // }

  _showSnackBar(BuildContext context, String text) {
    Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text(text),
            duration: Duration(milliseconds: 3000),
          ),
        );
  }

  void _handleSubmitted() {
    final FormState form = formKey.currentState;
    if (!form.validate()) {
      autovalidate = true; // Start validating on every change.
      _showSnackBar(context, 'Please fix the errors in red before submitting.');
    } else {
      form.save();
      // print(eventData);

      var text;
      if (formKey.currentState.validate()) {
        formKey.currentState.save();
        if (eventData.name == null || eventData.name.length < 3) {
          text = 'Event name is required.';
        }
        if (!(eventData.endTime?.isAfter(eventData.startTime) ?? false)) {
          text = 'Event must end after it starts.';
        }
      } else {
        setState(() => autovalidate = true);
        text = 'Fix fields outlined in red.';
      }
      if (text != null) {
        _showSnackBar(context, text);
      } else {
        _postEvent();
      }
    }
  }

  void _postEvent() async {
    print('posting event...');
    final response =
        await http.post('http://toledotechevents.org/events', body: {
      'utf8': '✓',
      'authenticity_token': widget.authToken,
      'event[title]': eventData.name,
      'venue_name': eventData.venueTitle,
      'event[venue_id]': '${eventData.venue?.id ?? ''}',
      'start_date': DateFormat('yyyy-MM-dd').format(eventData.startTime),
      'start_time': DateFormat('h:mm a').format(eventData.startTime),
      'end_date': DateFormat('yyyy-MM-dd').format(eventData.endTime),
      'end_time': DateFormat('h:mm a').format(eventData.endTime),
      'event[url]': eventData.websiteUrl,
      'event[rsvp_url]': eventData.rsvpUrl,
      'event[description]': eventData.description,
      'event[venue_details]': eventData.venueDetails,
      'event[tag_list]': eventData.tags,
    });

    print("Response status: ${response?.statusCode}");
    // print("Response body: ${response?.body}");
    if (response?.statusCode == 302) {
      int id;
      try {
        id = int
            .parse(response.body.split('.org/events/').last.split('"').first);
      } catch (e) {
        try {
          id = int
              .parse(response.body.split('from_event=').last.split('"').first);
          // A venue was also created
          await getVenues(forceReload: true);
        } catch (e) {
          print('Failed to find new event.');
          _showSnackBar(context, 'Created new event.');
          final events = await getEvents(forceReload: true);
          // Navigator.push(context, MaterialPageRoute(builder: (_) {
          //   return EventList(events);
          // }));
        }
      }

      if (id != null) {
        _showSnackBar(context, 'Created event $id');
        final events = await getEvents(forceReload: true);
        final event = Event.findById(events, id);
        if (event != null) {
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return EventDetails(event);
          }));
        } else {
          // TODO events created in the past wont be available in the atom feed.
          // They could be constructed based on their ID but this is a rare
          // situation not currently supported
          print(
              'Failed to get newly created event $id. Is the event already over?');
          // Navigator.push(context, MaterialPageRoute(builder: (_) {
          //   return EventList(events);
          // }));
        }
      } else {}
    } else {
      _showSnackBar(context,
          'Problem submitting form. Please report this if it continues to happen');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      autovalidate: autovalidate,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: <Widget>[
              Text('Add Event', style: Theme.of(context).textTheme.headline),
              SizedBox(height: 16.0),
              TextFormField(
                // autofocus: true,
                decoration: InputDecoration(labelText: 'Event name'),
                validator: (value) {
                  if (value.trim().length < 3) {
                    return 'The event name is required.';
                  }
                },
                onSaved: (value) => eventData.name = value.trim(),
              ),
              SizedBox(height: 8.0),
              SimpleAutocompleteFormField<Venue>(
                // suggestionsContainerHeight: 156.0,
                maxSuggestions: 10,
                controller: venueController,
                decoration: InputDecoration(
                    labelText: 'Venue', helperText: venueHelperText),
                onChanged: (value) {
                  // print('venue changed');
                  setState(() {
                    venueHelperText = value?.address;
                    eventData.venue = value;
                  });
                },
                onSaved: (value) {
                  eventData.venue = value;
                  if (value == null)
                    eventData.venueTitle = venueController.text;
                  else
                    eventData.venueTitle = value.title;
                },
                itemBuilder: (context, venue) => Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text(venue.title,
                            style: TextStyle(fontWeight: FontWeight.w600)),
                        Text(
                          venue.address,
                          style: Theme.of(context).textTheme.caption,
                        ),
                        // Text('${venue.eventCount}'),
                      ],
                    ),
                itemParser: ItemParser<Venue>(
                  itemToString: (item) => item?.title ?? '',
                  itemFromString: (string) => Venue.findByTitle(venues, string),
                ),
                onSearch: (search) async {
                  // debugPrint('Sorting...');
                  search = search.toLowerCase().trim();
                  venues ??= await getVenues();
                  final results = List<Venue>();
                  results.addAll(venues.where((v) =>
                      v.title.toLowerCase().contains(search) ||
                      v.address.toLowerCase().contains(search)));
                  results.sort((a, b) {
                    int mostPopular(Venue a, Venue b) {
                      return b.eventCount - a.eventCount;
                    }

                    final aTitleStartsWith =
                        a.title.toLowerCase().startsWith(search);
                    final bTitleStartsWith =
                        b.title.toLowerCase().startsWith(search);
                    if (aTitleStartsWith && bTitleStartsWith)
                      return mostPopular(a, b);
                    else if (aTitleStartsWith)
                      return -1;
                    else if (bTitleStartsWith)
                      return 1;
                    else {
                      final aTitleContains =
                          a.title.toLowerCase().contains(search);
                      final bTitleContains =
                          b.title.toLowerCase().contains(search);
                      if (aTitleContains && bTitleContains)
                        return mostPopular(a, b);
                      else if (aTitleContains)
                        return -1;
                      else if (bTitleContains)
                        return 1;
                      else {
                        final aAddressContains =
                            a.address.toLowerCase().contains(search);
                        final bAddressContains =
                            b.address.toLowerCase().contains(search);
                        if (aAddressContains && bAddressContains)
                          return mostPopular(a, b);
                        else if (aAddressContains)
                          return -1;
                        else if (bAddressContains)
                          return 1;
                        else {
                          return mostPopular(a, b);
                        }
                      }
                    }
                  });
                  // results.take(3).forEach((venue) => debugPrint(venue.title));
                  return results;
                },
              ),
              SizedBox(height: 8.0),
              DateTimePickerFormField(
                controller: startTimeController,
                format: format,
                decoration: InputDecoration(labelText: 'Start time'),
                validator: (value) {
                  return value == null ? 'Invalid start time.' : null;
                },
                onSaved: (value) => eventData.startTime = value,
                onChanged: (value) {
                  if (value != null && endTimeController.text.isEmpty) {
                    endTimeController.text =
                        format.format(value.add(Duration(hours: 1)));
                  }
                },
              ),
              SizedBox(height: 8.0),
              DateTimePickerFormField(
                controller: endTimeController,
                format: format,
                decoration: InputDecoration(labelText: 'End time'),
                validator: (value) =>
                    value == null ? 'Invalid end time.' : null,
                onSaved: (value) => eventData.endTime = value,
                onChanged: (value) {
                  if (value != null && startTimeController.text.isEmpty) {
                    startTimeController.text =
                        format.format(value.subtract(Duration(hours: 1)));
                  }
                },
              ),
              SizedBox(height: 8.0),
              TextFormField(
                decoration: InputDecoration(labelText: 'RSVP / Register URL'),
                validator: (value) {
                  try {
                    Uri.parse(value);
                  } catch (e) {
                    return 'Invalid URL';
                  }
                },
                onSaved: (value) => eventData.rsvpUrl = value.toLowerCase(),
              ),
              SizedBox(height: 8.0),
              TextFormField(
                decoration:
                    InputDecoration(labelText: 'Website / More Info URL'),
                validator: (value) {
                  try {
                    Uri.parse(value);
                  } catch (e) {
                    return 'Invalid URL';
                  }
                },
                onSaved: (value) => eventData.websiteUrl = value.toLowerCase(),
              ),
              SizedBox(height: 8.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Description',
                  helperText: 'Markdown and some HTML supported.',
                ),
                onSaved: (value) => eventData.description = value.trim(),
                maxLines: null,
              ),
              SizedBox(height: 8.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Venue Details',
                  helperText: 'Event-specific details like the room number.',
                ),
                onSaved: (value) => eventData.venueDetails = value.trim(),
                maxLines: null,
              ),
              SizedBox(height: 8.0),
              TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Tags',
                    helperText: 'Comma-separated keywords.',
                  ),
                  onSaved: (value) {
                    eventData.tags = value;
                  }),
              Center(
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: PrimaryButton(
                    context,
                    'CREATE EVENT',
                    _handleSubmitted,
                    color: kPrimaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
