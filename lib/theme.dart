// See the theme @material.io:
// https://material.io/tools/color/#!/?view.left=1&view.right=1&primary.color=0C4964&secondary.color=8DC641&primary.text.color=ffffff
import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xFF0c4964);
const kPrimaryColorLight = Color(0xFF437492);
const kPrimaryColorDark = Color(0xFF00223a);

const kSecondaryColor = Color(0xFF8dc641);
const kSecondaryColorLight = Color(0xFFc0f972);
const kSecondaryColorDark = Color(0xFF5b9502);

const kTextColorOnPrimary = Color(0xFFffffff);
const kTextColorOnSecondary = Color(0xFF000000);

const kBackgroundColor = Color(0xFFfefefe);
const kDividerColor = Color(0xFFf1f1f1);

final kErrorColor = Colors.deepOrange[900];
final kErrorBackgroundColor = Colors.deepOrange[50];

final ThemeData kTheme = _buildTheme();

ThemeData _buildTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    accentColor: kSecondaryColor,
    primaryColor: kPrimaryColor,
    buttonColor: kSecondaryColor,
    scaffoldBackgroundColor: kBackgroundColor,
    cardColor: kBackgroundColor,
    textSelectionColor: kPrimaryColorLight,
    errorColor: kErrorColor,
    dividerColor: kDividerColor,
    backgroundColor: kBackgroundColor,
    primaryColorDark: kPrimaryColorDark,
    primaryColorLight: kPrimaryColorLight,
    textSelectionHandleColor: kPrimaryColorDark,
    buttonTheme: ButtonThemeData(
      textTheme: ButtonTextTheme.accent,
    ),
    // primaryIconTheme: base.iconTheme.copyWith(color: kShrineBrown900),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(),
    ),
    textTheme: _buildTextTheme(base.textTheme),
    primaryTextTheme: _buildTextTheme(base.primaryTextTheme),
    accentTextTheme: _buildTextTheme(base.accentTextTheme),
  );
}

TextTheme _buildTextTheme(TextTheme base) {
  var theme = base
      .copyWith(
        body1: base.body1.copyWith(fontSize: 16.0, height: 1.15),
        body2: base.body2.copyWith(
            fontSize: 18.0,
            // height: 1.25,
            fontWeight: FontWeight.w600,
            color: kPrimaryColor),
        button: base.button.copyWith(fontSize: 16.0),
        caption: base.caption.copyWith(fontSize: 16.0),
      )
      .apply(fontFamily: 'Open Sans');
  return theme.copyWith(
    title:
        theme.title.copyWith(fontWeight: FontWeight.w700, fontFamily: 'Ubuntu'),
    headline: theme.headline.copyWith(
        height: 2.5, fontWeight: FontWeight.w700, fontFamily: 'Ubuntu'),
    subhead: base.subhead.copyWith(
        fontSize: 18.0,
        height: 1.75,
        fontWeight: FontWeight.w300,
        // color: kSecondaryColor,
        fontFamily: 'Ubuntu'),
  );
}
