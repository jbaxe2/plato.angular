library plato.angular.services.archive.resources;

import 'dart:async' show Future, StreamController;
import 'dart:convert' show JSON;

import 'package:angular/core.dart';

import 'package:http/http.dart' show Client, Response;

import './course/archive_course.dart';
import './course/archive_course_factory.dart';

import './resource/archive_resource.dart';

import 'archive_exception.dart';

const String _BROWSE_URI = '/plato/browse/archive';

/// The [BrowseArchiveService] class...
@Injectable()
class BrowseArchiveService {
  StreamController<ArchiveCourse> archiveCourseController;

  StreamController<ArchiveResource> resourceController;

  ArchiveCourseFactory _archiveCourseFactory;

  final Client _http;

  static BrowseArchiveService _instance;

  /// The [BrowseArchiveService] factory constructor...
  factory BrowseArchiveService (Client http) =>
    _instance ?? (_instance = new BrowseArchiveService (http));

  /// The [BrowseArchiveService] private constructor...
  BrowseArchiveService._ (this._http) {
    archiveCourseController = new StreamController<ArchiveCourse>.broadcast();
    resourceController = new StreamController<ArchiveResource>.broadcast();

    _archiveCourseFactory = new ArchiveCourseFactory();
  }

  /// The [browseArchive] method...
  Future browseArchive (
    String archiveId, [String resourceId = 'none', String resourceTitle = 'N/A']
  ) async {
    try {
      final Response archiveResponse = await _http.get (
        '$_BROWSE_URI?archiveId=$archiveId&resourceId=$resourceId'
      );

      Map<String, dynamic> rawArchiveInfo = JSON.decode (archiveResponse.body);

      if (!(rawArchiveInfo.containsKey ('courseId') &&
            rawArchiveInfo.containsKey ('courseTitle'))) {
        throw rawArchiveInfo;
      }

      if (rawArchiveInfo.containsKey ('manifestOutline')) {
        archiveCourseController.add (_archiveCourseFactory.create (rawArchiveInfo));
      } else if (rawArchiveInfo.containsKey ('resource')) {
        resourceController.add (
          _createResource (resourceId, resourceTitle, rawArchiveInfo['resource'])
        );
      } else {
        // Must have either a manifest outline or resource.
        throw rawArchiveInfo;
      }
    } catch (_) {
      throw new ArchiveException (
        'Missing course information from retrieved archive information.'
      );
    }
  }

  /// The [previewResource] method...
  Future previewResource (String archiveId, String resourceId, String title) async =>
    await browseArchive (archiveId, resourceId, title);

  /// The [_createResource] method...
  ArchiveResource _createResource (String resourceId, String title, String content) {
    if ('' == content) {
      content = '(The content for this resource returned blank.)';
    }

    return new ArchiveResource (resourceId, title, content);
  }
}
