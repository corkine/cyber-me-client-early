import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:learn_flutter/cmgo/data.dart';
import 'package:learn_flutter/cmgo/config.dart';
import 'package:learn_flutter/cmgo/quicklink.dart';

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
  String _title(Config config) {
    switch (_index) {
      case 0:
        return '短链接(最近 ${config.shortURLShowLimit} 天${config.filterDuplicate ? ' 去重' : ''})';
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
        return QuickLinkPage();
      default:
        return QuickLinkPage();
    }
  }

  List<Widget> _buildActions(Config config, int index) {
    return [
      PopupMenuButton(
          icon: Icon(Icons.more_horiz),
          onSelected: (e) {
            if (e is int) config.setShortUrlShowLimit(e);
            if (e is bool) config.setFilterDuplicate(!config.filterDuplicate);
          },
          itemBuilder: (c) {
            return [
              [0, '最近 5 天', 5],
              [0, '最近 10 天', 10],
              [0, '最近 20 天', 20],
              [0, '最近 30 天', 30],
              [1, '去除重复项', config.filterDuplicate]
            ].map((List e) {
              if (e[0] == 0) {
                return PopupMenuItem(child: Text(e[1]), value: e[2]);
              } else {
                return PopupMenuItem(
                    child: Text(e[2] ? '取消' + e[1] : e[1]), value: e[2]);
              }
            }).toList();
          })
    ];
  }

  Widget _callActionButton(int index) {
    showSearch(context: context, delegate: ItemSearchDelegate());
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
                toolbarHeight: config.toolBarHeight,
                actions: _buildActions(config, _index)),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                /*Navigator.push(context, MaterialPageRoute(
                    builder: (c) => _callActionButton(_index)));*/
                _callActionButton(_index);
              },
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
