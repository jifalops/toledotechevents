
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Main Screen'),
      ),
      body: new GestureDetector(
        child: new Hero(
          tag: 'imageHero',
          child: new Image.network(
            'https://raw.githubusercontent.com/flutter/website/master/_includes/code/layout/lakes/images/lake.jpg',
          ),
        ),
        onTap: () {
          Navigator.push(context, new MaterialPageRoute(builder: (_) {
            return new DetailScreen();
          }));
        },
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new GestureDetector(
        child: new Center(
          child: new Hero(
            tag: 'imageHero',
            child: new Image.network(
              'https://raw.githubusercontent.com/flutter/website/master/_includes/code/layout/lakes/images/lake.jpg',
            ),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}