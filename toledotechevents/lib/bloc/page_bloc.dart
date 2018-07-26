import 'dart:async';
import 'package:rxdart/rxdart.dart';
import '../pages.dart';

/// Listens for [Page] requests, [Display] changes, and [Theme] changes;
/// outputs a [Stream] of [RenderablePage].
class PageBloc {
  final _pageController = StreamController<Page>();
  final _displayController = StreamController<Display>();
  final _themeController = StreamController<Theme>();

  final _renderablePage = BehaviorSubject<RenderablePage>();

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
    _renderablePage.close();
  }

  void _handleInput(Page page, Display display, Theme theme) {
    if (page != null && display != null) {
      _renderablePage.add(RenderablePage(page, display, theme));
    }
  }

  /// The input stream for signaling that the current route should change.
  Sink<Page> get page => _pageController.sink;

  /// The input stream for signaling that the app's screen/window changed.
  Sink<Display> get display => _displayController.sink;

  /// Input stream for signaling [Theme] changes.
  Sink<Theme> get theme => _themeController.sink;

  /// Output stream of
  Stream<RenderablePage> get renderablePage => _renderablePage.stream;
}
