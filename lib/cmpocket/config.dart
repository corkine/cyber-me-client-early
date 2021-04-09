import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:learn_flutter/cmpocket/data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Config extends ChangeNotifier {

  static const VERSION = 'VERSION 1.0.9, Build#2021-04-09';
  /*
  1.0.4 修复了 Goods 标题显示详情问题，新键项目添加图片表单信息丢失问题，添加/修改返回后列表不更新问题
  1.0.5 修复了 QuickLink 非去重时的数据折叠问题
  1.0.6 修复了更新 Goods 时图片预览不更新的问题
  1.0.7 取消使用 static const 配置 Config，使用 Provider 替代，添加登录和注销，以及凭证记录。
  1.0.8 修改 Goods 逻辑，点击显示 HTML 预览，长按进行修改，修改了默认的排序逻辑，提供显示创建/修改时间的选项，
  并自动根据选择时间处理排序，自动将选中对象拷贝到剪贴板，用户配置自动记住。
  1.0.9 更新 Good 返回列表刷新后会自动返回进入时的位置(新键 Good 则不会)，此外现在可以对列表进行同重要性和状态内的排序了，数据
  会记录在本地，下次打开后会自动排序。此外修复了 Dismissible 条目删除后短暂停留项目重新回来的问题（Good 和 QuickLink）。
  */
  static const int pageIndex = 1;

  static const headerStyle = TextStyle(fontSize: 20);
  static const smallHeaderStyle = TextStyle(fontSize: 13);
  static const formHelperStyle = TextStyle(color: Colors.grey,fontSize: 10);

  String user = '';
  String password = '';
  String get token => '?user=$user&password=$password';
  String get base64Token => "Basic ${base64Encode(utf8.encode('$user:$password'))}";

  double position = 0.0;

  Config() {
    _init();
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
  String goodsView(Good good) => 'https://status.mazhangjing.com/goods/${good.id}/details$token';
  String goodsViewNoToken(Good good) => 'https://status.mazhangjing.com/goods/${good.id}/details';

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
  bool showUpdateButNotCreateTime = true;
  bool autoCopyToClipboard = true;
  bool useReorderableListView = false;

  Map<String,int> map = {};

  SharedPreferences prefs;

  _init() async {
    prefs = await SharedPreferences.getInstance();
    user = prefs.getString('user') ?? '';
    password = prefs.getString('password') ?? '';
    _shortURLShowLimit = prefs.getInt('_shortURLShowLimit') ?? 10;
    _filterDuplicate = prefs.getBool('_filterDuplicate') ?? true;
    goodsShortByName = prefs.getBool('goodsShortByName') ?? true;
    goodsRecentFirst = prefs.getBool('goodsRecentFirst') ?? true;
    notShowClothes = prefs.getBool('notShowClothes') ?? true;
    notShowRemoved = prefs.getBool('notShowRemoved') ?? true;
    notShowArchive = prefs.getBool('notShowArchive') ?? true;
    showUpdateButNotCreateTime = prefs.getBool('showUpdateButNotCreateTime') ?? true;
    autoCopyToClipboard = prefs.getBool('autoCopyToClipboard') ?? true;
    useReorderableListView = prefs.getBool('useReorderableListView') ?? false;
    map = Map<String,int>.fromEntries((prefs.getStringList('goodsOrderMap') ?? <String>[]).map((e){
      final r = e.split('::');
      return MapEntry<String,int>(r[0], int.parse(r[1]));
    }));
    notifyListeners();
  }

  setGoodsShortByName(bool res) {
    prefs.setBool('goodsShortByName', res);
    goodsShortByName = res;
    notifyListeners();
  }

  setGoodsRecentFirst(bool res) {
    prefs.setBool('goodsRecentFirst', res);
    goodsRecentFirst = res;
    notifyListeners();
  }

  setNotShowClothes(bool res) {
    prefs.setBool('notShowClothes', res);
    notShowClothes = res;
    notifyListeners();
  }

  setNotShowRemoved(bool res) {
    prefs.setBool('notShowRemoved', res);
    notShowRemoved = res;
    notifyListeners();
  }

  setNotShowArchive(bool res) {
    prefs.setBool('notShowArchive', res);
    notShowArchive = res;
    notifyListeners();
  }

  setShowUpdateButNotCreateTime(bool set) {
    prefs.setBool('showUpdateButNotCreateTime', set);
    showUpdateButNotCreateTime = set;
    notifyListeners();
  }

  setAutoCopyToClipboard(bool set) {
    prefs.setBool('autoCopyToClipboard', set);
    autoCopyToClipboard = set;
    notifyListeners();
  }

  setShortUrlShowLimit(int limit) {
    prefs.setInt('_shortURLShowLimit', limit);
    _shortURLShowLimit = limit;
    notifyListeners();
  }

  setFilterDuplicate(bool set) {
    prefs.setBool('_filterDuplicate', set);
    _filterDuplicate = set;
    notifyListeners();
  }

  setUseReorderableListView(bool set) {
    prefs.setBool('useReorderableListView', set);
    prefs.setStringList('goodsOrderMap', map.entries.map((e) => e.key + '::' + e.value.toString()).toList());
    //prefs.setStringList('goodsOrderMap', []);
    useReorderableListView = set;
    notifyListeners();
  }

  justNotify() {
    notifyListeners();
  }
}