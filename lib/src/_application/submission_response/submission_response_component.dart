library plato.crf.components.application.response;

import 'dart:html' show window;

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

import '../../courses/rejected_course.dart';

import '../../course_request/course_request_service.dart';

import 'submission_response.dart';

/// The [SubmissionResponseComponent] class...
@Component(
  selector: 'submission-response',
  templateUrl: 'submission_response_component.html',
  styleUrls: ['submission_response_component.css'],
  directives: [
    ModalComponent, MaterialDialogComponent, MaterialButtonComponent,
    NgIf, NgFor
  ],
  providers: [CourseRequestService]
)
class SubmissionResponseComponent implements OnInit {
  bool isVisible;

  SubmissionResponse submissionResponse;

  List<RejectedCourse> rejectedCourses;

  final CourseRequestService _courseRequestService;

  /// The [SubmissionResponseComponent] constructor...
  SubmissionResponseComponent (this._courseRequestService);

  /// The [ngOnInit] method...
  @override
  void ngOnInit() {
    isVisible = false;
    rejectedCourses = <RejectedCourse>[];

    _courseRequestService.responseController.stream.listen (
      (SubmissionResponse theSubmissionResponse) {
        submissionResponse = theSubmissionResponse;

        rejectedCourses
          ..clear()
          ..addAll (submissionResponse.rejectedCourses);

        isVisible = true;
      }
    );
  }

  /// The [redirectToPlato] method...
  void redirectToPlato() {
    window.location.replace ('http://www.westfield.ma.edu/plato/');
  }
}
