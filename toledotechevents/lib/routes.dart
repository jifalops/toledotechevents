/// The routes of the app. [id] is for details views that render a list item.
class PageRoute {
  final Page page;
  final int id;
  final String route;

  PageRoute(this.page, [this.id]) : route = _routeForPage(page, id);

  @override
  String toString() => route;
}

String _routeForPage(Page page, int id) {
  switch (page) {
    case Page.eventDetails:
      return '/events/$id';
    case Page.venuesList:
      return '/venues/';
    case Page.venueDetails:
      return '/venues/$id';
    case Page.createEvent:
      return '/events/new';
    case Page.about:
      return '/about';
    case Page.spamRemover:
      return '/venues/spam';
    case Page.eventList:
    default:
      return '/events';
  }
}

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
