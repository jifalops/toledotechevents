import 'dart:async';
import 'package:flutter/material.dart';
import 'package:toledotechevents/bloc/resources_bloc.dart';
import 'package:toledotechevents/theme.dart' as base;
import 'package:toledotechevents_mobile/util/bloc_state.dart';
import 'package:toledotechevents_mobile/resources.dart';
import 'package:toledotechevents_mobile/providers.dart';

typedef void LoadedCallback(Resources resources);

final _backgroundColor = Color(base.Theme.defaultTheme.primaryColor.argb);
final _textColor = Color(base.Theme.defaultTheme.onPrimaryColor.argb);
final _textSize = 16.0;

class SplashScreen extends StatefulWidget {
  SplashScreen(this.onLoadingComplete);
  final LoadedCallback onLoadingComplete;
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Resources resources;

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.ltr,
        child: Stack(children: <Widget>[
          Container(
              color: _backgroundColor,
              alignment: Alignment.center,
              child: Image.asset('assets/images/splash.jpg')),
          Container(
              alignment: Alignment.bottomCenter,
              margin: EdgeInsets.only(bottom: 100.0),
              child: FutureBuilder(
                  future: getResources(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return LoadingProgress(
                          snapshot.data, widget.onLoadingComplete);
                    } else if (snapshot.hasError) {
                      return new Text('${snapshot.error}');
                    }
                    return LoadingProgress(null, null);
                  })),
        ]));
  }
}

class LoadingProgress extends StatefulWidget {
  LoadingProgress(this.resources, this.doneCallback);
  final Resources resources;
  final LoadedCallback doneCallback;
  @override
  _LoadingProgressState createState() => new _LoadingProgressState();
}

class _LoadingProgressState extends BlocState<LoadingProgress> {
  ResourcesBloc bloc;
  StreamSubscription subscription;
  @override
  Widget build(BuildContext context) => bloc == null
      ? Text('0%', style: TextStyle(color: _textColor, fontSize: _textSize))
      : StreamHandler<int>(
          stream: bloc.percent,
          initialData: 0,
          handler: (context, percent) => Text('$percent%',
              style: TextStyle(color: _textColor, fontSize: _textSize)),
        );

  @override
  void initBloc() {
    if (widget.resources != null) {
      bloc = ResourcesBloc(widget.resources);
      subscription =
          bloc.loaded.listen((_) => widget.doneCallback(widget.resources));
    }
  }

  @override
  void disposeBloc() {
    if (subscription != null) subscription.cancel();
    if (bloc != null) bloc.dispose();
  }
}
