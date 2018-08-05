import 'dart:async';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:toledotechevents/bloc/theme_bloc.dart';
import 'package:toledotechevents/bloc/page_bloc.dart';
import 'package:toledotechevents/bloc/event_list_bloc.dart';
import 'package:toledotechevents/bloc/event_details_bloc.dart';
import 'package:toledotechevents/bloc/venue_list_bloc.dart';
import 'package:toledotechevents/bloc/venue_details_bloc.dart';

export 'package:toledotechevents/bloc/theme_bloc.dart';
export 'package:toledotechevents/bloc/page_bloc.dart';
export 'package:toledotechevents/bloc/event_list_bloc.dart';
export 'package:toledotechevents/bloc/event_details_bloc.dart';
export 'package:toledotechevents/bloc/venue_list_bloc.dart';
export 'package:toledotechevents/bloc/venue_details_bloc.dart';

export 'package:toledotechevents_mobile/util/async_handlers.dart';

class ThemeProvider extends InheritedWidget {
  ThemeProvider({Key key, @required this.bloc, @required Widget child})
      : super(key: key, child: child);

  final ThemeBloc bloc;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static ThemeBloc of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(ThemeProvider) as ThemeProvider)
          .bloc;
}

class LayoutProvider extends InheritedWidget {
  LayoutProvider({Key key, @required this.bloc, @required Widget child})
      : super(key: key, child: child);

  final PageLayoutBloc bloc;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static PageLayoutBloc of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(LayoutProvider) as LayoutProvider)
          .bloc;
}

class EventListProvider extends InheritedWidget {
  EventListProvider({Key key, @required this.bloc, @required Widget child})
      : super(key: key, child: child);

  final EventListBloc bloc;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static EventListBloc of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(EventListProvider)
              as EventListProvider)
          .bloc;
}

class EventDetailsProvider extends InheritedWidget {
  EventDetailsProvider({Key key, @required this.bloc, @required Widget child})
      : super(key: key, child: child);

  final EventDetailsBloc bloc;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static EventDetailsBloc of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(EventDetailsProvider)
              as EventDetailsProvider)
          .bloc;
}

class VenueListProvider extends InheritedWidget {
  VenueListProvider({Key key, @required this.bloc, @required Widget child})
      : super(key: key, child: child);

  final VenueListBloc bloc;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static VenueListBloc of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(VenueListProvider)
              as VenueListProvider)
          .bloc;
}

class VenueDetailsProvider extends InheritedWidget {
  VenueDetailsProvider({Key key, @required this.bloc, @required Widget child})
      : super(key: key, child: child);

  final VenueDetailsBloc bloc;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static VenueDetailsBloc of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(VenueDetailsProvider)
              as VenueDetailsProvider)
          .bloc;
}
