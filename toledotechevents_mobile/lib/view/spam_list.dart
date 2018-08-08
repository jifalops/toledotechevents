import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:toledotechevents/internal/deleter.dart';
import 'package:toledotechevents_mobile/resources.dart';
import 'package:toledotechevents_mobile/providers.dart';
import 'package:toledotechevents_mobile/theme.dart';

class SpamListView extends StatefulWidget {
  SpamListView(this.venues, this.pageData) {
    if (venues.sortOrder != VenuesOrder.newest) {
      venues.setOrder(VenuesOrder.newest);
    }
  }
  final VenueList venues;
  final PageData pageData;
  @override
  _VenueSpamListState createState() => new _VenueSpamListState();
}

class _VenueSpamListState extends State<SpamListView> {
  final _selectedVenues = List<VenueListItem>();
  bool _isDeleting = false;

  Future<Null> refresh() async {
    AppDataProvider.of(context).venuesRequest.add(true);
    _isDeleting = false;
  }

  @override
  void initState() {
    super.initState();
    if (widget.venues.selectedItem != null) {
      Future
          .delayed(Duration(milliseconds: 400))
          .then((_) => setState(() => widget.venues.selectedItem = null));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                                  if (venue.eventCount < 10) {
                                    final details = VenueDetails(venue,
                                        resources.venueDetails(venue.id));
                                    if ((await details.futureEvents).isEmpty) {
                                      for (var event
                                          in await details.pastEvents) {
                                        await Deleter.delete(eventId: event.id);
                                      }
                                      if (await Deleter.delete(venue: venue)) {
                                        print(
                                            'Venue ${venue.id} and ${venue.eventCount} events deleted.');
                                      }
                                    }
                                  }
                                }
                                // Navigator.pop(context);
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

    widget.venues.asMap().forEach((i, venue) {
      items.add(Hero(
        tag: 'venue-${venue.id}',
        child: Card(
          elevation: widget.venues.selectedItem == venue ? 8.0 : 0.0,
          color: i % 2 == 0
              ? Theme.of(context).dividerColor
              : Theme.of(context).backgroundColor,
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
                              child: Text(
                                  VenueListItem.formatter.format(venue.created),
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

  void _cardTapped(VenueListItem venue, BuildContext context) async {
    // timeDilation = 10.0;
    setState(() => widget.venues.selectedItem =
        widget.venues.selectedItem == venue ? null : venue);
    if (widget.venues.selectedItem != null) {
      await Future.delayed(Duration(milliseconds: 250));
      AppDataProvider
          .of(context)
          .pageRequest
          .add(PageRequest(Page.venueDetails, {
            'venue': widget.venues.selectedItem,
            'resource': resources.venueDetails(widget.venues.selectedItem.id),
          }));
    }
  }
}
