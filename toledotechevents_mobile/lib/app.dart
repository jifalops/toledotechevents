import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_html_view/flutter_html_view.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

import 'provider/theme_provider.dart' hide Theme;
import 'provider/layout_provider.dart' hide Theme;
import 'theme.dart';
import 'view/event_list.dart';
import 'view/venue_list.dart';
import 'view/create_event.dart';
import 'view/app_bar.dart';
import 'view/animated_page.dart';
import 'package:toledotechevents/build_config.dart';
import 'package:toledotechevents/bloc/event_list_bloc.dart';
import 'package:toledotechevents/bloc/event_details_bloc.dart';
import 'package:html/parser.dart' show parse, parseFragment;
import 'package:html/dom.dart' as dom;
import 'package:toledotechevents_mobile/resources.dart';
import 'package:toledotechevents_mobile/view/layout.dart';

class App extends StatefulWidget {
  @override
  AppState createState() {
    return new AppState();
  }
}

class AppState extends State<App> {
  final ThemeBloc themeBloc = ThemeBloc(themeResource);

  @override
  void dispose() {
    themeBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    themeBloc.display
        .add(Display(height: media.size.height, width: media.size.width));

    return ThemeProvider(
        themeBloc: themeBloc,
        child: StreamBuilder<DisplayTheme>(
            stream: themeBloc.displayTheme,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return MaterialApp(
                  title: config.title,
                  theme: buildTheme(snapshot.data.theme),
                  home: PageNavigator(themeBloc.displayTheme),
                );
              } else if (snapshot.hasError) {
                return new Text('${snapshot.error}');
              }
              return Center(child: CircularProgressIndicator());
            }));
  }
}

class PageNavigator extends StatefulWidget {
  final Stream<DisplayTheme> themeStream;

  PageNavigator(this.themeStream);

  @override
  PageNavigatorState createState() {
    return new PageNavigatorState();
  }
}

class PageNavigatorState extends State<PageNavigator> {
  final LayoutBloc layoutBloc = LayoutBloc();

  PageLayout data, previous;

  PageNavigatorState() {
    widget.themeStream.listen(layoutBloc.display.add);
  }

  @override
  void dispose() {
    layoutBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _handleNavigatorPop,
      child: LayoutProvider(
          layoutBloc: layoutBloc,
          child: StreamBuilder<PageLayout>(
              stream: layoutBloc.layoutData,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  data = snapshot.data;
                  Widget page = _handleLayout(context);
                  previous = data;
                  return page;
                } else if (snapshot.hasError) {
                  return new Text('${snapshot.error}');
                }
                return Center(child: CircularProgressIndicator());
              })),
    );
  }

  Widget _handleLayout(BuildContext context) {
    if (previous == null ||
        data.page == previous.page ||
        data.layout.nav.contains(data.page)) {
      return LayoutView(data, _buildBody);
    } else {
      Navigator.of(context).push(
          NoAnimationRoute(builder: (context) => LayoutView(data, _buildBody)));
      return NullWidget();
    }
  }

  Future<bool> _handleNavigatorPop() async {}

  Widget _buildBody(BuildContext context) {
    switch (data.page) {
      case Page.eventList:
        break;
      case Page.eventDetails:
        break;
      case Page.venuesList:
        break;
      case Page.venueDetails:
        break;
      case Page.createEvent:
        break;
      case Page.about:
        break;
      case Page.spamRemover:
        break;
    }
  }
}
