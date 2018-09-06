import 'dart:async';
import 'package:flutter/material.dart';
import 'package:toledotechevents/bloc/splash_bloc.dart';
import 'package:toledotechevents/theme.dart' as base;
import 'package:toledotechevents_mobile/util/bloc_state.dart';
import 'package:toledotechevents_mobile/resources.dart';
import 'package:toledotechevents_mobile/providers.dart';

typedef void LoadedCallback(Resources resources);

final _backgroundColor = Color(base.Theme.defaultTheme.primaryColor.argb);
final _textColor = Color(base.Theme.defaultTheme.onPrimaryColor.argb);
final _textSize = 16.0;

class SplashScreen extends StatefulWidget {
  SplashScreen(this.resources, this.onLoadingComplete);

  final Resources resources;
  final LoadedCallback onLoadingComplete;

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends BlocState<SplashScreen> {
  SplashBloc bloc;
  StreamSubscription subscription;

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
              child: StreamHandler<int>(
                stream: bloc.percent,
                initialData: 0,
                handler: (context, percent) => Text('$percent%',
                    style: TextStyle(color: _textColor, fontSize: _textSize)),
              ))
        ]));
  }

  @override
  void initBloc() {
    bloc = SplashBloc(widget.resources);
    subscription =
        bloc.loaded.listen((_) => widget.onLoadingComplete(widget.resources));
  }

  @override
  void disposeBloc() {
    subscription.cancel();
    bloc.dispose();
  }
}
