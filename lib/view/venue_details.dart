import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_html_view/flutter_html_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import '../model.dart';
import '../theme.dart';

class VenueDetails extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final Venue venue;
  final format = DateFormat(' MMMM yyyy');

  VenueDetails(this.venue);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: _buildAppBar(context),
      body: _buildVenue(context),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      // leading: IconButton(
      //   icon: Icon(Icons.close),
      //   onPressed: () => Navigator.pop(context),
      // ),
      title: Text('Venue details'),
      actions: <Widget>[
        // overflow menu
        PopupMenuButton(
          icon: Icon(Icons.more_vert),
          onSelected: (url) async {
            print('url $url');
            if (await canLaunch(url))
              launch(url);
            else {
              _scaffoldKey.currentState.showSnackBar(SnackBar(
                content: Text('Could not launch URL.'),
                duration: Duration(seconds: 3),
              ));
            }
          },
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                child: Text('Edit this venue'),
                value: venue.editUrl,
              ),
              PopupMenuItem(
                child: Text('See past venue events'),
                value: venue.url,
              ),
              PopupMenuItem(
                child: Text('Subscribe via iCal'),
                value: venue.iCalendarUrl,
              ),
              PopupMenuItem(
                child: Text('Subscribe via web'),
                value: venue.subscribeUrl,
              ),
            ];
          },
        ),
      ],
    );
  }

  Widget _buildVenue(BuildContext context) {
    return SingleChildScrollView(
      child: Hero(
        tag: 'venue-${venue.id}',
        child: Card(
          elevation: 0.0,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 24.0, bottom: 16.0),
                  child: Center(
                    child: Hero(
                      tag: 'venue-title-${venue.id}',
                      child: Text(
                        venue.title,
                        style: Theme.of(context).textTheme.title,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Hero(
                      tag: 'venue-events-${venue.id}',
                      child: Text(
                        '${venue.eventCount} events',
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ),
                    Text(' since ',
                        style: Theme.of(context).textTheme.caption),
                    Hero(
                      tag: 'venue-created-${venue.id}',
                      child: Text(format.format(venue.created),
                          style: Theme.of(context).textTheme.caption),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Hero(tag: 'venue-street-${venue.id}',
                                                      child: Text(
                              venue.street,
                              style: Theme.of(context).textTheme.body2,
                            ),
                          ),
                          Hero(tag: 'venue-city-${venue.id}',
                                                      child: Text('${venue.city}, ${venue.state} ${venue.zip}',
                                style: Theme.of(context).textTheme.body2),
                          ),
                        ],
                      ),
                    ),
                    Hero(tag: 'venue-map-${venue.id}',
                                          child: SecondaryButton(
                        context,
                        'MAP',
                        () => launch(venue.mapUrl),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                venue.hasWifi
                    ? Hero(tag: 'venue-wifi-${venue.id}',
                                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.wifi, color: kSecondaryColor),
                            Text(' Public WiFi')
                          ],
                        ),
                    )
                    : NullWidget(),
                SizedBox(height: 8.0),
                Text(venue.accessNotes),
                SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    venue.phone.isNotEmpty
                        ? HtmlView(
                            data:
                                '<a href="${venue.phoneUrl}">${venue.phone}</a>')
                        : NullWidget(),
                    venue.email.isNotEmpty
                        ? HtmlView(
                            data:
                                '<a href="${venue.emailUrl}">${venue.email}</a>')
                        : NullWidget(),
                  ],
                ),
                SizedBox(height: 16.0),
                Text(venue.description),
                SizedBox(height: 8.0),
                HtmlView(
                    data: '<a href="${venue.homepage}">${venue.homepage}</a>'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
