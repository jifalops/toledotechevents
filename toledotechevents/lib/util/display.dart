import 'package:meta/meta.dart';

/// Usually a device's screen.
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
