import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:learn_flutter/utils/padding.dart';
import 'package:learn_flutter/widgets/class1.dart';
import 'package:learn_flutter/widgets/class2.dart';
import 'package:learn_flutter/widgets/class3.dart';
import 'package:learn_flutter/widgets/class4.dart';
import 'package:learn_flutter/widgets/class5.dart';

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
    const Class3Widget(),
    const Class5Widget(),
    const Class6Widget(),
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

  _showQuickBar() {
    return Text(
      'Hello World Bottom PreferredSized Widget',
      style: TextStyle(color: Colors.white),
    );
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
                      child: Center(child: _showQuickBar()),
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
              : (index < 3
                  ? SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: bodys[index],
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.all(10),
                      child: bodys[index],
                    )),
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
            _split,
            TextButton(
                onPressed: () {
                  setState(() {
                    index = 3;
                  });
                },
                child: Text('List', style: TextStyle(color: Colors.white))),
            _split,
            TextButton(
                onPressed: () {
                  setState(() {
                    index = 4;
                  });
                },
                child: Text('Gesture', style: TextStyle(color: Colors.white)))
          ],
        ));
  }

  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      fixedColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      unselectedLabelStyle: TextStyle(color: Colors.grey),
      showUnselectedLabels: true,
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
            icon: Icon(Icons.repeat_rounded), label: 'Animation'),
        BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'List'),
        BottomNavigationBarItem(icon: Icon(Icons.gesture), label: 'Gesture'),
      ],
    );
  }
}

class Class6Widget extends StatefulWidget {
  const Class6Widget({Key key}) : super(key: key);
  @override
  _Class6WidgetState createState() => _Class6WidgetState();
}

class _Class6WidgetState extends State<Class6Widget> {
  String _info = '';
  Color _paintedColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        GestureDetector(
          onTap: () {
            print('Taped');
            setState(() => _info = 'Tapped');
          },
          onDoubleTap: () {
            print('Double Taped');
            setState(() => _info = 'Double Taped');
          },
          onLongPress: () {
            print('Long Pressed');
            setState(() => _info = 'Long Pressed');
          },
          onPanUpdate: (details) {
            print('PanUpdated');
            setState(() => _info = 'Pan Updated $details');
          },
          child: Container(
            alignment: Alignment.center,
            child: Icon(
              Icons.alarm,
              size: 100,
              color: Colors.blueGrey,
            ),
          ),
        ),
        Text('$_info'),
        Divider(),
        Draggable(
            onDragStarted: () => setState(() => _paintedColor = Colors.black),
            child: Column(
              children: [
                Icon(
                  Icons.palette,
                  color: Colors.deepOrange,
                  size: 48,
                ),
                Text('Drag Me below to change color')
              ],
            ),
            childWhenDragging: Icon(
              Icons.palette,
              color: Colors.grey,
              size: 48,
            ),
            feedback: FractionalTranslation(
              translation: Offset(0.9, -0.4),
              child: Icon(
                Icons.brush,
                color: Colors.deepOrange,
                size: 80,
              ),
            ),
            data: Colors.deepOrange.value),
        Divider(),
        DragTarget<int>(
          onAccept: (data) => _paintedColor = Color(data),
          builder: (c, acceptedData, rejectedData) => acceptedData.isEmpty
              ? Text(
                  'Drag To and See color change',
                  style: TextStyle(color: _paintedColor),
                )
              : Text(
                  'Painting Color $acceptedData',
                  style: TextStyle(
                      color: Color(acceptedData[0]),
                      fontWeight: FontWeight.bold),
                ),
        ),
        Divider(),
        pt10,
        ElevatedButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (c) => ScaleRouteDemo()));
            },
            child: Text('Show Scale and Rotate Demo'))
      ],
    );
  }
}

class ScaleRouteDemo extends StatefulWidget {
  const ScaleRouteDemo({Key key}) : super(key: key);
  @override
  _ScaleRouteDemoState createState() => _ScaleRouteDemoState();
}

class _ScaleRouteDemoState extends State<ScaleRouteDemo> {
  double _currentScale = 2.0;
  Offset _currentOffset = Offset(0, 0);
  Offset _startLastOffset;
  Offset _lastOffset;
  double _lastScale;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Demo'),
      ),
      body: GestureDetector(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Transform(
              transform: Matrix4.identity()
                ..scale(_currentScale, _currentScale)
                ..translate(_currentOffset.dx, _currentOffset.dy),
              alignment: FractionalOffset.center,
              child: Image.asset('asserts/images/girl.jpg'),
            ),
            Positioned(
              top: 0.0,
              width: MediaQuery.of(context).size.width,
              child: Container(
                color: Colors.white54,
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('Scale: ${_currentScale.toStringAsFixed(4)}'),
                    Text('Current: $_currentOffset')
                  ],
                ),
              ),
            )
          ],
        ),
        onScaleStart: (details) {
          _startLastOffset = details.focalPoint;
          _lastOffset = _currentOffset;
          _lastScale = _currentScale;
        },
        onScaleUpdate: (details) {
          if (details.scale != 1.0) { //当进行了缩放，设置当前的缩放级别
            double currentScale = _lastScale * details.scale;
            if (currentScale < 0.5) currentScale = 0.5; //如果过小则使用安全值
            setState(() => _currentScale = currentScale); //更新缩放值并刷新页面
          } else if (details.scale == 1.0) { //如果没有进行缩放，那么就进行了平移
            //计算相对于刚开始移动时的每缩放偏移，然后计算出当前位置在当前缩放下偏移应该移动的数目，将其更新
            Offset offsetAdjustedForScale = (_startLastOffset - _lastOffset) / _lastScale;
            Offset currentOffset = details.focalPoint - (offsetAdjustedForScale * _currentScale);
            setState(() => _currentOffset = currentOffset);
          }
        },
        onDoubleTap: () {
          setState(() => _currentScale >= 4
              ? _currentScale = 1.0
              : _currentScale = _currentScale * 2);
        },
        onLongPress: () {
          setState(() {
            _startLastOffset = Offset.zero;
            _lastOffset = Offset.zero;
            _currentOffset = Offset.zero;
            _currentScale = 1.0;
            _lastScale = 1.0;
          });
        },
      ),
    );
  }
}
