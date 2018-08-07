import 'dart:async';
import 'dart:collection';
import 'package:collection/collection.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:async_resource/async_resource.dart';

import 'package:toledotechevents/theme.dart';
import 'package:toledotechevents/pages.dart';
import 'package:toledotechevents/layouts.dart';
import 'package:toledotechevents/model/events.dart';
import 'package:toledotechevents/model/venues.dart';

// export 'package:toledotechevents/theme.dart';
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

  final LocalResource<String> _themeResource;
  final NetworkResource<EventList> _eventsResource;
  final NetworkResource<VenueList> _venuesResource;

  AppBloc(
      {@required LocalResource<String> themeResource,
      @required NetworkResource<EventList> eventsResource,
      @required NetworkResource<VenueList> venuesResource})
      : _themeResource = themeResource,
        _eventsResource = eventsResource,
        _venuesResource = venuesResource {
    setupInputs();

    // Read the user's theme preference from disk and add it to the stream.
    _themeResource.get().then((name) => themeRequest.add(name == null
        ? Theme.light
        : Theme.values.firstWhere((theme) => theme.name == name,
            orElse: () => Theme.light)));

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
      _themeResource.write(theme.name);
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
        _updateEvents(await _eventsResource.get(forceReload: refresh)));

    /// Load the [VenueList].
    _venuesController.stream.listen((refresh) async =>
        _updateVenues(await _venuesResource.get(forceReload: refresh)));
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

  void _updateTheme(Theme theme) => _theme.add(theme);

  void _updatePage({PageRequest request, Display display, Theme theme}) async {
    request ??= await _pageController.stream.last;
    theme ??= await _themeController.stream.last;
    display ??= await _displayController.stream.last;
    if (request != null && theme != null && display != null) {
      _page.add(PageData(request, theme, display));

      /// Ensure the venue list has been requested for pages that depend on it.
      if (request.page != Page.eventList &&
          request.page != Page.about &&
          await _venuesController.stream.last == null) {
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
  const PageRequest(this.page, [this.args]);

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

  PageData(PageRequest request, this.theme, this.display)
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
