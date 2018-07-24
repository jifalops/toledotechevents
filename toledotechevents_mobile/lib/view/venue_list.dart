import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:intl/intl.dart';
import '../model.dart';
import '../theme.dart';
import 'venue_details.dart';

enum VenuesOrder {
  popular,
  newest,
  hot
  // Can't do recent without list of _past_ events
}

class VenueList extends StatefulWidget {
  final List<Venue> venues;
  final DateFormat format = DateFormat('yyyy-MM-dd');
  VenueList(this.venues);
  @override
  _VenueListState createState() => new _VenueListState();
}

class _VenueListState extends State<VenueList> {
  Venue _selectedVenue;
  VenuesOrder sortOrder = VenuesOrder.popular;
  bool sortReverse = false;

  Future<Null> refresh() async {
    widget.venues.clear();
    widget.venues.addAll(await getVenues(forceReload: true));
    _sort();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refresh,
      child: ListView(children: _buildVenueList(context)),
    );
  }

  List<Widget> _buildVenueList(BuildContext context) {
    final items = List<Widget>();
    _sort();

    items.add(
      Center(
          child: Text('Venues', style: Theme.of(context).textTheme.headline)),
    );
    items.add(Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TertiaryButton(
          'POPULAR${sortIndicator(VenuesOrder.popular)}',
          () => setState(() {
                if (sortOrder == VenuesOrder.popular)
                  sortReverse = !sortReverse;
                else {
                  sortOrder = VenuesOrder.popular;
                  sortReverse = false;
                }
              }),
        ),
        SizedBox(width: 8.0),
        TertiaryButton(
          'NEWEST${sortIndicator(VenuesOrder.newest)}',
          () => setState(() {
                if (sortOrder == VenuesOrder.newest)
                  sortReverse = !sortReverse;
                else {
                  sortOrder = VenuesOrder.newest;
                  sortReverse = false;
                }
              }),
        ),
        TertiaryButton(
          'HOT${sortIndicator(VenuesOrder.hot)}',
          () => setState(() {
                if (sortOrder == VenuesOrder.hot)
                  sortReverse = !sortReverse;
                else {
                  sortOrder = VenuesOrder.hot;
                  sortReverse = false;
                }
              }),
        ),
      ],
    ));

    widget.venues.asMap().forEach((i, venue) {
      items.add(Hero(
        tag: 'venue-${venue.id}',
        child: Card(
          elevation: _selectedVenue == venue ? 8.0 : 0.0,
          color: i % 2 == 0 ? kDividerColor : kBackgroundColor,
          child: InkWell(
            onTap: () => _cardTapped(venue, context),
            child: Padding(
              padding: EdgeInsets.all(8.0),
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

  void _sort() {
    switch (sortOrder) {
      case VenuesOrder.popular:
        sortReverse
            ? widget.venues.sort((a, b) => a.eventCount - b.eventCount)
            : widget.venues.sort((a, b) => b.eventCount - a.eventCount);
        break;
      case VenuesOrder.newest:
        sortReverse
            ? widget.venues.sort((a, b) => a.created.compareTo(b.created))
            : widget.venues.sort((a, b) => b.created.compareTo(a.created));
        break;
      case VenuesOrder.hot:
        final now = DateTime.now();
        double hotness(Venue v) {
          return v.eventCount /
              (now.millisecondsSinceEpoch - v.created.millisecondsSinceEpoch);
        }
        sortReverse
            ? widget.venues.sort((a, b) => hotness(a).compareTo(hotness(b)))
            : widget.venues.sort((a, b) => hotness(b).compareTo(hotness(a)));
        break;
    }
  }

  String sortIndicator(VenuesOrder order) {
    return sortOrder == order ? (sortReverse ? ' ↑' : ' ↓') : '';
  }
}
