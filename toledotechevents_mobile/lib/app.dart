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
  // if (previous == null) {
  //    // First page.
  //   return _buildPage(context, data);
  // } else if (data.page == previous.page) {
  //   // Theme, display, or page args changed.
  //   return _buildPage(context, data);
  // } else if (data.layout.mainNavigation.items.contains(data.page) &&
  // data.layout.mainNavigation.items.contains(previous.page)) {
  //   // Changing among main screens, just rebuild the body.

  // }

  if (previous == null ||
      data.page == previous.page ||
      data.layout.mainNavigation.items.containsKey(data.page)) {
    return _buildPage(context, data);
  } else {
    Navigator.of(context).push(
        NoAnimationRoute(builder: (context) => _buildPage(context, data)));
    return Container(height: 0.0, width: 0.0);
  }
}

Widget _buildPage(BuildContext context, LayoutData data) {
  return Scaffold(
    appBar: buildAppBar(context, data),
    body: _buildBody(context, data),
    bottomNavigationBar: data.layout.mainNavigation == MainNavigation.bottom
        ? _buildBottomNav(context, data)
        : null,
  );
}

Widget _buildBottomNav(BuildContext context, LayoutData data) {
  Icon iconFor(Page page) {
    switch (page) {
      case Page.eventList:
        return Icon(Icons.event);
      case Page.createEvent:
        return Icon(Icons.add_circle_outline);
      case Page.venuesList:
        return Icon(Icons.business);
      case Page.about:
        return Icon(Icons.help);
      default:
        return null;
    }
  }

  List<BottomNavigationBarItem> items;
  data.layout.mainNavigation.items.forEach((page, title) => items.add(
      BottomNavigationBarItem(
          title: Text(title, style: Theme.of(context).textTheme.button),
          icon: iconFor(page))));

  return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex:
          data.layout.mainNavigation.items.keys.toList().indexOf(data.page),
      iconSize: 24.0,
      onTap: (index) => LayoutProvider.of(context).page.add(
          PageRequest(data.layout.mainNavigation.items.keys.toList()[index])),
      items: items);
}

Widget _buildBody(BuildContext context, LayoutData data) {
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

class EventListPage extends StatefulWidget {
  final LayoutData layoutData;

  EventListPage(this.layoutData);

  @override
  _EventListPageState createState() => new _EventListPageState();
}

class _EventListPageState extends State<EventListPage> {
  final eventListBloc = EventListBloc(eventListResource);

  @override
  void dispose() {
    eventListBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: eventListBloc.events,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return EventListView(snapshot.data, eventListBloc.fetch);
          } else if (snapshot.hasError) {
            return new Text('${snapshot.error}');
          }
          return Center(child: CircularProgressIndicator());
        });
  }
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


