import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:async_resource/async_resource.dart';
import '../theme.dart';
import '../layout.dart';

export '../theme.dart';
export '../layout.dart';

/// Listens for signals that may require the page to be redrawn and outputs a
/// [Stream] of [DisplayTheme] that can be used to update the theme.
class ThemeBloc {
  // Inputs.
  final _displayController = StreamController<Display>();
  final _themeController = StreamController<Theme>();
  // Output.
  final _displayTheme = BehaviorSubject<DisplayTheme>();

  final LocalResource<String> _themeResource;

  ThemeBloc(LocalResource<String> themeResource)
      : _themeResource = themeResource {
    _displayController.stream.distinct().listen((display) async =>
        _updateTheme(display, await _themeController.stream.last));
    _themeController.stream.distinct().listen((theme) async {
      if (theme != await _themeResource.get()) {
        // Save the chosen theme to disk.
        _themeResource.write(theme.name);
      }
      _updateTheme(await _displayController.stream.last, theme);
    });

    // Read the user's theme preference from disk and add it to the stream.
    _themeResource.get().then((name) => theme.add(name == null
        ? Theme.values[0]
        : Theme.values.firstWhere((theme) => theme.name == name)));
  }

  void dispose() {
    _displayController.close();
    _themeController.close();
    _displayTheme.close();
  }

  void _updateTheme(Display display, Theme theme) {
    if (display != null && theme != null) {
      _displayTheme.add(DisplayTheme(theme, display));
    }
  }

  /// The input stream for signaling that the app's screen/window changed.
  Sink<Display> get display => _displayController.sink;

  /// Input stream for signaling theme changes.
  Sink<Theme> get theme => _themeController.sink;

  /// Platform-agnostic output stream for notifying theme or display changes.
  Stream<DisplayTheme> get displayTheme => _displayTheme.stream;
}

/// The display and selected theme.
class DisplayTheme {
  final Theme theme;
  final Display display;

  DisplayTheme(this.theme, this.display);

  @override
  operator ==(other) => theme == other.theme && display == other.display;

  @override
  int get hashCode => '$display$theme'.hashCode;
}
