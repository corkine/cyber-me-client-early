import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:learn_flutter/utils/padding.dart';
import 'package:learn_flutter/widgets/class1.dart';
import 'package:learn_flutter/widgets/class2.dart';
import 'package:learn_flutter/widgets/class3.dart';
import 'package:learn_flutter/widgets/class4.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  String tools = '';
  int index = 0;
  TabController _tabController;
  static const bodys = [
    const Class1Widget(),
    const Class2Widget(),
    const Class3Widget()
  ];
  final btnDATA = [
    [Icons.directions_bike, 'Bike'],
    [Icons.car_rental, 'Car'],
    [Icons.directions_boat, 'Boat'],
    [Icons.airplanemode_active, 'AirPlane']
  ];
  _showAboutDialog() => Navigator.push(
      context,
      MaterialPageRoute(
          fullscreenDialog: true,
          builder: (context) {
            return AboutWidget();
          }));
  _openPageGratitude() async {
    final _response = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (c) => Gratitude(
                  value: tools,
                )));
    setState(() {
      tools = _response ?? '';
    });
  }

  final _split = Container(
    width: 1,
    height: 20,
    color: Colors.lightGreen.withOpacity(0.1),
  );
  final _subject = ["语文", "数学", "英语", "政治", "历史", "地理", "化学"];
  var useTabView = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _subject.length, vsync: this);
    _tabController
        .addListener(() => print('Change Tab to ${_tabController.index}'));
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const Class4LeftDrawer(),
        endDrawer: const Class4Drawer(),
        appBar: AppBar(
            leading: Builder(
              builder: (c) => Tooltip(
                message: 'width > 400 show endDrawer, < 400 show Drawer',
                child: IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () {
                      MediaQuery.of(context).size.width > 400
                          ? Scaffold.of(c).openEndDrawer()
                          : Scaffold.of(c).openDrawer();
                    }),
              ),
            ),
            title: Text('Home - $tools'),
            actions: [
              Tooltip(
                message: 'Check to show Tab and TabView',
                child: Checkbox(
                    fillColor: MaterialStateProperty.all(Colors.white54),
                    value: useTabView,
                    onChanged: (v) => {setState(() => useTabView = v)}),
              ),
              IconButton(
                  icon: Icon(Icons.auto_awesome),
                  onPressed: _openPageGratitude),
              (MediaQuery.of(context).orientation == Orientation.portrait
                  ? PopupMenuButton(
                      padding: EdgeInsets.all(2),
                      itemBuilder: (c) => btnDATA
                          .map((e) => PopupMenuItem<String>(
                              value: e[1],
                              child: Row(children: [
                                Icon(e[0], color: Colors.lightBlue),
                                Padding(padding: EdgeInsets.only(left: 15)),
                                Text(e[1])
                              ])))
                          .toList(),
                      onSelected: (v) => setState(() => tools = v),
                      icon: Icon(Icons.more_vert),
                    )
                  : Row(
                      children: btnDATA
                          .map((e) => IconButton(
                              icon: Icon(e[0]),
                              onPressed: () => setState(() => tools = e[1])))
                          .toList()))
            ],
            flexibleSpace: SafeArea(
              child: Icon(
                Icons.camera,
                size: 75,
                color: Colors.white24,
              ),
            ),
            bottom: useTabView
                ? PreferredSize(
                    child: buildTabBar(),
                    preferredSize: Size.fromHeight(15),
                  )
                : PreferredSize(
                    child: Container(
                      color: Colors.blue.shade700,
                      //width: MediaQuery.of(context).size.width,
                      width: double.infinity,
                      height: 30,
                      child: Center(
                        child: Text(
                          'Hello World Bottom PreferredSized Widget',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    preferredSize: Size.fromHeight(15),
                  )),
        body: SafeArea(
          child: useTabView
              ? TabBarView(
                  children: _subject
                      .map((e) => Center(
                            child: Text(e),
                          ))
                      .toList(),
                  controller: _tabController,
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: bodys[index],
                  ),
                ),
        ),
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        floatingActionButtonLocation: MediaQuery.of(context).size.width > 400
            ? FloatingActionButtonLocation.endDocked
            : FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.play_arrow),
          backgroundColor: Colors.lightBlueAccent,
          onPressed: _showAboutDialog,
        ),
        bottomNavigationBar: MediaQuery.of(context).size.width > 400
            ? buildBottomAppBar()
            : buildBottomNavigationBar());
  }

  Widget buildTabBar() {
    return Container(
      height: 30,
      child: TabBar(
        //physics: BouncingScrollPhysics(),
        tabs: _subject.map((e) => Tab(text: e)).toList(),
        isScrollable: true,
        controller: _tabController,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white60,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorWeight: 1,
        labelStyle: TextStyle(height: 1),
      ),
    );
  }

  BottomAppBar buildBottomAppBar() {
    return BottomAppBar(
        color: Colors.lightBlueAccent,
        shape: CircularNotchedRectangle(),
        child: ButtonBar(
          alignment: MainAxisAlignment.start,
          overflowDirection: VerticalDirection.down,
          children: [
            TextButton(
                onPressed: () => setState(() => index = 0),
                child: Text('Basic', style: TextStyle(color: Colors.white))),
            _split,
            TextButton(
                onPressed: () => setState(() => index = 1),
                child: Text(
                  'Widget',
                  style: TextStyle(color: Colors.white),
                )),
            _split,
            TextButton(
                onPressed: () => setState(() => index = 2),
                child:
                    Text('Animation', style: TextStyle(color: Colors.white))),
            _split,
            TextButton(
                onPressed: () => setState(() => index = 2),
                child:
                    Text('Navigator', style: TextStyle(color: Colors.white))),
          ],
        ));
  }

  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
      onTap: (int ind) {
        setState(() => index = ind);
      },
      currentIndex: index,
      elevation: 10,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Basic'),
        BottomNavigationBarItem(
            icon: Icon(Icons.apartment_rounded), label: 'Widget'),
        BottomNavigationBarItem(
            icon: Icon(Icons.repeat_rounded), label: 'Animation')
      ],
    );
  }
}
