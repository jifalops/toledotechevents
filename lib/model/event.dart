import 'package:xml/xml.dart' as xml;

/**
 * A ToledoTechEvents event. See http://toledotechevents.org/events.atom.
 */
class Event {
  Event(xml.XmlElement entry) {
    print(entry.findElements('published').first.firstChild);
  }
}
