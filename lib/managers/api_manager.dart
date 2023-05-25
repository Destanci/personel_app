import 'dart:convert';
import 'dart:developer' as developer;

import 'package:personel_app/core/models/api_response.dart';

import '../core/models/paged_request_model.dart';
import '../models/employee_model.dart';
import 'connection_manager.dart';
import 'employee_manager.dart';

class ApiManager {
  static final ApiManager _singleton = ApiManager._internal();
  ApiManager._internal();

  factory ApiManager() {
    return _singleton;
  }

  final ConnectionManager _connectionManager = ConnectionManager();
  final EmployeeManager _employeeManager = EmployeeManager();

  int _draw = 1;

  void getEmployees(PagedRequest request, {bool clearList = false}) async {
    request.draw = _draw++;

    var res = await _connectionManager.postServer(
      jsonEncode(request),
      controller: 'GetPersonelList',
    );

    if (res != null) {
      try {
        var response = DataResponse.fromMap(res);

        if (response.draw != _draw - 1) {
          developer.log('[ERROR -> Draw miss match]');
          return;
        }

        if (response.data is Map<String, dynamic>) {
          var employees = response.data.map((e) => Employee.fromMap(e)).toList();

          if (clearList) {
            _employeeManager.list = employees;
          } else {
            _employeeManager.addList(employees);
          }
        }
      } catch (ex) {
        developer.log('[ERROR] -> Converting Data : $ex');
      }
    }
  }
}
