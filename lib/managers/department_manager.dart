import 'dart:developer' as developer;

import 'package:flutter/material.dart';

import '../models/department.dart';

class DepartmentManager with ChangeNotifier {
  static final DepartmentManager _singleton = DepartmentManager._internal();
  DepartmentManager._internal() {
    developer.log('$this initialized');
  }

  factory DepartmentManager() {
    return _singleton;
  }

  List<Department> _list = [];
  List<Department> get list => [..._list];
  set list(List<Department> new_list) {
    _list = new_list;
    notifyListeners();
  }
}
