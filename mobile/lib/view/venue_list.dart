import 'dart:async';
import 'package:flutter/material.dart';
import 'package:toledotechevents_mobile/view/page_parts.dart';

class VenueListView extends StatefulWidget {
  VenueListView(this.pageData);
  final PageData pageData;
  @override
  _VenueListState createState() => new _VenueListState();
}

class _VenueListState extends State<VenueListView> {
  @override
  Widget build(BuildContext context) {
    return buildScaffold(context, widget.pageData, _buildBody);
  }

  Widget _buildBody(BuildContext context) {
    final appBloc = AppDataProvider.of(context);
    return FutureHandler<VenueList>(
        future: appBloc.resources.venueList.get(),
        initialData: appBloc.resources.venueList.data,
        handler: (context, venues) {
          return FadeScaleIn(RefreshIndicator(
              onRefresh: () async {
                await appBloc.resources.venueList.get(forceReload: true);
                setState(() {});
              },
              child: ListView(children: _buildVenueList(context, venues))));
        });
  }

  List<Widget> _buildVenueList(BuildContext context, VenueList venues) {
    final items = List<Widget>();
    venues.sort();

    items.add(
      Center(
          child: Text('Venues', style: Theme.of(context).textTheme.headline)),
    );
    items.add(Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TertiaryButton(
          'POPULAR${venues.indicatorFor(VenuesOrder.popular)}',
          () => setState(() => venues.setOrder(VenuesOrder.popular)),
        ),
        SizedBox(width: 8.0),
        TertiaryButton(
          'NEWEST${venues.indicatorFor(VenuesOrder.newest)}',
          () => setState(() => venues.setOrder(VenuesOrder.newest)),
        ),
        TertiaryButton(
          'HOT${venues.indicatorFor(VenuesOrder.hot)}',
          () => setState(() => venues.setOrder(VenuesOrder.hot)),
        ),
      ],
    ));

    venues.asMap().forEach((i, venue) {
      items.add(Hero(
        tag: 'venue-${venue.id}',
        child: Card(
          elevation: venues.selectedItem == venue ? 8.0 : 0.0,
          color: i % 2 == 0
              ? Theme.of(context).dividerColor
              : Theme.of(context).backgroundColor,
          child: InkWell(
            onTap: () => _cardTapped(venues, venue, context),
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

  void _cardTapped(
      VenueList venues, VenueListItem venue, BuildContext context) async {
    setState(() =>
        venues.selectedItem = venues.selectedItem == venue ? null : venue);
    if (venues.selectedItem != null) {
      await Future.delayed(Duration(milliseconds: 250));
      AppDataProvider.of(context)
          .pageRequest
          .add(PageRequest(Page.venueDetails, args: {
            'details': VenueDetails(
                venues.selectedItem,
                AppDataProvider.of(context)
                    .resources
                    .venueDetails(venues.selectedItem.id)),
          }, onPop: () {
            if (venues.selectedItem != null) {
              Future.delayed(Duration(milliseconds: 400))
                  .then((_) => setState(() => venues.selectedItem = null));
            }
          }));
    }
  }
}
