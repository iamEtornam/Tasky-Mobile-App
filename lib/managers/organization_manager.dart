import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
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
}
