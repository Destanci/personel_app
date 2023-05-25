import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/services.dart';

import '../models/employee_model.dart';
import 'employee_manager.dart';

class JEmployeeReader {
  static final JEmployeeReader _singleton = JEmployeeReader._internal();
  JEmployeeReader._internal() {
    developer.log('$this initialized');
  }

  factory JEmployeeReader() {
    return _singleton;
  }

  void read() async {
    var data = await rootBundle.loadString("assets/template.json").then((value) => jsonDecode(value));

    if (data is List) {
      Iterable<Employee> list = data.map((element) => Employee.fromMap(element));

      EmployeeManager().list = list.toList();
    }
  }
}
