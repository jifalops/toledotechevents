import 'package:flutter/material.dart';
import 'package:flutter_html_view/flutter_html_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:toledotechevents_mobile/view/page_parts.dart';

class VenueDetailsView extends StatelessWidget {
  VenueDetailsView(this.pageData) : venue = pageData.args['details'];
  final VenueDetails venue;
  final PageData pageData;

  @override
  Widget build(BuildContext context) {
    return buildScaffold(context, pageData, _buildBody);
  }

  Widget _buildBody(BuildContext context) {
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
                    Text(' since ', style: Theme.of(context).textTheme.caption),
                    Hero(
                      tag: 'venue-created-${venue.id}',
                      child: Text(VenueDetails.date.format(venue.created),
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
                          Hero(
                            tag: 'venue-street-${venue.id}',
                            child: Text(
                              venue.street,
                              style: Theme.of(context).textTheme.body2,
                            ),
                          ),
                          Hero(
                            tag: 'venue-city-${venue.id}',
                            child: Text(
                                '${venue.city}, ${venue.state} ${venue.zip}',
                                style: Theme.of(context).textTheme.body2),
                          ),
                        ],
                      ),
                    ),
                    Hero(
                      tag: 'venue-map-${venue.id}',
                      child: SecondaryButton(context, 'MAP',
                          () => launch(venue.mapUrl), pageData.theme),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                venue.hasWifi
                    ? Hero(
                        tag: 'venue-wifi-${venue.id}',
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.wifi,
                                color: Theme.of(context).accentColor),
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
                SizedBox(height: 16.0),
                FutureHandler<List<VenueEvent>>(
                  future: venue.futureEvents,
                  handler: (context, events) {
                    final items = List<Widget>();
                    items.add(Text('Upcoming events',
                        style: TextStyle(fontWeight: FontWeight.bold)));
                    if (events.length > 0) {
                      events.forEach((event) =>
                          items.add(Text('${event.id}: ${event.title}')));
                    } else {
                      items.add(Text('none',
                          style: TextStyle(fontStyle: FontStyle.italic)));
                    }
                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: items);
                  },
                ),
                SizedBox(height: 16.0),
                FutureHandler<List<VenueEvent>>(
                  future: venue.pastEvents,
                  handler: (context, events) {
                    final items = List<Widget>();
                    items.add(Text('Past events',
                        style: TextStyle(fontWeight: FontWeight.bold)));
                    if (events.length > 0) {
                      events.forEach((event) =>
                          items.add(Text('${event.id}: ${event.title}')));
                    } else {
                      items.add(Text('none',
                          style: TextStyle(fontStyle: FontStyle.italic)));
                    }
                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: items);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
