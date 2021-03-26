import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:tasky_app/models/member.dart';
import 'package:tasky_app/models/organization.dart';
import 'package:tasky_app/services/organization_service.dart';
import 'package:tasky_app/utils/local_storage.dart';

final OrganizationService _organizationService =
    GetIt.I.get<OrganizationService>();
final LocalStorage _localStorage = GetIt.I.get<LocalStorage>();

class OrganizationManager with ChangeNotifier {
  String _message = '';
  bool _isLoading = false;

  String get message => _message;
  bool get isLoading => _isLoading;

  setMessage(String message) {
    _message = message;
    notifyListeners();
  }

  setisLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  Future<Organization> getOrganization() async {
    Organization _organization;
    setisLoading(true);
    int organizationID = await _localStorage.getOrganizationId();
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
    }).timeout(Duration(seconds: 60), onTimeout: () {
      _organization = null;
      setMessage('Timeout! Check your internet connection.');
      setisLoading(false);
    });
    return _organization;
  }

  Future<String> updateOrganizationPicture(File imageFile) async {
    String fileUrl;
    await _organizationService
        .fileUploaderRequest(file: imageFile)
        .then((response) async {
      Map<String, dynamic> body = json.decode(response.body);
      print(body);
      setMessage('${body['message']}');
      if (response.statusCode == 200) {
        fileUrl = body['fileUrl'];
      } else {
        fileUrl = null;
      }
    }).catchError((onError) {
      debugPrint('error $onError');
      setMessage('Something went wrong while uploading file');
      fileUrl = null;
    });
    return fileUrl;
  }

  Future<bool> createOrganization(
      {File image, String name, List<String> teams}) async {
    bool isCreated = false;
    String fileUrl = await updateOrganizationPicture(image);
    if (fileUrl != null) {
      await _organizationService
          .createOrganizationRequest(
              teams: teams, imageUrl: fileUrl, name: name)
          .then((response) {
        int statusCode = response.statusCode;
        print(statusCode);
        Map<String, dynamic> body = json.decode(response.body);
        setMessage('${body['message']}');
        if (statusCode == 201) {
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

    Future<Member> getOrganizationMembers() async {
    Member _member;
    setisLoading(true);
    int organizationID = await _localStorage.getOrganizationId();
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
    }).timeout(Duration(seconds: 60), onTimeout: () {
      _member = null;
      setMessage('Timeout! Check your internet connection.');
      setisLoading(false);
    });
    return _member;
  }
}
