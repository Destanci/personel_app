import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

class ConnectionManager with ChangeNotifier {
  static final ConnectionManager _singleton = ConnectionManager._internal();
  ConnectionManager._internal() {
    developer.log('$this initialized');
  }

  factory ConnectionManager() {
    return _singleton;
  }

  static const bool _debug = true;

  bool _hasConnection = true;
  bool get hasConnection => _hasConnection;
  set hasConnection(bool value) {
    _hasConnection = value;
    notifyListeners();
  }

  static const String _host = 'localhost:44391';
  String get host => 'https://${_host.replaceFirst('localhost', '10.0.2.2')}';
  String get headerHost => _host;

  Future<Map<String, dynamic>?> postServer(
    String data, {
    String controller = '',
    timeout = 10,
  }) async {
    try {
      var url = '$host/api/$controller';

      if (_debug) {
        developer.log('To: $url Posting:\n$data');
      }
      bool connectionEstablished = true;

      Map<String, dynamic>? res = await http
          .post(Uri.parse(url),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
                'Content-Length': utf8.encode(data).length.toString(),
                'Host': headerHost
              },
              body: data)
          .timeout(Duration(seconds: timeout))
          .then(
        (response) {
          if (_debug) {
            developer.log('CONNECTION STATUS CODE: ${response.statusCode}');
          }
          if (response.statusCode == 200) {
            connectionEstablished = true;
            if (_debug) {
              developer.log('CONNECTION Response:\n${response.body}');
            }

            final json = jsonDecode(response.body);
            if (json is Map<String, dynamic>) {
              return json;
            }
            connectionEstablished = false;
            developer.log('ERROR -> Server Returned Unknown: [${json['Error'].toString()}]');
          } else {
            connectionEstablished = false;
          }
        },
      ).onError((error, stackTrace) {
        connectionEstablished = false;
        developer.log('ERROR -> Connection Failed with an Error: [$error]');
        return null;
      }).whenComplete(() {
        hasConnection = connectionEstablished;
        if (_debug) {
          developer.log('Connection End');
        }
      });
      return res;
    } catch (ex) {
      hasConnection = false;
      developer.log('ERROR -> Connection Failed with an Error: [$ex]');
      return null;
    }
  }

  Future<Map<String, dynamic>?> sendImage(
    int id,
    String imagePath, {
    String controller = '',
  }) async {
    try {
      var url = '$host/api/$controller';

      var request = http.MultipartRequest("POST", Uri.parse(url));
      request.headers.addAll({
        'Content-Type': 'application/json; charset=UTF-8',
        'Host': headerHost,
      });
      request.fields["Id"] = id.toString();

      var pic = await http.MultipartFile.fromPath("file", imagePath);
      request.files.add(pic);

      var response = await request.send();
      if (_debug) developer.log('CONNECTION STATUS CODE: ${response.statusCode}');

      var responseData = await response.stream.toBytes();
      var responseJson = jsonDecode(String.fromCharCodes(responseData));
      if (_debug) developer.log('CONNECTION STATUS CODE: $responseJson');

      return responseJson;
    } catch (ex) {
      developer.log('ERROR -> Connection Failed with an Error: [$ex]');
      return null;
    }
  }
}
