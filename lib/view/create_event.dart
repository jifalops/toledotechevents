import 'dart:async';
import 'dart:core';
import 'package:flutter/material.dart';
import '../model.dart';

String _authToken;

class CreateEventForm extends StatefulWidget {
  CreateEventForm(String authToken) {
    _authToken = authToken;
  }

  @override
  _CreateEventFormState createState() {
    return _CreateEventFormState();
  }
}

class _CreateEventFormState extends State<CreateEventForm> {
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  final nameController = TextEditingController();
  final venueController = TextEditingController();
  final startTimeController = TextEditingController();
  final endTimeController = TextEditingController();
  final rsvpController = TextEditingController();
  final websiteController = TextEditingController();
  final descriptionController = TextEditingController();
  final venueDetailsController = TextEditingController();
  final tagsController = TextEditingController();

  final startTimeFocus = FocusNode();
  final endTimeFocus = FocusNode();

  bool showVenueSuggestions = false;

  @override
  void initState() {
    super.initState();
    startTimeFocus.addListener(startTimeChanged);
    endTimeFocus.addListener(endTimeChanged);
    startTimeController.addListener(startTimeChanged);
    endTimeController.addListener(endTimeChanged);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
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
                if (value.isEmpty) {
                  return 'The event name is required.';
                }
              },
            ),
            SizedBox(height: 8.0),
            TextFormField(
                controller: venueController,
                decoration: InputDecoration(labelText: 'Venue'),
                onFieldSubmitted: (text) {
                  showVenueSuggestions = false;
                }),
            SizedBox(height: 8.0),
            TextFormField(
              controller: startTimeController,
              decoration: InputDecoration(
                labelText: 'Start time',
                suffixIcon:
                    // startTimeController.text.isEmpty
                    //     ? NullWidget()
                    //     :
                    IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    startTimeFocus.unfocus();
                    startTimeController.clear();
                  },
                ),
              ),
              focusNode: startTimeFocus,
            ),
            SizedBox(height: 8.0),
            TextFormField(
              controller: endTimeController,
              decoration: InputDecoration(
                labelText: 'End time',
                suffixIcon:
                    // endTimeController.text.isEmpty
                    //     ? NullWidget()
                    //     :
                    IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    endTimeFocus.unfocus();
                    endTimeController.clear();
                  },
                ),
              ),
              focusNode: endTimeFocus,
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
              autovalidate: true,
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
              autovalidate: true,
            ),
            SizedBox(height: 8.0),
            TextFormField(
              controller: descriptionController,
              decoration: InputDecoration(
                  labelText: 'Description',
                  helperText: 'Markdown and some HTML supported.'),
            ),
            SizedBox(height: 8.0),
            TextFormField(
              controller: venueDetailsController,
              decoration: InputDecoration(
                  labelText: 'Venue Details',
                  helperText:
                      'Event-specific details like the room number.'),
            ),
            SizedBox(height: 8.0),
            TextFormField(
              controller: tagsController,
              decoration: InputDecoration(
                  labelText: 'Tags',
                  helperText:
                      'Comma-separated keywords.'),
            ),
          ],
        ),
      ),
    );
  }

  void startTimeChanged() {
    if (startTimeController.text.isEmpty && startTimeFocus.hasFocus) {
      getDateTimeInput(context).then((date) {
        startTimeFocus.unfocus();
        startTimeController.text = formatDateTime(date);
      });
    }
  }

  void endTimeChanged() {
    if (endTimeController.text.isEmpty && endTimeFocus.hasFocus) {
      getDateTimeInput(context).then((date) {
        endTimeFocus.unfocus();
        endTimeController.text = formatDateTime(date);
      });
    }
  }

  Future<DateTime> getDateTimeInput(BuildContext context) async {
    final now = DateTime.now();
    var date = await showDatePicker(
        context: context,
        firstDate: now.subtract(Duration(days: 365)),
        lastDate: now.add(Duration(days: 365 * 2)),
        initialDate: now);
    if (date != null) {
      date = startOfDay(date);
      print('date: $date');
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: 12, minute: 0),
      );
      print('selected time: $time');
      if (time != null) {
        date = date.add(Duration(hours: time.hour, minutes: time.minute));
        print('date: $date');
      }
    }
    return date;
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
