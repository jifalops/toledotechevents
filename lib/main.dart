import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_html_view/flutter_html_view.dart';

import 'colors.dart';
import 'data.dart';
import 'model/event.dart';
import 'model/venue.dart';

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
    // textTheme: _buildTextTheme(base.textTheme),
    // primaryTextTheme: _buildTextTheme(base.primaryTextTheme),
    // accentTextTheme: _buildTextTheme(base.accentTextTheme),
  );
}

TextTheme _buildTextTheme(TextTheme base) {
  return base
      .copyWith(
        headline: base.headline.copyWith(
          fontWeight: FontWeight.w500,
        ),
        title: base.title.copyWith(fontSize: 18.0),
        caption: base.caption.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: 14.0,
        ),
        body2: base.body2.copyWith(
          fontWeight: FontWeight.w500,
          fontSize: 16.0,
        ),
      )
      .apply(
        fontFamily: 'Open Sans',
        displayColor: kTextColorOnPrimary,
        bodyColor: kPrimaryColorDark,
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
  int _counter = 0;

  // List<Event> _events;
  // List<Venue> _venues;

  _MyHomePageState() {}

  Future<List<Event>> getData() async {
    var venues = await getVenues();
    var events = await getEvents();
    events.forEach((event) {
      event.setVenue(venues);
      print(event);
    });
    return events;
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

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
          Text('Tech Events', style: TextStyle(color: kSecondaryColor)),
        ],
      )),
      body: new FutureBuilder<List<Event>>(
        future: getData(),
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
                    HtmlView(data: event.content),
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
