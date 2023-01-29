import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

/// This class is responsible for sending images to the Flask server over HTTP.
class ImageSender {
  final HttpClient _client = HttpClient();
  final String serverAddress = "https://jigsaw-hints.free.beeceptor.com";
  final String contentType = "application/json";
  final Duration timeoutDuration = const Duration(seconds: 10);

  Future<List<String>> retrieveDataFromFlask() async {
    List<String> groups = [];
    _client
        .getUrl(Uri.parse("$serverAddress/retrieveDataFromFlask"))
        .then((HttpClientRequest request) {
      request.headers.set(HttpHeaders.contentTypeHeader, contentType);
      return request.close();
    }) // Process the response
        .then(
      (HttpClientResponse response) {
        response.transform(utf8.decoder).listen(
          (event) {
            List<dynamic> data = jsonDecode(event);
            for (var object in data) {
              (object as Map<String, dynamic>).forEach(
                (key, value) {
                  debugPrint("$key: $value");
                },
              );
            }
          },
        );
      },
    );
    return groups;
  }

  Future<http.Response> sendImageToFlask(context, String image) async {
    final response = await http
        .post(
      Uri.parse("$serverAddress/sendImageToFlask"),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: contentType,
      },
      body: jsonEncode(<String, String>{
        'imagedata': image,
      }),
    )
        .timeout(timeoutDuration, onTimeout: () {
      return http.Response('Timed out', 408);
    });
    return response;
  }
}
