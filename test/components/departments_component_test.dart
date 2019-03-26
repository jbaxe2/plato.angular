@TestOn('browser')
library plato.crf.tests.components.departments;

import 'package:angular/core.dart';
import 'package:angular_test/angular_test.dart';
import 'package:http/http.dart' show Client;
import 'package:pageloader/html.dart';
import 'package:test/test.dart';

import 'package:plato_crf/src/courses/courses_service.dart';

import 'package:plato_crf/src/departments/departments_component.dart';
import 'package:plato_crf/src/departments/departments_component.template.dart' as dc;

import 'package:plato_crf/src/departments/departments_service.dart';

import '../services/mock_client/mock_departments_client.dart';

import '../testable.dart';

import 'departments_po.dart';

import 'departments_component_test.template.dart' as dct;

/// The [main] function...
void main() => (new DepartmentsComponentTester()).run();

@GenerateInjector([
  const ClassProvider (Client, useClass: MockDepartmentsClient),
  const ClassProvider (DepartmentsService),
  const ClassProvider (CoursesService)
])
final deptsInjector = dct.deptsInjector$Injector;

/// The [DepartmentsComponentTester] class...
class DepartmentsComponentTester implements Testable {
  NgTestFixture<DepartmentsComponent> deptsFixture;

  DepartmentsPO deptsPo;

  /// The [DepartmentsComponentTester] constructor...
  DepartmentsComponentTester();

  /// The [run] method...
  @override
  void run() {
    dct.initReflector();

    _init();

    group (
      'Departments component:', () {
        _testDepartmentsComponent();
      }
    );
  }

  /// The [_init] method...
  void _init() {
    final deptsTestBed = NgTestBed.forComponent<DepartmentsComponent> (
      dc.DepartmentsComponentNgFactory, rootInjector: deptsInjector
    );

    setUp (() async {
      deptsFixture = await deptsTestBed.create();

      final deptsContext =
        new HtmlPageLoaderElement.createFromElement (deptsFixture.rootElement);

      deptsPo = new DepartmentsPO.create (deptsContext);
    });

    tearDown (disposeAnyRunningTest);
  }

  /// The [_testDepartmentsComponent] function...
  void _testDepartmentsComponent() {
    test (
      'Departments in the component are loaded successfully.', () async {
        await deptsPo.initDeptsPO();

        expect ((0 < (await deptsPo.departments).length), true);
      }
    );
  }
}
