library plato.angular.services.user.information;

import 'dart:async' show Future;
import 'dart:convert' show JSON;

import 'package:http/http.dart' show Client, Response;

import 'package:angular/core.dart';

import '../user/user_exception.dart';

import 'user_information.dart';

const String _LEARN_AUTH_URI = '/plato/authenticate/learn';
const String _SESSION_URI = '/plato/retrieve/session';
const String _USER_URI = '/plato/retrieve/user';

@Injectable()
/// The [UserInformationService] class...
class UserInformationService {
  UserInformation userInformation;

  String _username;

  String _password;

  bool _isLtiSession;

  bool get isLtiSession => _isLtiSession;

  bool _isAuthenticated;

  bool get isAuthenticated => _isAuthenticated;

  final Client _http;

  static UserInformationService _instance;

  /// The [UserInformationService] factory constructor...
  factory UserInformationService (Client http) =>
    _instance ?? (_instance = new UserInformationService._ (http));

  /// The [UserInformationService] private constructor...
  UserInformationService._ (this._http) {
    _isLtiSession = false;
    _isAuthenticated = false;
  }

  /// The [retrieveSession] method...
  Future retrieveSession() async {
    final Response sessionResponse = await _http.get (_SESSION_URI);

    Map<String, dynamic> rawSession =
      (JSON.decode (sessionResponse.body) as Map)['session'];

    if ((rawSession.containsKey ('plato.session.exists')) &&
        (rawSession.containsKey ('learn.user.authenticated'))) {
      if ('true' == rawSession['learn.user.authenticated']) {
        _isLtiSession = true;
        _isAuthenticated = true;
      }
    }
  }

  /// The [authenticateLearn] method...
  Future authenticateLearn (String theUsername, String thePassword) async {
    try {
      final Response authResponse = await _http.post (
        _LEARN_AUTH_URI,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'username': theUsername, 'password': thePassword}
      );

      Map<String, dynamic> rawAuth = JSON.decode (authResponse.body) as Map;

      if (true == rawAuth['learn.user.authenticated']) {
        _isAuthenticated = true;

        _username = theUsername;
        _password = thePassword;
      }
    } catch (_) {
      throw new UserException ('Authentication for the Plato user has failed.');
    }
  }

  /// The [retrieveUser] method...
  Future retrieveUser() async {
    if (!_isAuthenticated) {
      throw new UserException (
        'Authentication must happen before retrieving user infomration.'
      );
    }

    try {
      final Response userResponse = await _http.get (_USER_URI);

      Map<String, String> rawUser =
        (JSON.decode (userResponse.body) as Map)['user'];

      userInformation = new UserInformation (
        _username, _password, rawUser['learn.user.firstName'],
        rawUser['learn.user.lastName'], rawUser['learn.user.email'],
        rawUser['banner.user.cwid'], _isLtiSession
      );
    } catch (_) {
      throw new UserException ('Unable to retrieve the user information.');
    }
  }
}
