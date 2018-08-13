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
  final _eventsController = StreamController<bool>();
  final _venuesController = StreamController<bool>();
  // Outputs.
  final _theme = BehaviorSubject<Theme>();
  final _page = BehaviorSubject<PageData>();
  final _events = BehaviorSubject<EventList>();
  final _venues = BehaviorSubject<VenueList>();

  final Resources resources;

  // trouble combining streams
  Display _lastDisplay;
  Theme _lastTheme;
  PageRequest _lastRequest;
  VenueList _lastVenues;

  AppBloc(this.resources) {
    setupInputs();

    // Read the user's theme preference from disk and add it to the stream.
    resources.theme.get().then((name) => themeRequest.add(name == null
        ? Theme.defaultTheme
        : Theme.values.firstWhere((theme) => theme.name == name,
            orElse: () => Theme.defaultTheme)));

    // Request the first page.
    pageRequest.add(PageRequest(Page.eventList));

    // Start fetching events.
    eventsRequest.add(false);
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

    /// Load the [EventList].
    _eventsController.stream.listen((refresh) async =>
        _updateEvents(await resources.eventList.get(forceReload: refresh)));

    /// Load the [VenueList].
    _venuesController.stream.listen((refresh) async =>
        _updateVenues(await resources.venueList.get(forceReload: refresh)));
  }

  void dispose() {
    _displayController.close();
    _themeController.close();
    _theme.close();
    _pageController.close();
    _page.close();
    _eventsController.close();
    _events.close();
    _venuesController.close();
    _venues.close();
  }

  void _updateTheme(Theme theme) {
    print('Updating theme to "${theme.name}"...');
    _theme.add(theme);
  }

  void _updatePage({Display display, PageRequest request, Theme theme}) async {
    if (display != null) _lastDisplay = display;
    if (request != null) _lastRequest = request;
    if (theme != null) _lastTheme = theme;

    if (_lastDisplay != null && _lastRequest != null && _lastTheme != null) {
      print('Updating page to "${_lastRequest.page.route}"...');
      _page.add(PageData(_lastRequest, _lastTheme, _lastDisplay));

      /// Ensure the venue list has been requested for pages that depend on it.
      if (_lastRequest.page != Page.eventList &&
          _lastRequest.page != Page.about &&
          _lastVenues == null) {
        // Start fetching venues.
        venuesRequest.add(false);
      }
    }
  }

  void _updateEvents(EventList events) {
    if (events != null) {
      _events.add(events);
    }
  }

  void _updateVenues(VenueList venues) {
    if (venues != null) {
      _lastVenues = venues;
      _venues.add(venues);
    }
  }

  /// Signal that the screen/window changed.
  Sink<Display> get displayRequest => _displayController.sink;

  /// Request a theme change.
  Sink<Theme> get themeRequest => _themeController.sink;

  /// Signal that the current page or its arguments are changing.
  Sink<PageRequest> get pageRequest => _pageController.sink;

  /// Request the [EventList] be readied. Input `true` to force a full reload.
  Sink<bool> get eventsRequest => _eventsController.sink;

  /// Request the [VenueList] be readied. Input `true` to force a full reload.
  Sink<bool> get venuesRequest => _venuesController.sink;

  /// The currently selected theme.
  Stream<Theme> get theme => _theme.stream;

  /// The current page and encompassing data ([Theme], [Display], [Layout]).
  Stream<PageData> get page => _page.stream;

  /// Output stream of event lists.
  Stream<EventList> get events => _events.stream;

  /// Output stream of venue lists.
  Stream<VenueList> get venues => _venues.stream;
}

/// Passed to the [PageLayoutBloc] to signal for a new page that may require arguments.
class PageRequest {
  final Page page;
  final Map<String, dynamic> args;
  final void Function() onPop;
  const PageRequest(this.page, {this.args, this.onPop});

  @override
  operator ==(other) =>
      page.route == other?.page?.route &&
      MapEquality().equals(args, other.args);

  @override
  int get hashCode => '${page.route}$args'.hashCode;
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
      page == other.pageData &&
      MapEquality().equals(args, other.args) &&
      theme == other.theme &&
      display == other.display &&
      layout == other.layout;

  @override
  int get hashCode => '$page$args$theme$display$layout'.hashCode;
}
