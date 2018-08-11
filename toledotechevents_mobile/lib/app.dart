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

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('Initializing resources...');
    return FutureHandler(
      future: getResources(),
      handler: (context, resources) => AppWithResources(resources),
    );
  }
}

class AppWithResources extends StatefulWidget {
  AppWithResources(this.resources);
  final Resources resources;
  @override
  State<StatefulWidget> createState() => _AppWithResourcesState();
}

class _AppWithResourcesState extends BlocState<AppWithResources> {
  AppBloc bloc;

  @override
  Widget build(BuildContext context) {
    return AppDataProvider(
      bloc: bloc,
      child: StreamHandler<base.Theme>(
          stream: bloc.theme,
          handler: (context, theme) {
            print('Building app...');
            return MaterialApp(
              title: config.title,
              theme: buildTheme(theme),
              home: AppPage(),
            );
          }),
    );
  }

  @override
  void initBloc() {
    bloc = AppBloc(widget.resources);
    final media = MediaQueryData();
    bloc.displayRequest
        .add(Display(height: media.size.height, width: media.size.width));
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
      print('Skipping navigation.');
      return _buildPage(context);
    } else {
      print('Using navigation.');
      Navigator.of(context).push(NoAnimationRoute(
        builder: (context) => _buildPage(context),
      ));
      return NullWidget();
    }
  }

  Widget _buildPage(BuildContext context) {
    switch (pageData.page) {
      case Page.eventList:
        print('Building EventListPage...');
        return EventListPage(pageData);
      case Page.eventDetails:
        print('Building EventDetailsPage...');
        return EventDetailsPage(pageData);
      case Page.venuesList:
        print('Building VenueListPage...');
        return VenueListPage(pageData);
      case Page.venueDetails:
        print('Building VenueDetailsPage...');
        return VenueDetailsPage(pageData);
      case Page.createEvent:
        print('Building EventFormPage...');
        return EventFormPage(pageData);
      case Page.about:
        print('Building AboutPage...');
        return AboutPage(pageData);
      case Page.spamRemover:
        print('Building SpamListPage...');
        return SpamListPage(pageData);
      default:
        assert(false);
        return NullWidget();
    }
  }
}
