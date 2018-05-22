import 'dart:async';

import 'package:flutter/material.dart';

import 'theme.dart';
import 'model.dart';
import 'view/event_list.dart';
import 'view/app_bar.dart';
import 'view/bottom_nav.dart';

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
      bottomNavigationBar: getBottomNav(
          context, (index) => setState(() => _selectedPage = index)),
    );
  }

  Widget _getBody() {
    switch (_selectedPage) {
      // Add new event
      case 1:
        return Text('Add new event');
      // Venues list
      case 2:
        return Text('Venue list');
      // About page
      case 3:
        return Text('About');
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
            // By default, show a loading spinner
            return Center(child: CircularProgressIndicator());
          },
        );
    }
  }
}
