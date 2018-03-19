library plato.angular.components.previous_content;

import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

import '../enrollments/enrollment.dart';
import '../enrollments/enrollments_service.dart';

import '../sections/section.dart';

import 'previous_content_service.dart';

/// The [PreviousContentComponent] class...
@Component(
  selector: 'previous-content',
  templateUrl: 'previous_content_component.html',
  directives: const [CORE_DIRECTIVES, materialDirectives],
  providers: const [PreviousContentService, EnrollmentsService]
)
class PreviousContentComponent implements OnInit {
  List<Enrollment> enrollments;

  Section invokerSection;

  bool isVisible;

  final PreviousContentService _previousContentService;

  final EnrollmentsService _enrollmentsService;

  /// The [PreviousContentComponent] constructor...
  PreviousContentComponent (this._previousContentService, this._enrollmentsService);

  /// The [ngOnInit] method...
  void ngOnInit() {
    enrollments = _enrollmentsService.enrollments;
    isVisible = false;

    _previousContentService.sectionsStreamer.stream.listen (
      (Section section) {
        window.console.log (
          'Encountered a section (${section.sectionId}) for previous content'
        );

        invokerSection = section;
        isVisible = true;
      }
    );
  }

  /// The [browseArchive] method...
  void browseArchive (String archiveId) {
    window.console.debug ('Attempting to view archive info for $archiveId.');
  }

  /// The [confirmPreviousContent] method...
  void confirmPreviousContent() {}
}
