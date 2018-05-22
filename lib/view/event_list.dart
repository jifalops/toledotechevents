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
          items.add(_buildEvent(event, context));
        });
      }
    }

    items.add(
      Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
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

  Widget _buildEvent(Event event, BuildContext context) {
    return Card(
      key: Key('${event.id}'),
      // elevation: 0.0,
      child: InkWell(
        onTap: () => _cardTapped(event, context),
        child: Padding(
          padding: EdgeInsets.all(4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                event.title,
                style: Theme.of(context).textTheme.body2,
                // maxLines: 1,
                // softWrap: true,
                // overflow: TextOverflow.fade,
              ),
              SizedBox(height: 4.0),
              _formatDateTime(event),
              SizedBox(height: 4.0),
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
    );
  }

  void _cardTapped(Event event, BuildContext context) {
    setState(() => _selectedEvent = _selectedEvent == event ? null : event);
    // _playAnimation(events.indexOf(event), _selectedEvent == event);
    Navigator.push(context, new MaterialPageRoute(builder: (_) {
      return new EventDetails(event);
    }));
  }
}

Widget _formatDateTime(Event event) {
  final isOneDay = _isToday(event, event.startTime);
  final startDate =
      '${_formatDay(event.startTime)} ${_formatDate(event.startTime)}';
  final endTime = _formatTime(event.endTime, true);

  final line1 =
      startDate + (isOneDay ? '' : ' at ${_formatTime(event.startTime, true)}');
  final line2 = isOneDay
      ? '${_formatTime(event.startTime)}–$endTime'
      : '${_formatDate(event.endTime)} at $endTime';
  return _wrapStrings([line1, line2]);
}

String _formatDay(DateTime dt) => DateFormat('EEEE').format(dt);
String _formatDate(DateTime dt) => DateFormat('MMMM d').format(dt);
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

Flex _wrapStrings(List<String> strings, [Axis direction = Axis.vertical]) {
  final texts = List<Text>();
  strings.forEach((s) => texts.add(Text(s)));
  return Flex(
    direction: direction,
    children: texts,
  );
}
