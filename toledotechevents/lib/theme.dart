// See the theme @material.io:
// https://material.io/tools/color/#!/?view.left=1&view.right=1&primary.color=0C4964&secondary.color=8DC641&primary.text.color=ffffff

import 'package:meta/meta.dart';
import 'util/colors.dart';
import 'util/fonts.dart';

/// The available [Theme]s. Used for showing the user their options.
class Themes {

}

// Shared theme properties. This makes reusing them easier.

// Colors (ARGB, prefixed with an opacity byte)
const _primary = Color(0xFF0C4964);
const _primaryLight = Color(0xFF437492);
const _primaryDark = Color(0xFF00223A);
const _secondary = Color(0xFF8DC641);
const _secondaryLight = Color(0xFFC0F972);
const _secondaryDark = Color(0xFF5B9502);
const _error = Color(0xFFB00020);
// Colors on top of theme colors (usually text).
const _onPrimary = Colors.white;
const _onPrimaryLight = Colors.white;
const _onPrimaryDark = Colors.white;
const _onSecondary = Colors.black;
const _onSecondaryLight = Colors.black;
const _onSecondaryDark = Colors.black;
const _onError = Colors.white;
// Other
const _inputTheme = InputTheme.outline;
const _buttonCornerRadius = 4.0;
// Derivative
const _primaryButton = _secondaryDark;
const _onPrimaryButton = _onSecondaryDark;
const _secondaryButton = _primary;
const _onSecondaryButton = _onPrimary;

/// Platform independent theming information such as colors and fonts.
///
/// Class properties can be modified according to business needs.
class Theme {
  /// The business's light theme.
  static const Theme light = Theme._(
      brightness: Brightness.light,
      backgroundColor: Color(0xFEFEFE),
      onBackgroundColor: Colors.black87,
      surfaceColor: Color(0xFEFEFE),
      onSurfaceColor: Colors.black87,
      dividerColor: Color(0xF1F1F1),
      // These fonts are based on the material [Fonts.*], but defined here
      // statically so this theme definition can be a `const`.
      headline: Font(size: 24.0, weight: 700, height: 2.5, family: 'Ubuntu'),
      title: Font(size: 20.0, weight: 700, family: 'Ubuntu'),
      subhead: Font(size: 18.0, height: 1.75, weight: 300, family: 'Ubuntu'),
      body2:
          Font(size: 18.0, weight: 600, color: _primary, family: 'Open Sans'),
      body1: Font(size: 16.0, height: 1.15, family: 'Open Sans'),
      caption: Font(size: 16.0, color: Colors.black54, family: 'Open Sans'),
      button: Font(size: 14.0, weight: 500, family: 'Open Sans'),
      display4: Fonts.display4Black,
      display3: Fonts.display3Black,
      display2: Fonts.display2Black,
      display1: Fonts.display1Black,
      // Theme independent
      primaryColor: _primary,
      primaryColorLight: _primaryLight,
      primaryColorDark: _primaryDark,
      secondaryColor: _secondary,
      secondaryColorLight: _secondaryLight,
      secondaryColorDark: _secondaryDark,
      errorColor: _error,
      primaryButtonColor: _primaryButton,
      secondaryButtonColor: _secondaryButton,
      onPrimaryColor: _onPrimary,
      onPrimaryColorLight: _onPrimaryLight,
      onPrimaryColorDark: _onPrimaryDark,
      onSecondaryColor: _onSecondary,
      onSecondaryColorLight: _onSecondaryLight,
      onSecondaryColorDark: _onSecondaryDark,
      onErrorColor: _onError,
      onPrimaryButtonColor: _onPrimaryButton,
      onSecondaryButtonColor: _onSecondaryButton,
      inputTheme: _inputTheme,
      buttonCornerRadius: _buttonCornerRadius);

  /// The business's dark theme.
  static const Theme dark = Theme._(
      brightness: Brightness.dark,
      backgroundColor: Color(0x212121),
      onBackgroundColor: Colors.white,
      surfaceColor: Color(0x212121),
      onSurfaceColor: Colors.white,
      dividerColor: Color(0x333333),
      // These fonts are based on the material [Fonts.*], but defined here
      // statically so this theme definition can be a `const`.
      headline: Font(
          size: 24.0,
          weight: 700,
          height: 2.5,
          family: 'Ubuntu',
          color: Colors.white),
      title:
          Font(size: 20.0, weight: 700, family: 'Ubuntu', color: Colors.white),
      subhead: Font(
          size: 18.0,
          height: 1.75,
          weight: 300,
          family: 'Ubuntu',
          color: Colors.white),
      body2:
          Font(size: 18.0, weight: 600, color: _primary, family: 'Open Sans'),
      body1: Font(
          size: 16.0, height: 1.15, family: 'Open Sans', color: Colors.white),
      caption: Font(size: 16.0, color: Colors.white70, family: 'Open Sans'),
      button: Font(
          size: 14.0, weight: 500, family: 'Open Sans', color: Colors.white),
      display4: Fonts.display4White,
      display3: Fonts.display3White,
      display2: Fonts.display2White,
      display1: Fonts.display1White,
      // Theme independent
      primaryColor: _primary,
      primaryColorLight: _primaryLight,
      primaryColorDark: _primaryDark,
      secondaryColor: _secondary,
      secondaryColorLight: _secondaryLight,
      secondaryColorDark: _secondaryDark,
      errorColor: _error,
      primaryButtonColor: _primaryButton,
      secondaryButtonColor: _secondaryButton,
      onPrimaryColor: _onPrimary,
      onPrimaryColorLight: _onPrimaryLight,
      onPrimaryColorDark: _onPrimaryDark,
      onSecondaryColor: _onSecondary,
      onSecondaryColorLight: _onSecondaryLight,
      onSecondaryColorDark: _onSecondaryDark,
      onErrorColor: _onError,
      onPrimaryButtonColor: _onPrimaryButton,
      onSecondaryButtonColor: _onSecondaryButton,
      inputTheme: _inputTheme,
      buttonCornerRadius: _buttonCornerRadius);

  final Brightness brightness;
  // Colors
  final Color primaryColor;
  final Color primaryColorLight;
  final Color primaryColorDark;
  final Color secondaryColor;
  final Color secondaryColorLight;
  final Color secondaryColorDark;
  final Color backgroundColor;
  final Color surfaceColor;
  final Color dividerColor;
  final Color errorColor;
  final Color primaryButtonColor;
  final Color secondaryButtonColor;
  // Color on top of theme colors (usually text).
  final Color onPrimaryColor;
  final Color onPrimaryColorLight;
  final Color onPrimaryColorDark;
  final Color onSecondaryColor;
  final Color onSecondaryColorLight;
  final Color onSecondaryColorDark;
  final Color onBackgroundColor;
  final Color onSurfaceColor;
  final Color onErrorColor;
  final Color onPrimaryButtonColor;
  final Color onSecondaryButtonColor;
  // Fonts
  final Font display4;
  final Font display3;
  final Font display2;
  final Font display1;
  final Font headline;
  final Font title;
  final Font subhead;
  final Font body2;
  final Font body1;
  final Font caption;
  final Font button;
  // Other
  final InputTheme inputTheme;
  final double buttonCornerRadius;

  const Theme._(
      {@required this.brightness,
      // Colors
      @required this.primaryColor,
      @required this.primaryColorLight,
      @required this.primaryColorDark,
      @required this.secondaryColor,
      @required this.secondaryColorLight,
      @required this.secondaryColorDark,
      @required this.backgroundColor,
      @required this.surfaceColor,
      @required this.dividerColor,
      @required this.errorColor,
      @required this.primaryButtonColor,
      @required this.secondaryButtonColor,
      // Color on top of theme colors (usually text).
      @required this.onPrimaryColor,
      @required this.onPrimaryColorLight,
      @required this.onPrimaryColorDark,
      @required this.onSecondaryColor,
      @required this.onSecondaryColorLight,
      @required this.onSecondaryColorDark,
      @required this.onBackgroundColor,
      @required this.onSurfaceColor,
      @required this.onErrorColor,
      @required this.onPrimaryButtonColor,
      @required this.onSecondaryButtonColor,
      // Fonts
      @required this.display4,
      @required this.display3,
      @required this.display2,
      @required this.display1,
      @required this.headline,
      @required this.title,
      @required this.subhead,
      @required this.body2,
      @required this.body1,
      @required this.caption,
      @required this.button,
      // Other
      @required this.inputTheme,
      @required this.buttonCornerRadius});
}

enum Brightness { light, dark }
enum InputTheme { fill, outline }
