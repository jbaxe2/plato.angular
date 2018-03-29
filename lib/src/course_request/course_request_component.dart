library plato.angular.components.course_request;

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

import '../_application/directions/directions_component.dart';
import '../_application/error/error_component.dart';
import '../_application/progress/progress_component.dart';
import '../_application/review_request/review_request_component.dart';
import '../_application/session_cleanup/session_cleanup_component.dart';

import '../archives/archive_component.dart';

import '../cross_listings/cross_listings_component.dart';

import '../previous_content/previous_content_component.dart';

import '../sections/requested_sections_component.dart';
import '../sections/requesting_sections_component.dart';

import '../user/user_component.dart';

import 'course_request_service.dart';

/// The [CourseRequestComponent] component class...
@Component(
  selector: 'course-request',
  templateUrl: 'course_request_component.html',
  styleUrls: const [
    'package:angular_components/app_layout/layout.scss.css',
    'course_request_component.scss.css'
  ],
  directives: const [
    COMMON_DIRECTIVES, materialDirectives,
    UserComponent, RequestingSectionsComponent, RequestedSectionsComponent,
    CrossListingsComponent, PreviousContentComponent, ArchivesComponent,
    DirectionsComponent, ErrorComponent, ProgressComponent,
    ReviewRequestComponent, SessionCleanupComponent
  ],
  providers: const [materialProviders, CourseRequestService],
)
class CourseRequestComponent {
  bool get submittable => _crfService.submittable;

  final CourseRequestService _crfService;

  /// The [CourseRequestComponent] constructor...
  CourseRequestComponent (this._crfService);

  /// The [reviewCourseRequest] method...
  void reviewCourseRequest() => _crfService.reviewCourseRequest();
}
