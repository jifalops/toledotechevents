import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:toledotechevents/resources.dart';

/// Emits loading percentages for the splash screen during itialization.
class SplashBloc {
  final _percentComplete = BehaviorSubject<int>();
  final _loaded = BehaviorSubject<void>();

  final Resources resources;
  final bool forceReload;

  SplashBloc(this.resources, {this.forceReload: true}) {
    double total = 0.0;
    _percentComplete.add(0);

    void _addToTotal(double percent) async {
      total += percent;
      if (total >= _totalPercent || total >= 100) {
        _percentComplete.add(100);
        await Future.delayed(Duration(milliseconds: 250));
        _loaded.add(null);
      } else {
        _percentComplete.add(total.round());
      }
    }

    // Get resources concurrently and update the total as they finish.
    resources.theme
        .get(forceReload: forceReload)
        .then((_) => _addToTotal(_themePercent));
    resources.eventList
        .get(forceReload: forceReload)
        .then((_) => _addToTotal(_eventsPercent));
    resources.venueList
        .get(forceReload: forceReload)
        .then((_) => _addToTotal(_venuesPercent));
    resources.authToken
        .get(forceReload: forceReload)
        .then((_) => _addToTotal(_newEventPercent));
    resources.about
        .get(forceReload: forceReload)
        .then((_) => _addToTotal(_aboutPercent));
  }

  void dispose() {
    _percentComplete.close();
    _loaded.close();
  }

  /// Loading progress 0-100.
  Stream<int> get percent => _percentComplete.stream;

  /// All resources loaded.
  Stream<void> get loaded => _loaded.stream;
}

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
const _totalPercent = _eventsPercent +
    _venuesPercent +
    _aboutPercent +
    _newEventPercent +
    _themePercent;
