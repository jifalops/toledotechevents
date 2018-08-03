import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:toledotechevents/bloc/theme_bloc.dart';

export 'package:toledotechevents/bloc/theme_bloc.dart';

class ThemeProvider extends InheritedWidget {
  ThemeProvider({Key key, @required this.themeBloc, @required Widget child})
      : super(key: key, child: child);

  final ThemeBloc themeBloc;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static ThemeBloc of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(ThemeProvider) as ThemeProvider)
          .themeBloc;
}
