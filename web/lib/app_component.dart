import 'dart:html';
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:toledotechevents/bloc/app_bloc.dart';
import 'resources.dart' as res;
import 'src/event_list/event_list.dart';

// AngularDart info: https://webdev.dartlang.org/angular
// Components info: https://webdev.dartlang.org/components

@Component(
  selector: 'my-app',
  styleUrls: [
    'package:angular_components/app_layout/layout.scss.css',
    'app_component.css'
  ],
  templateUrl: 'app_component.html',
  directives: [
    EventListComponent,
     MaterialButtonComponent,
    // MaterialIconComponent,
    NgIf,
    NgClass
  ],
)
class AppComponent implements OnInit {
  final resources = res.resources;
  final appBloc = AppBloc(res.resources);



  @override
  void ngOnInit() async {
//    showSplash = (await res.resources.splash.get()) ?? false;
//    initialized = true;
  }

  void setTheme(String theme) async {
    if (theme == await resources.theme.get()) return;
    document.documentElement.className = 'theme-${theme.toLowerCase()}';
    resources.theme.write(theme);
  }

  void toggleSplash() async {
    final value = !(await resources.splash.get());
    resources.splash.write(value.toString());
  }
}
