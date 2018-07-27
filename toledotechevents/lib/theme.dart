/// Domain-specific theming information such as colors and fonts.
class Theme {
  final Brightness brightness;

  Theme({this.brightness: Brightness.light});

  @override
  operator ==(other) => brightness == other.brightness;

  @override
  int get hashCode => '$brightness'.hashCode;
}

enum Brightness { light, dark }

enum InputTheme { fill, outline }

class ButtonTheme {}

class RoundedCornerButtonTheme extends ButtonTheme {
  final double radiusX, radiusY;
  RoundedCornerButtonTheme(this.radiusX, this.radiusY);
}
