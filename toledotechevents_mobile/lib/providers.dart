import 'dart:async';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:toledotechevents/bloc/app_bloc.dart';

export 'package:toledotechevents/bloc/app_bloc.dart';
export 'package:toledotechevents_mobile/util/async_handlers.dart';

class AppDataProvider extends InheritedWidget {
  AppDataProvider({Key key, @required this.bloc, @required Widget child})
      : super(key: key, child: child);

  final AppBloc bloc;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static AppBloc of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(AppDataProvider) as AppDataProvider)
          .bloc;
}
