import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:learn_flutter/cmpocket/connect.dart';
import 'package:learn_flutter/cmpocket/goods.dart';
import 'package:provider/provider.dart';
import 'package:learn_flutter/cmpocket/config.dart';
import 'package:learn_flutter/cmpocket/quicklink.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class CMPocket {
  static void run() {
    runApp(ChangeNotifierProvider(
      create: (c) {
        return Config();
      },
      child: MaterialApp(
        title: 'CMPocket',
        debugShowCheckedModeBanner: true,
        home: PocketHome(),
      ),
    ));
  }
}

class PocketHome extends StatefulWidget {
  @override
  _PocketHomeState createState() => _PocketHomeState();
}

class _PocketHomeState extends State<PocketHome> {
  int _index = Config.pageIndex;
  Widget _title(Config config) {
    switch (_index) {
      case 0:
        return RichText(
            text: TextSpan(text: '短链接', style: Config.headerStyle, children: [
          TextSpan(
              text:
                  ' (最近 ${config.shortURLShowLimit} 天${config.filterDuplicate ? ' 去重' : ''})',
              style: Config.smallHeaderStyle)
        ]));
      case 1:
        return config.useReorderableListView
            ? Text('拖动条目以排序', style: Config.headerStyle)
            : RichText(
                text: TextSpan(
                    text: '物品管理',
                    style: Config.headerStyle,
                    children: [
                    TextSpan(
                        text: ' ('
                            '${config.notShowRemoved ? '不' : ''}显示删除, '
                            '${config.notShowArchive ? '不' : ''}显示收纳)',
                        style: Config.smallHeaderStyle)
                  ]));
      case 2:
        return Text('健康管理');
      default:
        return Text('CMGO');
    }
  }

  _widgets(int index) {
    switch (index) {
      case 0:
        return QuickLinkPage();
      case 1:
        return GoodsHome();
      default:
        return Connect();
    }
  }

  List<Widget> _buildActions(Config config, int index) {
    if (index == 0) {
      return [
        PopupMenuButton(
            icon: Icon(Icons.more_vert_rounded),
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
    } else {
      return config.useReorderableListView
          ? [
              ElevatedButton(
                onPressed: () {
                  final position = config.controller.offset;
                  config.position =  position;
                  config.setUseReorderableListView(false);
                },
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 3),
                      child: Icon(Icons.done),
                    ),
                    Text('确定')
                  ],
                ),
              )
            ]
          : [
              PopupMenuButton<int>(
                  icon: Icon(Icons.more_vert_rounded),
                  onSelected: (e) {
                    switch (e) {
                      case 0:
                        return config
                            .setGoodsShortByName(!config.goodsShortByName);
                      case 1:
                        return config
                            .setGoodsRecentFirst(!config.goodsRecentFirst);
                      case 2:
                        return config.setNotShowClothes(!config.notShowClothes);
                      case 3:
                        return config.setNotShowRemoved(!config.notShowRemoved);
                      case 4:
                        return config.setNotShowArchive(!config.notShowArchive);
                      case 5:
                        return config.setShowUpdateButNotCreateTime(
                            !config.showUpdateButNotCreateTime);
                      case 6:
                        return config.setAutoCopyToClipboard(
                            !config.autoCopyToClipboard);
                      case 7:
                        final position = config.controller.offset;
                        config.position =  position;
                        return config.setUseReorderableListView(
                            !config.useReorderableListView);
                      default:
                        return;
                    }
                  },
                  itemBuilder: (c) {
                    return [
                      /*[0, '按照名称排序', config.goodsShortByName],
                [1, '按照最近排序', config.goodsRecentFirst],*/
                      [2, '显示衣物', !config.notShowClothes],
                      [3, '显示已删除', !config.notShowRemoved],
                      [4, '显示收纳', !config.notShowArchive],
                      [5, '显示更新而非创建日期', config.showUpdateButNotCreateTime],
                      [6, '将链接拷贝到剪贴板', config.autoCopyToClipboard],
                      [7, '排序模式（仅限同状态和重要度项目排序）', config.useReorderableListView]
                    ].map((List e) {
                      return PopupMenuItem(
                          child: Text(e[2] ? '✅ ' + e[1] : '❎ ' + e[1]),
                          value: e[0] as int);
                    }).toList();
                  })
            ];
    }
  }

  _callActionButton(Config config, int index) {
    switch (index) {
      case 0:
        showSearch(context: context, delegate: ItemSearchDelegate(config));
        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext c) {
          return const GoodAdd(null);
        }));
        break;
      default:
        return null;
    }
  }

  Widget _buildActionButtonWidget(int index) {
    switch (index) {
      case 0:
        return Icon(Icons.search);
      case 1:
        return Icon(Icons.add);
      default:
        return Icon(Icons.search);
    }
  }

  _handleLogin(Config config) {
    if (config.user.isNotEmpty) {
      config.user = '';
      config.password = '';
      config.justNotify();
    } else
      showDialog<List<String>>(
          context: context,
          builder: (BuildContext c) {
            final userController = TextEditingController();
            final passwordController = TextEditingController();
            return SimpleDialog(
              title: Text('输入用户名和登录凭证'),
              contentPadding: EdgeInsets.all(19),
              children: [
                TextField(
                    controller: userController,
                    decoration: InputDecoration(labelText: '用户名')),
                TextField(
                    controller: passwordController,
                    decoration: InputDecoration(labelText: '密码'),
                    obscureText: true),
                ButtonBar(
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(null);
                        },
                        child: Text('取消')),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(
                              [userController.text, passwordController.text]);
                        },
                        child: Text('确定')),
                  ],
                )
              ],
            );
          }).then((List<String> value) {
        if (value != null) {
          config.user = value[0];
          config.password = value[1];
          config.justNotify();
          _savingData(config.user, config.password);
        }
      });
  }

  _savingData(String user, String pass) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user', user);
    prefs.setString('password', pass);
  }

  final QuickActions quickActions = QuickActions();

  _doAddLong() async {
    var query = await FlutterClipboard.paste();
    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext c) {
      return AddDialog(query,isShortWord: false);
    }));
  }

  _doAddShort() async {
    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext c) {
      return AddDialog('',isShortWord: true);
    }));
  }

  @override
  void initState() {
    super.initState();
    quickActions.initialize((shortcutType) {
      if (shortcutType == 'action_quicklink') {
        setState(() {
          _index = 0;
        });
      } else if (shortcutType == 'action_add_good') {
        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext c) {
          return const GoodAdd(null,fromActionCameraFirst: true);
        }));
      } else if (shortcutType == 'action_add_quicklink_long') {
        _doAddLong();
      } else if (shortcutType == 'action_add_quicklink_short') {
        _doAddShort();
      }
    });
    quickActions.setShortcutItems(<ShortcutItem>[
      const ShortcutItem(type: 'action_quicklink', localizedTitle: '最近短链接'),
      const ShortcutItem(type: 'action_add_quicklink_short', localizedTitle: '添加短链接'),
      const ShortcutItem(type: 'action_add_quicklink_long', localizedTitle: '从剪贴板添加短链接'),
      const ShortcutItem(type: 'action_add_good', localizedTitle: '新物品入库')
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Config>(
      builder: (BuildContext context, Config config, Widget w) {
        return Scaffold(
            drawer: Drawer(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      UserAccountsDrawerHeader(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.fitWidth,
                                alignment: Alignment.centerLeft,
                                image: AssetImage('asserts/images/girl.jpg'))),
                        accountName: Text('Corkine Ma'),
                        accountEmail: Text('corkine@outlook.com'),
                        currentAccountPicture: FractionalTranslation(
                            translation: Offset(-0.1, 0.1),
                            child: Icon(
                              Icons.face_unlock_sharp,
                              size: 70,
                              color: Colors.white,
                            )),
                      ),
                      ListTile(
                        leading: Icon(Icons.home),
                        title: Text('主页'),
                        onTap: () {
                          launch('https://mazhangjing.com');
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.all_inclusive_sharp),
                        title: Text('博客'),
                        onTap: () {},
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(
                          width: 200,
                          child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.green.shade300)),
                              onPressed: () => _handleLogin(config),
                              child:
                                  Text(config.user.isEmpty ? '验证秘钥' : '取消登录'))),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Text(
                          Config.VERSION,
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            appBar: AppBar(
                elevation: 7,
                title: _title(config),
                leading: Builder(
                  builder: (BuildContext context) => IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  ),
                ),
                centerTitle: true,
                toolbarHeight: Config.toolBarHeight,
                actions: _buildActions(config, _index)),
            floatingActionButton: FloatingActionButton(
              onPressed: () => _callActionButton(config, _index),
              child: _buildActionButtonWidget(_index),
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
