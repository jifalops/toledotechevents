import 'util/display.dart';
import 'pages.dart';
import 'theme.dart';

export 'util/display.dart';

/// Domain-specific locations for the page navigation UI.
enum MainNavigation { none, top, bottom }

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

/// Domain-specific [Page] layout information.
class Layout {
  final MainNavigation mainNavigation;

  Layout(Page page, Theme theme, Display display)
      : mainNavigation = _placeMainNavigation(page, theme, display);
}
