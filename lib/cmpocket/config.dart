import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Config extends ChangeNotifier {

  static const VERSION = 'VERSION 1.0.7, Build#2021-04-07';
  /*
  1.0.4 修复了 Goods 标题显示详情问题，新键项目添加图片表单信息丢失问题，添加/修改返回后列表不更新问题
  1.0.5 修复了 QuickLink 非去重时的数据折叠问题
  1.0.6 修复了更新 Goods 时图片预览不更新的问题
  1.0.7 取消使用 static const 配置 Config，使用 Provider 替代，添加登录和注销，以及凭证记录。
  */
  static const int pageIndex = 1;

  static const headerStyle = TextStyle(fontSize: 20);
  static const smallHeaderStyle = TextStyle(fontSize: 13);
  static const formHelperStyle = TextStyle(color: Colors.grey,fontSize: 10);

  String user = '';
  String password = '';
  String get token => '?user=$user&password=$password';
  String get base64Token => "Basic ${base64Encode(utf8.encode('$user:$password'))}";

  Config() {
    _init();
  }

  _init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user = prefs.getString('user') ?? '';
    password = prefs.getString('password') ?? '';
    notifyListeners();
  }

  String addURL = 'https://go.mazhangjing.com/add';
  String basicURL = 'https://go.mazhangjing.com';
  String get goodsAddURL => 'https://status.mazhangjing.com/goods/add$token';

  String searchURL(String word) => 'https://go.mazhangjing.com/searchjson/$word$token';
  String dataURL(int limit) => 'https://go.mazhangjing.com/logs$token&day=$limit';
  String deleteURL(String keyword) => 'https://go.mazhangjing.com/deleteKey/$keyword$token';
  String deleteGoodsURL(String goodsId) => 'https://status.mazhangjing.com/goods/$goodsId/delete$token';
  String goodsUpdateURL(String goodsId) => 'https://status.mazhangjing.com/goods/$goodsId/update$token';

  String goodsURL() => 'https://status.mazhangjing.com/goods/data$token&hideRemove=$notShowRemoved&hideClothes=$notShowClothes'
        '&recentFirst:$goodsRecentFirst&shortByName:$goodsShortByName';

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
  bool notShowArchive = true;

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

  setNotShowArchive(bool res) {
    notShowArchive = res;
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

  justNotify() {
    notifyListeners();
  }
}