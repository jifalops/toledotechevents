// The app's pages.
class Page {
  static const eventList = Page._(null, '/events');

  /// The `event` argument can be an [EventListItem] or [int].
  static const eventDetails = Page._('Event details', '/event/:event');
  static const venuesList = Page._(null, '/venues');

  /// The `venue` argument can be a [VenueListItem] or [int].
  static const venueDetails = Page._('Venue details', '/venue/:venue');
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
