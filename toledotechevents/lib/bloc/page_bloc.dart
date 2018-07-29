import 'dart:async';
import 'dart:collection';

import 'package:rxdart/rxdart.dart';

import '../pages.dart';
import '../theme.dart';
import '../layout.dart';
import '../util/display.dart';

export '../pages.dart';
export '../theme.dart';
export '../layout.dart';
export '../util/display.dart';

/// Listens for signals that may require the page to be redrawn and outputs a
/// [Stream] of [PageData] that can be used to draw a page.
class PageBloc {
  // Inputs.
  final _pageController = StreamController<PageRequest>();
  final _displayController = StreamController<Display>();
  final _themeController = StreamController<Theme>();
  final _themeResourceController = StreamController<LocalResource<Theme>>();
  // Output.
  final _pageData = BehaviorSubject<PageData>();

  PageBloc() {
    _pageController.stream.distinct().listen((page) async => _handleInput(
        page,
        await _displayController.stream.last,
        await _themeController.stream.last));
    _displayController.stream.distinct().listen((display) async => _handleInput(
        await _pageController.stream.last,
        display,
        await _themeController.stream.last));
    _themeController.stream.distinct().listen((theme) async => _handleInput(
        await _pageController.stream.last,
        await _displayController.stream.last,
        theme));
  }

  void dispose() {
    _pageController.close();
    _displayController.close();
    _themeController.close();
    _pageData.close();
  }

  void _handleInput(PageRequest request, Display display, Theme theme) {
    if (request != null && display != null && theme != null) {
      _pageData.add(PageData(request, theme, display));
    }
  }

  /// The input stream for signaling that the current page or its arguments
  /// should change.
  Sink<PageRequest> get request => _pageController.sink;

  /// The input stream for signaling that the app's screen/window changed.
  Sink<Display> get display => _displayController.sink;

  /// Input stream for signaling theme changes.
  Sink<Theme> get theme => _themeController.sink;

  /// Platform-agnostic output stream for presenting pages to the user.
  Stream<PageData> get pageData => _pageData.stream;
}

/// Passed to the [PageBloc] to signal for a new page that may require arguments.
class PageRequest {
  final Page page;
  final Map<String, dynamic> args;
  const PageRequest(this.page, [this.args]);
}

/// Platform specific view logic uses this to show a page to the user.
class PageData {
  final Page page;
  final UnmodifiableMapView<String, dynamic> args;
  final Theme theme;
  final Display display;
  final Layout layout;

  PageData(PageRequest request, this.theme, this.display)
      : page = request.page,
        args = UnmodifiableMapView(request.args ?? {}),
        layout = Layout(request.page, theme, display);
}
