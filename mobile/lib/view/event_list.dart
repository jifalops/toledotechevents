import 'dart:async';
import 'package:flutter/material.dart';
import 'package:toledotechevents_mobile/view/page_parts.dart';

class EventListView extends StatefulWidget {
  EventListView(this.pageData);
  final PageData pageData;
  @override
  State<EventListView> createState() => _EventListState();
}

class _EventListState extends State<EventListView> {
  @override
  Widget build(BuildContext context) {
    return buildScaffold(context, widget.pageData, _buildBody);
  }

  Widget _buildBody(BuildContext context) {
    final appBloc = AppDataProvider.of(context);
    return FutureHandler<EventList>(
        future: appBloc.resources.eventList.get(),
        initialData: appBloc.resources.eventList.data,
        handler: (context, events) {
          return FadeScaleIn(RefreshIndicator(
              onRefresh: () async {
                await appBloc.resources.eventList.get(forceReload: true);
                setState(() {});
              },
              child: ListView(children: _buildEventList(context, events))));
        });
  }

  List<Widget> _buildEventList(BuildContext context, EventList events) {
    var items = List<Widget>();
    var now = DateTime.now();
    var twoWeeks = now.add(Duration(days: 15)); // 15 intended.

    var today = List<EventListItem>();
    var tomorrow = List<EventListItem>();
    var nextTwoWeeks = List<EventListItem>();
    var afterTwoWeeks = List<EventListItem>();

    events.forEach((e) {
      if (e.occursOnDay(now)) today.add(e);
      if (e.occursOnDay(now.add(Duration(days: 1)))) tomorrow.add(e);
      if (e.occursOnDayInRange(now.add(Duration(days: 2)), twoWeeks))
        nextTwoWeeks.add(e);
      if (e.occursOnOrAfterDay(twoWeeks)) afterTwoWeeks.add(e);
    });

    void addItems(String name, List<EventListItem> list) {
      if (list.length > 0) {
        items.add(
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(name, style: Theme.of(context).textTheme.subhead),
          ),
        );
        list.asMap().forEach((i, event) {
          items.add(
            EventListItemView(
              event,
              color: i % 2 == 0
                  ? Theme.of(context).dividerColor
                  : Theme.of(context).backgroundColor,
              elevation: events.selectedItem == event ? 8.0 : 0.0,
              onTap: () => _cardTapped(events, event, context),
            ),
          );
        });
      }
    }

    items.add(
      Center(
        child: Padding(
          padding: EdgeInsets.all(0.0),
          child: Text("What's happening?",
              style: Theme.of(context).textTheme.headline),
        ),
      ),
    );
    addItems('Today', today);
    addItems('Tomorrow', tomorrow);
    addItems('Next two weeks', nextTwoWeeks);
    addItems('Later', afterTwoWeeks);

    return items;
  }

  void _cardTapped(
      EventList events, EventListItem event, BuildContext context) async {
    setState(() {
      events.selectedItem = events.selectedItem == event ? null : event;
    });
    if (events.selectedItem != null) {
      await Future.delayed(Duration(milliseconds: 250));
      AppDataProvider.of(context)
          .pageRequest
          .add(PageRequest(Page.eventDetails, args: {
            'details': EventDetails(
                events.selectedItem,
                AppDataProvider.of(context)
                    .resources
                    .eventDetails(events.selectedItem.id))
          }, onPop: () {
            if (events.selectedItem != null) {
              Future.delayed(Duration(milliseconds: 400))
                  .then((_) => setState(() => events.selectedItem = null));
            }
          }));
    }
  }
}

class EventListItemView extends StatelessWidget {
  final EventListItem event;
  final Color color;
  final double elevation;
  final Function onTap;
  EventListItemView(this.event,
      {@required this.color,
      this.elevation: 0.0,
      @required this.onTap,
      Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'event-${event.id}',
      child: Card(
        elevation: elevation,
        color: color,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Hero(
                  tag: 'event-title-${event.id}',
                  child: Text(
                    event.title,
                    style: Theme.of(context).textTheme.body2,
                    maxLines: 2,
                    overflow: TextOverflow.fade,
                  ),
                ),
                Hero(
                  tag: 'event-venue-title-${event.id}',
                  child: Text(
                    event.venue.title,
                    style: Theme.of(context).textTheme.caption,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(height: 4.0),
                Hero(
                  tag: 'event-times-${event.id}',
                  child: _buildEventTimeRange(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEventTimeRange(BuildContext context) {
    final startDay = formatDay(event.startTime);
    final startDate = formatDate(event.startTime);
    final startTime = formatTime(event.startTime, ampm: !event.isOneDay);
    final endTime = formatTime(event.endTime, ampm: true);

    return event.isOneDay
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('$startDay, $startDate'),
              Text('$startTime – $endTime',
                  style: Theme.of(context).textTheme.caption),
            ],
          )
        : Column(
            children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('$startDay, $startDate'),
                    Text('$startTime',
                        style: Theme.of(context).textTheme.caption),
                  ]),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                      '${formatDay(event.endTime)}, ${formatDate(event.endTime)}'),
                  Text('$endTime', style: Theme.of(context).textTheme.caption),
                ],
              ),
            ],
          );
  }
}
