import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

import 'package:toledotechevents/build_config.dart';

import 'package:toledotechevents_mobile/theme.dart';
import 'package:toledotechevents_mobile/resources.dart';
import 'package:toledotechevents_mobile/providers.dart' hide Color, Theme;
import 'package:toledotechevents_mobile/view/layout.dart';
import 'package:toledotechevents_mobile/view/pages.dart';

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
        bloc: themeBloc,
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
  final PageLayoutBloc bloc = PageLayoutBloc();

  PageLayout data, previous;

  PageNavigatorState() {
    widget.themeStream.listen(bloc.display.add);
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _handleNavigatorPop,
      child: LayoutProvider(
          bloc: bloc,
          child: StreamBuilder<PageLayout>(
              stream: bloc.pageLayout,
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
        return EventListPage(data);
      case Page.eventDetails:
        return EventDetailsPage(data);
      case Page.venuesList:
        return VenueListPage(data);
      case Page.venueDetails:
        return VenueDetailsPage(data);
      case Page.createEvent:
        return CreateEventPage(data);
      case Page.about:
        return AboutPage(data);
      case Page.spamRemover:
        return SpamRemoverPage(data);
      default:
        assert(false);
        return NullWidget();
    }
  }
}
