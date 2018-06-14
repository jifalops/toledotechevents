import 'package:flutter/material.dart';
import '../model.dart';
import '../theme.dart';

class EventListItem extends StatelessWidget {
  final Event event;
  final Color color;
  final double elevation;
  final Function onTap;
  EventListItem(this.event,
      {this.color: kBackgroundColor,
      this.elevation: 0.0,
      @required this.onTap,
      Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
    Hero(
      tag: 'event-${event.id}',
      child:
      Card(
        elevation: elevation,
        color: color,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Hero(
                  tag: 'event-title-${event.id}',
                  child:
                Text(
                  event.title,
                  style: Theme.of(context).textTheme.body2,
                  maxLines: 2,
                  overflow: TextOverflow.fade,
                ),
                ),
                Hero(
                  tag: 'event-venue-title-${event.id}',
                  child:
                Text(
                  event.venue.title,
                  style: Theme.of(context).textTheme.caption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                ),
                SizedBox(height: 4.0),
                Hero(
                  tag: 'event-times-${event.id}',
                  child:
                _buildEventTimeRange(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEventTimeRange(BuildContext context) {
    final startDay = formatDay(event.startTime);
    final startDate = formatDate(event.startTime);
    final startTime = formatTime(event.startTime, ampm: !event.isOneDay);
    final endTime = formatTime(event.endTime, ampm: true);

    return event.isOneDay
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('$startDay, $startDate'),
              Text('$startTime – $endTime',
                  style: Theme.of(context).textTheme.caption),
            ],
          )
        : Column(
            children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('$startDay, $startDate'),
                    Text('$startTime',
                        style: Theme.of(context).textTheme.caption),
                  ]),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                      '${formatDay(event.endTime)}, ${formatDate(event.endTime)}'),
                  Text('$endTime', style: Theme.of(context).textTheme.caption),
                ],
              ),
            ],
          );
  }
}
