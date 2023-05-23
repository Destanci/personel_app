import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:personel_app/managers/employee_manager.dart';

import '../models/employee_model.dart';

class JEmployeeReader {
  static final JEmployeeReader _singleton = JEmployeeReader._internal();
  JEmployeeReader._internal();

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
