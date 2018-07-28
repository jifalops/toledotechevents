// See the theme @material.io:
// https://material.io/tools/color/#!/?view.left=1&view.right=1&primary.color=0C4964&secondary.color=8DC641&primary.text.color=ffffff

import 'package:meta/meta.dart';
import 'util/color.dart';

/// The available [Theme]s.
enum Themes { light, dark }

// Brand colors are typically theme independent.

const _primaryColor = ;
const _primaryColorLight = ;
const _primaryColorDark = ;

const _secondaryColor = Color.fromRGB(0x8DC641);
const _secondaryColorLight = Color.fromRGB(0xC0F972);
const _secondaryColorDark = Color.fromRGB(0x5B9502);

const _textColorOnPrimary = Color.fromRGB(0xFFFFFF);
const _textColorOnSecondary = Color.fromRGB(0x000000);


// The actual themes.

const Theme _lightTheme = Theme.custom(
  brightness: Brightness.light,
  primaryColor: _primaryColor,
  primaryColorLight: _primaryColorLight,
  primaryColorDark: _primaryColorDark,
  secondaryColor: _secondaryColor,
  secondaryColorLight: _secondaryColorLight,
  secondaryColorDark: _secondaryColorDark,
  textColorOnPrimary: _textColorOnPrimary,
  textColorOnSecondary: _textColorOnSecondary,
  backgroundColor: Color.fromRGB(0xFEFEFE),
  dividerColor: Color.fromRGB(0xF1F1F1),
  errorColor: Color.fromRGB(0xBF360C), // deep orange 900
  errorBackgroundColor: Color.fromRGB(0xFBE9E7), // deep orange 50

  headline: Font(size: ),

  inputTheme: InputTheme.outline,
  buttonCornerRadius: 4.0
);

const Theme _darkTheme = Theme.custom();



const kBackgroundColor = ;
const kDividerColor = 0xf1f1f1;
const kFlatButtonColor = 0xfcfcfc;

const kErrorColor =
const kErrorBackgroundColor =

/// Platform independent theming information such as colors and fonts.
class Theme {
  final Brightness brightness;

  final Color primaryColor;
  final Color primaryColorLight;
  final Color primaryColorDark;
  final Color secondaryColor;
  final Color secondaryColorLight;
  final Color secondaryColorDark;
  final Color textColorOnPrimary;
  final Color textColorOnSecondary;
  final Color backgroundColor;
  final Color dividerColor;
  final Color errorColor;
  final Color errorBackgroundColor;

  final Font body1;
  final Font body2;
  final Font button;
  final Font caption;
  final Font title;
  final Font headline;
  final Font subhead;

  final InputTheme inputTheme;

  final double buttonCornerRadius;

  factory Theme(Themes type) {
    switch (type) {
      case Themes.dark:
        return _darkTheme;
      case Themes.light:
      default:
        return _lightTheme;
    }
  }

  const Theme.custom(
      {@required this.brightness,
      this.primaryColor: const Color.fromRGB(0x0C4964),
      this.primaryColorLight: const Color.fromRGB(0x437492),
      this.primaryColorDark: const Color.fromRGB(0x00223A),
      this.secondaryColor,
      this.secondaryColorLight,
      this.secondaryColorDark,
      this.textColorOnPrimary,
      this.textColorOnSecondary,
      @required this.backgroundColor,
      @required this.dividerColor,
      @required this.errorColor,
      @required this.errorBackgroundColor,
      @required this.body1,
      @required this.body2,
      @required this.button,
      @required this.caption,
      @required this.headline,
      @required this.title,
      @required this.subhead,
      @required this.inputTheme,
      @required this.buttonCornerRadius});
}

/// Platform independent representation of a font for a [Theme].
class Font {
  final double size;
  final String family;
  final Color color;
  final int weight;
  final bool italic;
  final bool underline;
  final double heightFactor;
  const Font(
      {@required this.size,
      @required this.family,
      this.color: const Color.fromRGB(0),
      this.heightFactor: 1.0,
      this.weight: 400,
      this.italic: false,
      this.underline: false});
}

enum Brightness { light, dark }
enum InputTheme { fill, outline }
