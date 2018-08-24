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
      this.underline: false,
      this.align: TextAlign.start});

  final double size;
  final String family;
  final Color color;
  final int weight;
  final bool italic;
  final bool underline;

  /// The line-height factor where 1.0 is the default line height.
  final double height;
  final TextAlign align;

  /// Returns a new [Font] with the desired changes to this [Font].
  Font copyWith(
          {double size,
          String family,
          Color color,
          double heightFactor,
          int weight,
          bool italic,
          bool underline,
          TextAlign align}) =>
      Font(
          size: size ?? this.size,
          family: family ?? this.family,
          color: color ?? this.color,
          height: heightFactor ?? this.height,
          weight: weight ?? this.weight,
          italic: italic ?? this.italic,
          underline: underline ?? this.underline,
          align: align ?? this.align);

  /// Returns a list of CSS properties.
  List<String> toCss() => [
        'font-size: ${size}px;',
        'font-family: $family;',
        'color: ${color.cssValue};',
        'line-height: ${height * 100}%;',
        'font-weight: $weight;',
        '${italic ? 'font-style: italic;' : ''}',
        '${underline ? 'text-decoration: underline;' : ''}',
        'text-align: ${_textAlignToString(align)};',
      ];
}

enum TextAlign {
  left,
  right,
  center,
  justify,

  /// Left when the text direction is LTR (left to right) or
  /// right when the text direction is RTL (right to left).
  start,

  /// Right when the text direction is LTR (left to right) or
  /// left when the text direction is RTL (right to left).
  end,
}

String _textAlignToString(TextAlign align) {
  switch (align) {
    case TextAlign.left:
      return 'left';
    case TextAlign.right:
      return 'right';
    case TextAlign.center:
      return 'center';
    case TextAlign.justify:
      return 'justify';
    case TextAlign.start:
      return 'start';
    case TextAlign.end:
      return 'end';
    default:
      return '';
  }
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
