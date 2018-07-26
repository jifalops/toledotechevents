import 'dart:async';
import 'package:rxdart/rxdart.dart';
import '../pages.dart';

export '../pages.dart';

/// Listens for signals that may require the page to be redrawn and outputs a
/// [Stream] of [PageData] that can be used to draw a page.
class PageBloc {
  final _pageController = StreamController<PageRequest>();
  final _displayController = StreamController<Display>();
  final _themeController = StreamController<Theme>();

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
    if (page != null && display != null) {
      _pageData.add(PageData(request.page, display, theme, request.args));
    }
  }

  /// The input stream for signaling that the current page or its arguments
  /// should change.
  Sink<PageRequest> get page => _pageController.sink;

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
  final PageArgs args;
  PageRequest(this.page, [this.args]);
}
