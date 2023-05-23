import 'package:flutter/cupertino.dart';

import '../models/employee_model.dart';

class EmployeeManager with ChangeNotifier {
  static final EmployeeManager _singleton = EmployeeManager._internal();
  EmployeeManager._internal();

  factory EmployeeManager() {
    return _singleton;
  }

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
    _list.addAll(new_items);
    notifyListeners();
  }
}
