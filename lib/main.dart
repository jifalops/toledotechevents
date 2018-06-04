import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_html_view/flutter_html_view.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'theme.dart';
import 'model.dart';
import 'view/event_list.dart';
import 'view/venue_list.dart';
import 'view/create_event.dart';
import 'view/app_bar.dart';
import 'view/animated_page.dart';

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
}

class MyHomePageState extends State<MyHomePage> {
  int _selectedPage = 0;

  @override
  Widget build(BuildContext context) {
    // timeDilation = 10.0;
    return new Scaffold(
      appBar: getAppBar(context),
      body: _getBody(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedPage,
        iconSize: 24.0,
        onTap: (index) => setState(() => _selectedPage = index),
        items: [
          BottomNavigationBarItem(
            title: Text('Events', style: Theme.of(context).textTheme.button),
            icon: Icon(Icons.event),
          ),
          BottomNavigationBarItem(
            title: Text('New', style: Theme.of(context).textTheme.button),
            icon: Icon(Icons.add_circle_outline),
          ),
          BottomNavigationBarItem(
            title: Text('Venues', style: Theme.of(context).textTheme.button),
            icon: Icon(Icons.business),
          ),
          BottomNavigationBarItem(
            title: Text('About', style: Theme.of(context).textTheme.button),
            icon: Icon(Icons.help),
          ),
        ],
      ),
    );
  }

  Widget _getBody() {
    switch (_selectedPage) {
      // Add new event
      case 1:
        // return CreateEventForm();
        return FutureBuilder<String>(
          future: getNewEventAuthToken(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return AnimatedPage(CreateEventForm(snapshot.data));
            } else if (snapshot.hasError) {
              return new Text('${snapshot.error}');
            }
            return Center(child: CircularProgressIndicator());
          },
        );
      // Venues list
      case 2:
        return FutureBuilder<List<Venue>>(
          future: getVenues(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return AnimatedPage(VenueList(snapshot.data));
            } else if (snapshot.hasError) {
              return new Text('${snapshot.error}');
            }
            return Center(child: CircularProgressIndicator());
          },
        );
      // About page
      case 3:
        return FutureBuilder<String>(
          future: getAboutSectionHtml(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SingleChildScrollView(
                child: AnimatedPage(HtmlView(data: snapshot.data)),
              );
            } else if (snapshot.hasError) {
              return new Text('${snapshot.error}');
            }
            return Center(child: CircularProgressIndicator());
          },
        );
      // Event list
      case 0:
      default:
        return FutureBuilder<List<Event>>(
          future: getEvents(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return AnimatedPage(EventList(snapshot.data));
            } else if (snapshot.hasError) {
              return new Text('${snapshot.error}');
            }
            return Center(child: CircularProgressIndicator());
          },
        );
    }
  }
}
