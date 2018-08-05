import 'package:html/parser.dart' show parse;

class AboutSection {
  AboutSection(String aboutPage)
      : html = parse(aboutPage)?.querySelector('.about-us')?.outerHtml ?? '';

  final String html;
}
