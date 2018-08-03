import 'package:flutter/material.dart';
import 'package:toledotechevents/theme.dart' as ref;

ThemeData buildTheme(ref.Theme t) {
  final base = t.brightness == ref.Brightness.light
      ? ThemeData.light()
      : ThemeData.dark();
  return base.copyWith(
    accentColor: Color(t.secondaryColor.argb),
    primaryColor: Color(t.primaryColor.argb),
    buttonColor: Color(t.onPrimaryButtonColor.argb),
    scaffoldBackgroundColor: Color(t.backgroundColor.argb),
    cardColor: Color(t.surfaceColor.argb),
    textSelectionColor: Color(t.primaryColorLight.argb),
    errorColor: Color(t.errorColor.argb),
    dividerColor: Color(t.dividerColor.argb),
    backgroundColor: Color(t.backgroundColor.argb),
    primaryColorDark: Color(t.primaryColorDark.argb),
    primaryColorLight: Color(t.primaryColorLight.argb),
    textSelectionHandleColor: Color(t.primaryColorDark.argb),
    buttonTheme: ButtonThemeData(
      shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.all(Radius.circular(t.buttonCornerRadius))),
    ),
    inputDecorationTheme: t.inputTheme == ref.InputTheme.outline
        ? InputDecorationTheme(border: OutlineInputBorder())
        : base.inputDecorationTheme,
    textTheme: _buildTextTheme(base.textTheme, t),
    primaryTextTheme: _buildTextTheme(base.primaryTextTheme, t),
    accentTextTheme: _buildTextTheme(base.accentTextTheme, t),
  );
}

TextTheme _buildTextTheme(TextTheme base, ref.Theme t) => base.copyWith(
    display4: _makeStyle(base.display4, t.display4),
    display3: _makeStyle(base.display3, t.display3),
    display2: _makeStyle(base.display2, t.display2),
    display1: _makeStyle(base.display1, t.display1),
    headline: _makeStyle(base.headline, t.headline),
    title: _makeStyle(base.title, t.title),
    subhead: _makeStyle(base.subhead, t.subhead),
    body2: _makeStyle(base.body2, t.body2),
    body1: _makeStyle(base.body1, t.body1),
    button: _makeStyle(base.button, t.button),
    caption: _makeStyle(base.caption, t.caption));

TextStyle _makeStyle(TextStyle base, ref.Font f) => base.copyWith(
    fontFamily: f.family,
    color: Color(f.color.argb),
    fontWeight: _weight(f.weight),
    fontStyle: f.italic ? FontStyle.italic : FontStyle.normal,
    decoration: f.underline ? TextDecoration.underline : TextDecoration.none,
    height: f.height,
    fontSize: f.size);

FontWeight _weight(int w) {
  if (w < 200) return FontWeight.w100;
  if (w < 300) return FontWeight.w200;
  if (w < 400) return FontWeight.w300;
  if (w < 500) return FontWeight.w400;
  if (w < 600) return FontWeight.w500;
  if (w < 700) return FontWeight.w600;
  if (w < 800) return FontWeight.w700;
  if (w < 900) return FontWeight.w800;
  return FontWeight.w900;
}

class PrimaryButton extends RaisedButton {
  PrimaryButton(BuildContext context, String text, onPressed,
      {color: kSecondaryColorDark})
      : super(
          elevation: 8.0,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Text(
              text,
              style: Theme.of(context)
                  .textTheme
                  .button
                  .copyWith(color: Colors.white, fontSize: 16.0),
            ),
          ),
          color: color,
          onPressed: onPressed,
        );
}

class SecondaryButton extends FlatButton {
  SecondaryButton(BuildContext context, String text, onPressed)
      : super(
            color: kPrimaryColorLight,
            child: Text(text,
                style: Theme.of(context)
                    .textTheme
                    .button
                    .copyWith(color: kTextColorOnPrimary)),
            onPressed: onPressed);
}

class TertiaryButton extends FlatButton {
  TertiaryButton(String text, onPressed)
      : super(
            color: kFlatButtonColor,
            textColor: kPrimaryColor,
            child: Text(text),
            onPressed: onPressed,
            padding: EdgeInsets.all(2.0));
}

class FadePageRoute extends MaterialPageRoute {
  FadePageRoute({@required WidgetBuilder builder}) : super(builder: builder);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // return AnimatedCrossFade(
    //   crossFadeState: CrossFadeState.showFirst,
    //   duration: Duration(milliseconds: 400),
    //   firstChild: firstChild,
    //   secondChild: child,
    // );
    return FadeTransition(opacity: animation, child: child);
    // return child;
  }
}
