import 'dart:async';

import 'package:flutter/material.dart';

import 'theme.dart';
import 'model.dart';
import 'view/event_list.dart';
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
