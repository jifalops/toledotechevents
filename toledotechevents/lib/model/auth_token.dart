class AuthToken {
  AuthToken(String newEventPage) : value = _findToken(newEventPage);

  final String value;
}

String _findToken(String page) {
  if (page == null) return '';
  final search = 'name="authenticity_token" value="';
  final start = page.indexOf(search) + search.length;
  return page.substring(start, page.indexOf('"', start));
}
