import 'dart:async';
import 'package:flutter/material.dart';
import 'package:toledotechevents_mobile/view/page_container.dart';

class VenueListView extends StatefulWidget {
  VenueListView(this.venues, this.pageData);
  final VenueList venues;
  final PageData pageData;
  @override
  _VenueListState createState() => new _VenueListState();
}

class _VenueListState extends State<VenueListView> {
  @override
  void initState() {
    super.initState();
    if (widget.venues.selectedItem != null) {
      Future.delayed(Duration(milliseconds: 400))
          .then((_) => setState(() => widget.venues.selectedItem = null));
    }
  }

  @override
  Widget build(BuildContext context) {
    return buildScaffold(context, widget.pageData, _buildBody);
  }

  Widget _buildBody(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        AppDataProvider.of(context).venuesRequest.add(true);
      },
      child: ListView(children: _buildVenueList(context)),
    );
  }

  List<Widget> _buildVenueList(BuildContext context) {
    final items = List<Widget>();
    widget.venues.sort();

    items.add(
      Center(
          child: Text('Venues', style: Theme.of(context).textTheme.headline)),
    );
    items.add(Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TertiaryButton(
          'POPULAR${widget.venues.indicatorFor(VenuesOrder.popular)}',
          () => setState(() => widget.venues.setOrder(VenuesOrder.popular)),
        ),
        SizedBox(width: 8.0),
        TertiaryButton(
          'NEWEST${widget.venues.indicatorFor(VenuesOrder.newest)}',
          () => setState(() => widget.venues.setOrder(VenuesOrder.newest)),
        ),
        TertiaryButton(
          'HOT${widget.venues.indicatorFor(VenuesOrder.hot)}',
          () => setState(() => widget.venues.setOrder(VenuesOrder.hot)),
        ),
      ],
    ));

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
                        child: Text(VenueListItem.date.format(venue.created),
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

  void _cardTapped(VenueListItem venue, BuildContext context) async {
    // timeDilation = 10.0;
    setState(() => widget.venues.selectedItem =
        widget.venues.selectedItem == venue ? null : venue);
    if (widget.venues.selectedItem != null) {
      await Future.delayed(Duration(milliseconds: 250));
      AppDataProvider.of(context)
          .pageRequest
          .add(PageRequest(Page.venueDetails, {
            'venue': widget.venues.selectedItem,
            'resource': AppDataProvider.of(context)
                .resources
                .venueDetails(widget.venues.selectedItem.id),
          }));
    }
  }
}
