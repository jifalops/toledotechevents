import 'dart:collection';

import 'package:collection/collection.dart';

import 'util/route.dart';
import 'util/display.dart';
import 'theme.dart';
import 'layout.dart';

export 'util/route.dart';
export 'util/display.dart';
export 'theme.dart';
export 'layout.dart';

/// Domain-specific pages of the app.
enum Page {
  eventList,
  eventDetails,
  venuesList,
  venueDetails,
  createEvent,
  about,
  spamRemover
}

/// Business logic for each page's route and parameters.
final _routes = UnmodifiableMapView<Page, Route>({
  Page.eventList: Route('/events'),
  Page.eventDetails: Route('/event/:id'),
  Page.venuesList: Route('/venues'),
  Page.venueDetails: Route('/venue/:id'),
  Page.createEvent: Route('/events/new'),
  Page.about: Route('/about'),
  Page.spamRemover: Route('/venues/spam'),
});

/// Checks for consistency between the [Page] enum and [_routes].
bool debugAllRoutesDefined() {
  if (Page.values.length != _routes.length) return false;
  Page.values.forEach((page) {
    if (_routes[page] == null) return false;
  });
  return true;
}

/// A platform independent representation of a page that contains domain-specific
/// data. Platform specific view logic uses this to show a page to the user.
class PageData {
  // This is basically a utility class, but it's kept here because it
  // depends on classes defined at the business level. It is unlikely to need to
  // modify this class, unless adding a new data type that all page rendering
  // relies on.

  final Page page;
  final Route route;
  final Display display;
  final Theme theme;
  final PageArgs args;
  Layout _layout;

  PageData(this.page, this.display, this.theme, [Map<String, dynamic> args])
      : route = _routes[page],
        args = PageArgs(args ?? {}) {
    assert(IterableEquality().equals(args.keys, route.params));
  }

  Layout get layout => _layout ??= Layout(page, route, display, theme, args);
}

class PageArgs extends UnmodifiableMapView<String, dynamic> {
  PageArgs(Map<String, dynamic> args) : super(args);
}
