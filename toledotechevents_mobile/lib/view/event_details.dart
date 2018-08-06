import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_html_view/flutter_html_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:toledotechevents/build_config.dart';
import 'package:toledotechevents_mobile/theme.dart';
import 'package:toledotechevents_mobile/providers.dart'
    hide Theme, Color, TextAlign;

class EventDetailsView extends StatelessWidget {
  EventDetailsView(this.event, this.page);
  final EventDetails event;
  final PageLayoutData page;

  @override
  Widget build(BuildContext context) {
    return Hero(
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
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Add to calendar: '),
                    Row(
                      children: [
                        SecondaryButton(context, 'ICAL',
                            () => launch(event.iCalendarUrl), page.theme),
                        SizedBox(width: 8.0),
                        SecondaryButton(context, 'GOOGLE',
                            () => _launchGoogleCalendarUrl(), page.theme),
                      ],
                    ),
                  ],
                ),
              ),
              FutureHandler<Widget>(
                future: _buildRsvpWidget(context),
                handler: (context, data) => data,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child:
                    // Text('Venue', style: Theme.of(context).textTheme.subhead),
                    event.venue != null
                        ? StreamHandler<VenueList>(
                            stream: VenueListProvider.of(context).venues,
                            handler: _buildVenue,
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
              child: PrimaryButton(
                  context, 'RSVP / REGISTER', () => launch(url), page.theme),
            ),
          );
  }

  Widget _buildVenue(BuildContext context, VenueList venues) {
    VenueListItem venue = venues.findById(event.venue.id);
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
                      child: SecondaryButton(context, 'MAP',
                          () => launch(venue.mapUrl), page.theme),
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
                            Icon(Icons.wifi,
                                color: Theme.of(context).accentColor),
                            Text(' Public WiFi')
                          ],
                        ),
                      )
                    : NullWidget()),
                // SizedBox(width: 16.0),
                TertiaryButton(
                    'VENUE DETAILS',
                    () => PageLayoutProvider.of(context)
                        .request
                        .add(PageRequest(Page.venueDetails, {'id': venue.id}))),
              ])
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
          onTap: () => launch(config.tagUrl(tag)),
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
