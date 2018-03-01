library plato.angular.components.banner.terms;

import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

import 'terms_service.dart';
import 'term.dart';

/// The [TermsComponent] component class...
@Component(
  selector: 'terms',
  templateUrl: 'terms_component.html',
  directives: const [CORE_DIRECTIVES, materialDirectives],
  providers: const [TermsService],
)
class TermsComponent implements OnInit {
  final TermsService termsService;

  List<Term> terms;

  Term selectedTerm;

  /// The [TermsComponent] constructor...
  TermsComponent (this.termsService);

  /// The [ngOnInit] method...
  @override
  Future ngOnInit() async {
    terms = await termsService.retrieveTerms();
  }

  /// The [onTermSelected] method...
  Future<Null> onTermSelected() async {}
}
