import 'dart:async';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../model.dart';
import '../theme.dart';
import '../util/datetime_picker_formfield.dart';
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
  String name, venue, rsvpUrl, websiteUrl, description, venueDetails, tags;
  // Venue venue;
  DateTime startTime, endTime;
  @override
  String toString() => '''
$name
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
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  final eventData = EventData();
  final format = DateFormat("MMMM d, yyyy 'at' h:mma");

  bool showVenueSuggestions = false;
  bool autovalidate = false;

  _showSnackBar(String text) {
    scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(text),
        duration: Duration(milliseconds: 2500),
      ),
    );
  }

  void _handleSubmitted() {
    final FormState form = formKey.currentState;
    if (!form.validate()) {
      autovalidate = true; // Start validating on every change.
      _showSnackBar('Please fix the errors in red before submitting.');
    } else {
      form.save();
      print(eventData);

      // var text;
      // if (formKey.currentState.validate()) {
      //   formKey.currentState.save();
      //   if (eventData.name == null || eventData.name.length < 3) {
      //     text = 'Event name is required.';
      //   }
      //   if (!(eventData.endTime?.isAfter(eventData.startTime) ?? false)) {
      //     text = 'Event must end after it starts.';
      //   }
      // } else {
      //   setState(() => autovalidate = true);
      //   text = 'Fix fields outlined in red.';
      // }
      // if (text != null) {
      //   _showSnackBar(text);
      // } else {
      //   print('posting event...');
      //   var url = "http://toledotechevents.org/events";
      //   http.post(url, body: {
      //     'utf8': '✓',
      //     'authenticity_token': widget.authToken,
      //     'event[title]': eventData.name,
      //     'venue_name': eventData.venue,
      //     'start_date': DateFormat('yyyy-MM-dd').format(eventData.startTime),
      //     'start_time': DateFormat('h:mm a').format(eventData.startTime),
      //     'end_date': DateFormat('yyyy-MM-dd').format(eventData.endTime),
      //     'end_time': DateFormat('h:mm a').format(eventData.endTime),
      //     'event[url]': eventData.websiteUrl,
      //     'event[rsvp_url]': eventData.rsvpUrl,
      //     'event[description]': eventData.description,
      //     'event[venue_details]': eventData.venueDetails,
      //     'event[tag_list]': eventData.tags,
      //   }).then((response) {
      //     print("Response status: ${response.statusCode}");
      //     print("Response body: ${response.body}");
      //     if (response.statusCode == 302) {
      //       var id = int.parse(
      //           response.body.split('.org/events/').last.split('"').first);
      //       _showSnackBar('Created event $id');
      //       getEvents(forceReload: true).then((events) {
      //         Event event = Event.findById(events, id);
      //         if (event != null) {
      //           Navigator.push(context, MaterialPageRoute(builder: (_) {
      //             return EventDetails(event);
      //           }));
      //         } else {
      //           print('Failed to get newly created event $id');
      //         }
      //       });
      //     }
      //   });
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      autovalidate: autovalidate,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ListView(
          children: <Widget>[
            Text('Add Event', style: Theme.of(context).textTheme.headline),
            SizedBox(height: 16.0),
            TextFormField(
              // controller: nameController,
              // autofocus: true,
              decoration: InputDecoration(labelText: 'Event name'),
              validator: (value) {
                if (value.trim().length < 3) {
                  return 'The event name is required.';
                }
              },
              // maxLines: null,
              onSaved: (value) => eventData.name = value.trim(),
            ),
            SizedBox(height: 8.0),
            TextFormField(
              // controller: venueController,
              decoration: InputDecoration(labelText: 'Venue'),
              onFieldSubmitted: (text) {
                showVenueSuggestions = false;
              },
              // maxLines: null,
              onSaved: (value) => eventData.venue = value.trim(),
            ),
            SizedBox(height: 8.0),
            DateTimePickerFormField(
              format: format,
              decoration: InputDecoration(labelText: 'Start time'),
              validator: (value) =>
                  value == null ? 'Invalid start time.' : null,
              onSaved: (value) => eventData.startTime = value,
            ),
            SizedBox(height: 8.0),
            DateTimePickerFormField(
              format: format,
              decoration: InputDecoration(labelText: 'End time'),
              validator: (value) => value == null ? 'Invalid end time.' : null,
              onSaved: (value) => eventData.endTime = value,
            ),
            SizedBox(height: 8.0),
            TextFormField(
              // controller: rsvpController,
              decoration: InputDecoration(labelText: 'RSVP / Register URL'),
              validator: (value) {
                try {
                  Uri.parse(value);
                } catch (e) {
                  return 'Invalid URL';
                }
              },
              onSaved: (value) => eventData.rsvpUrl = value,
            ),
            SizedBox(height: 8.0),
            TextFormField(
              // controller: websiteController,
              decoration: InputDecoration(labelText: 'Website / More Info URL'),
              validator: (value) {
                try {
                  Uri.parse(value);
                } catch (e) {
                  return 'Invalid URL';
                }
              },
              onSaved: (value) => eventData.websiteUrl = value,
            ),
            SizedBox(height: 8.0),
            TextFormField(
              // controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                helperText: 'Markdown and some HTML supported.',
              ),
              onSaved: (value) => eventData.description = value.trim(),
              maxLines: null,
            ),
            SizedBox(height: 8.0),
            TextFormField(
              // controller: venueDetailsController,
              decoration: InputDecoration(
                labelText: 'Venue Details',
                helperText: 'Event-specific details like the room number.',
              ),
              onSaved: (value) => eventData.venueDetails = value.trim(),
              maxLines: null,
            ),
            SizedBox(height: 8.0),
            TextFormField(
                // controller: tagsController,
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
    );
  }

  Future<List<Prediction>> autoCompleteVenue(String search,
      [int maxSuggestions = 3]) async {
    final predictions = List<Prediction>();
    final venues = await getVenues();
    Prediction p;
    if (search.length >= 3) {
      venues.forEach((venue) {
        p = Prediction(venue);
        if (venue.title == search)
          p.score += 100;
        else if (venue.title.startsWith(search))
          p.score += 50;
        else if (venue.title.contains(search)) p.score += 25;

        if (venue.address == search)
          p.score += 100;
        else if (venue.address.startsWith(search))
          p.score += 50;
        else if (venue.address.contains(search)) p.score += 25;

        predictions.add(p);
      });
    }
    predictions.sort();
    return predictions.take(maxSuggestions);
  }
}

class Prediction implements Comparable {
  final Venue venue;
  int score = 0;

  Prediction(this.venue);

  @override
  int compareTo(other) {
    return other.score.compareTo(score);
  }
}
