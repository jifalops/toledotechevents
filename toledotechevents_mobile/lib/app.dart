import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_html_view/flutter_html_view.dart';

import 'package:toledotechevents/build_config.dart';
import 'package:toledotechevents/theme.dart' as base;

import 'package:toledotechevents_mobile/util/bloc_state.dart';
import 'package:toledotechevents_mobile/theme.dart';
import 'package:toledotechevents_mobile/resources.dart';
import 'package:toledotechevents_mobile/providers.dart';
import 'package:toledotechevents_mobile/view/splash.dart';
import 'package:toledotechevents_mobile/view/page_parts.dart';
import 'package:toledotechevents_mobile/view/event_list.dart';
import 'package:toledotechevents_mobile/view/event_details.dart';
import 'package:toledotechevents_mobile/view/venue_list.dart';
import 'package:toledotechevents_mobile/view/venue_details.dart';
import 'package:toledotechevents_mobile/view/event_form.dart';
import 'package:toledotechevents_mobile/view/spam_list.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() {
    return new _AppState();
  }
}

class _AppState extends State<App> {
  Resources resources;
  @override
  Widget build(BuildContext context) {
    return resources == null
        ? SplashScreen((res) => setState(() => resources = res))
        : AppWithResources(resources);
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
                home: HomePage());
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

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends BlocState<HomePage> {
  PageData pageData;
  StreamSubscription subscription;

  @override
  Widget build(BuildContext context) {
    return pageData == null ? Scaffold() : _buildPage(context, pageData);
  }

  void _handleIncomingData(PageData data) {
    if (data.layout.nav.contains(data.page)) {
      // One of the main pages was requested, rebuild this widget.
      setState(() => pageData = data);
    } else {
      // Navigate to the new page.
      Navigator.of(context)
          .push(FadePageRoute(builder: (context) => _buildPage(context, data)))
          .then((_) {
        if (data.onPop != null) data.onPop();
      });
    }
  }

  @override
  void initBloc() {
    subscription = AppDataProvider.of(context).page.listen(_handleIncomingData);
  }

  @override
  void disposeBloc() {
    subscription.cancel();
  }
}

Widget _buildPage(BuildContext context, PageData data) {
  print('Building ${data.page.route}...');
  final resources = AppDataProvider.of(context).resources;
  switch (data.page) {
    case Page.eventList:
      return EventListView(data);
    case Page.eventDetails:
      return EventDetailsView(data);
    case Page.venuesList:
      return VenueListView(data);
    case Page.venueDetails:
      return VenueDetailsView(data);
    case Page.createEvent:
      return EventFormView(data);
    case Page.about:
      return buildScaffold(
          context,
          data,
          (context) => FutureHandler(
              future: resources.about.get(),
              handler: (context, about) => FadeScaleIn(
                  SingleChildScrollView(child: HtmlView(data: about.html)))));
    case Page.spamRemover:
      return SpamListView(data);
    default:
      assert(false);
      return NullWidget();
  }
}
