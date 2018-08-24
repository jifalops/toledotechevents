import 'package:meta/meta.dart';

/// A [Display] represents device's screen or other container such as an iframe.
///
/// It includes lazy getters for some derivable properties such as the
/// [Material breakpoints](https://material.io/design/layout/responsive-layout-grid.html#breakpoints)
/// for screen type, columns, and default margins/gutters.
class Display {
  final double height;
  final double width;
  final Orientation orientation;

  double _aspectRatio;
  MaterialDisplayType _specificType;
  DisplayType _type;
  int _columns;
  double _defaultMarginsAndGutters;

  Display(
      {@required this.height, @required this.width, Orientation orientation})
      : orientation = orientation ?? width > height
            ? Orientation.landscape
            : Orientation.portrait;

  double get aspectRatio => _aspectRatio ??= width / height;
  MaterialDisplayType get specificType =>
      _specificType ??= _calcSpecificType(width, orientation);
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

/// An distilled version of [MaterialDisplayType].
///
/// [DisplayType.mobile] includes [MaterialDisplayType.extraSmallWindow] and
/// [DisplayType.tablet] includes [MaterialDisplayType.smallWindow].
enum DisplayType { mobile, tablet, window }

enum MaterialDisplayType {
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

DisplayType _calcType(MaterialDisplayType type) {
  switch (type) {
    case MaterialDisplayType.smallHandset:
    case MaterialDisplayType.mediumHandset:
    case MaterialDisplayType.largeHandset:
    case MaterialDisplayType.extraSmallWindow:
      return DisplayType.mobile;
    case MaterialDisplayType.smallTablet:
    case MaterialDisplayType.largeTablet:
    case MaterialDisplayType.smallWindow:
      return DisplayType.tablet;
    default:
      return DisplayType.window;
  }
}

MaterialDisplayType _calcSpecificType(double width, Orientation orientation) {
  switch (orientation) {
    case Orientation.portrait:
      if (width < 360)
        return MaterialDisplayType.smallHandset;
      else if (width < 400)
        return MaterialDisplayType.mediumHandset;
      else if (width < 600)
        return MaterialDisplayType.largeHandset;
      else if (width < 720)
        return MaterialDisplayType.smallTablet;
      else if (width < 960)
        return MaterialDisplayType.largeTablet;
      else if (width < 1024)
        return MaterialDisplayType.smallWindow;
      else if (width < 1440)
        return MaterialDisplayType.mediumWindow;
      else if (width < 1920)
        return MaterialDisplayType.largeWindow;
      else
        return MaterialDisplayType.extraLargeWindow;
      break;
    case Orientation.landscape:
    default:
      if (width < 480)
        return MaterialDisplayType.extraSmallWindow;
      else if (width < 600)
        return MaterialDisplayType.smallHandset;
      else if (width < 720)
        return MaterialDisplayType.mediumHandset;
      else if (width < 960)
        return MaterialDisplayType.largeHandset;
      else if (width < 1024)
        return MaterialDisplayType.smallTablet;
      else if (width < 1440)
        return MaterialDisplayType.largeTablet;
      else if (width < 1920)
        return MaterialDisplayType.largeWindow;
      else
        return MaterialDisplayType.extraLargeWindow;
      break;
  }
}

int _calcColumns(double width) {
  if (width < 600)
    return 4;
  else if (width < 840)
    return 8;
  else
    return 12;
}

double _calcMarginsAndGutters(double width) {
  if (width < 720)
    return 16.0;
  else
    return 24.0;
}
