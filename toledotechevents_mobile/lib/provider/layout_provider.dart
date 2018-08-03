import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:toledotechevents/bloc/layout_bloc.dart';

export 'package:toledotechevents/bloc/layout_bloc.dart';

class LayoutProvider extends InheritedWidget {
  LayoutProvider({Key key, @required this.layoutBloc, @required Widget child})
      : super(key: key, child: child);

  final LayoutBloc layoutBloc;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static LayoutBloc of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(LayoutProvider) as LayoutProvider)
          .layoutBloc;
}
