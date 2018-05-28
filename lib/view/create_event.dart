import 'dart:async';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../model.dart';
import '../theme.dart';
import '../util/datetime_picker_textfield.dart';
import 'event_details.dart';

class CreateEventForm extends StatefulWidget {
  final String authToken;
  CreateEventForm(this.authToken);

  @override
  _CreateEventFormState createState() {
    return _CreateEventFormState();
  }
}

class _FormData {
  String name, venue, rsvpUrl, websiteUrl, description, venueDetails;
  // Venue venue;
  DateTime startTime, endTime;
  List<String> tags;
}

class _CreateEventFormState extends State<CreateEventForm> {
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  final nameController = TextEditingController();
  final venueController = TextEditingController();
  final rsvpController = TextEditingController();
  final websiteController = TextEditingController();
  final descriptionController = TextEditingController();
  final venueDetailsController = TextEditingController();
  final tagsController = TextEditingController();

  final data = _FormData();

  bool showVenueSuggestions = false;
  bool autovalidate = false;

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
              controller: nameController,
              // autofocus: true,
              decoration: InputDecoration(labelText: 'Event name'),
              validator: (value) {
                if (value.trim().length < 3) {
                  return 'The event name is required.';
                }
              },
              // maxLines: null,
              onSaved: (value) => data.name = value.trim(),
            ),
            SizedBox(height: 8.0),
            TextFormField(
              controller: venueController,
              decoration: InputDecoration(labelText: 'Venue'),
              onFieldSubmitted: (text) {
                showVenueSuggestions = false;
              },
              // maxLines: null,
              onSaved: (value) => data.venue = value.trim(),
            ),
            SizedBox(height: 8.0),
            DateTimePickerTextFormField(
              labelText: 'Start time',
              errorText: 'Invalid start time.',
              onSaved: (value) => data.startTime = value,
            ),
            SizedBox(height: 8.0),
            DateTimePickerTextFormField(
              labelText: 'End time',
              errorText: 'Invalid end time.',
              onSaved: (value) => data.endTime = value,
            ),
            SizedBox(height: 8.0),
            TextFormField(
              controller: rsvpController,
              decoration: InputDecoration(labelText: 'RSVP / Register URL'),
              validator: (value) {
                try {
                  Uri.parse(value);
                } catch (e) {
                  return 'Invalid URL';
                }
              },
              onSaved: (value) => data.rsvpUrl = value,
            ),
            SizedBox(height: 8.0),
            TextFormField(
              controller: websiteController,
              decoration: InputDecoration(labelText: 'Website / More Info URL'),
              validator: (value) {
                try {
                  Uri.parse(value);
                } catch (e) {
                  return 'Invalid URL';
                }
              },
              onSaved: (value) => data.websiteUrl = value,
            ),
            SizedBox(height: 8.0),
            TextFormField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                helperText: 'Markdown and some HTML supported.',
              ),
              onSaved: (value) => data.description = value.trim(),
              maxLines: null,
            ),
            SizedBox(height: 8.0),
            TextFormField(
              controller: venueDetailsController,
              decoration: InputDecoration(
                labelText: 'Venue Details',
                helperText: 'Event-specific details like the room number.',
              ),
              onSaved: (value) => data.venueDetails = value.trim(),
              maxLines: null,
            ),
            SizedBox(height: 8.0),
            TextFormField(
                controller: tagsController,
                decoration: InputDecoration(
                  labelText: 'Tags',
                  helperText: 'Comma-separated keywords.',
                ),
                onSaved: (value) {
                  data.tags = value.split(',');
                  data.tags.forEach((tag) => tag = tag.trim());
                }),
            Center(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: PrimaryButton(
                  context,
                  'CREATE EVENT',
                  () {
                    var text;
                    if (formKey.currentState.validate()) {
                      formKey.currentState.save();
                      if (nameController.text.length < 3) {
                        text = 'Event name is required.';
                      }
                      if (!data.endTime.isAfter(data.startTime)) {
                        text = 'Event must end after it starts.';
                      }
                    } else {
                      setState(() => autovalidate = true);
                      text = 'Fix fields outlined in red.';
                    }
                    if (text != null) {
                      _showSnackBar(context, text);
                    } else {
                      print('posting event...');
                      var url = "http://toledotechevents.org/events";
                      http.post(url, body: {
                        'utf8': '✓',
                        'authenticity_token': widget.authToken,
                        'event[title]': nameController.text,
                        'venue_name': data.venue,
                        'start_date':
                            DateFormat('yyyy-MM-dd').format(data.startTime),
                        'start_time':
                            DateFormat('h:mm a').format(data.startTime),
                        'end_date':
                            DateFormat('yyyy-MM-dd').format(data.endTime),
                        'end_time': DateFormat('h:mm a').format(data.endTime),
                        'event[url]': data.websiteUrl,
                        'event[rsvp_url]': data.rsvpUrl,
                        'event[description]': data.description,
                        'event[venue_details]': data.venueDetails,
                        'event[tag_list]': data.tags.join(','),
                      }).then((response) {
                        print("Response status: ${response.statusCode}");
                        print("Response body: ${response.body}");
                        if (response.statusCode == 302) {
                          var id = int.parse(response.body
                              .split('.org/events/')
                              .last
                              .split('"')
                              .first);
                          _showSnackBar(context, 'Created event $id');
                          getEvents(forceReload: true).then((events) {
                            Event event = Event.findById(events, id);
                            if (event != null) {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (_) {
                                return EventDetails(event);
                              }));
                            } else {
                              print('Failed to get newly created event $id');
                            }
                          });
                        }
                      });
                    }
                  },
                  color: kPrimaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _showSnackBar(BuildContext context, String text) {
    Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text(text),
            duration: Duration(seconds: 3),
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
