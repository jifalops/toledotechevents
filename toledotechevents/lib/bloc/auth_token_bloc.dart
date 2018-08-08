import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:async_resource/async_resource.dart';
import 'package:toledotechevents/model/auth_token.dart';

export 'package:toledotechevents/model/auth_token.dart';

/// The auth token from the add-event page.
class AuthTokenBloc {
  final _fetchController = StreamController<bool>();
  final _authToken = BehaviorSubject<AuthToken>();

  final NetworkResource<AuthToken> _tokenResource;

  AuthTokenBloc(NetworkResource<AuthToken> resource)
      : _tokenResource = resource {
    _fetchController.stream.listen((refresh) async =>
        _updateAboutSection(await _tokenResource.get(forceReload: refresh)));

    fetch.add(false);
  }

  void dispose() {
    _fetchController.close();
    _authToken.close();
  }

  void _updateAboutSection(AuthToken token) {
    if (token != null && token.value != null) {
      _authToken.add(token);
    }
  }

  /// The input stream for signaling the output stream should be refreshed.
  Sink<bool> get fetch => _fetchController.sink;

  /// Platform-agnostic output stream for presenting pages to the user.
  Stream<AuthToken> get token => _authToken.stream;
}
