library plato.angular.services.learn.cross_listing;

import 'package:angular/core.dart';

import '../banner/section.dart';

import '../crf/request_information.dart';

import 'cross_listing.dart';

/// The [CrossListingService] class...
@Injectable()
class CrossListingService {
  List<CrossListing> crossListings;

  Map<Section, CrossListing> crossListedSections;

  Section invokerSection;

  RequestInformation _requestInformation;

  static CrossListingService _instance;

  /// The [CrossListingService] factory constructor...
  factory CrossListingService() =>
    _instance ?? (_instance = new CrossListingService._());

  /// The [CrossListingService] private constructor...
  CrossListingService._() {
    _requestInformation = new RequestInformation();
    crossListings = _requestInformation.crossListings;
  }

  /// The [invokeForSection] method...
  void invokeForSection (Section section) => (invokerSection = section);

  /// The [revokeSection] method...
  void revokeSection() => (invokerSection = null);

  /// The [createCrossListingSet] method...
  CrossListing createCrossListingSet() {
    var crossListing = new CrossListing();

    try {
      _requestInformation.addCrossListing (crossListing);
    } catch (_) { rethrow; }

    return crossListing;
  }

  /// The [addCrossListings] method...
  void addCrossListings (List<CrossListing> crossListings) =>
    _requestInformation.addCrossListings (crossListings);

  /// The [removeCrossListing] method...
  bool removeCrossListing (CrossListing crossListing) =>
    _requestInformation.removeCrossListing (crossListing);

  /// The [addSectionToCrossListing] method...
  void addSectionToCrossListing (Section theSection, CrossListing theCrossListing) {
    try {
      _requestInformation.addSectionToCrossListing (theSection, theCrossListing);
      crossListedSections.putIfAbsent (theSection, () => theCrossListing);
    } catch (_) { rethrow; }
  }

  /// The [removeSectionFromCrossListing] method...
  void removeSectionFromCrossListing (Section theSection, CrossListing theCrossListing) {
    try {
      _requestInformation.removeSectionFromCrossListing (theSection, theCrossListing);
      crossListedSections.remove (theSection);
    } catch (_) { rethrow; }
  }
}
