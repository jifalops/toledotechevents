import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:async_resource/async_resource.dart';
import 'package:meta/meta.dart';

/// A value stored in shared preferences.
abstract class SharedPrefsResource<T> extends LocalResource<T> {
  SharedPrefsResource(this.key, {this.saveLastModified: false});

  final String key;
  final bool saveLastModified;

  Future<SharedPreferences> get prefs async => SharedPreferences.getInstance();

  @override
  Future<bool> get exists async => (await value) != null;

  @override
  Future fetchContents() => value;

  @override
  Future<DateTime> get lastModified async {
    if (saveLastModified) {
      try {
        return DateTime.fromMillisecondsSinceEpoch(
            (await prefs).getInt(_lastModifiedKey));
      } catch (e) {}
    }
    return null;
  }

  Future<T> get value;

  String get _lastModifiedKey => '${key}_modified';

  void _handleLastModified(SharedPreferences p, contents, bool written) {
    if (saveLastModified && written) {
      if (contents == null)
        p.remove(_lastModifiedKey);
      else
        p.setInt(_lastModifiedKey, DateTime.now().millisecondsSinceEpoch);
    }
  }
}

/// A String [SharedPreferences] entry.
class StringPrefsResource extends SharedPrefsResource<String> {
  StringPrefsResource(String key, {bool saveLastModified: false})
      : super(key, saveLastModified: saveLastModified);

  @override
  Future<String> get value async => (await prefs).getString(key);

  @override
  Future<String> write(contents) async {
    final p = await prefs;
    bool success = await p.setString(key, contents);
    _handleLastModified(p, contents, success);
    return super.write(success ? contents : null);
  }
}

/// A boolean [SharedPreferences] entry.
class BoolPrefsResource extends SharedPrefsResource<bool> {
  BoolPrefsResource(String key, {bool saveLastModified: false})
      : super(key, saveLastModified: saveLastModified);

  @override
  Future<bool> get value async => (await prefs).getBool(key);

  @override
  Future<bool> write(contents) async {
    final p = await prefs;
    bool success = await p.setBool(key, contents);
    _handleLastModified(p, contents, success);
    return super.write(success ? contents : null);
  }
}

/// An integer [SharedPreferences] entry.
class IntPrefsResource extends SharedPrefsResource<int> {
  IntPrefsResource(String key, {bool saveLastModified: false})
      : super(key, saveLastModified: saveLastModified);

  @override
  Future<int> get value async => (await prefs).getInt(key);

  @override
  Future<int> write(contents) async {
    final p = await prefs;
    bool success = await p.setInt(key, contents);
    _handleLastModified(p, contents, success);
    return super.write(success ? contents : null);
  }
}

/// A double [SharedPreferences] entry.
class DoublePrefsResource extends SharedPrefsResource<double> {
  DoublePrefsResource(String key, {bool saveLastModified: false})
      : super(key, saveLastModified: saveLastModified);

  @override
  Future<double> get value async => (await prefs).getDouble(key);

  @override
  Future<double> write(contents) async {
    final p = await prefs;
    bool success = await p.setDouble(key, contents);
    _handleLastModified(p, contents, success);
    return super.write(success ? contents : null);
  }
}

/// A string list [SharedPreferences] entry.
class StringListPrefsResource extends SharedPrefsResource<List<String>> {
  StringListPrefsResource(String key, {bool saveLastModified: false})
      : super(key, saveLastModified: saveLastModified);

  @override
  Future<List<String>> get value async => (await prefs).getStringList(key);

  @override
  Future<List<String>> write(contents) async {
    final p = await prefs;
    bool success = await p.setStringList(key, contents);
    _handleLastModified(p, contents, success);
    return super.write(success ? contents : null);
  }
}
