import 'package:meta/meta.dart';

/// Shorthand for [BuildConfig.instance].
BuildConfig get config => BuildConfig.instance;

/// Configuration for the current flavor of the app
/// (e.g. production, development, staging).
class BuildConfig {
  const BuildConfig._(
      {@required this.flavor,
      @required this.baseUrl,
      @required this.cacheName});

  /// Sets up the top-level [config] getter on the first call only.
  static void init(
          {@required BuildFlavor flavor,
          @required String baseUrl,
          @required String cacheName}) =>
      instance ??=
          BuildConfig._(flavor: flavor, baseUrl: baseUrl, cacheName: cacheName);

  final BuildFlavor flavor;

  /// The backend server.
  final String baseUrl;

  /// The name of the service worker cache.
  final String cacheName;

  static BuildConfig instance;
}

enum BuildFlavor { production, development, staging }
