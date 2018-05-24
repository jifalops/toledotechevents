import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model.dart';
import '../theme.dart';
import 'event_details.dart';

class EventList extends StatefulWidget {
  final List<Event> events;
  EventList(this.events);
  @override
  State<EventList> createState() => _EventListState(events);
}

class _EventListState extends State<EventList> with TickerProviderStateMixin {
  final List<Event> events;
  Event _selectedEvent;
  final _controllers = List<AnimationController>();

  _EventListState(this.events);

  @override
  void initState() {
    super.initState();
    events.forEach((e) => _controllers.add(AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this)));
  }

  @override
  void dispose() {
    _controllers.forEach((c) => c.dispose());
    super.dispose();
  }

  Future<Null> _playAnimation(int index, bool forward) async {
    try {
      if (forward)
        await _controllers[index].forward().orCancel;
      else
        await _controllers[index].reverse().orCancel;
    } on TickerCanceled {
      // the animation got canceled, probably because we were disposed
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(children: _buildEventList(context));
  }

  List<Widget> _buildEventList(BuildContext context) {
    var items = List<Widget>();
    var now = DateTime.now();
    var twoWeeks = now.add(Duration(days: 15)); // 15 intended.

    var today = List<Event>();
    var tomorrow = List<Event>();
    var nextTwoWeeks = List<Event>();
    var afterTwoWeeks = List<Event>();

    events.forEach((e) {
      if (e.occursOnDay(now)) today.add(e);
      if (e.occursOnDay(now.add(Duration(days: 1)))) tomorrow.add(e);
      if (e.occursOnDayInRange(now.add(Duration(days: 2)), twoWeeks))
        nextTwoWeeks.add(e);
      if (e.occursOnOrAfterDay(twoWeeks)) afterTwoWeeks.add(e);
    });

    void addItems(String name, List<Event> events) {
      if (events.length > 0) {
        items.add(
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(name, style: Theme.of(context).textTheme.subhead),
          ),
        );
        events.asMap().forEach((i, event) {
          items.add(_buildEvent(event, i, context));
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

  Widget _buildEvent(Event event, int index, BuildContext context) {
    return Card(
      key: Key('${event.id}'),
      elevation: 0.0,
      color: index % 2 == 0 ? kBackgroundColor : kDividerColor,
      child: InkWell(
        onTap: () => _cardTapped(event, index, context),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                event.title,
                // textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.body2,
                maxLines: 2,
                // softWrap: true,
                overflow: TextOverflow.fade,
              ),
              // SizedBox(height: 4.0),
              Text(
                event.venue.title,
                style: Theme.of(context).textTheme.caption,
                maxLines: 1,
                // softWrap: false,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 4.0),
              buildEventTimeRange(event, context),
            ],
          ),
        ),
      ),
    );
  }

  void _cardTapped(Event event, int index, BuildContext context) {
    setState(() => _selectedEvent = _selectedEvent == event ? null : event);
    // _playAnimation(index, _selectedEvent == event);
    Navigator.push(context, new MaterialPageRoute(builder: (_) {
      return new EventDetails(event);
    }));
  }
}

Widget buildEventTimeRange(Event event, BuildContext context) {
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
