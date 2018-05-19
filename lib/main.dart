import 'dart:async';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html_view/flutter_html_view.dart';

import 'colors.dart';
import 'data.dart';
import 'model/event.dart';

const kSubscribeGoogleCalenderUrl =
    'http://www.google.com/calendar/render?cid=http%3A%2F%2Ftoledotechevents.org%2Fevents.ics';
const kSubscribeICalendarUrl = 'webcal://toledotechevents.org/events.ics';
const kFileIssueUrl = 'http://github.com/jmslagle/calagator/issues';
const kForumUrl = 'http://groups.google.com/group/tol-calagator/';

String pastEventsUrl() {
  var now = DateTime.now();
  var fmt = new DateFormat('yyyy-MM-dd');
  return 'http://toledotechevents.org/events?utf8=%E2%9C%93&date%5Bstart%5D=' +
      fmt.format(now.subtract(Duration(days: 30))) +
      '&date%5Bend%5D=' +
      fmt.format(now) +
      '&time%5Bstart%5D=&time%5Bend%5D=&commit=Filter';
}

void main() => runApp(new MyApp());

final ThemeData _kTheme = _buildTheme();

ThemeData _buildTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    accentColor: kSecondaryColor,
    primaryColor: kPrimaryColor,
    buttonColor: kSecondaryColor,
    scaffoldBackgroundColor: kBackgroundColor,
    cardColor: kBackgroundColor,
    textSelectionColor: kPrimaryColorLight,
    errorColor: kErrorColor,
    dividerColor: kDividerColor,
    backgroundColor: kBackgroundColor,
    primaryColorDark: kPrimaryColorDark,
    primaryColorLight: kPrimaryColorLight,
    textSelectionHandleColor: kPrimaryColorDark,
    buttonTheme: ButtonThemeData(
      textTheme: ButtonTextTheme.accent,
    ),
    // primaryIconTheme: base.iconTheme.copyWith(color: kShrineBrown900),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(),
    ),
    textTheme: _buildTextTheme(base.textTheme),
    primaryTextTheme: _buildTextTheme(base.primaryTextTheme),
    accentTextTheme: _buildTextTheme(base.accentTextTheme),
  );
}

TextTheme _buildTextTheme(TextTheme base) {
  return base.copyWith(
    title:
        base.title.copyWith(fontWeight: FontWeight.w700, fontFamily: 'Ubuntu'),
    body1: base.body1.copyWith(fontFamily: 'Open Sans'),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Toledo Tech Events',
      theme: _kTheme,
      home: new MyHomePage(title: 'Toledo Tech Events'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return new Scaffold(
      appBar: new AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Row(
        children: <Widget>[
          Text('Toledo'),
          SizedBox(width: 3.0),
          Text('Tech Events', style: TextStyle(color: kSecondaryColor)),
        ],
      )),
      body: new FutureBuilder<List<Event>>(
        future: loadEvents(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return new ListView(
              children: _buildEvents(context, snapshot.data),
            );
            // return new Text(snapshot.data.title);
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
            title: Text('Add'),
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

  void _navItemTapped(int index) {
    print('Bottomnav $index');
  }

  List<Widget> _buildEvents(BuildContext context, List<Event> events) {
    var items = List<Widget>();
    events.forEach(
      (event) => items.add(
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    Text(event.toString()),
                    HtmlView(data: event.contentHtml),
                  ],
                ),
              ),
            ),
          ),
    );
    return items;
  }

  // List<Widget> _buildVenues(BuildContext context) {
  //   var items = List<Widget>();
  //   for (var prop in _venues) {
  //     // items.add(prop);
  //   }
  //   return items;
  // }
}
