import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:tasky_mobile_app/models/comment.dart';
import 'package:tasky_mobile_app/models/inbox.dart' as inbox;
import 'package:tasky_mobile_app/models/user.dart';
import 'package:tasky_mobile_app/services/inbox_service.dart';
import 'package:tasky_mobile_app/utils/local_storage.dart';

class InboxManager with ChangeNotifier {
  final InboxService _inboxService = GetIt.I.get<InboxService>();
  final LocalStorage _localStorage = GetIt.I.get<LocalStorage>();

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

  Future<inbox.Inbox?> getInboxes({String query = 'All'}) async {
    try {
      inbox.Inbox? _inbox;
      int? userId = await _localStorage.getId();
      Data? userInfo = await _localStorage.getUserInfo();
      await _inboxService.getInboxRequest(userId: userId!).then((response) {
        int statusCode = response.statusCode;
        Map<String, dynamic> body = json.decode(response.body);

        setMessage(body['message']);
        setisLoading(false);
        if (statusCode == 200) {
          _inbox = inbox.Inbox.fromJson(body);
          Iterable<inbox.Datum> searchData = _inbox!.data!.where((element) {
            if (query == 'Assigned to me' || query == 'All') {
              return element.userId == userId;
            } else if (query == 'Assigned to team') {
              return element.team == userInfo.team;
            } else {
              return false;
            }
          });

          _inbox = inbox.Inbox(
              data: searchData.toList(),
              message: _inbox!.message,
              status: _inbox!.status);
        } else {
          _inbox = null;
        }
      }).catchError((onError) {
        _logger.d(onError);
        _inbox = null;
        setMessage('$onError');
        setisLoading(false);
      }).timeout(const Duration(seconds: 60), onTimeout: () {
        _inbox = null;
        setMessage('Timeout! Check your internet connection.');
        setisLoading(false);
      });
      return _inbox;
    } catch (e) {
      _logger.d(e);
      setMessage('$e');
      setisLoading(false);
      return null;
    }
  }

  Future<Comment?> getInboxComments({int? inboxId}) async {
    Comment? _comment;
    await _inboxService.getInboxCommentRequest(inbox: inboxId).then((response) {
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

  Future<bool> submitInboxComment({int? inboxId, String? comment}) async {
    bool isSent = true;
    await _inboxService.submitInboxCommentRequest(inbox: inboxId,comment: comment).then((response) {
      int statusCode = response.statusCode;
      Map<String, dynamic> body = json.decode(response.body);
      setMessage(body['message']);
      setisLoading(false);
      if (statusCode == 201) {
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
