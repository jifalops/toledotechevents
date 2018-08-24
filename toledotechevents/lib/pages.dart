// The app's pages.
class Page {
  // Route paths should conform to Angular's route paths.
  // See https://angular.io/guide/router#configuration.
  static const eventList = Page._(null, '/events');
  static const eventDetails = Page._('Event details', '/events/:details');
  static const venuesList = Page._(null, '/venues');
  static const venueDetails = Page._('Venue details', '/venues/:details');
  static const createEvent = Page._(null, '/events/new');
  static const about = Page._(null, '/about');
  static const spamRemover = Page._(null, '/venues/spam');

  static const values = [
    eventList,
    eventDetails,
    venuesList,
    venueDetails,
    createEvent,
    about,
    spamRemover
  ];

  const Page._(this.title, this.route);

  /// If `null`, use the app's title.
  final String title;
  final String route;

  List<String> get params =>
      route.allMatches(r'/:([^/]+)').map((match) => match.group(0).toString());
}
