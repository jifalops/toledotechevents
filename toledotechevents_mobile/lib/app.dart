import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

import 'package:toledotechevents/build_config.dart';
import 'package:toledotechevents/theme.dart' as base;

import 'package:toledotechevents_mobile/util/bloc_state.dart';
import 'package:toledotechevents_mobile/theme.dart';
import 'package:toledotechevents_mobile/resources.dart';
import 'package:toledotechevents_mobile/providers.dart';
import 'package:toledotechevents_mobile/view/pages.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends BlocState<App> {
  AppBloc bloc;
  bool checkDisplayMedia;

  @override
  Widget build(BuildContext context) {
    if (checkDisplayMedia) {
      final media = MediaQuery.of(context);
      bloc.displayRequest
          .add(Display(height: media.size.height, width: media.size.width));
      checkDisplayMedia = false;
    }
    return AppDataProvider(
      bloc: bloc,
      child: StreamHandler<base.Theme>(
        stream: bloc.theme,
        handler: (context, theme) => MaterialApp(
              title: config.title,
              theme: buildTheme(theme),
              home: AppPage(),
            ),
      ),
    );
  }

  @override
  void initBloc() {
    bloc = AppBloc(
        themeResource: resources.theme,
        eventsResource: resources.eventList,
        venuesResource: resources.venueList);
    checkDisplayMedia = true;
  }

  @override
  void disposeBloc() {
    bloc.dispose();
  }
}

class AppPage extends StatefulWidget {
  @override
  _AppPageState createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  PageData pageData, prevPageData;

  @override
  Widget build(BuildContext context) {
    return StreamHandler<PageData>(
        stream: AppDataProvider.of(context).page,
        handler: (context, data) {
          pageData = data;
          Widget page = _navigateOrRebuildPage(context);
          prevPageData = pageData;
          return page;
        });
  }

  Widget _navigateOrRebuildPage(BuildContext context) {
    if (prevPageData == null ||
        pageData.page == prevPageData.page ||
        pageData.layout.nav.contains(pageData.page)) {
      return _buildPage(context);
    } else {
      Navigator.of(context).push(NoAnimationRoute(
        builder: (context) => _buildPage(context),
      ));
      return NullWidget();
    }
  }

  Widget _buildPage(BuildContext context) {
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
        return EventFormPage(pageData);
      case Page.about:
        return AboutPage(pageData);
      case Page.spamRemover:
        return SpamListPage(pageData);
      default:
        assert(false);
        return NullWidget();
    }
  }
}
