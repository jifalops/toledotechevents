import 'dart:async';

import 'package:angular/core.dart';
//import 'package:toledotechevents/bloc/page_bloc.dart';

/// Mock service emulating access to a to-do list stored on a server.
@Injectable()
class TodoListService {
  List<String> mockTodoList = <String>[];
//  final pageBloc = PageBloc();
  Future<List<String>> getTodoList() async => mockTodoList;
}
