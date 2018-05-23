import 'package:flutter_html_view/flutter_html_view.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../model.dart';
import '../theme.dart';

class EventDetails extends StatelessWidget {
  final Event event;

  EventDetails(this.event);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Event details'),
      ),
      body: ListView(
        children: <Widget>[
          Card(
            key: Key('${event.id}'),
            elevation: 16.0,
            child: Column(
              children: <Widget>[
                Text(
                  event.title,
                  style: Theme.of(context).textTheme.title,
                ),
                _formatDateTime(event, context),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  direction: Axis.horizontal,
                  children: _buildTags(),
                ),
                Text('Venue', style: Theme.of(context).textTheme.subhead),
                Card(
                  child: FutureBuilder<List<Venue>>(
                    future: getVenues(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return _buildVenueInfo(snapshot.data);
                      } else if (snapshot.hasError) {
                        return new Text('${snapshot.error}');
                      }
                      return _buildEventVenue();
                    },
                  ),
                ),
                HtmlView(data: event.descriptionHtml),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVenueInfo(List<Venue> venues) {
    Venue venue;
    venues.forEach((v) {
      if (v.id == event.venue.id) {
        venue = v;
        return;
      }
    });
    if (venue != null) {
      return Column(
        children: <Widget>[
          Text(venue.title),
          Text(venue.address),
          venue.hasWifi
              ? Row(
                  children: <Widget>[
                    Icon(Icons.wifi, color: kSecondaryColor),
                    Text('Public WiFi')
                  ],
                )
              : Container(),
          HtmlView(data: '<a href="${venue.mapUrl}">Map</a>'),
          Text(venue.description),
        ],
      );
    } else {
      return _buildEventVenue();
    }
  }

  Widget _buildEventVenue() {
    if (event.venue != null) {
      return Column(
        children: <Widget>[
          Text(event.venue.title),
          Text(event.venue.address),
          HtmlView(data: '<a href="${event.venue.mapUrl}">Map</a>'),
        ],
      );
    } else {
      return Text('Venue TBD');
    }
  }

  List<Widget> _buildTags() {
    var chips = List<Widget>();
    event.tags?.forEach((tag) => chips.add(GestureDetector(
          onTap: () => launch(getTagUrl(tag)),
          child: Chip(
            label: Text(tag),
          ),
        )));
    return chips;
  }
}

Widget _formatDateTime(Event event, BuildContext context) {
  final isOneDay = _isToday(event, event.startTime);
  final startDate =
      '${_formatDay(event.startTime)}, ${_formatDate(event.startTime)}';
  final startTime = _formatTime(event.startTime, !isOneDay);
  final endTime = _formatTime(event.endTime, true);

  return isOneDay
      ? Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(startDate),
            Text('$startTime – $endTime',
                style:
                    Theme.of(context).textTheme.caption.copyWith(height: 1.15)),
          ],
        )
      : Column(
          children: <Widget>[
            Row(children: <Widget>[
              Text('$startDate'),
              Text('$startTime –'),
            ]),
            Row(
              children: <Widget>[
                Text(_formatDate(event.endTime)),
                Text('$endTime'),
              ],
            ),
          ],
        );
}

String _formatDay(DateTime dt) => DateFormat('EEEE').format(dt);
String _formatDate(DateTime dt) => DateFormat('MMMM d').format(dt);
String _formatTime(DateTime dt, [bool ampm = false]) =>
    DateFormat('h:mm' + (ampm ? 'a' : '')).format(dt);

bool _isToday(Event e, DateTime now) {
  var min = _beginningOfDay(now);
  var max = _beginningOfDay(now.add(Duration(days: 1)));
  return e.endTime.isAfter(min) && e.startTime.isBefore(max);
}

bool _isTomorrow(Event e, DateTime now) {
  var min = _beginningOfDay(now.add(Duration(days: 1)));
  var max = _beginningOfDay(now.add(Duration(days: 2)));
  return e.endTime.isAfter(min) && e.startTime.isBefore(max);
}

bool _isNextTwoWeeks(Event e, DateTime now) {
  var min = _beginningOfDay(now.add(Duration(days: 2)));
  var max = _beginningOfDay(now.add(Duration(days: 15)));
  return e.endTime.isAfter(min) && e.startTime.isBefore(max);
}

bool _isAfterTwoWeeks(Event e, DateTime now) {
  var min = _beginningOfDay(now.add(Duration(days: 15)));
  return e.endTime.isAfter(min);
}

DateTime _beginningOfDay(DateTime dt) => dt
    .subtract(Duration(hours: dt.hour))
    .subtract(Duration(minutes: dt.minute))
    .subtract(Duration(seconds: dt.second))
    .subtract(Duration(milliseconds: dt.millisecond));
