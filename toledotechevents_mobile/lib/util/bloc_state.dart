import 'package:flutter/material.dart';
import 'dart:async';

abstract class BlocState<T extends StatefulWidget> extends State<T> {
  /// Create *BLoC*s and setup [StreamSubscription]s.
  void initBloc();

  /// Cancel [StreamSubscription]s and dispose of *BLoC*s.
  void disposeBloc();

  @override
  @mustCallSuper
  @protected
  void initState() {
    super.initState();
    initBloc();
  }

  @override
  @mustCallSuper
  @protected
  void dispose() {
    disposeBloc();
    super.dispose();
  }

  @override
  @mustCallSuper
  @protected
  void didUpdateWidget(StatefulWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    disposeBloc();
    initBloc();
  }
}
