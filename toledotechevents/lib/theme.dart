// See the theme @material.io:
// https://material.io/tools/color/#!/?view.left=1&view.right=1&primary.color=0C4964&secondary.color=8DC641&primary.text.color=ffffff

import 'package:meta/meta.dart';
import 'util/colors.dart';
import 'util/fonts.dart';

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
  /// The statically defined themes.
  ///
  /// For the default theme use `Theme.values[0]`.
  static const values = [Theme.light, Theme.dark];

  /// The business's light theme.
  static const Theme light = Theme._(
      name: 'Light',
      backgroundColor: Color(0xFFFEFEFE),
      surfaceColor: Color(0xFFFEFEFE),
      // These fonts are based on the material [Fonts.*], but defined here
      // statically so this theme definition can be a `const`.
      headline: Font(size: 24.0, weight: 700, height: 2.5, family: 'Ubuntu'),
      title: Font(size: 20.0, weight: 700, family: 'Ubuntu'),
      subhead: Font(size: 18.0, height: 1.75, weight: 300, family: 'Ubuntu'),
      body2:
          Font(size: 18.0, weight: 600, color: _primary, family: 'Open Sans'),
      body1: Font(size: 16.0, height: 1.15, family: 'Open Sans'),
      caption: Font(size: 16.0, color: Colors.black54, family: 'Open Sans'),
      button: Font(size: 14.0, weight: 500, family: 'Open Sans'));

  /// The business's dark theme.
  static const Theme dark = Theme._(
      name: 'Dark',
      brightness: Brightness.dark,
      backgroundColor: Color(0xFF212121),
      onBackgroundColor: Colors.white,
      surfaceColor: Color(0xFF212121),
      onSurfaceColor: Colors.white,
      dividerColor: Color(0xFF333333),
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
      display1: Fonts.display1White);

  const Theme._(
      {this.name: 'Default',
      this.brightness: Brightness.light,
      // Colors (ARGB, prefixed with an opacity byte)
      this.primaryColor: _primary,
      this.primaryColorLight: _primaryLight,
      this.primaryColorDark: _primaryDark,
      this.secondaryColor: _secondary,
      this.secondaryColorLight: _secondaryLight,
      this.secondaryColorDark: _secondaryDark,
      this.errorColor: _error,
      this.primaryButtonColor: _primaryButton,
      this.secondaryButtonColor: _secondaryButton,
      // Color on top of theme colors (usually text).
      this.onPrimaryColor: _onPrimary,
      this.onPrimaryColorLight: _onPrimaryLight,
      this.onPrimaryColorDark: _onPrimaryDark,
      this.onSecondaryColor: _onSecondary,
      this.onSecondaryColorLight: _onSecondaryLight,
      this.onSecondaryColorDark: _onSecondaryDark,
      this.onErrorColor: _onError,
      this.onPrimaryButtonColor: _onPrimaryButton,
      this.onSecondaryButtonColor: _onSecondaryButton,
      // Other colors.
      this.dividerColor: Colors.black12,
      this.backgroundColor: Colors.white,
      this.surfaceColor: Colors.white,
      this.onBackgroundColor: Colors.black87,
      this.onSurfaceColor: Colors.black87,
      // Fonts
      this.display4: Fonts.display4Black,
      this.display3: Fonts.display3Black,
      this.display2: Fonts.display2Black,
      this.display1: Fonts.display1Black,
      this.headline: Fonts.headlineBlack,
      this.title: Fonts.titleBlack,
      this.subhead: Fonts.subheadBlack,
      this.body2: Fonts.body2Black,
      this.body1: Fonts.body1Black,
      this.caption: Fonts.captionBlack,
      this.button: Fonts.buttonBlack,
      // Other
      this.inputTheme: _inputTheme,
      this.buttonCornerRadius: _buttonCornerRadius});

  final String name;
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
}

enum Brightness { light, dark }
enum InputTheme { fill, outline }
