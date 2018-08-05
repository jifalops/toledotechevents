import 'dart:async';
import 'dart:collection';
import 'package:collection/collection.dart';
import 'package:rxdart/rxdart.dart';
import '../pages.dart';
import '../layout.dart';
import 'theme_bloc.dart';

export '../pages.dart';
export '../layout.dart';
export 'theme_bloc.dart';

/// Listens for signals that may require the page to be redrawn and outputs a
/// [Stream] of [PageLayout] that can be used to draw a page.
class LayoutBloc {
  // Inputs.
  final _pageController = StreamController<PageRequest>();
  final _displayThemeController = StreamController<DisplayTheme>();
  // Output.
  final _layoutData = BehaviorSubject<PageLayout>();

  LayoutBloc() {
    _pageController.stream.distinct().listen((page) async =>
        _updatePage(page, await _displayThemeController.stream.last));
    _displayThemeController.stream.distinct().listen((display) async =>
        _updatePage(await _pageController.stream.last, display));
    // Request the first page.
    page.add(PageRequest(Page.first));
  }

  void dispose() {
    _pageController.close();
    _displayThemeController.close();
    _layoutData.close();
  }

  void _updatePage(PageRequest request, DisplayTheme displayTheme) {
    if (request != null && displayTheme != null) {
      _layoutData
          .add(PageLayout(request, displayTheme.theme, displayTheme.display));
    }
  }

  /// The input stream for signaling that the current page or its arguments
  /// should change.
  Sink<PageRequest> get page => _pageController.sink;

  /// The input stream for signaling that the app's screen/window changed.
  Sink<DisplayTheme> get display => _displayThemeController.sink;

  /// Platform-agnostic output stream for presenting pages to the user.
  Stream<PageLayout> get layoutData => _layoutData.stream;
}

/// Passed to the [LayoutBloc] to signal for a new page that may require arguments.
class PageRequest {
  final Page page;
  final Map<String, dynamic> args;
  const PageRequest(this.page, [this.args]);

  @override
  operator ==(other) =>
      page == other.page && MapEquality().equals(args, other.args);

  @override
  int get hashCode => '$page$args'.hashCode;
}

/// Platform specific view logic uses this to show a page to the user.
class PageLayout {
  final Page page;
  final UnmodifiableMapView<String, dynamic> args;
  final Theme theme;
  final Display display;
  final Layout layout;

  PageLayout(PageRequest request, this.theme, this.display)
      : page = request.page,
        args = UnmodifiableMapView(request.args ?? {}),
        layout = Layout(request.page, theme, display);

  @override
  operator ==(other) =>
      page == other.page &&
      MapEquality().equals(args, other.args) &&
      theme == other.theme &&
      display == other.display &&
      layout == other.layout;

  @override
  int get hashCode => '$page$args$theme$display$layout'.hashCode;
}
