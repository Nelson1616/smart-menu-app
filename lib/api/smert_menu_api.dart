import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ResponseJson {
  bool success;
  String message;
  Map<String, dynamic>? data;

  ResponseJson(this.success, this.message, this.data);
}

class SmartMenuApi {
  // String mainUrl = "http://localhost:8016/api";
  static String mainUrl = "http://192.168.1.9:8016/api";

  static Future<http.Response> get(String url) {
    if (url[0] != '/') {
      url = '/$url';
    }

    debugPrint("get: $mainUrl$url");

    return http.get(Uri.parse(mainUrl + url));
  }

  static Future<http.Response> post(String url, String json) {
    if (url[0] != '/') {
      url = '/$url';
    }

    debugPrint("post: $mainUrl$url");
    debugPrint("post body: $json");

    return http.post(Uri.parse(mainUrl + url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json);
  }

  static Future<ResponseJson> getTableByCode(String code) async {
    http.Response response = await get('tables/$code');

    Map<String, dynamic> json;

    json = jsonDecode(response.body);

    if (json['success'] == null) {
      throw Exception("Invalid response from api");
    }

    return ResponseJson(json['success'], json['message'], json['data']);
  }
}
