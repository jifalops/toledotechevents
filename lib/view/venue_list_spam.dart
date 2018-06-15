import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';
import '../model.dart';
import '../theme.dart';
import 'venue_details.dart';
import 'app_bar.dart';
import '../internal/deleter.dart';

class VenueSpamList extends StatefulWidget {
  final List<Venue> venues;
  final DateFormat format = DateFormat('yyyy-MM-dd');
  VenueSpamList(List<Venue> venues) : venues = Venue.findSpam(venues);
  @override
  _VenueSpamListState createState() => new _VenueSpamListState(venues);
}

class _VenueSpamListState extends State<VenueSpamList> {
  var venues = List<Venue>();
  Venue _selectedVenue;
  final _selectedVenues = List<Venue>();
  bool _isDeleting = false;

  _VenueSpamListState(this.venues) {
    _sort();
  }

  void _sort() => venues.sort((a, b) => b.created.compareTo(a.created));

  Future<Null> refresh() async {
    venues = Venue.findSpam(await getVenues(forceReload: true));
    _sort();
    _isDeleting = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(context, 0),
      body: RefreshIndicator(
        onRefresh: refresh,
        child: ListView(children: _buildVenueList(context)),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.delete),
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  int events = 0;
                  _selectedVenues
                      .forEach((venue) => events += venue.eventCount);
                  final controller = TextEditingController();
                  return AlertDialog(
                    title: Text('Confirm'),
                    content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                              'Remove ${_selectedVenues.length} venues and $events corresponding events?\nThis cannot be undone.'),
                          TextField(
                              controller: controller,
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: 'Password',
                              ))
                        ]),
                    actions: <Widget>[
                      _isDeleting
                          ? CircularProgressIndicator()
                          : TertiaryButton('REMOVE ALL', () async {
                              if ('${sha256.convert(utf8.encode(controller.text))}' ==
                                  '410d937d400fe5214a4b207949cc8426e0bcb41bf17365b537bde2e7caefbb83') {
                                print('Removing selected spam entries...');
                                setState(() => _isDeleting = true);
                                for (var venue in _selectedVenues) {
                                  // Safeguards
                                  if (venue.eventCount < 10 &&
                                      (await venue.futureEvents).isEmpty) {
                                    for (var event in await venue.pastEvents) {
                                      await Deleter.delete(eventId: event.id);
                                    }
                                    if (await Deleter.delete(venue: venue)) {
                                      print(
                                          'Venue ${venue.id} and ${venue.eventCount} events deleted.');
                                    }
                                  }
                                }
                                Navigator.pop(context);
                                _selectedVenues.clear();
                                refresh();
                              }
                            })
                    ],
                  );
                });
          }),
    );
  }

  List<Widget> _buildVenueList(BuildContext context) {
    final items = List<Widget>();

    items.add(
      Center(
          child: Column(
        children: <Widget>[
          Text('Possible Spam Venues',
              style: Theme.of(context).textTheme.headline),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Select venues to delete. All events for those venues will also be deleted. Password required.',
              textAlign: TextAlign.center,
            ),
          )
        ],
      )),
    );

    venues.asMap().forEach((i, venue) {
      items.add(Hero(
        tag: 'venue-${venue.id}',
        child: Card(
          elevation: _selectedVenue == venue ? 8.0 : 0.0,
          color: i % 2 == 0 ? kDividerColor : kBackgroundColor,
          child: InkWell(
            onTap: () => _cardTapped(venue, context),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Checkbox(
                      value: _selectedVenues.contains(venue),
                      onChanged: (checked) {
                        setState(() {
                          int index = _selectedVenues.indexOf(venue);
                          if (index >= 0)
                            _selectedVenues.removeAt(index);
                          else
                            _selectedVenues.add(venue);
                        });
                      }),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Hero(
                          tag: 'venue-title-${venue.id}',
                          child: Text(
                            venue.title,
                            style: Theme.of(context).textTheme.body2,
                            maxLines: 2,
                            overflow: TextOverflow.fade,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Hero(
                              tag: 'venue-events-${venue.id}',
                              child: Text('${venue.eventCount} events',
                                  style: Theme.of(context).textTheme.caption),
                            ),
                            Hero(
                              tag: 'venue-created-${venue.id}',
                              child: Text(widget.format.format(venue.created),
                                  style: Theme.of(context).textTheme.caption),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ));
    });
    return items;
  }

  void _cardTapped(Venue venue, BuildContext context) async {
    // timeDilation = 10.0;
    setState(() => _selectedVenue = _selectedVenue == venue ? null : venue);
    if (_selectedVenue != null) {
      await Future.delayed(Duration(milliseconds: 250));
      await Navigator.push(
        context,
        FadePageRoute(builder: (context) => VenueDetails(_selectedVenue)),
      );
      await Future.delayed(Duration(milliseconds: 400));
      setState(() => _selectedVenue = null);
    }
  }
}
