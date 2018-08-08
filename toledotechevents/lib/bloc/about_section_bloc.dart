import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:async_resource/async_resource.dart';
import 'package:toledotechevents/model/about_section.dart';

export 'package:toledotechevents/model/about_section.dart';

/// The about section of the about page.
class AboutSectionBloc {
  final _fetchController = StreamController<bool>();
  final _aboutSection = BehaviorSubject<AboutSection>();

  final NetworkResource<AboutSection> _aboutResource;

  AboutSectionBloc(NetworkResource<AboutSection> resource)
      : _aboutResource = resource {
    _fetchController.stream.listen((refresh) async =>
        _updateAboutSection(await _aboutResource.get(forceReload: refresh)));

    fetch.add(false);
  }

  void dispose() {
    _fetchController.close();
    _aboutSection.close();
  }

  void _updateAboutSection(AboutSection about) {
    if (about != null && about.html != null) {
      _aboutSection.add(about);
    }
  }

  /// The input stream for signaling the output stream should be refreshed.
  Sink<bool> get fetch => _fetchController.sink;

  /// Platform-agnostic output stream for presenting pages to the user.
  Stream<AboutSection> get about => _aboutSection.stream;
}
