import 'dart:async';
import 'package:flutter/material.dart';
import 'package:toledotechevents_mobile/providers.dart' hide Theme, Color;
import 'package:toledotechevents_mobile/resources.dart';

class EventListView extends StatefulWidget {
  EventListView(this.events, this.pageData);
  final EventList events;
  final PageLayoutData pageData;
  @override
  State<EventListView> createState() => _EventListState();
}

class _EventListState extends State<EventListView> {
  EventListItem selectedEvent;

  @override
  void initState() {
    super.initState();
    if (widget.events.selectedId != null) {
      selectedEvent = widget.events.findById(widget.events.selectedId);
      Future.delayed(Duration(milliseconds: 400))
          .then((_) => setState(() => selectedEvent = null));
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: () async => EventListProvider.of(context).fetch.add(true),
        child: ListView(children: _buildEventList(context)));
  }

  List<Widget> _buildEventList(BuildContext context) {
    var items = List<Widget>();
    var now = DateTime.now();
    var twoWeeks = now.add(Duration(days: 15)); // 15 intended.

    var today = List<EventListItem>();
    var tomorrow = List<EventListItem>();
    var nextTwoWeeks = List<EventListItem>();
    var afterTwoWeeks = List<EventListItem>();

    widget.events.forEach((e) {
      if (e.occursOnDay(now)) today.add(e);
      if (e.occursOnDay(now.add(Duration(days: 1)))) tomorrow.add(e);
      if (e.occursOnDayInRange(now.add(Duration(days: 2)), twoWeeks))
        nextTwoWeeks.add(e);
      if (e.occursOnOrAfterDay(twoWeeks)) afterTwoWeeks.add(e);
    });

    void addItems(String name, List<EventListItem> events) {
      if (events.length > 0) {
        items.add(
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(name, style: Theme.of(context).textTheme.subhead),
          ),
        );
        events.asMap().forEach((i, event) {
          items.add(
            EventListItemView(
              event,
              color: i % 2 == 0
                  ? Theme.of(context).dividerColor
                  : Theme.of(context).backgroundColor,
              elevation: selectedEvent == event ? 8.0 : 0.0,
              onTap: () => _cardTapped(event, context),
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

  void _cardTapped(EventListItem event, BuildContext context) async {
    setState(() {
      selectedEvent = selectedEvent == event ? null : event;
      widget.events.selectedId =
          selectedEvent == null ? null : selectedEvent.id;
    });
    if (selectedEvent != null) {
      await Future.delayed(Duration(milliseconds: 250));
      PageLayoutProvider.of(context).request.add(PageRequest(
              Page.eventDetails, {
            'event': selectedEvent,
            'resource': EventDetailsResource(selectedEvent.id)
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
