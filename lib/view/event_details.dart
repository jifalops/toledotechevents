import 'package:flutter_html_view/flutter_html_view.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../model.dart';
import '../theme.dart';
import 'venue_details.dart';

class EventDetails extends StatelessWidget {
  final Event event;
  EventDetails(this.event);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Hero(
          tag: 'event-${event.id}',
          child: Card(
            elevation: 0.0,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 16.0, bottom: 24.0),
                    child: Center(
                      child: Hero(
                        tag: 'event-title-${event.id}',
                        child: Text(
                          event.title,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.title,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    // child: Hero(
                    // tag: 'event-times-${event.id}',
                    child: _buildEventTimeRange(context),
                    // ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Add to calendar: '),
                        Row(
                          children: [
                            SecondaryButton(
                              context,
                              'ICAL',
                              () => launch(event.iCalendarUrl),
                            ),
                            SizedBox(width: 8.0),
                            SecondaryButton(
                              context,
                              'GOOGLE',
                              () => _launchGoogleCalendarUrl(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  FutureBuilder<Widget>(
                    future: _buildRsvpWidget(context),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return snapshot.data;
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }
                      return NullWidget();
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child:
                        // Text('Venue', style: Theme.of(context).textTheme.subhead),
                        event.venue != null
                            ? FutureBuilder<List<Venue>>(
                                future: getVenues(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return _buildVenue(snapshot.data, context);
                                  } else if (snapshot.hasError) {
                                    return Text('${snapshot.error}');
                                  }
                                  return _buildEventVenue(context);
                                },
                              )
                            : Text(
                                'Venue TBD',
                                style: Theme.of(context).textTheme.subhead,
                              ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      direction: Axis.horizontal,
                      children: _buildTags(),
                    ),
                  ),
                  HtmlView(data: event.descriptionHtml),
                  event.links.length > 0
                      ? HtmlView(
                          data:
                              '<a href="${event.links.first.url}">More information</a>')
                      : NullWidget()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      // leading: IconButton(
      //   icon: Icon(Icons.close),
      //   onPressed: () => Navigator.pop(context),
      // ),
      title: Text('Event details'),
      actions: <Widget>[
        // overflow menu
        PopupMenuButton(
          icon: Icon(Icons.more_vert),
          onSelected: (String url) {
            if (url == 'delete')
              event.delete(context);
            else
              launch(url);
          },
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                child: Text('Edit this event'),
                value: event.editUrl,
              ),
              PopupMenuItem(
                child: Text('Clone this event'),
                value: event.cloneUrl,
              ),
              // PopupMenuItem(
              //   child: Text('Delete this event'),
              //   value: 'delete',
              // ),
            ];
          },
        ),
      ],
    );
  }

  void _launchGoogleCalendarUrl() async {
    var url = await event.googleCalendarUrl ?? '';
    if (url.isNotEmpty) launch(url);
  }

  Future<Widget> _buildRsvpWidget(BuildContext context) async {
    var url = await event.rsvpUrl ?? '';
    return url.isEmpty
        ? NullWidget()
        : Padding(
            padding: EdgeInsets.only(top: 16.0, bottom: 8.0),
            child: Center(
              child:
                  PrimaryButton(context, 'RSVP / REGISTER', () => launch(url)),
            ),
          );
  }

  Widget _buildVenue(List<Venue> venues, BuildContext context) {
    Venue venue = Venue.findById(venues, event.venue.id);
    if (venue != null) {
      return Hero(
        tag: 'venue-${venue.id}',
        child: Card(
          elevation: 0.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Hero(
                tag: 'event-venue-title-${event.id}',
                child: Hero(
                  tag: 'venue-title-${venue.id}',
                  child: Text(venue.title,
                      style: Theme.of(context).textTheme.body2),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(8.0, 8.0, 4.0, 4.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Hero(
                              tag: 'venue-street-${venue.id}',
                              child: Text(venue.street)),
                          Hero(
                              tag: 'venue-city-${venue.id}',
                              child: Text(
                                  '${venue.city}, ${venue.state} ${venue.zip}')),
                        ],
                      ),
                    ),
                    Hero(
                      tag: 'venue-map-${venue.id}',
                      child: SecondaryButton(
                        context,
                        'MAP',
                        () => launch(venue.mapUrl),
                      ),
                    ),
                  ],
                ),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                (venue.hasWifi
                    ? Hero(
                        tag: 'venue-wifi-${venue.id}',
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.wifi, color: kSecondaryColor),
                            Text(' Public WiFi')
                          ],
                        ),
                      )
                    : NullWidget()),
                // SizedBox(width: 16.0),
                TertiaryButton(
                  'VENUE DETAILS',
                  () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => VenueDetails(venue))),
                ),
              ])
            ],
          ),
        ),
      );
    } else {
      return NullWidget(); // _buildEventVenue(context);
    }
  }

  Widget _buildEventVenue(BuildContext context) {
    if (event.venue != null && event.venue.id > 0) {
      return Hero(
        tag: 'venue-${event.venue.id}',
        child: Card(
          elevation: 0.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Hero(
                tag: 'event-venue-title-${event.id}',
                child: Hero(
                  tag: 'venue-title-${event.venue.id}',
                  child: Text(event.venue.title,
                      style: Theme.of(context).textTheme.body2),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Hero(
                              tag: 'venue-street-${event.venue.id}',
                              child: Text(event.venue.street)),
                          Hero(
                            tag: 'venue-city-${event.venue.id}',
                            child: Text(
                                '${event.venue.city}, ${event.venue.state} ${event.venue.zip}'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Hero(
                    tag: 'venue-map-${event.venue.id}',
                    child: SecondaryButton(
                      context,
                      'MAP',
                      () => launch(event.venue.mapUrl),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    } else {
      return Text('Venue TBD', style: Theme.of(context).textTheme.body2);
    }
  }

  List<Widget> _buildTags() {
    var chips = List<Widget>();
    event.tags?.forEach((tag) => chips.add(GestureDetector(
          onTap: () => launch(Event.getTagUrl(tag)),
          child: Chip(
            label: Text(tag),
          ),
        )));
    return chips;
  }

  Widget _buildEventTimeRange(BuildContext context) {
    final startDay = formatDay(event.startTime);
    final startDate = formatDate(event.startTime);
    final startTime = formatTime(event.startTime, ampm: !event.isOneDay);
    final endTime = formatTime(event.endTime, ampm: true);
    final style = Theme.of(context).textTheme.body2;
    return event.isOneDay
        ? Text('$startDay, $startDate, $startTime – $endTime', style: style)
        : Column(
            children: <Widget>[
              Text(
                '$startDay, $startDate, $startTime –',
                style: style,
              ),
              Text(
                '${formatDay(event.endTime)}, ${formatDate(event.endTime)}, $endTime',
                style: style,
              )
            ],
          );
  }
}
