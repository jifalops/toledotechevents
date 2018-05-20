import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_html_view/flutter_html_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

import 'theme.dart';
import 'model.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Toledo Tech Events',
      theme: kTheme,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Row(
          children: <Widget>[
            Text('Toledo'),
            SizedBox(width: 3.0),
            Text(
              'Tech Events',
              style: TextStyle(color: kSecondaryColor),
            ),
          ],
        ),
        actions: <Widget>[
          // overflow menu
          new PopupMenuButton(
            icon: Icon(Icons.more_vert),
            onSelected: _overflowItemSelected,
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  child: Text('Subscribe to Google Calendar'),
                  value: {
                    'context': context,
                    'url': kSubscribeGoogleCalenderUrl
                  },
                ),
                PopupMenuItem(
                  child: Text('Subscribe via iCal'),
                  value: {'context': context, 'url': kSubscribeICalendarUrl},
                ),
                PopupMenuItem(
                  child: Text('Visit forum'),
                  value: {'context': context, 'url': kForumUrl},
                ),
                PopupMenuItem(
                  child: Text('Report an issue'),
                  value: {'context': context, 'url': kFileIssueUrl},
                ),
              ];
            },
          ),
        ],
      ),
      body: new FutureBuilder<List<Event>>(
        future: loadEvents(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return new ListView(
              // padding: EdgeInsets.all(8.0),
              children: _buildEvents(context, snapshot.data),
            );
          } else if (snapshot.hasError) {
            return new Text("${snapshot.error}");
          }
          // By default, show a loading spinner
          return new CircularProgressIndicator();
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        iconSize: 24.0,
        onTap: _navItemTapped,
        items: [
          BottomNavigationBarItem(
            title: Text('Events'),
            icon: Icon(Icons.event),
          ),
          BottomNavigationBarItem(
            title: Text('New'),
            icon: Icon(Icons.add_circle_outline),
          ),
          BottomNavigationBarItem(
            title: Text('Venues'),
            icon: Icon(Icons.business),
          ),
          BottomNavigationBarItem(
            title: Text('About'),
            icon: Icon(Icons.help),
          ),
        ],
      ),
    );
  }

  void _overflowItemSelected(item) async {
    if (await canLaunch(item['url'])) {
      launch(item['url']);
    } else {
      final msg = item['url'].endsWith('ics')
          ? 'No apps available to handle iCal link.'
          : 'Could not launch URL.';
      Scaffold.of(item['context']).showSnackBar(
            SnackBar(
              content: Text(msg),
              duration: Duration(seconds: 3),
            ),
          );
    }
  }

  void _navItemTapped(int index) {
    switch (index) {
      case 0:
        print('Events');
        break;
      case 1:
        print('New event');
        break;
      case 2:
        print('Venues');
        break;
      case 3:
        print('About');
        break;
    }
  }

  List<Widget> _buildEvents(BuildContext context, List<Event> events) {
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

    if (today.length > 0) {
      items.add(
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Today',
            style: Theme.of(context).textTheme.subhead,
          ),
        ),
      );
      today.forEach((event) {
        items.add(_makeListItem(event, context));
      });
    }

    if (tomorrow.length > 0) {
      items.add(Padding(
        padding: EdgeInsets.all(8.0),
        child: Text('Tomorrow', style: Theme.of(context).textTheme.subhead),
      ));
      tomorrow.forEach((event) {
        items.add(_makeListItem(event, context));
      });
    }

    if (nextTwoWeeks.length > 0) {
      items.add(Padding(
        padding: EdgeInsets.all(8.0),
        child:
            Text('Next two weeks', style: Theme.of(context).textTheme.subhead),
      ));
      nextTwoWeeks.forEach((event) {
        items.add(_makeListItem(event, context));
      });
    }

    if (afterTwoWeeks.length > 0) {
      items.add(Padding(
        padding: EdgeInsets.all(8.0),
        child: Text('Later', style: Theme.of(context).textTheme.subhead),
      ));
      afterTwoWeeks.forEach((event) {
        items.add(_makeListItem(event, context));
      });
    }

    return items;
  }

  Widget _makeListItem(Event event, context) {
    return Card(
      // elevation: 0.0,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: new Row(
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
    );
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
}
