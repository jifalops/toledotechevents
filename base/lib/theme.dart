// See the theme at material.io: https://goo.gl/qC57Cd
import 'package:meta/meta.dart';
import 'package:toledotechevents/util/colors.dart';
import 'package:toledotechevents/util/fonts.dart';

export 'package:toledotechevents/util/colors.dart';
export 'package:toledotechevents/util/fonts.dart';

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
const _onSecondaryColorDark = Colors.white;

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
  body1: _darkFonts.body1.copyWith(color: Fonts.body1White.color),
  caption: _darkFonts.caption.copyWith(color: Fonts.captionWhite.color),
  button: _darkFonts.button.copyWith(color: Fonts.buttonWhite.color),
);

class Theme {
  /// The predefined themes.
  static final values = [Theme.light, Theme.dark];
  static final defaultTheme = Theme.light;

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
      dividerColor: Color(0xFFEEEEEE));

  /// The business's dark theme.
  static final Theme dark = Theme._(
      name: 'Dark',
      brightness: Brightness.dark,
      fontSet: _lightFonts,
      // Colors.
      backgroundColor: Color(0xFF333333),
      onBackgroundColor: Colors.white,
      surfaceColor: Color(0xFF333333),
      onSurfaceColor: Colors.white,
      dividerColor: Color(0xFF484848));

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

  static String combineThemestoScss() {
    final sb = StringBuffer();
    Theme.values.forEach((theme) {
      sb.writeln('// ${theme.name} theme.');
      sb.writeln('${theme.name.toLowerCase()}: ${theme.toScssMap()},');
      sb.writeln('');
    });
    return '''// GENERATED CONTENT, CHANGES WILL BE LOST.
@import 'package:angular_components/css/material/material';
@import 'package:angular_components/css/mdc_web/theme/mixins';

//
// Theme maps.
//
\$themes: (
  ${sb.toString()}
);

//
// Themify utility
//
$_themifyScss

//
// Styles
//

// Fonts
@font-face {
  font-family: 'Open Sans';
  src: url('packages/toledotechevents/assets/fonts/OpenSans-Regular.ttf') format('truetype');
}
@font-face {
  font-family: 'Open Sans';
  font-weight: 500;
  src: url('packages/toledotechevents/assets/fonts/OpenSans-SemiBold.ttf') format('truetype');
}
@font-face {
  font-family: 'Open Sans';
  font-weight: 300;
  src: url('packages/toledotechevents/assets/fonts/OpenSans-Light.ttf') format('truetype');
}
@font-face {
  font-family: 'Open Sans';
  font-weight: 700;
  src: url('packages/toledotechevents/assets/fonts/OpenSans-Bold.ttf') format('truetype');
}
@font-face {
  font-family: 'Open Sans';
  font-style: italic;
  src: url('packages/toledotechevents/assets/fonts/OpenSans-Italic.ttf') format('truetype');
}
@font-face {
  font-family: 'Ubuntu';
  src: url('packages/toledotechevents/assets/fonts/Ubuntu-Regular.ttf') format('truetype');
}
@font-face {
  font-family: 'Ubuntu';
  font-weight: 300;
  src: url('packages/toledotechevents/assets/fonts/Ubuntu-Light.ttf') format('truetype');
}
@font-face {
  font-family: 'Ubuntu';
  font-weight: 700;
  src: url('packages/toledotechevents/assets/fonts/Ubuntu-Bold.ttf') format('truetype');
}

// Material design Sass globals.
body {
  @include themify {
    // `angular_components` global vars.
    \$mdc-theme-primary: themed('primaryColor') !global;
    \$mdc-theme-secondary: themed('secondaryColor') !global;
    \$mdc-theme-background: themed('backgroundColor') !global;
    \$mdc-theme-surface: themed('surfaceColor') !global;
    \$mdc-theme-on-primary: themed('onPrimaryColor') !global;
    \$mdc-theme-on-secondary: themed('onSecondaryColor') !global;
    \$mdc-theme-on-background: themed('onBackgroundColor') !global;
    \$mdc-theme-on-surface: themed('onSurfaceColor') !global;
  }
}

// Colors.

.primary-color {
  @include themify {
    background-color: themed('primaryColor');
    color: themed('onPrimaryColor');
  }
}
.primary-color-light {
  @include themify {
    background-color: themed('primaryColorLight');
    color: themed('onPrimaryColorLight');
  }
}
.primary-color-dark {
  @include themify {
    background-color: themed('primaryColorDark');
    color: themed('onPrimaryColorDark');
  }
}
.secondary-color {
  @include themify {
    background-color: themed('secondaryColor');
    color: themed('onSecondaryColor');
  }
}
.secondary-color-light {
  @include themify {
    background-color: themed('secondaryColorLight');
    color: themed('onSecondaryColorLight');
  }
}
.secondary-color-dark {
  @include themify {
    background-color: themed('secondaryColorDark');
    color: themed('onSecondaryColorDark');
  }
}
.background-color {
  @include themify {
    background-color: themed('backgroundColor');
    color: themed('onBackgroundColor');
  }
}
.surface-color {
  @include themify {
    background-color: themed('surfaceColor');
    color: themed('onSurfaceColor');
  }
}
.error {
  @include themify {
    background-color: themed('errorColor');
    color: themed('onErrorColor');
  }
}
.divider {
  @include themify {
    background-color: themed('dividerColor');
  }
}

// Fonts.

.display4 {
  @include themify {
    font: themed2('display4', 'font');
    text-decoration: themed2('display4', 'text-decoration');
    color: themed2('display4', 'color');
  }
}

.display3 {
  @include themify {
    font: themed2('display3', 'font');
    text-decoration: themed2('display3', 'text-decoration');
    color: themed2('display3', 'color');
  }
}

.display2 {
  @include themify {
    font: themed2('display2', 'font');
    text-decoration: themed2('display2', 'text-decoration');
    color: themed2('display2', 'color');
  }
}

.display1 {
  @include themify {
    font: themed2('display1', 'font');
    text-decoration: themed2('display1', 'text-decoration');
    color: themed2('display1', 'color');
  }
}

.headline {
  @include themify {
    font: themed2('headline', 'font');
    text-decoration: themed2('headline', 'text-decoration');
    color: themed2('headline', 'color');
  }
}

.title {
  @include themify {
    font: themed2('title', 'font');
    text-decoration: themed2('title', 'text-decoration');
    color: themed2('title', 'color');
  }
}

.subhead {
  @include themify {
    font: themed2('subhead', 'font');
    text-decoration: themed2('subhead', 'text-decoration');
    color: themed2('subhead', 'color');
  }
}

.body2 {
  @include themify {
    font: themed2('body2', 'font');
    text-decoration: themed2('body2', 'text-decoration');
    color: themed2('body2', 'color');
  }
}

.body1 {
  @include themify {
    font: themed2('body1', 'font');
    text-decoration: themed2('body1', 'text-decoration');
    color: themed2('body1', 'color');
  }
}

.caption {
  @include themify {
    font: themed2('caption', 'font');
    text-decoration: themed2('caption', 'text-decoration');
    color: themed2('caption', 'color');
  }
}

.button {
  @include themify {
    font: themed2('button', 'font');
    text-decoration: themed2('button', 'text-decoration');
    color: themed2('button', 'color');
    border-radius: themed('buttonCornerRadius');
  }
}

// Other

.primary-button {
  @include themify {
    font: themed2('button', 'font');
    text-decoration: themed2('button', 'text-decoration');
    background-color: themed('primaryButtonColor');
    color: themed('onPrimaryButtonColor');
    border-radius: themed('buttonCornerRadius');
  }
}

.secondary-button {
  @include themify {
    font: themed2('button', 'font');
    text-decoration: themed2('button', 'text-decoration');
    background-color: themed('secondaryButtonColor');
    color: themed('onSecondaryButtonColor');
    border-radius: themed('buttonCornerRadius');
  }
}
''';
  }
}

const _themifyScss = r'''
// See https://medium.com/@dmitriy.borodiy/easy-color-theming-with-scss-bc38fd5734d1

@mixin themify {
  @each $theme, $map in $themes {

    .theme-#{$theme} & {
      $theme-map: () !global;
      @each $key, $submap in $map {
        $value: map-get(map-get($themes, $theme), '#{$key}');
        $theme-map: map-merge($theme-map, ($key: $value)) !global;
      }

      @content;
      $theme-map: null !global;
    }

  }
}

@function themed($key) {
  @return map-get($theme-map, $key);
}

@function themed2($key1, $key2) {
  @return map-get(themed($key1), $key2);
}
''';

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
