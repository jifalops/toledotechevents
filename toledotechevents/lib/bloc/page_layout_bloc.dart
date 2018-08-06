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
/// [Stream] of [PageLayoutData] that can be used to draw a page.
class PageLayoutBloc {
  // Inputs.
  final _requestController = StreamController<PageRequest>();
  final _displayThemeController = StreamController<DisplayTheme>();
  // Output.
  final _pageLayout = BehaviorSubject<PageLayoutData>();

  PageLayoutBloc() {
    _requestController.stream.distinct().listen((page) async =>
        _updatePage(page, await _displayThemeController.stream.last));
    _displayThemeController.stream.distinct().listen((display) async =>
        _updatePage(await _requestController.stream.last, display));
    // Request the first page.
    request.add(PageRequest(Page.first));
  }

  void dispose() {
    _requestController.close();
    _displayThemeController.close();
    _pageLayout.close();
  }

  void _updatePage(PageRequest request, DisplayTheme displayTheme) {
    if (request != null && displayTheme != null) {
      _pageLayout
          .add(PageLayoutData(request, displayTheme.theme, displayTheme.display));
    }
  }

  /// The input stream for signaling that the current page or its arguments
  /// should change.
  Sink<PageRequest> get request => _requestController.sink;

  /// The input stream for signaling that the app's screen/window changed.
  Sink<DisplayTheme> get display => _displayThemeController.sink;

  /// Platform-agnostic output stream for presenting pages to the user.
  Stream<PageLayoutData> get pageLayout => _pageLayout.stream;
}

/// Passed to the [PageLayoutBloc] to signal for a new page that may require arguments.
class PageRequest {
  final Page page;
  final Map<String, dynamic> args;
  const PageRequest(this.page, [this.args]);

  @override
  operator ==(other) =>
      page == other.request && MapEquality().equals(args, other.args);

  @override
  int get hashCode => '$page$args'.hashCode;
}

/// Platform specific view logic uses this to show a page to the user.
class PageLayoutData {
  final Page page;
  final UnmodifiableMapView<String, dynamic> args;
  final Theme theme;
  final Display display;
  final Layout layout;

  PageLayoutData(PageRequest request, this.theme, this.display)
      : page = request.page,
        args = UnmodifiableMapView(request.args ?? {}),
        layout = Layout(request.page, theme, display);

  @override
  operator ==(other) =>
      page == other.request &&
      MapEquality().equals(args, other.args) &&
      theme == other.theme &&
      display == other.display &&
      layout == other.layout;

  @override
  int get hashCode => '$page$args$theme$display$layout'.hashCode;
}
