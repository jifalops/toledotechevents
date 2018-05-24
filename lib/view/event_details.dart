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
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Event details'),
        actions: <Widget>[
          // overflow menu
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            onSelected: (url) => launch(url),
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
              ];
            },
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Card(
            key: Key('${event.id}'),
            elevation: 0.0,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 16.0, bottom: 24.0),
                    child: Center(
                      child: Text(
                        event.title,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.title,
                      ),
                    ),
                  ),
                  Center(child: _buildEventTimeRange(event, context)),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Add to calendar: '),
                        Row(
                          children: [
                            PrimaryButton(
                              context,
                              'ICAL',
                              () => launch(event.iCalendarUrl),
                              // color: kFlatButtonColor,
                              // textColor: kTextColorOnSecondary,
                            ),
                            SizedBox(width: 8.0),
                            FutureBuilder<Widget>(
                              future: _buildGoogleCalendarWidget(context),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return snapshot.data;
                                } else if (snapshot.hasError) {
                                  return new Text('${snapshot.error}');
                                }
                                return NullWidget();
                              },
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
                        return new Text('${snapshot.error}');
                      }
                      return NullWidget();
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child:
                        // Text('Venue', style: Theme.of(context).textTheme.subhead),
                        event.venue != null
                            ? Card(
                                elevation: 0.0,
                                child: FutureBuilder<List<Venue>>(
                                  future: getVenues(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return _buildVenue(
                                          snapshot.data, context);
                                    } else if (snapshot.hasError) {
                                      return new Text('${snapshot.error}');
                                    }
                                    return _buildEventVenue(context);
                                  },
                                ),
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
                      : NullWidget
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<Widget> _buildGoogleCalendarWidget(BuildContext context) async {
    var url = await event.googleCalendarUrl ?? '';
    return url.isEmpty
        ? NullWidget()
        : PrimaryButton(
            context,
            'GOOGLE',
            () => launch(url),
            // color: kFlatButtonColor,
            // textColor: kTextColorOnSecondary,
          );
  }

  Future<Widget> _buildRsvpWidget(BuildContext context) async {
    var url = await event.rsvpUrl ?? '';
    return url.isEmpty
        ? NullWidget()
        : Padding(
            padding: EdgeInsets.only(top: 16.0, bottom: 8.0),
            child: Center(
              child: RaisedButton(
                elevation: 8.0,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: Text(
                    'RSVP / REGISTER',
                    style: Theme
                        .of(context)
                        .textTheme
                        .button
                        .copyWith(color: Colors.white, fontSize: 16.0),
                  ),
                ),
                color: kSecondaryColorDark,
                onPressed: () => launch(url),
              ),
            ),
          );
  }

  Widget _buildVenue(List<Venue> venues, BuildContext context) {
    Venue venue = Venue.findById(venues, event.venue.id);
    if (venue != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(venue.title, style: Theme.of(context).textTheme.body2),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(venue.street),
                      Text('${venue.city}, ${venue.state} ${venue.zip}'),
                    ],
                  ),
                ),
              ),
              PrimaryButton(
                context,
                'MAP',
                () => launch(venue.mapUrl),
              ),
            ],
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            (venue.hasWifi
                ? Row(
                    children: <Widget>[
                      Icon(Icons.wifi, color: kSecondaryColor),
                      Text(' Public WiFi')
                    ],
                  )
                : NullWidget()),
            // SizedBox(width: 16.0),
            PrimaryButton(
              context,
              'VENUE DETAILS',
              () => Navigator.push(context, new MaterialPageRoute(builder: (_) {
                    return VenueDetails(venue);
                  })),
              color: kFlatButtonColor,
              textColor: kTextColorOnSecondary,
              padding: EdgeInsets.all(0.0),
            ),
          ])
        ],
      );
    } else {
      return _buildEventVenue(context);
    }
  }

  Widget _buildEventVenue(BuildContext context) {
    if (event.venue != null && event.venue.id > 0) {
      return Column(
        children: <Widget>[
          Text(event.venue.title, style: Theme.of(context).textTheme.body2),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(event.venue.street),
                      Text(
                          '${event.venue.city}, ${event.venue.state} ${event.venue.zip}'),
                    ],
                  ),
                ),
              ),
              PrimaryButton(
                context,
                'MAP',
                () => launch(event.venue.mapUrl),
              ),
            ],
          ),
        ],
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

  // void _overflowItemSelected(item) async {
  //   if (await canLaunch(item['url'])) {
  //     launch(item['url']);
  //   } else {
  //     final msg = item['url'].endsWith('ics')
  //         ? 'No apps available to handle iCal link.'
  //         : 'Could not launch URL.';
  //     Scaffold.of(item['context']).showSnackBar(
  //           SnackBar(
  //             content: Text(msg),
  //             duration: Duration(seconds: 3),
  //           ),
  //         );
  //   }
  // }
}

Widget _buildEventTimeRange(Event event, BuildContext context) {
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
