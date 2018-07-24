/// The pages or screens of the app.
enum Page {
  eventList,
  eventDetails,
  venuesList,
  venueDetails,
  createEvent,
  about,
  spamRemover
}

///
abstract class RouteService {
  void popRoute();
  void pushRoute(Page page, Object obj);
}