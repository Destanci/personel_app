import 'dart:convert';
import 'dart:developer' as developer;

import 'package:personel_app/core/models/api_response.dart';

import '../core/models/paged_request_model.dart';
import '../models/employee_model.dart';
import 'connection_manager.dart';
import 'employee_manager.dart';

class ApiManager {
  static final ApiManager _singleton = ApiManager._internal();
  ApiManager._internal() {
    developer.log('$this initialized');
  }

  factory ApiManager() {
    return _singleton;
  }

  final ConnectionManager _connectionManager = ConnectionManager();
  final EmployeeManager _employeeManager = EmployeeManager();

  int _draw = 1;

  bool requestTimeout = true;

  void getEmployees(PagedRequest request, {bool clearList = false}) async {
    if (!requestTimeout) return;

    requestTimeout = false;
    Future.delayed(Duration(seconds: 1), () {
      requestTimeout = true;
    });

    request.draw = _draw++;

    var res = await _connectionManager.postServer(
      jsonEncode(request.toMap()),
      controller: 'Personel/GetPersonelList',
    );

    if (res != null) {
      try {
        var response = DataResponse.fromMap(res);

        if (response.draw != request.draw) {
          developer.log('[ERROR -> Draw miss match]');
          return;
        }

        if (response.data is List) {
          if ((response.data as List).isEmpty) {
            _employeeManager.endOfList = true;
          }
          var employees = response.data.map<Employee>((e) => Employee.fromMap(e)).toList();

          if (clearList) {
            _employeeManager.list = employees;
            _employeeManager.endOfList = false;
          } else {
            _employeeManager.addList(employees);
          }
          _employeeManager.recordsFiltered = response.recordsFiltered!;
          _employeeManager.recordTotal = response.recordsTotal!;
        }
      } catch (ex) {
        developer.log('[ERROR] -> Converting Data : $ex');
      }
    }
  }
}
