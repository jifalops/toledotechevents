import 'util/display.dart';
import 'pages.dart';
import 'theme.dart';
import 'build_config.dart';

export 'util/display.dart';

/// Domain-specific [Page] layout information.
class Layout {
  final MainNavigation nav;
  final List<MenuOption> menuOptions;

  Layout(Page page, Theme theme, Display display)
      : nav = _placeMainNavigation(page, theme, display),
        menuOptions = _getMenuOptions(page, theme, display);

  @override
  operator ==(other) => nav == other.nav && menuOptions == other.menuOptions;

  @override
  int get hashCode => '$nav$menuOptions'.hashCode;
}

/// Domain-specific locations for the page navigation UI.
class MainNavigation {
  static const MainNavigation none = MainNavigation._({});
  static const MainNavigation top = MainNavigation._(_navItems);
  static const MainNavigation bottom = MainNavigation._(_navItems);

  const MainNavigation._(this.items);
  final Map<Page, String> items;

  bool contains(Page page) => items.containsKey(page);
}

const _navItems = <Page, String>{
  Page.eventList: 'Events',
  Page.createEvent: 'New',
  Page.venuesList: 'Venues',
  Page.about: 'About'
};

/// Business logic that defines the location of the main navigation UI.
MainNavigation _placeMainNavigation(Page page, Theme theme, Display display) {
  switch (display.type) {
    case DisplayType.mobile:
      switch (page) {
        case Page.eventList:
        case Page.venuesList:
        case Page.createEvent:
        case Page.about:
          return MainNavigation.bottom;
        default:
          return MainNavigation.none;
      }
      break;
    default:
      return MainNavigation.top;
  }
}

List<MenuOption> _getMenuOptions(Page page, Theme theme, Display display) {
  switch (page) {
    case Page.eventDetails:
      return _eventOptions;
    case Page.venueDetails:
      return _venueOptions;
    case Page.venuesList:
      return _venueListOptions;
    default:
      return _mainOptions;
  }
}

final _mainOptions = <MenuOption>[
  MenuOption.pastEvents,
  MenuOption.subscribeAllGoogle,
  MenuOption.subscribeAllICal,
  MenuOption.visitForum,
  MenuOption.reportIssue
];

final _eventOptions = <MenuOption>[MenuOption.editEvent, MenuOption.cloneEvent];
final _venueOptions = <MenuOption>[
  MenuOption.pastVenueEvents,
  MenuOption.subscribeVenueGoogle,
  MenuOption.subscribeVenueICal,
  MenuOption.editVenue
];

final _venueListOptions = List.from(_mainOptions)..add(MenuOption.removeSpam);

class MenuOption {
  // Main.
  static final pastEvents =
      MenuOption._('See past events', (_) => config.urls.pastEvents);
  static final subscribeAllGoogle = MenuOption._(
      'Subscribe to Google Calendar', (_) => config.urls.subscribeEventsGoogle);
  static final subscribeAllICal = MenuOption._(
      'Subscribe via iCal', (_) => config.urls.subscribeEventsICal);
  static final visitForum = MenuOption._('Visit forum', (_) => config.forumUrl);
  static final reportIssue =
      MenuOption._('Report an issue', (_) => config.issuesUrl);
  // Event details.
  static final editEvent =
      MenuOption._('Edit event', (id) => config.urls.eventEdit(id));
  static final cloneEvent =
      MenuOption._('Clone event', (id) => config.urls.eventClone(id));
  // Venue details.
  static final pastVenueEvents =
      MenuOption._('See past venue events', (id) => config.urls.venue(id));
  static final subscribeVenueGoogle = MenuOption._(
      'Subscribe via Google', (id) => config.urls.venueSubscribe(id));
  static final subscribeVenueICal =
      MenuOption._('Subscribe via iCal', (id) => config.urls.venueICal(id));
  static final editVenue =
      MenuOption._('Edit venue', (id) => config.urls.venueEdit(id));
  // Venue list (plus main)
  static final removeSpam = MenuOption._('Remove spam', (_) => 'removeSpam');

  const MenuOption._(this.title, this.action);

  final String title;
  final String Function(dynamic arg) action;
}
