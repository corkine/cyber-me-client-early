import 'package:flutter/cupertino.dart';
import 'package:learn_flutter/models/link.dart';
import 'package:url_launcher/url_launcher.dart';

class MyIOSApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
        debugShowCheckedModeBanner: false,
        title: 'Quick Link',
        home: CupertinoTabScaffold(
            tabBar: CupertinoTabBar(items: [
              BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.home, size: 25), label: '主页'),
              BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.asterisk_circle_fill, size: 25),
                  label: '最近访问'),
              BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.number, size: 25), label: '管理')
            ]),
            tabBuilder: (BuildContext context, int index) {
              switch (index) {
                case 0:
                  return CupertinoTabView(
                    builder: (c) => HomeListTab(),
                  );
                case 1:
                  return CupertinoTabView(
                    builder: (c) => RecentTab(),
                  );
                case 2:
                  return CupertinoTabView(
                    builder: (c) => ManageTab(),
                  );
                default:
                  return CupertinoTabView(
                    builder: (c) => Container(),
                  );
              }
            }));
  }
}

class HomeListTab extends StatefulWidget {
  const HomeListTab({Key key}):super(key:key);
  @override
  _HomeListTabState createState() => _HomeListTabState();
}

class _HomeListTabState extends State<HomeListTab> {
  List<Link> _data = [];
  @override
  void initState() {
    super.initState();
    LinkRepository.fetch().then((value) => setState(() => _data = value));
  }
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers: <Widget>[
      CupertinoSliverNavigationBar(
        largeTitle: Text('Let\'s GO'),
      ),
      SliverSafeArea(
          sliver: SliverList(
              delegate: SliverChildBuilderDelegate((c, i) =>
                  GestureDetector(
                    onTap: () { launch(_data[i].redirectURL);},
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(_data[i].keyword),
                                Text(_data[i].redirectURL, style: TextStyle(
                                    fontSize: 13, color: CupertinoColors.systemGrey3
                                ),maxLines: 10,
                                  overflow: TextOverflow.ellipsis,)
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),childCount: _data.length)))
    ]);
  }
}

class ManageTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: const <Widget>[
        CupertinoSliverNavigationBar(
          largeTitle: Text('管理'),
        )
      ],
    );
  }
}

class RecentTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: const <Widget>[
        CupertinoSliverNavigationBar(
          largeTitle: Text('最近访问'),
        )
      ],
    );
  }
}