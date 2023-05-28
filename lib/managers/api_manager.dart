import 'dart:convert';
import 'dart:developer' as developer;

import '../core/models/api_response.dart';
import '../core/models/paged_request_model.dart';
import '../models/department.dart';
import '../models/employee.dart';
import '../models/filter_models/employee_filter.dart';
import '../models/position.dart';
import 'connection_manager.dart';
import 'department_manager.dart';
import 'employee_manager.dart';
import 'position_manager.dart';

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

  Future getEmployees(PagedRequest request,
      {EmployeeFilter? filter, String? search, List<RequestOrder>? orderList, bool clearList = false}) async {
    request.draw = _draw++;

    Map<String, dynamic> map = request.toMap();
    if (filter != null) map["Filter"] = filter.toMap();
    if (search != null) map["Search"] = {"Value": search};
    if (orderList != null) map["Order"] = orderList.map((e) => e.toMap()).toList();

    var res = await _connectionManager.postServer(
      jsonEncode(map),
      controller: 'Personel/GetList',
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

  Future<bool> updateEmployee(Employee employee, {bool add = false}) async {
    var controller = add ? 'Personel/Create' : 'Personel/Update';

    Map<String, dynamic> map = employee.toMap();

    var res = await _connectionManager.postServer(
      jsonEncode(map),
      controller: controller,
    );

    if (res != null) {
      try {
        if (res["Result"] is String && (res["Result"] as String).contains("Success")) {
          developer.log(res["Result"]);
          return true;
        }
      } catch (ex) {
        developer.log('[ERROR] -> Progressing Data : $ex');
      }
    }
    return false;
  }

  Future syncOtherData() async {
    var res = await _connectionManager.postServer('', controller: 'Department/GetList');
    if (res != null) {
      try {
        var response = DataResponse.fromMap(res);
        if (response.data is List) {
          DepartmentManager departmentManager = DepartmentManager();
          departmentManager.list = response.data.map<Department>((e) => Department.fromMap(e)).toList();
        }
      } catch (ex) {
        developer.log('[ERROR] -> Converting Data : $ex');
      }
    }

    res = await _connectionManager.postServer('', controller: 'Position/GetList');
    if (res != null) {
      try {
        var response = DataResponse.fromMap(res);
        if (response.data is List) {
          PositionManager positionManager = PositionManager();
          positionManager.list = response.data.map<Position>((e) => Position.fromMap(e)).toList();
        }
      } catch (ex) {
        developer.log('[ERROR] -> Converting Data : $ex');
      }
    }
  }
}
