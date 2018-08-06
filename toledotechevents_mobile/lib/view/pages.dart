import 'package:flutter/material.dart';
import 'package:toledotechevents_mobile/view/animated_page.dart';
import 'package:toledotechevents_mobile/providers.dart';
import 'package:toledotechevents_mobile/resources.dart';
import 'package:toledotechevents_mobile/view/event_list.dart';
import 'package:toledotechevents_mobile/view/event_details.dart';
import 'package:toledotechevents_mobile/view/venue_list.dart';
import 'package:toledotechevents_mobile/view/venue_details.dart';

/// Creates the [EventListProvider] and listens to its stream, passing new data
/// to the [EventListView] that actually displays the list.
class EventListPage extends StatefulWidget {
  EventListPage(this.pageData);
  final PageLayoutData pageData;
  @override
  _EventListPageState createState() => new _EventListPageState();
}

class _EventListPageState extends State<EventListPage> {
  final bloc = EventListBloc(eventListResource);

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return EventListProvider(
      bloc: bloc,
      child: StreamHandler<EventList>(
        stream: bloc.events,
        handler: (context, events) =>
            AnimatedPage(EventListView(events, widget.pageData)),
      ),
    );
  }
}

/// Creates the [EventDetailsProvider] and listens to its stream, passing new
/// data to the [EventDetailsView] that actually displays the event.
class EventDetailsPage extends StatefulWidget {
  EventDetailsPage(this.pageData);
  final PageLayoutData pageData;
  @override
  _EventDetailsPageState createState() => new _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  final bloc = EventDetailsBloc();

  void initBloc() {
    // TODO manage bloc state correctly.

    // TODO move to bloc
    final event = widget.pageData.args['event'];
    if (event is EventListItem) {
      bloc.request.add(EventDetailsRequest(
        event: event,
        resource: EventDetailsResource(event.id),
      ));
    } else if (event is int) {
      bloc.request.add(EventDetailsRequest(
        id: event,
        resource: EventDetailsResource(event),
      ));
    }
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return EventDetailsProvider(
      bloc: bloc,
      child: StreamHandler<EventDetails>(
        stream: bloc.details,
        handler: (context, event) => event.venue != null
            ? VenueListProvider(
                bloc: VenueListBloc(venueListResource),
                child: EventDetailsView(event, widget.pageData),
              )
            : EventDetailsView(event, widget.pageData),
      ),
    );
  }
}

/// Creates the [VenueListProvider] and listens to its stream, passing new data
/// to the [VenueListView] that actually displays the list.
class VenueListPage extends StatefulWidget {
  VenueListPage(this.pageData);
  final PageLayoutData pageData;
  @override
  _VenueListPageState createState() => new _VenueListPageState();
}

class _VenueListPageState extends State<VenueListPage> {
  final bloc = VenueListBloc(venueListResource);

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VenueListProvider(
      bloc: bloc,
      child: StreamHandler<VenueList>(
        stream: bloc.venues,
        handler: (context, venues) =>
            AnimatedPage(VenueListView(venues, widget.pageData)),
      ),
    );
  }
}

/// Creates the [VenueDetailsProvider] and listens to its stream, passing new
/// data to the [VenueDetailsView] that actually displays the venue.
class VenueDetailsPage extends StatefulWidget {
  VenueDetailsPage(this.pageData);
  final PageLayoutData pageData;
  @override
  _VenueDetailsPageState createState() => new _VenueDetailsPageState();
}

class _VenueDetailsPageState extends State<VenueDetailsPage> {
  final bloc = VenueDetailsBloc();

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VenueDetailsProvider(
      bloc: bloc,
      child: StreamHandler<VenueDetails>(
        stream: bloc.details,
        handler: (context, venue) => VenueDetailsView(venue, widget.pageData),
      ),
    );
  }
}
