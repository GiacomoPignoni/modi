import 'dart:convert';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:modi/services/config_service.dart';
import 'package:modi/services/message_service.dart';
import 'package:http/http.dart' as http;

class HttpService {
  final ConfigService _configSvc = GetIt.I.get<ConfigService>();
  final MessageService _msgSvc = GetIt.I.get<MessageService>();

  String? _token;

  void setToken(String? newToken) {
    _token = newToken;
  }

  Future<T?> get<T>(String path, { T Function(Map<String, dynamic> json)? serializer, bool showError = true }) {
    return _generationAction(
      path,
      (headers, uri) => http.get(uri, headers: headers),
      serializer, showError
    );
  }

  Future<T?> post<T>(String path, dynamic body, { T Function(Map<String, dynamic> json)? serializer, bool showError = true }) async {
    final encodedBody = jsonEncode(body);

    return _generationAction(
      path,
      (headers, uri) => http.post(uri, body: encodedBody, headers: headers),
      serializer, showError
    );
  }

  Future<T?> delete<T>(String path, { T Function(Map<String, dynamic> json)? serializer, bool showError = true, dynamic body }) async {
    final encodedBody = jsonEncode(body);

    return _generationAction(
      path,
      (headers, uri) => http.delete(uri, headers: headers, body: (body != null) ? encodedBody : null),
      serializer, showError
    );
  }

  Future<T?> put<T>(String path, dynamic body, { T Function(Map<String, dynamic> json)? serializer, bool showError = true }) async {
    final encodedBody = jsonEncode(body);

    return _generationAction(
      path,
      (headers, uri) => http.put(uri, body: encodedBody, headers: headers),
      serializer, showError
    );
  }

  Future<T?> _generationAction<T>(String path, Future<Response> Function(Map<String, String> headers, Uri uri) action, T Function(Map<String, dynamic> json)? serializer, bool showError) async {
    try {
      final uri = Uri.parse("${_configSvc.baseUrl}$path");

      Map<String, String> headers = {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.acceptHeader: "application/json"
      };

      if(_token != null) {
        headers[HttpHeaders.authorizationHeader] = "Bearer $_token";
      }

      final res = await action(headers, uri);

      if(res.statusCode == 200) {
        final json = jsonDecode(utf8.decode(res.bodyBytes));
        
        if(json["success"] != null  && json["success"] == false) {
          _showError(showError, text: json["errorMessage"]);
        } else {
          if(serializer != null) {
            return serializer(json);
          }
        }
      } else if(res.statusCode == 440) {

      } else {
        _showError(showError);
        debugPrint("HTTP ERROR " + res.statusCode.toString());
      }
    } catch(error) {
      debugPrint("HTTP ERROR " + error.toString());
      _showError(showError);
    }
    return null;
  }

  void _showError(bool showError, {String? text}) {
    if(showError) {
      _msgSvc.showErrorDialog(text ?? tr("errors.generic"));
    }
  }
}
