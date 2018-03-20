library plato.angular.services.crf.request;

import 'dart:async' show Future;

import 'package:http/http.dart' show Client, Response;

import 'package:angular/core.dart';

import '../cross_listings/cross_listing.dart';

import '../previous_content/previous_content_mapping.dart';

import '../sections/section.dart';

import '../user/user_information.dart';

import 'course_request_exception.dart';
import 'request_information.dart';

const String _SUBMISSION_URI = '/plato/submit/crf';

/// The [CourseRequestService] class...
@Injectable()
class CourseRequestService {
  RequestInformation _requestInformation;

  final Client _http;

  bool get submittable => _requestInformation.submittable;

  static CourseRequestService _instance;

  /// The [CourseRequestService] factory constructor...
  factory CourseRequestService (Client http) =>
    _instance ?? (_instance = new CourseRequestService._ (http));

  /// The [CourseRequestService] private constructor...
  CourseRequestService._ (this._http) {
    _requestInformation = new RequestInformation();
  }

  /// The [setUserInformation] method...
  void setUserInformation (UserInformation userInformation) {
    try {
      _requestInformation.setUserInformation (userInformation);
    } catch (_) { rethrow; }
  }

  /// The [submitCrf] method...
  Future submitCrf() async {
    try {
      _validateCrf();
    } catch (_) { rethrow; }

    try {
      final Response crfResponse = await _http.post (_SUBMISSION_URI);

      crfResponse.body;
    } catch (_) {
      throw new CrfException (
        'An error has occurred while attempting to submit the course request.'
      );
    }
  }

  /// The [_validateCrf] method...
  void _validateCrf() {
    if (null == _requestInformation) {
      throw new CrfException ('Cannot submit a course request that does not exist.');
    }

    if (null == _requestInformation.userInformation) {
      throw new CrfException (
        'No user information has been provided to submit the course request.'
      );
    }

    if (_requestInformation.sections.isEmpty) {
      throw new CrfException ('No sections have been selected for this course request.');
    }

    _requestInformation.crossListings.forEach ((CrossListing crossListing) {
      if (crossListing.sections.length < 2) {
        throw new CrfException ('Cannot have a cross-listing set with only one section.');
      }

      if (!crossListing.sections.every (
        (Section section) => (_requestInformation.sections.contains (section))
      )) {
        throw new CrfException (
          'Cannot have a cross-listing set containing a section which is not '
            'part of the course request.'
        );
      }
    });

    _requestInformation.previousContents.forEach ((PreviousContentMapping previousContent) {
      if (!_requestInformation.sections.contains (previousContent.section)) {
        throw new CrfException (
          'Cannot have previous content specified for a section that is not part '
            'of the course request.'
        );
      };
    });
  }
}