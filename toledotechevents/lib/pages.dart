import 'util/route.dart';

export 'util/route.dart';

// The app's pages.
class Page {
  static const eventList = Page._(Route('/events'));
  static const eventDetails = Page._(Route('/event/:id'));
  static const venuesList = Page._(Route('/venues'));
  static const venueDetails = Page._(Route('/venue/:id'));
  static const createEvent = Page._(Route('/events/new'));
  static const about = Page._(Route('/about'));
  static const spamRemover = Page._(Route('/venues/spam'));

  static Page get home => eventList;
  static Page get first => eventList;

  static const values = [
    eventList,
    eventDetails,
    venuesList,
    venueDetails,
    createEvent,
    about,
    spamRemover
  ];

  const Page._(this.route);

  final Route route;
}
