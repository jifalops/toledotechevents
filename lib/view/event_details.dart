import 'package:flutter_html_view/flutter_html_view.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model.dart';
import '../theme.dart';

class EventDetails extends StatelessWidget {
  final Event event;

  EventDetails(this.event);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Event details'),
      ),
      body: Card(
        key: Key('${event.id}'),
        elevation: 0.0,
        child: Padding(
          padding: EdgeInsets.all(4.0),
          child: Row(
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
                    Hero(
                        tag: 'dateHero2',
                        child: Text(_formatDay(event.startTime))),
                    Text(_formatDate(event.startTime)),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Column(
                    children: <Widget>[
                      Hero(
                        tag: 'infoHero2',
                        child: Text(
                          event.title,
                          style: Theme.of(context).textTheme.body2,
                          maxLines: 1,
                          // softWrap: true,
                          overflow: TextOverflow.fade,
                        ),
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
      ),
    );
  }
}

String _formatDay(DateTime dt) => DateFormat('EEEE').format(dt);
String _formatDate(DateTime dt) => DateFormat('MMM d').format(dt);
String _formatTime(DateTime dt, [bool ampm = false]) =>
    DateFormat('h:mm' + (ampm ? 'a' : '')).format(dt);
