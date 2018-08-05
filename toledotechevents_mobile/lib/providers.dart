import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:toledotechevents/bloc/theme_bloc.dart';
import 'package:toledotechevents/bloc/layout_bloc.dart';
import 'package:toledotechevents/bloc/event_list_bloc.dart';
import 'package:toledotechevents/bloc/event_details_bloc.dart';

export 'package:toledotechevents/bloc/theme_bloc.dart';
export 'package:toledotechevents/bloc/layout_bloc.dart';
export 'package:toledotechevents/bloc/event_list_bloc.dart';
export 'package:toledotechevents/bloc/event_details_bloc.dart';

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

  final LayoutBloc bloc;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static LayoutBloc of(BuildContext context) =>
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
