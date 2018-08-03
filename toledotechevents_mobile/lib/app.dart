import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_html_view/flutter_html_view.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:async_resource/async_resource.dart';
import 'package:async_resource/file_resource.dart';

import 'package:xml/xml.dart' as xml;
import 'package:shared_preferences/shared_preferences.dart';
import 'provider/theme_provider.dart';
import 'provider/layout_provider.dart';
import 'theme.dart';
import 'model.dart';
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

class App extends StatefulWidget {
  @override
  AppState createState() {
    return new AppState();
  }
}

class AppState extends State<App> {
  final ThemeBloc themeBloc = ThemeBloc(ThemeResource());

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

  LayoutData previousPage;

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
    return LayoutProvider(
        layoutBloc: layoutBloc,
        child: StreamBuilder<LayoutData>(
            stream: layoutBloc.layoutData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                _handleLayout(context, snapshot.data, previousPage);
                previousPage = snapshot.data;
              } else if (snapshot.hasError) {
                return new Text('${snapshot.error}');
              }
              return Center(child: CircularProgressIndicator());
            }));
  }
}

Widget _handleLayout(
    BuildContext context, LayoutData data, LayoutData previous) {
  if (previous == null || data.page == previous.page) {
    return _buildPage(context, data);
  } else {
    Navigator.of(context).push(
        NoAnimationRoute(builder: (context) => _buildPage(context, data)));
    return Container(height: 0.0, width: 0.0);
  }
}

Widget _buildPage(BuildContext context, LayoutData data) {

}

Widget _getAppBar(BuildContext context, LayoutData data) {}

Widget _getTopNav(BuildContext context, LayoutData data) {}

Widget _buildBottomNav(BuildContext context, LayoutData data) {
  BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedPage,
        iconSize: 24.0,
        onTap: (index) => setState(() => _selectedPage = index),
        items: [
          BottomNavigationBarItem(
            title: Text('Events', style: Theme.of(context).textTheme.button),
            icon: Icon(Icons.event),
          ),
          BottomNavigationBarItem(
            title: Text('New', style: Theme.of(context).textTheme.button),
            icon: Icon(Icons.add_circle_outline),
          ),
          BottomNavigationBarItem(
            title: Text('Venues', style: Theme.of(context).textTheme.button),
            icon: Icon(Icons.business),
          ),
          BottomNavigationBarItem(
            title: Text('About', style: Theme.of(context).textTheme.button),
            icon: Icon(Icons.help),
          ),
        ],
      ),
}

Widget _getBody(BuildContext context, LayoutData data) {
  switch (data.page) {
    case Page.eventList:
      return stful
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


class EventListPage extends StatefulWidget {
  final LayoutData layoutData;

EventListPage(this.layoutData);

  @override
  _EventListPageState createState() => new _EventListPageState();
}

class _EventListPageState extends State<EventListPage> {
  final eventListBloc = EventListBloc(EventListResource());


  @override
    void dispose() {
      eventListBloc.dispose();
      super.dispose();
    }

  @override
  Widget build(BuildContext context) {

  }

}

class EventListResource extends HttpNetworkResource<List<Event>> {
  EventListResource(): super(url: config.baseUrl + '/events.atom',

  cache: FileResource(File('events.atom'), parser: (contents) {
  final events = List<Event>();
    if (contents != null && contents.isNotEmpty) {
      xml
          .parse(contents)
          .findAllElements('entry')
          .forEach((entry) => events.add(Event(entry, (id) => EventDetailsResource(id))));
}}));}

class EventDetailsResource extends HttpNetworkResource<dom.Document> {
  EventDetailsResource(int id) : super(url: config.baseUrl + '/event/$id',
  cache: FileResource(File('event_$id.html'), parser: (contents) => parse(contents)
  ),
  maxAge: Duration(hours: 24),
  strategy: CacheStrategy.cacheFirst);
}

Widget _buildAppBar(BuildContext context, LayoutData data) {

}


class MainPageState extends State<MainPage> {
  int _selectedPage = 0;

  @override
  Widget build(BuildContext context) {
    // timeDilation = 10.0;
    return Scaffold(
      appBar: getAppBar(context, _selectedPage),
      body: _getBody(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedPage,
        iconSize: 24.0,
        onTap: (index) => setState(() => _selectedPage = index),
        items: [
          BottomNavigationBarItem(
            title: Text('Events', style: Theme.of(context).textTheme.button),
            icon: Icon(Icons.event),
          ),
          BottomNavigationBarItem(
            title: Text('New', style: Theme.of(context).textTheme.button),
            icon: Icon(Icons.add_circle_outline),
          ),
          BottomNavigationBarItem(
            title: Text('Venues', style: Theme.of(context).textTheme.button),
            icon: Icon(Icons.business),
          ),
          BottomNavigationBarItem(
            title: Text('About', style: Theme.of(context).textTheme.button),
            icon: Icon(Icons.help),
          ),
        ],
      ),
    );
  }

  Widget _getBody() {
    switch (_selectedPage) {
      // Add new event
      case 1:
        // return CreateEventForm();
        return FutureBuilder<String>(
          future: getNewEventAuthToken(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return AnimatedPage(CreateEventForm(snapshot.data));
            } else if (snapshot.hasError) {
              return new Text('${snapshot.error}');
            }
            return Center(child: CircularProgressIndicator());
          },
        );
      // Venues list
      case 2:
        return FutureBuilder<List<Venue>>(
          future: getVenues(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return AnimatedPage(VenueList(snapshot.data));
            } else if (snapshot.hasError) {
              return new Text('${snapshot.error}');
            }
            return Center(child: CircularProgressIndicator());
          },
        );
      // About page
      case 3:
        return FutureBuilder<String>(
          future: getAboutSectionHtml(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SingleChildScrollView(
                child: AnimatedPage(HtmlView(data: snapshot.data)),
              );
            } else if (snapshot.hasError) {
              return new Text('${snapshot.error}');
            }
            return Center(child: CircularProgressIndicator());
          },
        );
      // Event list
      case 0:
      default:
        return FutureBuilder<List<Event>>(
          future: getEvents(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return AnimatedPage(EventList(snapshot.data));
            } else if (snapshot.hasError) {
              return new Text('${snapshot.error}');
            }
            return Center(child: CircularProgressIndicator());
          },
        );
    }
  }
}

class ThemeResource extends LocalResource<String> {
  Future<SharedPreferences> get prefs async => SharedPreferences.getInstance();

  Future<String> get value async => (await prefs).getString('theme');

  @override
  Future<bool> get exists async => (await value) != null;

  @override
  Future fetchContents() => value;

  @override
  Future<DateTime> get lastModified => null;

  @override
  Future<void> write(contents) async =>
      (await prefs).setString('theme', contents);
}

class NoAnimationRoute extends MaterialPageRoute {
  NoAnimationRoute({@required WidgetBuilder builder}) : super(builder: builder);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) =>
      child;
}
