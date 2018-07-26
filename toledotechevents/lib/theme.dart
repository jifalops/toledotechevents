class Theme {
  final Brightness brightness;

  Theme({this.brightness: Brightness.light});

  @override
  operator ==(other) => brightness == other.brightness;

  @override
  int get hashCode => '$brightness'.hashCode;
}

enum Brightness { light, dark }
