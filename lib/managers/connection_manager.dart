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

  static const bool _debug = false;

  bool _hasConnection = false;
  bool get hasConnection => _hasConnection;
  set hasConnection(bool value) {
    _hasConnection = value;
    notifyListeners();
  }

  static const String _host = 'localhost:7025';
  String get host => 'https://${_host.replaceFirst('localhost', '10.0.2.2')}';

  Future<Map<String, dynamic>?> postServer(
    String data, {
    String controller = '',
    timeout = 10,
  }) async {
    var url = '$host/api/$controller';

    if (_debug) {
      developer.log('To: $url Posting:\n$data');
    }
    bool connectionEstablished = false;

    Map<String, dynamic>? res = await http
        .post(Uri.parse(url),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Content-Length': data.length.toString(),
              'Host': _host
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
  }
}
