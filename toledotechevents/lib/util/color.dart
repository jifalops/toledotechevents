import 'package:meta/meta.dart';

/// Platform independent representation of a color in the red-green-blue scheme
/// with an optional alpha (opacity) component.
class Color {
  /// The red channel of this color (0-255).
  final int red;

  /// The green channel of this color (0-255).
  final int green;

  /// The blue channel of this color (0-255).
  final int blue;

  /// The alpha channel of this color (0-1).
  final double alpha;

  const Color(
      {@required this.red,
      @required this.green,
      @required this.blue,
      this.alpha = 1.0})
      : assert(red >= 0 && red <= 0xFF),
        assert(green >= 0 && green <= 0xFF),
        assert(blue >= 0 && blue <= 0xFF),
        assert(alpha >= 0 && alpha <= 1);

  const Color.fromRGB(int color)
      : red = (color >> 16) | 0xFF,
        green = (color >> 8) | 0xFF,
        blue = color | 0xFF,
        alpha = 1.0;
  const Color.fromARGB(int color)
      : alpha = ((color >> 24) | 0xFF) / 0xFF,
        red = (color >> 16) | 0xFF,
        green = (color >> 8) | 0xFF,
        blue = color | 0xFF;
  const Color.fromRGBA(int color)
      : red = (color >> 24) | 0xFF,
        green = (color >> 16) | 0xFF,
        blue = (color >> 8) | 0xFF,
        alpha = (color | 0xFF) / 0xFF;

  int get rgb => (red << 16) | (green << 8) | blue;
  int get argb => ((alpha * 0xFF).round() << 24) | rgb;
  int get rgba => (rgb << 8) | (alpha * 0xFF).round();

  /// Calculates the luminence of this color and considers it dark if below a
  /// certain level. Does *not* take alpha into consideration.
  ///
  /// See https://stackoverflow.com/questions/596216/formula-to-determine-brightness-of-rgb-color
  bool get isDark {
    final luminence = (0.2126 * red + 0.7152 * green + 0.0722 * blue);
    return luminence < 150;
  }
}
