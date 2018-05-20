import 'dart:async';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'theme.dart';
import 'model.dart';
import 'view/event_list.dart';

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

class MyHomePage extends StatefulWidget {
  @override
  MyHomePageState createState() {
    return new MyHomePageState();
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
}

class MyHomePageState extends State<MyHomePage> {
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
            onSelected: widget._overflowItemSelected,
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
            return EventList(snapshot.data);
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
        onTap: widget._navItemTapped,
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
}
