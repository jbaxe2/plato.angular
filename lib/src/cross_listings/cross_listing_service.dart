library plato.crf.services.cross_listing;

import 'dart:async' show StreamController;

import '../course_request/course_request.dart';

import '../sections/featured_section_service.dart';
import '../sections/section.dart';

import 'cross_listing.dart';
import 'cross_listing_exception.dart';

/// The [CrossListingService] class...
class CrossListingService extends FeaturedSectionService {
  List<CrossListing> crossListings;

  StreamController<CrossListing> crossListingStreamer;

  CourseRequest _courseRequest;

  static CrossListingService _instance;

  /// The [CrossListingService] factory constructor...
  factory CrossListingService() =>
    _instance ?? (_instance = CrossListingService._());

  /// The [CrossListingService] private constructor...
  CrossListingService._() {
    _courseRequest = CourseRequest();

    crossListings = _courseRequest.crossListings;
    crossListingStreamer = StreamController<CrossListing>.broadcast();

    init();
  }

  /// The [createCrossListingSet] method...
  CrossListing createCrossListingSet() {
    var crossListing = CrossListing();

    try {
      _courseRequest.addCrossListing (crossListing);
    } catch (_) { rethrow; }

    return crossListing;
  }

  /// The [revokeSection] method...
  @override
  void revokeSection() {}

  /// The [addCrossListings] method...
  void addCrossListings (List<CrossListing> crossListings) =>
    _courseRequest.addCrossListings (crossListings);

  /// The [removeCrossListing] method...
  bool removeCrossListing (CrossListing crossListing) =>
    _courseRequest.removeCrossListing (crossListing);

  /// The [addSectionToCrossListing] method...
  void addSectionToCrossListing (Section theSection, CrossListing theCrossListing) {
    try {
      _courseRequest.addSectionToCrossListing (theSection, theCrossListing);
    } catch (_) { rethrow; }
  }

  /// The [removeSectionFromCrossListing] method...
  void removeSectionFromCrossListing (Section theSection, CrossListing theCrossListing) {
    try {
      _courseRequest.removeSectionFromCrossListing (theSection, theCrossListing);
    } catch (_) { rethrow; }
  }

  /// The [getCrossListingForSection] method...
  CrossListing getCrossListingForSection (Section section) =>
    _courseRequest.getCrossListingForSection (section);

  /// The [verifyCrossListings] method...
  bool verifyCrossListings() {
    if (crossListings.isEmpty) {
      return true;
    }

    return crossListings.every ((CrossListing crossListing) => crossListing.isValid);
  }

  /// The [confirmCrossListings] method...
  void confirmCrossListings() {
    if (
      crossListings.any ((CrossListing crossListing) => crossListing.sections.isEmpty)
    ) {
      throw CrossListingException (
        'Cannot confirm cross-listings when one or more sets is empty.'
      );
    }

    if (crossListings.isEmpty) {
      crossListingStreamer.add (null);

      return;
    }

    crossListings.forEach (
      (CrossListing aCrossListing) => crossListingStreamer.add (aCrossListing)
    );
  }
}
