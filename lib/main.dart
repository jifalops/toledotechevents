import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_html_view/flutter_html_view.dart';

import 'theme.dart';
import 'model.dart';
import 'view/event_list.dart';
import 'view/venue_list.dart';
import 'view/create_event.dart';
import 'view/app_bar.dart';

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
              return CreateEventForm(snapshot.data);
            } else if (snapshot.hasError) {
              return new Text('${snapshot.error}');
            }
            return Center(child: CircularProgressIndicator());
          },
        );
      // Venues list
      case 2:
        return Text('Venue list');
      // About page
      case 3:
        return FutureBuilder<String>(
          future: getAboutSectionHtml(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SingleChildScrollView(
                child: HtmlView(data: snapshot.data),
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
              return EventList(snapshot.data);
            } else if (snapshot.hasError) {
              return new Text('${snapshot.error}');
            }
            return Center(child: CircularProgressIndicator());
          },
        );
    }
  }
}
