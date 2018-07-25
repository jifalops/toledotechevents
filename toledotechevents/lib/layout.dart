import 'package:meta/meta.dart';

enum NavbarPosition { hidden, top, left, bottom, right }

class Layout {
  final NavbarPosition navbarPosition;
  final bool stickyHeader;
  Layout(Display display) : navbarPosition = _getNavbarPosition(display), stickyHeader = _shouldStickyHeader(display);
  }

  _shouldStickyHeader(Display display) {
}

_getNavbarPosition(Display display) {
  if (display.type == DisplayType.mobile) {
    return NavbarPosition.bottom;
  } else if (display.orientation)
}



/// Information about the app's media or render box, so it can decide how to
/// lay itself out.
class Display {
  final double height;
  final double width;
  final double aspectRatio;
  final Orientation orientation;
  final DisplayType type;
  Display(
      {@required this.height, @required this.width, Orientation orientation})
      : aspectRatio = width / height,
        type = _getMaterialScreenSize(height, width),
        orientation = orientation ?? (width / height) > 1
            ? Orientation.landscape
            : Orientation.portrait;
  @override
  operator ==(other) =>
      height == other.height &&
      width == other.width &&
      orientation == other.orientation;
  @override
  int get hashCode => '$height$width$orientation'.hashCode;
}

enum Orientation { portrait, landscape }
enum DisplayType { mobile, tablet, laptop, desktop, tv }

// TODO implement.
DisplayType _getMaterialScreenSize(double height, double width) {
  return DisplayType.mobile;
}
