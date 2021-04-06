import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class CMGO {
  static void run() {
    runApp(ChangeNotifierProvider(
      create: (c) {
        return Config();
      },
      child: MaterialApp(
        title: 'CMGO',
        debugShowCheckedModeBanner: false,
        home: GoHome(),
      ),
    ));
  }
}

class GoHome extends StatefulWidget {
  @override
  _GoHomeState createState() => _GoHomeState();
}

class _GoHomeState extends State<GoHome> {
  int _index = 0;
  int _limit = 10;
  String _title(Config config) {
    switch (_index) {
      case 0:
        return '短链接(最近 ${config._shortURLShowLimit} 天${config._filterDuplicate ? ' 去重' : ''})';
      case 1:
        return '物品管理';
      case 2:
        return '健康管理';
      default:
        return 'CMGO';
    }
  }

  _widgets(int index) {
    switch (index) {
      case 0:
        return GoPage();
      default:
        return GoPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Config>(
      builder: (BuildContext context, Config config, Widget w) {
        return Scaffold(
            appBar: AppBar(
                elevation: 3,
                title: Text(_title(config)),
                leading: Icon(Icons.menu),
                centerTitle: true,
                toolbarHeight: 50.0,
                actions: [
                  PopupMenuButton(
                      icon: Icon(Icons.more_horiz),
                      onSelected: (e) {
                        if (e is int) config.setShortUrlShowLimit(e);
                        if (e is bool)
                          config.setFilterDuplicate(!config._filterDuplicate);
                      },
                      itemBuilder: (c) {
                        return [
                          [0, '最近 5 天', 5],
                          [0, '最近 10 天', 10],
                          [0, '最近 20 天', 20],
                          [0, '最近 30 天', 30],
                          [1, '去除重复项', config._filterDuplicate]
                        ].map((List e) {
                          if (e[0] == 0) {
                            return PopupMenuItem(
                                child: Text(e[1]), value: e[2]);
                          } else {
                            return PopupMenuItem(
                                child: Text(e[2] ? '取消' + e[1] : e[1]),
                                value: e[2]);
                          }
                        }).toList();
                      })
                ]),
            floatingActionButton: FloatingActionButton(
              onPressed: () {},
              child: Icon(Icons.search),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            body: _widgets(_index),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: _index,
              onTap: (i) => setState(() => _index = i),
              items: [
                BottomNavigationBarItem(
                    label: '短链接',
                    icon: Icon(Icons.bookmark_border_rounded),
                    activeIcon: Icon(Icons.bookmark)),
                BottomNavigationBarItem(
                    label: '物品管理',
                    icon: Icon(Icons.checkroom_outlined),
                    activeIcon: Icon(Icons.checkroom)),
                BottomNavigationBarItem(
                    label: '健康管理',
                    icon: Icon(Icons.favorite_outline),
                    activeIcon: Icon(Icons.favorite))
              ],
            ));
      },
    );
  }
}

class GoPage extends StatefulWidget {
  const GoPage();
  @override
  _GoPageState createState() => _GoPageState();
}

class _GoPageState extends State<GoPage> {
  Future<dynamic> _data;

  @override
  void initState() {
    super.initState();
  }

  Future<List<EntityLog>> fetchData(int limit) async {
    return http
        .get(Uri.parse(
            'https://go.mazhangjing.com/logs?user=corkine&password=mzj960032&day=$limit'))
        .then((value) {
      var data = jsonDecode(Utf8Codec().decode(value.bodyBytes));
      return (data as List).map((e) => EntityLog.fromJSON(e)).toList();
    });
  }

  _retry(int limit) => setState(() {
        _data = fetchData(limit);
      });

  @override
  Widget build(BuildContext context) {
    return Consumer<Config>(
      builder: (BuildContext context, Config config, Widget w) {
        _data = fetchData(config._shortURLShowLimit);
        return FutureBuilder(
            future: _data,
            builder: (b, s) {
              if (s.connectionState != ConnectionState.done)
                return Center(child: Text('正在检索数据'));
              if (s.hasError) //如果出错，state 重置，但是 data 不会重置
                return InkWell(
                    radius: 20,
                    onTap: _retry(config._shortURLShowLimit),
                    child: Center(child: Text('检索出错，点击重试')));
              if (s.hasData) {
                List<EntityLog> logs;
                if (config._filterDuplicate)
                  logs = HashMap<String, EntityLog>.fromIterable((s.data as List).reversed,
                      key: (e) => (e as EntityLog).keyword,
                      value: (e) => e).values.toList();
                else
                  logs = s.data;
                logs.sort((a,b) => -1 * a.actionTime.compareTo(b.actionTime));
                return ListView.builder(
                    itemCount: logs.length,
                    itemBuilder: (c, i) => ListTile(
                        onTap: () => launch(logs[i].url),
                        leading: Padding(
                          padding: const EdgeInsets.only(top: 5, right: 8),
                          child: Icon(Icons.vpn_lock),
                        ),
                        horizontalTitleGap: 0,
                        title: RichText(
                            text: TextSpan(
                                text: logs[i].keyword,
                                style: TextStyle(color: Colors.black),
                                children: [
                              TextSpan(
                                  text: '  ' +
                                      DateFormat('yy/M/d HH:mm')
                                          .format(logs[i].actionTime),
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12))
                            ])),
                        subtitle: Text(
                          logs[i].iPInfo,
                          style: TextStyle(
                              color: Colors.grey.shade700, fontSize: 13),
                        )));
              }
              return Center(
                child: Text('没有数据'),
              );
            });
      },
    );
  }
}

class EntityLog {
  String iPInfo;
  String keyword;
  String url;
  int entityId;
  String visitorIP;
  DateTime actionTime;
  EntityLog.fromJSON(Map<String, dynamic> map)
      : iPInfo = _fetchInfo(map),
        keyword = map['keyword'],
        url = map['url'],
        entityId = int.tryParse(map['entityLog']['entityId'].toString()),
        visitorIP = map['entityLog']['visitorIP'],
        actionTime = DateTime.parse(map['entityLog']['actionTime']);
  static String _fetchInfo(Map<String, dynamic> map) {
    var data = map['ipInfo']
        .toString()
        .replaceAll('|', ' ')
        .replaceFirst('0', '')
        .replaceFirst('中国', '')
        .trimLeft();
    var list = data.split(' ');
    if (list.length >= 2 && list[1].contains(list[0])) {
      list.removeAt(0);
      return list.join(' ');
    } else
      return data;
  }
}

class Config extends ChangeNotifier {
  int _shortURLShowLimit = 5;
  bool _filterDuplicate = false;
  setShortUrlShowLimit(int limit) {
    _shortURLShowLimit = limit;
    notifyListeners();
  }

  setFilterDuplicate(bool set) {
    _filterDuplicate = set;
    notifyListeners();
  }
}
