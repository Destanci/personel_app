import 'package:flutter/cupertino.dart';
import 'dart:developer' as developer;

import '../models/employee_model.dart';

class EmployeeManager with ChangeNotifier {
  static final EmployeeManager _singleton = EmployeeManager._internal();
  EmployeeManager._internal();

  factory EmployeeManager() {
    return _singleton;
  }
  static const bool _debug = true;

  List<Employee> _list = [];

  List<Employee> get list => [..._list];

  set list(List<Employee> new_list) {
    _list = new_list;
    notifyListeners();
  }

  void add(Employee new_item) {
    _list.add(new_item);
    notifyListeners();
  }

  void addList(List<Employee> new_items) {
    var ids = new_items.map((e) => e.id);
    var test = _list.where((element) => ids.contains(element.id)).toList();

    if (test.length > 0) {
      _list.removeWhere((element) => test.contains(element.id));
      if (_debug) {
        developer.log('Found duplicate data');
      }
    }

    _list.addAll(new_items);
    notifyListeners();
  }
}
