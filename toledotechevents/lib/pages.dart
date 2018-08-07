// The app's pages.
class Page {
  static const eventList = Page._(null, '/events');

  /// `resource` is an [EventDetailsResource]. `event` is an optional
  /// [EventListItem].
  static const eventDetails =
      Page._('Event details', '/event/:resource/:event');
  static const venuesList = Page._(null, '/venues');

  /// `resource` is a [VenueDetailsResource]. `venue` is an optional
  /// [VenueListItem].
  static const venueDetails =
      Page._('Venue details', '/venue/:resource/:venue');
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
