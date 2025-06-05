// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'package:flutter/foundation.dart'; // tambahkan ini
import 'package:http/http.dart' as http;

class UploadService {
  Future<String?> uploadImage(Uint8List imagebytes) async {
    if (kIsWeb) {
      print('Upload tidak didukung di platform web.');
      return null;
    }

    try {
      Uri url = Uri.parse('https://api.cloudinary.com/v1_1/dulun20eo/image/upload');

      var request = http.MultipartRequest('POST', url)
        ..fields['upload_preset'] = 'simple_app_preset'
        ..files.add(http.MultipartFile.fromBytes('file', imagebytes, filename: 'image.jpg'));

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var responseString = jsonDecode(responseData);
        return responseString['secure_url'];
      } else {
        print('Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Exception during uploadImage: $e');
      return null;
    }
  }

  Future<List<String>> uploadMultipleImages(List<Uint8List> imageBytesList) async {
    if (kIsWeb) {
      print('Upload multiple images tidak didukung di platform web.');
      return [];
    }

    Uri url = Uri.parse('https://api.cloudinary.com/v1_1/dulun20eo/image/upload');
    List<String> uploadedUrls = [];

    for (int i = 0; i < imageBytesList.length; i++) {
      try {
        var request = http.MultipartRequest('POST', url)
          ..fields['upload_preset'] = 'simple_app_preset'
          ..files.add(http.MultipartFile.fromBytes('file', imageBytesList[i], filename: 'image_$i.jpg'));

        var response = await request.send();
        if (response.statusCode == 200) {
          var responseData = await response.stream.bytesToString();
          var responseJson = jsonDecode(responseData);
          uploadedUrls.add(responseJson['secure_url']);
        } else {
          print('Error uploading image $i: ${response.statusCode}');
        }
      } catch (e) {
        print('Exception uploading image $i: $e');
      }
    }

    return uploadedUrls;
  }
}
