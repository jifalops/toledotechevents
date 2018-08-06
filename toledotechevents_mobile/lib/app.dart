import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

import 'package:toledotechevents/build_config.dart';

import 'package:toledotechevents_mobile/theme.dart';
import 'package:toledotechevents_mobile/resources.dart';
import 'package:toledotechevents_mobile/providers.dart' hide Color, Theme;
import 'package:toledotechevents_mobile/view/page_layout.dart';
import 'package:toledotechevents_mobile/view/pages.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  ThemeBloc themeBloc;
  PageLayoutBloc pageBloc;
  EventListBloc eventsBloc;
  VenueListBloc venuesBloc;

  /// Page layout is dependent on the theme. The connection between their blocs
  /// must be setup and torn down with the widget's state.
  StreamSubscription themeSubscription;
  bool checkDisplayMedia;

  @override
  Widget build(BuildContext context) {
    if (checkDisplayMedia) {
      final media = MediaQuery.of(context);
      themeBloc.display
          .add(Display(height: media.size.height, width: media.size.width));
      checkDisplayMedia = false;
    }
    return AppDataProvider(
      themeBloc: themeBloc,
      pageBloc: pageBloc,
      eventsBloc: eventsBloc,
      venuesBloc: venuesBloc,
      child: StreamHandler<DisplayTheme>(
        stream: themeBloc.displayTheme,
        handler: (context, displayTheme) => MaterialApp(
              title: config.title,
              theme: buildTheme(displayTheme.theme),
              home: PageNavigator(),
            ),
      ),
    );
  }

  void initBloc() {
    themeBloc = ThemeBloc(themeResource);
    pageBloc = PageLayoutBloc();
    themeSubscription = themeBloc.displayTheme.listen(pageBloc.display.add);
    eventsBloc = EventListBloc(eventListResource);
    venuesBloc = VenueListBloc(venueListResource);
  }

  void disposeBloc() {
    themeBloc.dispose();
    themeSubscription.cancel();
    pageBloc.dispose();
    eventsBloc.dispose();
    venuesBloc.dispose();
  }

  @override
  void initState() {
    super.initState();
    initBloc();
    checkDisplayMedia = true;
  }

  @override
  void dispose() {
    disposeBloc();
    super.dispose();
  }

  @override
  void didUpdateWidget(App oldWidget) {
    super.didUpdateWidget(oldWidget);
    disposeBloc();
    initBloc();
  }
}

class PageNavigator extends StatefulWidget {
  @override
  _PageNavigatorState createState() => _PageNavigatorState();
}

class _PageNavigatorState extends State<PageNavigator> {
  PageLayoutData pageData, prevPageData;

  @override
  Widget build(BuildContext context) {
    return StreamHandler<PageLayoutData>(
        stream: AppDataProvider.of(context).pageBloc.pageLayout,
        handler: (context, data) {
          pageData = data;
          Widget page = _handleLayout(context);
          prevPageData = pageData;
          return page;
        });
  }

  Widget _handleLayout(BuildContext context) {
    if (prevPageData == null ||
        pageData.page == prevPageData.page ||
        pageData.layout.nav.contains(pageData.page)) {
      return PageLayoutView(pageData, _buildBody);
    } else {
      Navigator.of(context).push(NoAnimationRoute(
        builder: (context) => PageLayoutView(pageData, _buildBody),
      ));
      return NullWidget();
    }
  }

  Widget _buildBody(BuildContext context) {
    switch (pageData.page) {
      case Page.eventList:
        return EventListPage(pageData);
      case Page.eventDetails:
        return EventDetailsPage(pageData);
      case Page.venuesList:
        return VenueListPage(pageData);
      case Page.venueDetails:
        return VenueDetailsPage(pageData);
      case Page.createEvent:
        return CreateEventPage(pageData);
      case Page.about:
        return AboutPage(pageData);
      case Page.spamRemover:
        return SpamRemoverPage(pageData);
      default:
        assert(false);
        return NullWidget();
    }
  }
}
