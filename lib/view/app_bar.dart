import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../model.dart';
import '../theme.dart';

AppBar getAppBar(BuildContext context) {
  return AppBar(
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
        itemBuilder: (context) {
          return [
            PopupMenuItem(
              child: Text('See past events'),
              value: {'context': context, 'url': pastEventsUrl()},
            ),
            PopupMenuItem(
              child: Text('Subscribe to Google Calendar'),
              value: {'context': context, 'url': kSubscribeGoogleCalenderUrl},
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
