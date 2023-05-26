import 'dart:developer' as developer;

import 'package:flutter/material.dart';

import '../models/position.dart';

class PositionManager with ChangeNotifier {
  static final PositionManager _singleton = PositionManager._internal();
  PositionManager._internal() {
    developer.log('$this initialized');
  }

  factory PositionManager() {
    return _singleton;
  }

  List<Position> _list = [];
  List<Position> get list => [..._list];
  set list(List<Position> new_list) {
    _list = new_list;
    notifyListeners();
  }
}
