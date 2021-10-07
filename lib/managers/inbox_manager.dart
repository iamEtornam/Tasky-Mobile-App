import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:tasky_mobile_app/models/comment.dart';
import 'package:tasky_mobile_app/models/inbox.dart';
import 'package:tasky_mobile_app/services/inbox_service.dart';
import 'package:tasky_mobile_app/utils/local_storage.dart';

class InboxManager with ChangeNotifier {
  final InboxService _inboxService = GetIt.I.get<InboxService>();
  final LocalStorage _localStorage = GetIt.I.get<LocalStorage>();

  final Logger _logger = Logger();

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

  Future<Inbox> getInboxes() async {
    Inbox _inbox;
    await _inboxService
        .getInboxRequest(userId: await _localStorage.getId())
        .then((response) {
      int statusCode = response.statusCode;
      Map<String, dynamic> body = json.decode(response.body);
      setMessage(body['message']);
      setisLoading(false);
      if (statusCode == 200) {
        _inbox = Inbox.fromJson(body);
      } else {
        _inbox = null;
      }
    }).catchError((onError) {
      _inbox = null;
      setMessage('$onError');
      setisLoading(false);
    }).timeout(const Duration(seconds: 60), onTimeout: () {
      _inbox = null;
      setMessage('Timeout! Check your internet connection.');
      setisLoading(false);
    });
    return _inbox;
  }

    Future<Comment> getInboxComments({int inboxId}) async {
    Comment _comment;
    await _inboxService
        .getInboxCommentRequest(inbox: inboxId)
        .then((response) {
      int statusCode = response.statusCode;
      Map<String, dynamic> body = json.decode(response.body);
      setMessage(body['message']);
      setisLoading(false);
      if (statusCode == 200) {
        _comment = Comment.fromJson(body);
      } else {
        _comment = null;
      }
    }).catchError((onError) {
      _comment = null;
      setMessage('$onError');
      setisLoading(false);
    }).timeout(const Duration(seconds: 60), onTimeout: () {
      _comment = null;
      setMessage('Timeout! Check your internet connection.');
      setisLoading(false);
    });
    return _comment;
  }
}
