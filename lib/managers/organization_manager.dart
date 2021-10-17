import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:tasky_mobile_app/managers/file_upload_manager.dart';
import 'package:tasky_mobile_app/managers/user_manager.dart';
import 'package:tasky_mobile_app/models/member.dart';
import 'package:tasky_mobile_app/models/organization.dart';
import 'package:tasky_mobile_app/services/organization_service.dart';
import 'package:tasky_mobile_app/utils/local_storage.dart';

class OrganizationManager with ChangeNotifier {
  final OrganizationService _organizationService =
      GetIt.I.get<OrganizationService>();
  final LocalStorage _localStorage = GetIt.I.get<LocalStorage>();
  final FileUploadManager _fileUploadManager = GetIt.I.get<FileUploadManager>();

  final UserManager _userManager =
      GetIt.I.get<UserManager>();
  final Logger _logger = Logger();
  String? _message = '';
  bool _isLoading = false;

  String? get message => _message;
  bool get isLoading => _isLoading;

  setMessage(String? message) {
    _message = message;
    notifyListeners();
  }

  setisLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  Future<Organization?> getOrganization() async {
    Organization? _organization;
    setisLoading(true);
    int? organizationID = await _localStorage.getOrganizationId();
    await _organizationService
        .getOrganizationRequest(organizationID: organizationID)
        .then((response) {
      int statusCode = response.statusCode;
      Map<String, dynamic> body = json.decode(response.body);
      setMessage(body['message']);
      setisLoading(false);
      if (statusCode == 200) {
        _organization = Organization.fromMap(body);
      } else {
        _organization = null;
      }
    }).catchError((onError) {
      _organization = null;
      setMessage('$onError');
      setisLoading(false);
    }).timeout(const Duration(seconds: 60), onTimeout: () {
      _organization = null;
      setMessage('Timeout! Check your internet connection.');
      setisLoading(false);
    });
    return _organization;
  }

  Future<bool> createOrganization(
      {required File image, String? name, List<String>? teams}) async {
    bool isCreated = false;
    String? fileUrl = await _fileUploadManager.updateOrganizationPicture(image);
    if (fileUrl != null) {
      await _organizationService
          .createOrganizationRequest(
              teams: teams, imageUrl: fileUrl, name: name)
          .then((response) async {
        int statusCode = response.statusCode;
        _logger.d(statusCode);
        Map<String, dynamic> body = json.decode(response.body);
        setMessage('${body['message']}');
        if (statusCode == 201) {
          await _userManager.getUserInformation();
          isCreated = true;
        } else {
          isCreated = false;
        }
      }).catchError((onError) {
        setMessage('$onError');
        isCreated = false;
      });
    } else {
      setMessage('Something went wrong while uploading file');
      isCreated = false;
    }
    return isCreated;
  }

  Future<Member?> getOrganizationMembers() async {
    Member? _member;
    setisLoading(true);
    int? organizationID = await _localStorage.getOrganizationId();
    await _organizationService
        .getMemberListRequest(organizationId: organizationID)
        .then((response) {
      int statusCode = response.statusCode;
      Map<String, dynamic> body = json.decode(response.body);
      setMessage(body['message']);
      setisLoading(false);
      if (statusCode == 200) {
        _member = Member.fromMap(body);
      } else {
        _member = null;
      }
    }).catchError((onError) {
      _member = null;
      setMessage('$onError');
      setisLoading(false);
    }).timeout(const Duration(seconds: 60), onTimeout: () {
      _member = null;
      setMessage('Timeout! Check your internet connection.');
      setisLoading(false);
    });
    return _member;
  }
}
