import 'package:meta/meta.dart';

enum BuildFlavor { production, development, staging }

/// Configuration for the current flavor of the app (e.g. production, development, staging).
AppConfig get config => _config;
AppConfig _config;

class AppConfig {
  /// The backend server.
  final String baseUrl;
  final BuildFlavor flavor;

  AppConfig._init(this.flavor, this.baseUrl);

  /// Sets up the top-level [config] getter on the first call only.
  static void init(BuildFlavor flavor, String baseUrl) =>
      _config ??= AppConfig._init(flavor, baseUrl);
}
