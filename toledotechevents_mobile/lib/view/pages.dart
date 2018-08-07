import 'package:flutter/material.dart';
import 'package:toledotechevents/bloc/event_details_bloc.dart';
import 'package:toledotechevents/bloc/venue_details_bloc.dart';
import 'package:toledotechevents_mobile/util/bloc_state.dart';
import 'package:toledotechevents_mobile/view/animated_page.dart';
import 'package:toledotechevents_mobile/providers.dart';
import 'package:toledotechevents_mobile/resources.dart';
import 'package:toledotechevents_mobile/view/event_list.dart';
import 'package:toledotechevents_mobile/view/event_details.dart';
import 'package:toledotechevents_mobile/view/venue_list.dart';
import 'package:toledotechevents_mobile/view/venue_details.dart';

/// Builds [EventListView]s as [EventList]s come from the [AppBloc.events]
/// stream.
class EventListPage extends StatelessWidget {
  EventListPage(this.pageData);
  final PageData pageData;
  @override
  Widget build(BuildContext context) {
    return StreamHandler<EventList>(
      stream: AppDataProvider.of(context).events,
      handler: (context, events) =>
          AnimatedPage(EventListView(events, pageData)),
    );
  }
}

/// Builds [EventDetailsView]s as [EventDetails]s come from the
/// [EventDetailsBloc.details] stream.
class EventDetailsPage extends StatefulWidget {
  EventDetailsPage(this.pageData);
  final PageData pageData;
  @override
  _EventDetailsPageState createState() => new _EventDetailsPageState();
}

class _EventDetailsPageState extends BlocState<EventDetailsPage> {
  EventDetailsBloc bloc;

  @override
  Widget build(BuildContext context) {
    return StreamHandler<EventDetails>(
      stream: bloc.details,
      handler: (context, event) => EventDetailsView(event, widget.pageData),
    );
  }

  @override
  void initBloc() {
    bloc = EventDetailsBloc();
    bloc.args.add(widget.pageData.args);
  }

  @override
  void disposeBloc() {
    bloc.dispose();
  }
}

/// Builds [VenueListView]s as [VenueList]s come from the [AppBloc.venues]
/// stream.
class VenueListPage extends StatelessWidget {
  VenueListPage(this.pageData);
  final PageData pageData;
  @override
  Widget build(BuildContext context) {
    return StreamHandler<VenueList>(
      stream: AppDataProvider.of(context).venues,
      handler: (context, venues) =>
          AnimatedPage(VenueListView(venues, pageData)),
    );
  }
}

/// Builds [VenueDetailsView]s as [VenueDetails]s come from the
/// [VenueDetailsBloc.details] stream.
class VenueDetailsPage extends StatefulWidget {
  VenueDetailsPage(this.pageData);
  final PageData pageData;
  @override
  _VenueDetailsPageState createState() => new _VenueDetailsPageState();
}

class _VenueDetailsPageState extends BlocState<VenueDetailsPage> {
  VenueDetailsBloc bloc;

  @override
  Widget build(BuildContext context) {
    return StreamHandler<VenueDetails>(
      stream: bloc.details,
      handler: (context, venue) => VenueDetailsView(venue, widget.pageData),
    );
  }

  @override
  void initBloc() {
    bloc = VenueDetailsBloc();
    bloc.args.add(widget.pageData.args);
  }

  @override
  void disposeBloc() {
    bloc.dispose();
  }
}
