import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class Config extends ChangeNotifier {
  static const String user = 'corkine';
  static const String password = 'mzj960032';
  static const String token = '?user=$user&password=$password';
  static final String base64Token = "Basic ${base64Encode(utf8.encode('$user:$password'))}";
  static String dataURL(int limit) {
    return 'https://go.mazhangjing.com/logs$token&day=$limit';
  }
  static String searchURL(String word) {
    return 'https://go.mazhangjing.com/searchjson/$word$token';
  }
  static String deleteURL(String keyword) {
    return 'https://go.mazhangjing.com/deleteKey/$keyword$token';
  }
  static String deleteGoodsURL(String goodsId) {
    return 'https://status.mazhangjing.com/goods/$goodsId/delete$token';
  }
  static const String addURL = 'https://go.mazhangjing.com/add';
  static const String basicURL = 'https://go.mazhangjing.com';
  static const goodsAddURL = 'https://status.mazhangjing.com/goods/add$token';
  static const headerStyle = TextStyle(fontSize: 20);
  static const smallHeaderStyle = TextStyle(fontSize: 13);
  static const formHelperStyle = TextStyle(color: Colors.grey,fontSize: 10);
  static const VERSION = 'VERSION 1.0.1, Build@2021-04-07';

  String goodsURL() {
    return 'https://status.mazhangjing.com/goods/data$token&hideRemove=$notShowRemoved&hideClothes=$notShowClothes'
        '&recentFirst:$goodsRecentFirst&shortByName:$goodsShortByName';
  }

  int _shortURLShowLimit = 10;
  static double toolBarHeight = 50.0;
  bool _filterDuplicate = true;
  int get shortURLShowLimit => _shortURLShowLimit;
  bool get filterDuplicate => _filterDuplicate;

  int goodsLastDay = 300;
  bool goodsShortByName = true;
  bool goodsRecentFirst = true;
  bool notShowClothes = true;
  bool notShowRemoved = true;

  setGoodsShortByName(bool res) {
    goodsShortByName = res;
    notifyListeners();
  }

  setGoodsRecentFirst(bool res) {
    goodsRecentFirst = res;
    notifyListeners();
  }

  setNotShowClothes(bool res) {
    notShowClothes = res;
    notifyListeners();
  }

  setNotShowRemoved(bool res) {
    notShowRemoved = res;
    notifyListeners();
  }

  setShortUrlShowLimit(int limit) {
    _shortURLShowLimit = limit;
    notifyListeners();
  }

  setFilterDuplicate(bool set) {
    _filterDuplicate = set;
    notifyListeners();
  }
}