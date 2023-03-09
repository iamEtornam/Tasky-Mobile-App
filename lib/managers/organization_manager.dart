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
  final OrganizationService _organizationService = GetIt.I.get<OrganizationService>();
  final LocalStorage _localStorage = GetIt.I.get<LocalStorage>();
  final FileUploadManager _fileUploadManager = GetIt.I.get<FileUploadManager>();

  final UserManager _userManager = GetIt.I.get<UserManager>();
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
    Organization? organization;
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
        organization = Organization.fromMap(body);
      } else {
        organization = null;
      }
    }).catchError((onError) {
      organization = null;
      setMessage('$onError');
      setisLoading(false);
    }).timeout(const Duration(seconds: 60), onTimeout: () {
      organization = null;
      setMessage('Timeout! Check your internet connection.');
      setisLoading(false);
    });
    return organization;
  }

  Future<bool> createOrganization({required File image, String? name, List<String>? teams}) async {
    bool isCreated = false;
    String? fileUrl = await _fileUploadManager.imageFileUploader(image);
    if (fileUrl != null) {
      await _organizationService
          .createOrganizationRequest(teams: teams, imageUrl: fileUrl, name: name)
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
    Member? member;
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
        member = Member.fromMap(body);
      } else {
        member = null;
      }
    }).catchError((onError) {
      member = null;
      setMessage('$onError');
      setisLoading(false);
    }).timeout(const Duration(seconds: 60), onTimeout: () {
      member = null;
      setMessage('Timeout! Check your internet connection.');
      setisLoading(false);
    });
    return member;
  }

  Future<bool> inviteMember({required List<String> emails}) async {
    bool isSent = false;
    await _organizationService.inviteMembersRequest(emails: emails).then((response) {
      int statusCode = response.statusCode;
      Map<String, dynamic> body = json.decode(response.body);
      setMessage(body['message']);
      setisLoading(false);
      if (statusCode == 200) {
        isSent = true;
      } else {
        isSent = false;
      }
    }).catchError((onError) {
      isSent = false;
      setMessage('$onError');
      setisLoading(false);
    }).timeout(const Duration(seconds: 60), onTimeout: () {
      isSent = false;
      setMessage('Timeout! Check your internet connection.');
      setisLoading(false);
    });
    return isSent;
  }
}
