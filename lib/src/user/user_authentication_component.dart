library plato.angular.components.user.authentication;

import 'dart:async' show Future;

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

import '../crf/course_request_service.dart';

import 'user_exception.dart';
import 'user_information_service.dart';

/// The [UserAuthenticationComponent] class...
@Component (
  selector: 'user-authentication',
  templateUrl: 'user_authentication_component.html',
  directives: const [CORE_DIRECTIVES, materialDirectives],
  providers: const [UserInformationService, CourseRequestService]
)
class UserAuthenticationComponent implements OnInit {
  String username;

  String password;

  bool get isAuthenticated => _userInfoService.isAuthenticated;

  final UserInformationService _userInfoService;

  final CourseRequestService _crfService;

  /// The [UserAuthenticationComponent] constructor...
  UserAuthenticationComponent (this._userInfoService, this._crfService);

  /// The [ngOnInit] method...
  @override
  Future ngOnInit() async {
    try {
      await _userInfoService.retrieveSession();

      if (_userInfoService.isAuthenticated && _userInfoService.isLtiSession) {
        await _userInfoService.retrieveUser();
      }
    } catch (_) {}
  }

  /// The [authenticateLearn] method...
  Future authenticateLearn() async {
    if (isAuthenticated) {
      throw new UserException (
        'Authentication has already completed; cannot authenticate again.'
      );
    }

    try {
      await _userInfoService.authenticateLearn (username, password);
      await _userInfoService.retrieveUser();

      _crfService.setUserInformation (_userInfoService.userInformation);
    } catch (_) {}
  }
}