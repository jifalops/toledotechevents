import 'package:flutter/material.dart';
import 'package:toledotechevents_mobile/providers.dart';
import 'package:toledotechevents_mobile/resources.dart';
import 'package:toledotechevents_mobile/view/event_list.dart';
import 'package:toledotechevents_mobile/view/event_details.dart';

class EventListPage extends StatefulWidget {
  EventListPage(this.pageData);
  final PageLayout pageData;
  @override
  _EventListPageState createState() => new _EventListPageState();
}

class _EventListPageState extends State<EventListPage> {
  final bloc = EventListBloc(eventListResource);

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return EventListProvider(
      bloc: bloc,
      child: StreamHandler<EventList>(
        stream: bloc.events,
        handler: (context, data) => EventListView(data),
      ),
    );
  }
}

class EventDetailsPage extends StatefulWidget {
  EventDetailsPage(this.data);
  final PageLayout data;
  @override
  _EventDetailsPageState createState() => new _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  final bloc = EventDetailsBloc();

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return EventDetailsProvider(
      bloc: bloc,
      child: StreamHandler<EventDetails>(
        stream: bloc.details,
        handler: (context, data) => data.venue != null
            ? VenueListProvider(
                bloc: VenueListBloc(venueListResource),
                child: EventDetailsView(data, widget.data),
              )
            : EventDetailsView(data, widget.data),
      ),
    );
  }
}

//   Widget _getBody() {
//     switch (_selectedPage) {
//       // Add new event
//       case 1:
//         // return CreateEventForm();
//         return FutureBuilder<String>(
//           future: getNewEventAuthToken(),
//           builder: (context, snapshot) {
//             if (snapshot.hasData) {
//               return AnimatedPage(CreateEventForm(snapshot.data));
//             } else if (snapshot.hasError) {
//               return new Text('${snapshot.error}');
//             }
//             return Center(child: CircularProgressIndicator());
//           },
//         );
//       // Venues list
//       case 2:
//         return FutureBuilder<List<Venue>>(
//           future: getVenues(),
//           builder: (context, snapshot) {
//             if (snapshot.hasData) {
//               return AnimatedPage(VenueList(snapshot.data));
//             } else if (snapshot.hasError) {
//               return new Text('${snapshot.error}');
//             }
//             return Center(child: CircularProgressIndicator());
//           },
//         );
//       // About page
//       case 3:
//         return FutureBuilder<String>(
//           future: getAboutSectionHtml(),
//           builder: (context, snapshot) {
//             if (snapshot.hasData) {
//               return SingleChildScrollView(
//                 child: AnimatedPage(HtmlView(data: snapshot.data)),
//               );
//             } else if (snapshot.hasError) {
//               return new Text('${snapshot.error}');
//             }
//             return Center(child: CircularProgressIndicator());
//           },
//         );
//       // Event list
//       case 0:
//       default:
//         return FutureBuilder<List<Event>>(
//           future: getEvents(),
//           builder: (context, snapshot) {
//             if (snapshot.hasData) {
//               return AnimatedPage(EventList(snapshot.data));
//             } else if (snapshot.hasError) {
//               return new Text('${snapshot.error}');
//             }
//             return Center(child: CircularProgressIndicator());
//           },
//         );
//     }
//   }
// }
