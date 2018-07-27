import 'package:meta/meta.dart';

/// Usually a device's screen.
class Display {
  final double height;
  final double width;
  final Orientation orientation;

  double _aspectRatio;
  SpecificDisplayType _specificType;
  DisplayType _type;
  int _columns;
  double _defaultMarginsAndGutters;

  Display(
      {@required this.height,
      @required this.width,
      @required this.orientation});

  double get aspectRatio => _aspectRatio ??= width / height;
  SpecificDisplayType get specificType =>
      _specificType ??= _calcSpecificType(height, width, orientation);
  DisplayType get type => _type ??= _calcType(specificType);
  int get columns => _columns ??= _calcColumns(width);
  double get defaultMarginsAndGutters =>
      _defaultMarginsAndGutters ??= _calcMarginsAndGutters(width);

  @override
  operator ==(other) =>
      height == other.height &&
      width == other.width &&
      orientation == other.orientation;

  @override
  int get hashCode => '$height$width$orientation'.hashCode;
}

enum Orientation { portrait, landscape }

/// An aggregated version of [SpecificDisplayType].
enum DisplayType { mobile, tablet, window }

/// See https://material.io/design/layout/responsive-layout-grid.html#breakpoints
enum SpecificDisplayType {
  smallHandset,
  mediumHandset,
  largeHandset,
  smallTablet,
  largeTablet,
  extraSmallWindow,
  smallWindow,
  mediumWindow,
  largeWindow,
  extraLargeWindow
}

DisplayType _calcType(SpecificDisplayType type) {
  switch (type) {
    case SpecificDisplayType.smallHandset:
    case SpecificDisplayType.mediumHandset:
    case SpecificDisplayType.largeHandset:
    case SpecificDisplayType.extraSmallWindow:
      return DisplayType.mobile;
    case SpecificDisplayType.smallTablet:
    case SpecificDisplayType.largeTablet:
    case SpecificDisplayType.smallWindow:
      return DisplayType.tablet;
    default:
      return DisplayType.window;
  }
}

SpecificDisplayType _calcSpecificType(
    double height, double width, Orientation orientation) {
  switch (orientation) {
    case Orientation.portrait:
      if (width < 360)
        return SpecificDisplayType.smallHandset;
      else if (width < 400)
        return SpecificDisplayType.mediumHandset;
      else if (width < 600)
        return SpecificDisplayType.largeHandset;
      else if (width < 720)
        return SpecificDisplayType.smallTablet;
      else if (width < 960)
        return SpecificDisplayType.largeTablet;
      else if (width < 1024)
        return SpecificDisplayType.smallWindow;
      else if (width < 1440)
        return SpecificDisplayType.mediumWindow;
      else if (width < 1920)
        return SpecificDisplayType.largeWindow;
      else
        return SpecificDisplayType.extraLargeWindow;
      break;
    case Orientation.landscape:
    default:
      if (width < 480)
        return SpecificDisplayType.extraSmallWindow;
      else if (width < 600)
        return SpecificDisplayType.smallHandset;
      else if (width < 720)
        return SpecificDisplayType.mediumHandset;
      else if (width < 960)
        return SpecificDisplayType.largeHandset;
      else if (width < 1024)
        return SpecificDisplayType.smallTablet;
      else if (width < 1440)
        return SpecificDisplayType.largeTablet;
      else if (width < 1920)
        return SpecificDisplayType.largeWindow;
      else
        return SpecificDisplayType.extraLargeWindow;
      break;
  }
}

/// See https://material.io/design/layout/responsive-layout-grid.html#breakpoints
int _calcColumns(double width) {
  if (width < 600)
    return 4;
  else if (width < 840)
    return 8;
  else
    return 12;
}

/// See https://material.io/design/layout/responsive-layout-grid.html#breakpoints
double _calcMarginsAndGutters(double width) {
  if (width < 720)
    return 16.0;
  else
    return 24.0;
}
