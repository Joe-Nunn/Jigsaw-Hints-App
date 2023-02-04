import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

/// This class is responsible for sending images to the Flask server over HTTP.
class ImageSender {
  final HttpClient _client = HttpClient();
  final String serverAddressEmulator = "http://10.0.2.2:5000";
  final String serverAddress = "http://10.89.72.162:4545";
  final String contentType = "application/json";
  final Duration timeoutDuration = const Duration(seconds: 90);

  Future<List<String>> retrieveDataFromFlask() async {
    List<String> groups = [];
    _client
        .getUrl(Uri.parse("$serverAddress/retrieve"))
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

  Future<http.Response> sendImageToFlask(
      {required String piece, required String base}) async {
    final response = await http
        .post(
      Uri.parse("$serverAddress/process"),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: contentType,
      },
      body: jsonEncode(<String, String>{
        'piece_data': piece,
        'base_data': base,
      }),
    )
        .timeout(timeoutDuration, onTimeout: () {
      return http.Response('Timed out', 408);
    });
    return response;
  }

  Future<http.Response> sendImageToFlaskTestData() async {
    final response = await http
        .post(
      Uri.parse("$serverAddress/process"),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: contentType,
      },
      body: await loadTestData(),
    )
        .timeout(timeoutDuration, onTimeout: () {
      return http.Response('Timed out', 408);
    });
    return response;
  }

  Future<String> loadTestData() async {
    return rootBundle.loadString('assets/test_data.json');
  }
}
