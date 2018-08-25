import 'dart:async';
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:toledotechevents_web/resources.dart';

@Component(
  selector: 'event-list',
  styleUrls: [
    // 'package:angular_components/app_layout/layout.scss.css',
    'event_list.scss.css'
  ],
  templateUrl: 'event_list.html',
  directives: [
    MaterialListComponent,
    MaterialListItemComponent,
    NgFor,
    NgIf,
  ],
)
class EventListComponent implements OnInit {
  EventList events;
  EventListItem selectedEvent;

  @override
  void ngOnInit() async {
    events = await resources.eventList.get();
    print('Events: ${events?.length}');
  }
}
