import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:tasky_mobile_app/services/file_upload_service.dart';

class FileUploadManager with ChangeNotifier {
  final FileUploadService _fileUploadService = GetIt.I.get<FileUploadService>();
  String? _message = '';

  String? get message => _message;

  setMessage(String? message) {
    _message = message;
    notifyListeners();
  }

  Future<String?> imageFileUploader(File imageFile) async {
    try {
      String? fileUrl;
      await _fileUploadService.fileUploaderRequest(file: imageFile).then((response) async {
        Map<String, dynamic> body = json.decode(response.body);

        if (response.statusCode == 200) {
          fileUrl = body['metadata']['url'];
        } else {
          fileUrl = null;
        }
      }).catchError((onError) {
        setMessage('Something went wrong while uploading file');
        fileUrl = null;
      });
      return fileUrl;
    } catch (e) {
      return null;
    }
  }
}
