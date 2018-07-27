/// A route string that includes parameters in the form of `:<param>`.
///
/// Route parts are delineated with a slash ("/"). Route parts that begin with a
/// colon (":") are extracted as parameter names, excluding the colon.
class Route {
  final String value;
  List<String> _params;

  Route(this.value);

  List<String> get params => _params ??=
      value.allMatches(r'/:([^/]+)').map((match) => match.group(0).toString());
}
