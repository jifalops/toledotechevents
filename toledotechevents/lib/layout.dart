import 'pages.dart';

/// Domain-specific [Page] layout information.
class Layout {
  final MainNavigation mainNavigation;

  Layout(Page page, Route route, Display display, Theme theme, PageArgs args)
      : mainNavigation = _placeMainNavigation(page, display);
}

/// Domain-specific locations for the page navigation UI.
enum MainNavigation { none, top, bottom }

/// Business logic that defines the location of the main navigation UI.
MainNavigation _placeMainNavigation(Page page, Display display) {
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
