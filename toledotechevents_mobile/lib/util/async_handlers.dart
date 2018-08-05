import 'dart:async';
import 'package:flutter/material.dart';

class StreamHandler<T> extends StreamBuilder<T> {
  StreamHandler(
      {@required Stream<T> stream,
      @required Widget Function(BuildContext context, T data) handler,
      T initialData})
      : super(
            stream: stream,
            initialData: initialData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return handler(context, snapshot.data);
              } else if (snapshot.hasError) {
                return new Text('${snapshot.error}');
              }
              return Center(child: CircularProgressIndicator());
            });
}

class FutureHandler<T> extends FutureBuilder<T> {
  FutureHandler(
      {@required Future<T> future,
      @required Widget Function(BuildContext context, T data) handler,
      T initialData})
      : super(
            future: future,
            initialData: initialData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return handler(context, snapshot.data);
              } else if (snapshot.hasError) {
                return new Text('${snapshot.error}');
              }
              return Center(child: CircularProgressIndicator());
            });
}
