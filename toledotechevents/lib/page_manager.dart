import 'package:meta/meta.dart';

/// Base class for managing top level view ([Page]) changes.
abstract class PageManager {
  ScreenData _screen;
  Page _page;

  PageManager(Page page, ScreenData screen) : _page = page, _screen = screen;

  Page get page => _page;
  ScreenData get screen => _screen;

  /// Default implementation to be overriden by child classes.
  void set page(Page value) => _page = value;

  /// Default implementation to be overriden by child classes.
  void set screen(ScreenData value) => _screen = value;
}

/// The pages of the app.
enum Page {
  eventList,
  eventDetails,
  venuesList,
  venueDetails,
  createEvent,
  about,
  spamRemover
}

class ScreenData {
  final double height;
  final double width;
  final double aspectRatio;
  final Orientation orientation;
  final ScreenSize size;
  ScreenData(
      {@required this.height, @required this.width, Orientation orientation})
      : aspectRatio = width / height,
        size = _getMaterialScreenSize(height, width),
        orientation = orientation ?? (width / height) > 1
            ? Orientation.landscape
            : Orientation.portrait;
}

enum Orientation { portrait, landscape }
enum ScreenSize { mobile, tablet, laptop, desktop, tv }

// TODO implement.
ScreenSize _getMaterialScreenSize(double height, double width) {
  return ScreenSize.mobile;
}
