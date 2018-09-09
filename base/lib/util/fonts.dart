import 'package:meta/meta.dart';
import 'colors.dart';

/// Platform independent representation of a font or text style.
///
/// Its properties are chosen somewhat arbitrarily according to business needs.
class Font {
  const Font(
      {@required this.size,
      this.family: 'Roboto',
      this.color: Colors.black87,
      this.height: 1.0,
      this.weight: 400,
      this.italic: false,
      this.underline: false});

  final double size;
  final String family;
  final Color color;
  final int weight;
  final bool italic;
  final bool underline;

  /// The line-height factor where 1.0 is the default line height.
  final double height;
  // final TextAlign align;

  /// Returns a new [Font] with the desired changes to this [Font].
  Font copyWith(
          {double size,
          String family,
          Color color,
          double height,
          int weight,
          bool italic,
          bool underline}) =>
      Font(
          size: size ?? this.size,
          family: family ?? this.family,
          color: color ?? this.color,
          height: height ?? this.height,
          weight: weight ?? this.weight,
          italic: italic ?? this.italic,
          underline: underline ?? this.underline);

  /// Returns a list of CSS properties.
  String toScssMap() => '''(
  font: ${italic ? 'italic' : ''} $weight ${size}px/$height $family,
  text-decoration: ${underline ? 'underline' : 'inherit'},
  color: ${color.cssValue}
)''';
}

/// Default fonts from material design.
class Fonts {
  // Black fonts.

  /// size: 112.0, weight: 100, color: Colors.black54
  static const display4Black =
      Font(size: 112.0, weight: 100, color: Colors.black54);

  /// size: 56.0, color: Colors.black54
  static const display3Black = Font(size: 56.0, color: Colors.black54);

  /// size: 45.0, color: Colors.black54
  static const display2Black = Font(size: 45.0, color: Colors.black54);

  /// size: 34.0, color: Colors.black54
  static const display1Black = Font(size: 34.0, color: Colors.black54);

  /// size: 24.0
  static const headlineBlack = Font(size: 24.0);

  /// size: 20.0, weight: 500
  static const titleBlack = Font(size: 20.0, weight: 500);

  /// size: 16.0
  static const subheadBlack = Font(size: 16.0);

  /// size: 14.0, weight: 500
  static const body2Black = Font(size: 14.0, weight: 500);

  /// size: 14.0
  static const body1Black = Font(size: 14.0);

  /// size: 12.0, color: Colors.black54
  static const captionBlack = Font(size: 12.0, color: Colors.black54);

  /// size: 14.0, weight: 500
  static const buttonBlack = Font(size: 14.0, weight: 500);

  // White fonts.

  /// size: 112.0, weight: 100, color: Colors.white70
  static const display4White =
      Font(size: 112.0, weight: 100, color: Colors.white70);

  /// size: 56.0, color: Colors.white70
  static const display3White = Font(size: 56.0, color: Colors.white70);

  /// size: 45.0, color: Colors.white70
  static const display2White = Font(size: 45.0, color: Colors.white70);

  /// size: 34.0, color: Colors.white70
  static const display1White = Font(size: 34.0, color: Colors.white70);

  /// size: 24.0, color: Colors.white
  static const headlineWhite = Font(size: 24.0, color: Colors.white);

  /// size: 20.0, weight: 500, color: Colors.white
  static const titleWhite = Font(size: 20.0, weight: 500, color: Colors.white);

  /// size: 16.0, color: Colors.white
  static const subheadWhite = Font(size: 16.0, color: Colors.white);

  /// size: 14.0, weight: 500, color: Colors.white
  static const body2White = Font(size: 14.0, weight: 500, color: Colors.white);

  /// size: 14.0, color: Colors.white
  static const body1White = Font(size: 14.0, color: Colors.white);

  /// size: 12.0, color: Colors.white70
  static const captionWhite = Font(size: 12.0, color: Colors.white70);

  /// size: 14.0, weight: 500, color: Colors.white
  static const buttonWhite = Font(size: 14.0, weight: 500, color: Colors.white);
}

class FontSet {
  const FontSet({
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
  });
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
}
