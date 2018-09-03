import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_html_view/flutter_html_view.dart';
import 'package:path_provider/path_provider.dart';

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
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  Resources resources;
  bool showSplash = false;

  @override
  void initState() {
    super.initState();
    getApplicationDocumentsDirectory().then((dir) async {
      final res = await MobileResources.init(dir.path);
      final splash = await res.splash.get();
      setState(() {
        resources = res;
        showSplash = splash ?? false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return resources == null
        ? Container()
        : showSplash
            ? SplashScreen(resources, (_) => setState(() => showSplash = false))
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
          initialData: bloc.lastTheme,
          handler: (context, theme) {
            print('Building app...');
            return MaterialApp(
                title: config.title,
                theme: buildTheme(theme),
                home: HomePage(bloc));
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
  HomePage(this.appBloc);
  final AppBloc appBloc;
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
      Navigator.of(context)
          .push(FadePageRoute(builder: (context) => _buildPage(context, data)))
          .then((_) {
        if (data.onPop != null) data.onPop();
      });
    }
  }

  @override
  void initBloc() {
    subscription = widget.appBloc.page.listen(_handleIncomingData);
  }

  @override
  void disposeBloc() {
    subscription.cancel();
  }

  Widget _buildPage(BuildContext context, PageData data) {
    print('Building ${data.page.route}');
    final resources = AppDataProvider.of(context).resources;
    switch (data.page) {
      case Page.eventList:
        return EventListView(data);
      case Page.eventDetails:
        return EventDetailsView(data);
      case Page.venueList:
        print('menu options: ${data.layout.menuOptions}');
        return VenueListView(data);
      case Page.venueDetails:
        return VenueDetailsView(data);
      case Page.createEvent:
        return EventFormView(data);
      case Page.about:
        return buildScaffold(
            context,
            data,
            (context) => FutureHandler<AboutSection>(
                future: resources.about.get(),
                initialData: widget.appBloc.resources.about.data,
                handler: (context, about) => FadeScaleIn(
                    SingleChildScrollView(child: HtmlView(data: about.html)))));
      case Page.spamRemover:
        return SpamListView(data);
      default:
        assert(false);
        return NullWidget();
    }
  }
}
