import 'package:angular/angular.dart';

import 'src/todo_list/todo_list_component.dart';
import 'resources.dart';

// AngularDart info: https://webdev.dartlang.org/angular
// Components info: https://webdev.dartlang.org/components

@Component(
  selector: 'my-app',
  styleUrls: ['app_component.css'],
  templateUrl: 'app_component.html',
  directives: [TodoListComponent],
)
class AppComponent implements OnInit {
  @override
  void ngOnInit() {

  }
}
