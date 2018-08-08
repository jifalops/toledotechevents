import 'package:flutter/material.dart';
import 'package:flutter_html_view/flutter_html_view.dart';
import 'package:toledotechevents/bloc/event_details_bloc.dart';
import 'package:toledotechevents/bloc/venue_details_bloc.dart';
import 'package:toledotechevents/bloc/about_section_bloc.dart';
import 'package:toledotechevents/bloc/auth_token_bloc.dart';
import 'package:toledotechevents_mobile/util/bloc_state.dart';
import 'package:toledotechevents_mobile/view/animated_page.dart';
import 'package:toledotechevents_mobile/providers.dart';
import 'package:toledotechevents_mobile/resources.dart';
import 'package:toledotechevents_mobile/view/event_list.dart';
import 'package:toledotechevents_mobile/view/event_details.dart';
import 'package:toledotechevents_mobile/view/venue_list.dart';
import 'package:toledotechevents_mobile/view/venue_details.dart';
import 'package:toledotechevents_mobile/view/event_form.dart';
import 'package:toledotechevents_mobile/view/spam_list.dart';

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

/// Builds [HtmlView]s as [AboutSection]s come from the
/// [AboutSectionBloc.about] stream.
class AboutPage extends StatefulWidget {
  AboutPage(this.pageData);
  final PageData pageData;
  @override
  _AboutPageState createState() => new _AboutPageState();
}

class _AboutPageState extends BlocState<AboutPage> {
  AboutSectionBloc bloc;

  @override
  Widget build(BuildContext context) {
    return StreamHandler<AboutSection>(
      stream: bloc.about,
      handler: (context, about) => HtmlView(data: about.html),
    );
  }

  @override
  void initBloc() {
    bloc = AboutSectionBloc(resources.about);
  }

  @override
  void disposeBloc() {
    bloc.dispose();
  }
}

/// Builds [EventFormView]s as [AuthToken]s come from the
/// [AuthTokenBloc.token] stream.
class EventFormPage extends StatefulWidget {
  EventFormPage(this.pageData);
  final PageData pageData;
  @override
  _EventFormPageState createState() => new _EventFormPageState();
}

class _EventFormPageState extends BlocState<EventFormPage> {
  AuthTokenBloc bloc;

  @override
  Widget build(BuildContext context) {
    return StreamHandler<AuthToken>(
      stream: bloc.token,
      handler: (context, token) => EventFormView(token.value, widget.pageData),
    );
  }

  @override
  void initBloc() {
    bloc = AuthTokenBloc(resources.authToken);
  }

  @override
  void disposeBloc() {
    bloc.dispose();
  }
}

/// Builds [SpamListView]s as [VenueList]s come from the [AppBloc.venues]
/// stream.
class SpamListPage extends StatelessWidget {
  SpamListPage(this.pageData);
  final PageData pageData;
  @override
  Widget build(BuildContext context) {
    return StreamHandler<VenueList>(
      stream: AppDataProvider.of(context).venues,
      handler: (context, venues) =>
          AnimatedPage(SpamListView(venues.findSpam(), pageData)),
    );
  }
}