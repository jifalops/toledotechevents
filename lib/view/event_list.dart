import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model.dart';
import '../theme.dart';

class EventList extends StatefulWidget {
  final List<Event> events;
  EventList(this.events);
  @override
  State<EventList> createState() => EventListState(events);
}

class EventListState extends State<EventList> {
  final List<Event> events;
  Event _selectedEvent;

  EventListState(this.events);

  @override
  Widget build(BuildContext context) {
    return ListView(children: _buildEventList(context));
  }

  List<Widget> _buildEventList(BuildContext context) {
    var items = List<Widget>();
    var now = DateTime.now();

    var today = List<Event>();
    var tomorrow = List<Event>();
    var nextTwoWeeks = List<Event>();
    var afterTwoWeeks = List<Event>();

    events.forEach((e) {
      if (_isToday(e, now)) today.add(e);
      if (_isTomorrow(e, now)) tomorrow.add(e);
      if (_isNextTwoWeeks(e, now)) nextTwoWeeks.add(e);
      if (_isAfterTwoWeeks(e, now)) afterTwoWeeks.add(e);
    });

    void addItems(String name, List<Event> events) {
      if (events.length > 0) {
        items.add(
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(name, style: Theme.of(context).textTheme.subhead),
          ),
        );
        events.forEach((event) {
          items.add(_buildEvent(event));
        });
      }
    }

    addItems('Today', today);
    addItems('Tomorrow', tomorrow);
    addItems('Next two weeks', nextTwoWeeks);
    addItems('Later', afterTwoWeeks);

    return items;
  }

  Widget _buildEvent(Event event) {
    return Card(
      elevation: event == _selectedEvent ? 8.0 : 0.0,
      child: InkWell(
        onTap: () => _cardTapped(event),
        child: Padding(
          padding: EdgeInsets.all(4.0),
          child: Row(
            children: <Widget>[
              Container(
                width: 90.0,
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(color: kPrimaryColorLight),
                  ),
                ),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text(_formatDay(event.startTime)),
                    Text(_formatDate(event.startTime)),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        event.title,
                        style: Theme.of(context).textTheme.body2,
                        maxLines: 1,
                        // softWrap: true,
                        overflow: TextOverflow.fade,
                      ),
                      Text(
                          '${_formatTime(event.startTime)} - ${_formatTime(event.endTime, true)}'),
                      Text(
                        event.venue.title,
                        maxLines: 1,
                        // softWrap: false,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _cardTapped(Event event) {
    setState(() => _selectedEvent = _selectedEvent == event ? null : event);
  }
}

String _formatDay(DateTime dt) => DateFormat('EEEE').format(dt);
String _formatDate(DateTime dt) => DateFormat('MMM d').format(dt);

String _formatTime(DateTime dt, [bool ampm = false]) =>
    DateFormat('h:mm' + (ampm ? 'a' : '')).format(dt);

bool _isToday(Event e, DateTime now) {
  var min = _beginningOfDay(now);
  var max = _beginningOfDay(now.add(Duration(days: 1)));
  return e.endTime.isAfter(min) && e.startTime.isBefore(max);
}

bool _isTomorrow(Event e, DateTime now) {
  var min = _beginningOfDay(now.add(Duration(days: 1)));
  var max = _beginningOfDay(now.add(Duration(days: 2)));
  return e.endTime.isAfter(min) && e.startTime.isBefore(max);
}

bool _isNextTwoWeeks(Event e, DateTime now) {
  var min = _beginningOfDay(now.add(Duration(days: 2)));
  var max = _beginningOfDay(now.add(Duration(days: 15)));
  return e.endTime.isAfter(min) && e.startTime.isBefore(max);
}

bool _isAfterTwoWeeks(Event e, DateTime now) {
  var min = _beginningOfDay(now.add(Duration(days: 15)));
  return e.endTime.isAfter(min);
}

DateTime _beginningOfDay(DateTime dt) => dt
    .subtract(Duration(hours: dt.hour))
    .subtract(Duration(minutes: dt.minute))
    .subtract(Duration(seconds: dt.second))
    .subtract(Duration(milliseconds: dt.millisecond));
