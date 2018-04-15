@Tags(const ['aot'])
@TestOn('browser')
library plato.angular.tests;

import 'package:angular/angular.dart';
import 'package:angular_test/angular_test.dart';

import 'package:test/test.dart';

import 'services/courses_service_test.dart' as courses_service;
import 'services/departments_service_test.dart' as departments_service;
import 'services/terms_service_test.dart' as terms_service;

import 'course_request_test.dart' as course_request;
import 'cross_listing_test.dart' as cross_listing;

/// The [main] function...
@AngularEntrypoint()
void main() {
  tearDown (disposeAnyRunningTest);

  course_request.main();
  cross_listing.main();

  departments_service.main();
  terms_service.main();
  courses_service.main();
}