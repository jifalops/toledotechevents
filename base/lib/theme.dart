// See the theme at material.io: https://goo.gl/qC57Cd

import 'package:meta/meta.dart';
import 'util/colors.dart';
import 'util/fonts.dart';

export 'util/colors.dart';
export 'util/fonts.dart';

// Set theme defaults here.

// Brand colors.
const _primaryColor = Color(0xFF0C4964);
const _onPrimaryColor = Colors.white;
const _primaryColorLight = Color(0xFF437492);
const _onPrimaryColorLight = _onPrimaryColor;
const _primaryColorDark = Color(0xFF00223A);
const _onPrimaryColorDark = _onPrimaryColor;
const _secondaryColor = Color(0xFF8DC641);
const _onSecondaryColor = Colors.black;
const _secondaryColorLight = Color(0xFFC0F972);
const _onSecondaryColorLight = _onSecondaryColor;
const _secondaryColorDark = Color(0xFF5B9502);
const _onSecondaryColorDark = _onSecondaryColor;

// Other theme-independent properties.
const _errorColor = Colors.error;
const _onErrorColor = Colors.onError;
const _primaryButtonColor = _secondaryColorDark;
const _onPrimaryButtonColor = _onSecondaryColorDark;
const _secondaryButtonColor = _primaryColor;
const _onSecondaryButtonColor = _onPrimaryColor;
const _inputTheme = InputTheme.outline;
const _buttonCornerRadius = 4.0;

// Theme font-sets (only color changes between themes in this app).
final _darkFonts = FontSet(
    headline: Fonts.headlineBlack
        .copyWith(weight: 700, height: 2.5, family: 'Ubuntu'),
    title: Fonts.titleBlack.copyWith(weight: 700, family: 'Ubuntu'),
    subhead: Fonts.subheadBlack
        .copyWith(size: 18.0, height: 1.75, weight: 300, family: 'Ubuntu'),
    body2: Fonts.body2Black.copyWith(
        size: 18.0, weight: 600, color: _primaryColor, family: 'Open Sans'),
    body1: Fonts.body1Black
        .copyWith(size: 16.0, height: 1.15, family: 'Open Sans'),
    caption: Fonts.captionBlack.copyWith(size: 16.0, family: 'Open Sans'),
    button: Fonts.buttonBlack.copyWith(family: 'Open Sans'));

final _lightFonts = FontSet(
  display4: _darkFonts.display4.copyWith(color: Fonts.display4White.color),
  display3: _darkFonts.display3.copyWith(color: Fonts.display3White.color),
  display2: _darkFonts.display2.copyWith(color: Fonts.display2White.color),
  display1: _darkFonts.display1.copyWith(color: Fonts.display1White.color),
  headline: _darkFonts.headline.copyWith(color: Fonts.headlineWhite.color),
  subhead: _darkFonts.subhead.copyWith(color: Fonts.subheadWhite.color),
  body2: _darkFonts.body2, // Uses brand color.
  caption: _darkFonts.caption.copyWith(color: Fonts.captionWhite.color),
  button: _darkFonts.button.copyWith(color: Fonts.buttonWhite.color),
);

class Theme {
  // Brand colors.
  final primaryColor = _primaryColor;
  final onPrimaryColor = _onPrimaryColor;
  final primaryColorLight = _primaryColorLight;
  final onPrimaryColorLight = _onPrimaryColorLight;
  final primaryColorDark = _primaryColorDark;
  final onPrimaryColorDark = _onPrimaryColorDark;
  final secondaryColor = _secondaryColor;
  final onSecondaryColor = _onSecondaryColor;
  final secondaryColorLight = _secondaryColorLight;
  final onSecondaryColorLight = _onSecondaryColorLight;
  final secondaryColorDark = _secondaryColorDark;
  final onSecondaryColorDark = _onSecondaryColorDark;

  // Other theme-independent properties.
  final errorColor = _errorColor;
  final onErrorColor = _onErrorColor;
  final primaryButtonColor = _primaryButtonColor;
  final onPrimaryButtonColor = _onPrimaryButtonColor;
  final secondaryButtonColor = _secondaryButtonColor;
  final onSecondaryButtonColor = _onSecondaryButtonColor;
  final inputTheme = _inputTheme;
  final buttonCornerRadius = _buttonCornerRadius;

  final String name;
  final Brightness brightness;

  // Theme-dependent colors.
  final Color backgroundColor;
  final Color onBackgroundColor;
  final Color surfaceColor;
  final Color onSurfaceColor;
  final Color dividerColor;

  // Fonts.
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

  Theme._(
      {@required this.name,
      @required this.brightness,
      // Colors.
      @required this.dividerColor,
      @required this.backgroundColor,
      @required this.surfaceColor,
      @required this.onBackgroundColor,
      @required this.onSurfaceColor,
      // Fonts
      @required FontSet fontSet})
      : display4 = fontSet.display4,
        display3 = fontSet.display4,
        display2 = fontSet.display4,
        display1 = fontSet.display4,
        headline = fontSet.headline,
        title = fontSet.title,
        subhead = fontSet.subhead,
        body2 = fontSet.body2,
        body1 = fontSet.body1,
        caption = fontSet.caption,
        button = fontSet.button;

  /// The business's light theme.
  static final light = Theme._(
      name: 'Light',
      brightness: Brightness.light,
      fontSet: _darkFonts,
      // Colors.
      backgroundColor: Color(0xFFFEFEFE),
      onBackgroundColor: Colors.black87,
      surfaceColor: Color(0xFFFEFEFE),
      onSurfaceColor: Colors.black87,
      dividerColor: Colors.black12);

  /// The business's dark theme.
  static final Theme dark = Theme._(
      name: 'Dark',
      brightness: Brightness.dark,
      fontSet: _lightFonts,
      // Colors.
      backgroundColor: Color(0xFF212121),
      onBackgroundColor: Colors.white,
      surfaceColor: Color(0xFF212121),
      onSurfaceColor: Colors.white,
      dividerColor: Color(0xFF333333));

  /// The statically defined themes.
  static final values = [Theme.light, Theme.dark];
  static final defaultTheme = Theme.light;

  static Theme fromName(String name) =>
      values.firstWhere((theme) => theme.name == name, orElse: () => null);

  /// Return an SCSS map for this theme.
  String toScssMap() => '''(
  // Colors.
  primaryColor: ${primaryColor.cssValue},
  primaryColorLight: ${primaryColorLight.cssValue},
  primaryColorDark: ${primaryColorDark.cssValue},
  secondaryColor: ${secondaryColor.cssValue},
  secondaryColorLight: ${secondaryColorLight.cssValue},
  secondaryColorDark: ${secondaryColorDark.cssValue},
  backgroundColor: ${backgroundColor.cssValue},
  surfaceColor: ${surfaceColor.cssValue},
  dividerColor: ${dividerColor.cssValue},
  errorColor: ${errorColor.cssValue},
  onPrimaryColor: ${onPrimaryColor.cssValue},
  onPrimaryColorLight: ${onPrimaryColorLight.cssValue},
  onPrimaryColorDark: ${onPrimaryColorDark.cssValue},
  onSecondaryColor: ${onSecondaryColor.cssValue},
  onSecondaryColorLight: ${onSecondaryColorLight.cssValue},
  onSecondaryColorDark: ${onSecondaryColorDark.cssValue},
  onBackgroundColor: ${onBackgroundColor.cssValue},
  onSurfaceColor: ${onSurfaceColor.cssValue},
  onErrorColor: ${onErrorColor.cssValue},
  primaryButtonColor: ${primaryButtonColor.cssValue},
  secondaryButtonColor: ${secondaryButtonColor.cssValue},
  onPrimaryButtonColor: ${onPrimaryButtonColor.cssValue},
  onSecondaryButtonColor: ${onSecondaryButtonColor.cssValue},
  // Fonts.
  display4: ${display4.toScssMap()},
  display3: ${display3.toScssMap()},
  display2: ${display2.toScssMap()},
  display1: ${display1.toScssMap()},
  headline: ${headline.toScssMap()},
  title: ${title.toScssMap()},
  subhead: ${subhead.toScssMap()},
  body2: ${body2.toScssMap()},
  body1: ${body1.toScssMap()},
  caption: ${caption.toScssMap()},
  button: ${button.toScssMap()},
  // Other.
  brightness: ${_brightnessToString(brightness)},
  inputTheme: ${_inputThemeToString(inputTheme)},
  buttonCornerRadius: ${buttonCornerRadius}px,
)''';
  // `angular_components` global vars.
  //     mdc-theme-primary: \$primary-color,
  //     mdc-theme-secondary: \$secondary-color,
  //     mdc-theme-background: \$background-color,
  //     mdc-theme-surface: \$surface-color,
  //     mdc-theme-on-primary: \$on-primary-color,
  //     mdc-theme-on-secondary: \$on-secondary-color,
  //     mdc-theme-on-background: \$on-background-color,
  //     mdc-theme-on-surface: \$on-surface-color,
  //   ];
  // }

  // List<String> scssClasses() {
  //   return [
  //     // Color classes
  //     '.primary-color { background-color: \$primary-color; color: \$on-primary-color; }',
  //     '.primary-color-light { background-color: \$primary-color-light; color: \$on-primary-color-light; }',
  //     '.primary-color-dark { background-color: \$primary-color-dark; color: \$on-primary-color-dark; }',
  //     '.secondary-color { background-color: \$secondary-color; color: \$on-secondary-color; }',
  //     '.secondary-color-light { background-color: \$secondary-color-light; color: \$on-secondary-color-light; }',
  //     '.secondary-color-dark { background-color: \$secondary-color-dark; color: \$on-secondary-color-dark; }',
  //     '.background { background-color: \$background-color; color: \$on-background-color; }',
  //     '.surface { background-color: \$surface-color; color: \$on-surface-color; }',
  //     '.error { background-color: \$error-color; color: \$on-error-color; }',
  //     '.divider { background-color: \$divider-color; }',

  //     // Font classes
  //     '.display4 { ${display4.toCss().join(' ')} }',
  //     '.display3 { ${display3.toCss().join(' ')} }',
  //     '.display2 { ${display2.toCss().join(' ')} }',
  //     '.display1 { ${display1.toCss().join(' ')} }',
  //     '.headline { ${headline.toCss().join(' ')} }',
  //     '.title { ${title.toCss().join(' ')} }',
  //     '.subhead { ${subhead.toCss().join(' ')} }',
  //     '.body2 { ${body2.toCss().join(' ')} }',
  //     '.body1 { ${body1.toCss().join(' ')} }',
  //     '.caption { ${caption.toCss().join(' ')} }',
  //     '.button { ${button.toCss().join(' ')} }',
  //   ];
  // }
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
