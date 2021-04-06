import 'package:flutter/material.dart';

class Config extends ChangeNotifier {
  int _shortURLShowLimit = 5;
  double toolBarHeight = 50.0;
  bool _filterDuplicate = false;
  int get shortURLShowLimit => _shortURLShowLimit;
  bool get filterDuplicate => _filterDuplicate;
  setShortUrlShowLimit(int limit) {
    _shortURLShowLimit = limit;
    notifyListeners();
  }

  setFilterDuplicate(bool set) {
    _filterDuplicate = set;
    notifyListeners();
  }
}