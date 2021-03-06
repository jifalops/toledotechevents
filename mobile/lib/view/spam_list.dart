import 'dart:async';
import 'package:flutter/material.dart';
import 'package:toledotechevents/internal/deleter.dart';
import 'package:toledotechevents_mobile/view/page_parts.dart';

class SpamListView extends StatefulWidget {
  SpamListView(this.pageData);
  final PageData pageData;
  @override
  _SpamListViewState createState() => new _SpamListViewState();
}

class _SpamListViewState extends State<SpamListView> {
  final _selectedVenues = List<VenueListItem>();
  bool _isDeleting = false;

  Future<Null> refresh() async {
    await AppDataProvider.of(context)
        .resources
        .venueList
        .get(forceReload: true);
    setState(() {
      _isDeleting = false;
      _selectedVenues.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return buildScaffold(context, widget.pageData, _buildBody, _buildFab);
  }

  Widget _buildBody(BuildContext context) {
    final appBloc = AppDataProvider.of(context);
    return RefreshIndicator(
        onRefresh: refresh,
        child: FutureHandler<VenueList>(
          future: appBloc.resources.venueList.get(),
          initialData: appBloc.resources.venueList.data,
          handler: (context, venues) => FadeScaleIn(
              ListView(children: _buildVenueList(context, venues.findSpam()))),
        ));
  }

  Widget _buildFab(BuildContext context) {
    return FloatingActionButton(
        child: Icon(Icons.delete),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                int events = 0;
                _selectedVenues.forEach((venue) => events += venue.eventCount);
                final controller = TextEditingController();
                return AlertDialog(
                  title: Text('Confirm'),
                  content:
                      Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
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
                            if (Deleter.validatePassword(controller.text)) {
                              setState(() => _isDeleting = true);
                              if (await Deleter.deleteAll(
                                  _selectedVenues,
                                  controller.text,
                                  AppDataProvider.of(context).resources)) {
                                Navigator.pop(context);
                                _selectedVenues.clear();
                                refresh();
                              }
                            }
                          })
                  ],
                );
              });
        });
  }

  List<Widget> _buildVenueList(BuildContext context, VenueList venues) {
    if (venues.sortOrder != VenuesOrder.newest) {
      venues.setOrder(VenuesOrder.newest);
    }

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
          elevation: venues.selectedItem == venue ? 8.0 : 0.0,
          color: i % 2 == 0
              ? Theme.of(context).dividerColor
              : Theme.of(context).backgroundColor,
          child: InkWell(
            onTap: () => _cardTapped(venues, venue, context),
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
                                  VenueListItem.date.format(venue.created),
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
