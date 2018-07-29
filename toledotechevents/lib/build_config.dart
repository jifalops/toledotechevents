/// Shorthand for [BuildConfig.instance].
BuildConfig get config => BuildConfig.instance;

/// Configuration for the current flavor of the app
/// (e.g. production, development, staging).
class BuildConfig {
  static BuildConfig instance;

  /// The backend server.
  final String baseUrl;
  final BuildFlavor flavor;

  const BuildConfig._init(this.flavor, this.baseUrl);

  /// Sets up the top-level [config] getter on the first call only.
  static void init(BuildFlavor flavor, String baseUrl) =>
      instance ??= BuildConfig._init(flavor, baseUrl);
}

enum BuildFlavor { production, development, staging }
