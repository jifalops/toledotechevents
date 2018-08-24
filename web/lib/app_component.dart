import 'package:angular/angular.dart';
import 'package:toledotechevents/bloc/app_bloc.dart';
import 'resources.dart' as res;
import 'src/splash/splash.dart';
import 'src/event_list/event_list.dart';

// AngularDart info: https://webdev.dartlang.org/angular
// Components info: https://webdev.dartlang.org/components

@Component(
  selector: 'my-app',
  styleUrls: ['app_component.scss.css'],
  templateUrl: 'app_component.html',
  directives: [SplashComponent, EventListComponent, NgIf, NgClass],
)
class AppComponent implements OnInit {
  final resources = res.resources;
  final appBloc = AppBloc(res.resources);

  bool initialized = false;
  bool showSplash;

  @override
  void ngOnInit() async {
    showSplash = await res.resources.splash.get();
    initialized = true;
  }
}
