// See the theme at material.io (might have to copy/paste):
// https://material.io/tools/color/#!/?view.left=1&view.right=1&primary.color=0C4964&secondary.color=8DC641&primary.text.color=ffffff

import 'package:meta/meta.dart';
import 'util/colors.dart';
import 'util/fonts.dart';

export 'util/colors.dart';
export 'util/fonts.dart';

// Theme independent properties

// Colors (ARGB, prefixed with an opacity byte)
const _primary = Color(0xFF0C4964);
const _primaryLight = Color(0xFF437492);
const _primaryDark = Color(0xFF00223A);
const _secondary = Color(0xFF8DC641);
const _secondaryLight = Color(0xFFC0F972);
const _secondaryDark = Color(0xFF5B9502);
const _error = Color(0xFFB00020);
const _primaryButton = _secondaryDark;
const _secondaryButton = _primary;
// Colors on top of theme colors (usually text).
const _onPrimary = Colors.white;
const _onPrimaryLight = _onPrimary;
const _onPrimaryDark = _onPrimary;
const _onSecondary = Colors.black;
const _onSecondaryLight = _onSecondary;
const _onSecondaryDark = _onSecondary;
const _onError = Colors.white;
const _onPrimaryButton = _onSecondaryDark;
const _onSecondaryButton = _onPrimary;
// Other
const _inputTheme = InputTheme.outline;
const _buttonCornerRadius = 4.0;

/// Platform independent theming information such as colors and fonts.
class Theme {
  static const defaultTheme = Theme.light;

  /// The statically defined themes.
  static const values = [Theme.light, Theme.dark];

  static Theme fromName(String name) =>
      values.firstWhere((theme) => theme.name == name, orElse: () => null);

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
      {@required this.name,
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

  /// Return SCSS variables and classes for this theme.
  ///
  /// Each property is converted to a class by replacing capital letters with
  /// a hyphen and the lowercase letter, `primaryColor` becomes `primary-color`.
  ///
  /// Single-valued properties such as color will also have a corresponding
  /// variable, in hyphenated-lowercase.
  ///
  /// Global material design variables used by `angular_components` are also
  /// set. See `package:angular_components/css/material/material.scss` and
  /// `package:angular_components/css/mdc_web/theme/mixins.scss`.
  List<String> toScss() => scssVars()..addAll(scssClasses());
  List<String> scssVars() {
    return [
      // Color vars
      '\$primary-color: ${primaryColor.cssValue} !global;',
      '\$primary-color-light: ${primaryColorLight.cssValue} !global;',
      '\$primary-color-dark: ${primaryColorDark.cssValue} !global;',
      '\$secondary-color: ${secondaryColor.cssValue} !global;',
      '\$secondary-color-light: ${secondaryColorLight.cssValue} !global;',
      '\$secondary-color-dark: ${secondaryColorDark.cssValue} !global;',
      '\$background-color: ${backgroundColor.cssValue} !global;',
      '\$surface-color: ${surfaceColor.cssValue} !global;',
      '\$divider-color: ${dividerColor.cssValue} !global;',
      '\$error-color: ${errorColor.cssValue} !global;',
      '\$on-primary-color: ${onPrimaryColor.cssValue} !global;',
      '\$on-primary-color-light: ${onPrimaryColorLight.cssValue} !global;',
      '\$on-primary-color-dark: ${onPrimaryColorDark.cssValue} !global;',
      '\$on-secondary-color: ${onSecondaryColor.cssValue} !global;',
      '\$on-secondary-color-light: ${onSecondaryColorLight.cssValue} !global;',
      '\$on-secondary-color-dark: ${onSecondaryColorDark.cssValue} !global;',
      '\$on-background-color: ${onBackgroundColor.cssValue} !global;',
      '\$on-surface-color: ${onSurfaceColor.cssValue} !global;',
      '\$on-error-color: ${onErrorColor.cssValue} !global;',

      // Color classes
      '.primary-color { background-color: \$primary-color; color: \$on-primary-color; }',
      '.primary-color-light { background-color: \$primary-color-light; color: \$on-primary-color-light; }',
      '.primary-color-dark { background-color: \$primary-color-dark; color: \$on-primary-color-dark; }',
      '.secondary-color { background-color: \$secondary-color; color: \$on-secondary-color; }',
      '.secondary-color-light { background-color: \$secondary-color-light; color: \$on-secondary-color-light; }',
      '.secondary-color-dark { background-color: \$secondary-color-dark; color: \$on-secondary-color-dark; }',
      '.background { background-color: \$background-color; color: \$on-background-color; }',
      '.surface { background-color: \$surface-color; color: \$on-surface-color; }',
      '.error { background-color: \$error-color; color: \$on-error-color; }',
      '.divider { background-color: \$divider-color; }',

      // Font classes
      '.display4 { ${display4.toCss().join(' ')} }',
      '.display3 { ${display3.toCss().join(' ')} }',
      '.display2 { ${display2.toCss().join(' ')} }',
      '.display1 { ${display1.toCss().join(' ')} }',
      '.headline { ${headline.toCss().join(' ')} }',
      '.title { ${title.toCss().join(' ')} }',
      '.subhead { ${subhead.toCss().join(' ')} }',
      '.body2 { ${body2.toCss().join(' ')} }',
      '.body1 { ${body1.toCss().join(' ')} }',
      '.caption { ${caption.toCss().join(' ')} }',
      '.button { ${button.toCss().join(' ')} }',

      // Other
      '\$brightness: ${_brightnessToString(brightness)} !global;',
      '\$input-theme: ${_inputThemeToString(inputTheme)} !global;',

      // `angular_components` global vars.
      '\$mdc-theme-primary: \$primary-color !global;',
      '\$mdc-theme-secondary: \$secondary-color !global;',
      '\$mdc-theme-background: \$background-color !global;',
      '\$mdc-theme-surface: \$surface-color !global;',
      '\$mdc-theme-on-primary: \$on-primary-color !global;',
      '\$mdc-theme-on-secondary: \$on-secondary-color !global;',
      '\$mdc-theme-on-background: \$on-background-color !global;',
      '\$mdc-theme-on-surface: \$on-surface-color !global;',
    ];
  }

  List<String> scssClasses() {
    return [
      // Color classes
      '.primary-color { background-color: \$primary-color; color: \$on-primary-color; }',
      '.primary-color-light { background-color: \$primary-color-light; color: \$on-primary-color-light; }',
      '.primary-color-dark { background-color: \$primary-color-dark; color: \$on-primary-color-dark; }',
      '.secondary-color { background-color: \$secondary-color; color: \$on-secondary-color; }',
      '.secondary-color-light { background-color: \$secondary-color-light; color: \$on-secondary-color-light; }',
      '.secondary-color-dark { background-color: \$secondary-color-dark; color: \$on-secondary-color-dark; }',
      '.background { background-color: \$background-color; color: \$on-background-color; }',
      '.surface { background-color: \$surface-color; color: \$on-surface-color; }',
      '.error { background-color: \$error-color; color: \$on-error-color; }',
      '.divider { background-color: \$divider-color; }',

      // Font classes
      '.display4 { ${display4.toCss().join(' ')} }',
      '.display3 { ${display3.toCss().join(' ')} }',
      '.display2 { ${display2.toCss().join(' ')} }',
      '.display1 { ${display1.toCss().join(' ')} }',
      '.headline { ${headline.toCss().join(' ')} }',
      '.title { ${title.toCss().join(' ')} }',
      '.subhead { ${subhead.toCss().join(' ')} }',
      '.body2 { ${body2.toCss().join(' ')} }',
      '.body1 { ${body1.toCss().join(' ')} }',
      '.caption { ${caption.toCss().join(' ')} }',
      '.button { ${button.toCss().join(' ')} }',
    ];
  }
}

enum Brightness { light, dark }
enum InputTheme { fill, outline }

String _brightnessToString(Brightness brightness) {
  switch (brightness) {
    case Brightness.light:
      return 'light';
    case Brightness.dark:
      return 'dark';
    default:
      return '';
  }
}

String _inputThemeToString(InputTheme inputTheme) {
  switch (inputTheme) {
    case InputTheme.fill:
      return 'fill';
    case InputTheme.outline:
      return 'outline';
    default:
      return '';
  }
}
