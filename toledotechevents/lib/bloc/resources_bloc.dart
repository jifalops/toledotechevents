import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:toledotechevents/resources.dart';
import 'package:toledotechevents/theme.dart';
import 'package:toledotechevents/model/events.dart';
import 'package:toledotechevents/model/venues.dart';
import 'package:toledotechevents/model/about_section.dart';
import 'package:toledotechevents/model/auth_token.dart';

// Reference resource sizes, sampled on Aug 13, 2018.
const _eventsSize = 38905;
const _venuesSize = 182201;
const _aboutSize = 5816;
const _newEventSize = 7667;
// Make theme worth 1%, even though it is much smaller.
const __total = _eventsSize + _venuesSize + _aboutSize + _newEventSize;
const _themeSize = __total * 0.0101;
const _totalSize = __total + _themeSize;
// Percentages
const _eventsPercent = _eventsSize / _totalSize * 100;
const _venuesPercent = _venuesSize / _totalSize * 100;
const _aboutPercent = _aboutSize / _totalSize * 100;
const _newEventPercent = _newEventSize / _totalSize * 100;
const _themePercent = _themeSize / _totalSize * 100;

/// Emits loading percentages for the splash screen during itialization.
class ResourcesBloc {
  final _reloadController = StreamController<bool>();
  final _percentComplete = BehaviorSubject<int>();
  final _loaded = BehaviorSubject<void>();

  final Resources resources;
  StreamSubscription _subscription;

  ResourcesBloc(this.resources) {
    _reloadController.stream.listen((refresh) async {
      var total = 0;
      _percentComplete.add(total);

      _subscription = resources.init(refresh).listen((data) {
        if (data is Theme)
          total += _themePercent.round();
        else if (data is EventList)
          total += _eventsPercent.round();
        else if (data is VenueList)
          total += _venuesPercent.round();
        else if (data is AboutSection)
          total += _aboutPercent.round();
        else if (data is AuthToken) total += _newEventPercent.round();
        if (total > 100) total = 100;
        _percentComplete.add(total);
      }, onDone: () => _loaded.add(null));
    });

    reload.add(false);
  }

  void dispose() {
    if (_subscription != null) _subscription.cancel();
    _reloadController.close();
    _percentComplete.close();
    _loaded.close();
  }

  Sink<bool> get reload => _reloadController.sink;
  Stream<int> get percent => _percentComplete.stream;
  Stream<void> get loaded => _loaded.stream;
}
