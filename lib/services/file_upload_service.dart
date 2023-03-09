import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';
import 'package:tasky_mobile_app/utils/network_utils/endpoints.dart';

class FileUploadService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<Response> fileUploaderRequest({required File file}) async {
    final token = await _firebaseAuth.currentUser!.getIdToken();
    Map<String, String> headers = {"Accept": "application/json", "Authorization": "Bearer $token"};
    final multipartRequest = MultipartRequest('POST', Uri.parse(fileUploaderPath));
    String fileName = basename(file.path);
    multipartRequest.headers.addAll(headers);
    multipartRequest.files.add(
      await MultipartFile.fromPath('files', file.path,
          filename: fileName, contentType: MediaType("image", "png")),
    );

    Response response = await Response.fromStream(await multipartRequest.send())
        .timeout(const Duration(seconds: 120));
    return response;
  }
}
