import 'package:async_resource/async_resource.dart';
import 'package:meta/meta.dart';
import 'package:html/dom.dart' as dom;
import 'package:toledotechevents/model/events.dart';
import 'package:toledotechevents/model/venues.dart';
import 'package:toledotechevents/model/about_section.dart';
import 'package:toledotechevents/model/auth_token.dart';

export 'package:toledotechevents/model/events.dart';
export 'package:toledotechevents/model/venues.dart';
export 'package:toledotechevents/model/about_section.dart';
export 'package:toledotechevents/model/auth_token.dart';

/// The resources required by the app.
abstract class Resources {
  Resources(
      {@required this.theme,
      @required this.eventList,
      @required this.venueList,
      @required this.aboutPage,
      @required this.newEvent});
  final LocalResource<String> theme;
  final NetworkResource<EventList> eventList;
  final NetworkResource<VenueList> venueList;
  final NetworkResource<AboutSection> aboutPage;
  final NetworkResource<NewEvent> newEvent;

  NetworkResource<dom.Document> eventDetails(int id);
  NetworkResource<dom.Document> venueDetails(int id);
}
