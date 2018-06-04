import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import '../model.dart';
import '../theme.dart';
import 'event_listitem.dart';
import 'event_details.dart';

class EventList extends StatefulWidget {
  final List<Event> events;
  EventList(this.events);
  @override
  State<EventList> createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  Event _selectedEvent;

  Future<Null> refresh() async {
    widget.events.clear();
    widget.events.addAll(await getEvents(forceReload: true));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: refresh,
        child: ListView(children: _buildEventList(context)));
  }

  List<Widget> _buildEventList(BuildContext context) {
    var items = List<Widget>();
    var now = DateTime.now();
    var twoWeeks = now.add(Duration(days: 15)); // 15 intended.

    var today = List<Event>();
    var tomorrow = List<Event>();
    var nextTwoWeeks = List<Event>();
    var afterTwoWeeks = List<Event>();

    widget.events.forEach((e) {
      if (e.occursOnDay(now)) today.add(e);
      if (e.occursOnDay(now.add(Duration(days: 1)))) tomorrow.add(e);
      if (e.occursOnDayInRange(now.add(Duration(days: 2)), twoWeeks))
        nextTwoWeeks.add(e);
      if (e.occursOnOrAfterDay(twoWeeks)) afterTwoWeeks.add(e);
    });

    void addItems(String name, List<Event> events) {
      if (events.length > 0) {
        items.add(
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(name, style: Theme.of(context).textTheme.subhead),
          ),
        );
        events.asMap().forEach((i, event) {
          items.add(
            EventListItem(
              event,
              color: i % 2 == 0 ? kBackgroundColor : kDividerColor,
              elevation: _selectedEvent == event ? 8.0 : 0.0,
              onTap: () => _cardTapped(event, context),
            ),
          );
        });
      }
    }

    items.add(
      Center(
        child: Padding(
          padding: EdgeInsets.all(0.0),
          child: Text("What's happening?",
              style: Theme.of(context).textTheme.headline),
        ),
      ),
    );
    addItems('Today', today);
    addItems('Tomorrow', tomorrow);
    addItems('Next two weeks', nextTwoWeeks);
    addItems('Later', afterTwoWeeks);

    return items;
  }

  void _cardTapped(Event event, BuildContext context) async {
    // timeDilation = 10.0;
    setState(() => _selectedEvent = _selectedEvent == event ? null : event);
    if (_selectedEvent != null) {
      // Navigator.of(context).widget.observers.add(IntermediateRouteObserver(() {
      //   Navigator
      //       .push(context,
      //           DetailsRoute(builder: (context) => EventDetails(event)))
      //       .then((_) => Navigator.pop(context));
      // }));
      await Future.delayed(Duration(milliseconds: 250));
      // Navigator.of(context).
      await Navigator.push(
        context,
        FadePageRoute(builder: (context) => EventDetails(_selectedEvent)),
        // IntermediateRoute(
        //   builder: (context) => EventListItem(
        //         _selectedEvent,
        //         key: Key('event-intermediate-${event.id}'),
        //         elevation: 8.0,
        //         onTap: () {},
        //       ),
        // onComplete: (_) {
        //
        // }
      );
      await Future.delayed(Duration(milliseconds: 400));
      setState(() => _selectedEvent = null);
    }
  }
}

// class IntermediateRouteObserver extends NavigatorObserver {
//   final onDidPush;
//   IntermediateRouteObserver(this.onDidPush);
//   @override
//   void didPush(Route route, Route previousRoute) {
//     if (route is IntermediateRoute) onDidPush();
//     super.didPush(route, previousRoute);
//   }
// }

// class IntermediateRoute extends MaterialPageRoute {
//   IntermediateRoute({@required WidgetBuilder builder})
//       : super(builder: builder);
//   @override
//   Widget buildTransitions(BuildContext context, Animation<double> animation,
//       Animation<double> secondaryAnimation, Widget child) {
//     return child;
//   }
// }

// class DetailsRoute extends MaterialPageRoute {
//   DetailsRoute({@required WidgetBuilder builder}) : super(builder: builder);
//   @override
//   Widget buildTransitions(BuildContext context, Animation<double> animation,
//       Animation<double> secondaryAnimation, Widget child) {
//     return child;
//   }
// }
