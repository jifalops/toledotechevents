import 'dart:async';
import 'dart:collection';
import 'package:collection/collection.dart';
import 'package:rxdart/rxdart.dart';

import 'package:toledotechevents/resources.dart';
import 'package:toledotechevents/theme.dart';
import 'package:toledotechevents/pages.dart';
import 'package:toledotechevents/layouts.dart';
import 'package:toledotechevents/model/events.dart';
import 'package:toledotechevents/model/venues.dart';

export 'package:toledotechevents/resources.dart';
export 'package:toledotechevents/pages.dart';
export 'package:toledotechevents/layouts.dart';
export 'package:toledotechevents/model/events.dart';
export 'package:toledotechevents/model/venues.dart';

/// The [AppBloc] is the Business Logic Component for initializing data
/// required to show the first page.
///
/// It first tries to read a [Theme] preference from the local system or
/// chooses a default. The theme is sent to an output stream that can be used
/// for global styling.
///
/// Before showing the first page, a [Display] must be received from the view
/// layer. The [Display] is combined with the [Theme] and [Page.eventList] to
/// output its first [PageData], which can be used by the underlying
/// platform to display a page.
///
/// At the same time as looking for a [Theme] during construction, it starts
/// fetching one of its two main resources, the [EventList], which is required
/// to fill out the body of the first page. The other main resource,
/// [VenueList], is managed here to make sure it has been fetched when a page is
/// requested that depends on it.
class AppBloc {
  // Inputs.
  final _displayController = StreamController<Display>();
  final _themeController = StreamController<Theme>();
  final _pageController = StreamController<PageRequest>();
  // Outputs.
  final _theme = BehaviorSubject<Theme>();
  final _page = BehaviorSubject<PageData>();

  final Resources resources;

  Theme get lastTheme => _theme.value ?? Theme.fromName(resources.theme.data);
  PageData get lastPage => _page.value;

  // Need to keep track of these in order to output the first `PageData`.
  Theme _lastTheme;
  Display _lastDisplay;
  PageRequest _lastRequest;

  AppBloc(this.resources) {
    setupInputs();

    // Read the user's theme preference from disk and add it to the stream.
    resources.theme.get().then((name) => themeRequest.add(name == null
        ? Theme.defaultTheme
        : Theme.fromName(name) ?? Theme.defaultTheme));

    // Request the first page.
    pageRequest.add(PageRequest(Page.eventList));
  }

  void setupInputs() {
    /// Change the theme per user request and save their preference to disk.
    _themeController.stream.distinct().listen((theme) {
      _updateTheme(theme);
      _updatePage(theme: theme);
      resources.theme.write(theme.name);
    });

    /// Set the [Display] from the view layer.
    _displayController.stream
        .distinct()
        .listen((display) => _updatePage(display: display));

    /// Handle new [PageRequest]s.
    _pageController.stream
        .distinct()
        .listen((pageRequest) => _updatePage(request: pageRequest));
  }

  void dispose() {
    _displayController.close();
    _themeController.close();
    _theme.close();
    _pageController.close();
    _page.close();
  }

  void _updateTheme(Theme theme) {
    print('Updating theme to "${theme.name}"');
    _theme.add(theme);
  }

  void _updatePage({Display display, Theme theme, PageRequest request}) async {
    if (display != null) _lastDisplay = display;
    if (theme != null) _lastTheme = theme;
    if (request != null) _lastRequest = request;
    if (_lastDisplay != null && _lastRequest != null && _lastTheme != null) {
      print('Updating page to "${_lastRequest.page.route}"');
      _page.add(PageData(_lastRequest, _lastTheme, _lastDisplay));
    }
  }

  /// Signal that the screen/window changed.
  Sink<Display> get displayRequest => _displayController.sink;

  /// Request a theme change.
  Sink<Theme> get themeRequest => _themeController.sink;

  /// Signal that the current page or its arguments are changing.
  Sink<PageRequest> get pageRequest => _pageController.sink;

  /// The currently selected theme.
  Stream<Theme> get theme => _theme.stream;

  /// The current page and encompassing data ([Theme], [Display], [Layout]).
  Stream<PageData> get page => _page.stream;
}

/// Passed to the [PageLayoutBloc] to signal for a new page that may require arguments.
class PageRequest {
  const PageRequest(this.page, {this.args, this.onPop});

  final Page page;
  final Map<String, dynamic> args;
  final void Function() onPop;

  @override
  operator ==(other) =>
      page == other.page && MapEquality().equals(args, other.args);

  @override
  int get hashCode => '$page$args'.hashCode;
}

/// Platform specific view logic uses this to show a page to the user.
class PageData {
  final Page page;
  final UnmodifiableMapView<String, dynamic> args;
  final Theme theme;
  final Display display;
  final Layout layout;
  final void Function() onPop;

  PageData(PageRequest request, this.theme, this.display)
      : page = request.page,
        args = UnmodifiableMapView(request.args ?? {}),
        onPop = request.onPop,
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
