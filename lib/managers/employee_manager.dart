import 'package:flutter/cupertino.dart';
import 'dart:developer' as developer;

import '../models/employee_model.dart';

class EmployeeManager with ChangeNotifier {
  static final EmployeeManager _singleton = EmployeeManager._internal();
  EmployeeManager._internal() {
    developer.log('$this initialized');
  }

  factory EmployeeManager() {
    return _singleton;
  }
  static const bool _debug = true;

  int recordsFiltered = 0;
  int recordTotal = 0;

  bool endOfList = false;

  List<Employee> _list = [];

  List<Employee> get list => [..._list];

  set list(List<Employee> new_list) {
    _list = new_list;
    developer.log("COUNT : ${_list.length}");
    notifyListeners();
  }

  void add(Employee new_item) {
    _list.add(new_item);
    notifyListeners();
  }

  void addList(List<Employee> new_items) {
    var ids = new_items.map((e) => e.id);
    var count = _list.where((element) => ids.contains(element.id)).length;

    if (count > 0) {
      _list.removeWhere((element) => ids.contains(element.id));
      if (_debug) {
        developer.log('Found duplicate data');
      }
    }

    _list.addAll(new_items);
    developer.log("COUNT : ${_list.length}");
    notifyListeners();
  }
}
