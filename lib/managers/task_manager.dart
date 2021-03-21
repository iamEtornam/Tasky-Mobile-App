import 'package:flutter/material.dart';
import 'package:tasky_app/models/user.dart';

class TaskManager with ChangeNotifier {
  List<Data> _assignees = [];
  List<String> _imagesList = [];
  String _message = '';
  bool _isLoading = false;

  String get message => _message;
  bool get isLoading => _isLoading;
  List<Data> get assignees => _assignees;
  List<String> get imagesList => _imagesList;

  setMessage(String message) {
    _message = message;
    notifyListeners();
  }

  setisLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  setAssignees(List<Data> users) {
    _assignees = users;
    List<String> ee = [];
    users.forEach((element) {
      ee.add(element.picture);
    });
    _imagesList = ee;
    
    notifyListeners();
  }
}
