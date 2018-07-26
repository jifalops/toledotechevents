import 'dart:collection';
import 'package:meta/meta.dart';
import 'util/router.dart';
import 'util/display.dart';
import 'theme.dart';

export 'util/router.dart';
export 'util/display.dart';
export 'theme.dart';

/// The pages of the app.
enum Page {
  eventList,
  eventDetails,
  venuesList,
  venueDetails,
  createEvent,
  about,
  spamRemover
}

/// Defines each [Page]'s [Route].
final _routes = UnmodifiableMapView<Page, Route>({
  Page.eventList: Route('/events'),
  Page.eventDetails: Route('/event/:id'),
  Page.venuesList: Route('/venues'),
  Page.venueDetails: Route('/venue/:id'),
  Page.createEvent: Route('/events/new'),
  Page.about: Route('/about'),
  Page.spamRemover: Route('/venues/spam'),
});

void debugAssertAllRoutesDefined() {
  assert(Page.values.length == _routes.length);
  Page.values.forEach((page) {
    assert(_routes[page] != null);
  });
}

/// Opinionated data for how a [Page] should be presented on screen.
class RenderablePage {
  final Page page;
  final Route route;
  final Display display;
  final Layout layout;
  final Theme theme;

  RenderablePage(this.page, this.display, [Theme theme])
      : route = _routes[page],
        layout = Layout(navbarPosition: _navbarPosition(page, display)),
        theme = theme ?? Theme();
}

/// On mobile, only the four top-level pages show a nav bar; at the bottom
/// of the page. For all other form factors, the nav bar is at the top of every
/// page.
NavbarPosition _navbarPosition(Page page, Display display) {
  switch (display.type) {
    case DisplayType.mobile:
      switch (page) {
        case Page.eventList:
        case Page.venuesList:
        case Page.createEvent:
        case Page.about:
          return NavbarPosition.bottom;
        default:
          return NavbarPosition.hidden;
      }
      break;
    default:
      return NavbarPosition.top;
  }
}

enum NavbarPosition { hidden, top, bottom }

/// Characteristics about a [Page]'s layout.
class Layout {
  final NavbarPosition navbarPosition;
  Layout({@required this.navbarPosition});
}
