import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:learn_flutter/utils/padding.dart';
import 'package:learn_flutter/widgets/class3.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String tools = '';
  final btnDATA = [
    [Icons.directions_bike, 'Bike'],
    [Icons.car_rental, 'Car'],
    [Icons.directions_boat, 'Boat'],
    [Icons.airplanemode_active, 'AirPlane']
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.menu), onPressed: () {}),
        title: Text('Home - $tools'),
        actions: [
          IconButton(icon: Icon(Icons.search), onPressed: () {}),
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
        bottom: PreferredSize(
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
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: const Class3Widget(),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.play_arrow),
        backgroundColor: Colors.lightBlueAccent,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (context) {
                    return Scaffold(
                      backgroundColor: Colors.blue.shade100,
                      appBar: AppBar(
                        toolbarHeight: 45,
                        title: Text('About'),
                      ),
                      body: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Text('Developed by Corkine Ma', style: TextStyle(fontSize: 20)),
                            ),
                            pt10,
                            ElevatedButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('Return Last Route Page', style: TextStyle(fontSize: 15))
                            )
                          ],
                        ),
                      ),
                    );
                  }));
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).primaryColor.withOpacity(0.8),
        child: SizedBox(
          height: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(
                Icons.pause,
                color: Colors.white,
              ),
              Icon(
                Icons.stop,
                color: Colors.white,
              ),
              Icon(
                Icons.access_time,
                color: Colors.white,
              ),
              Padding(padding: EdgeInsets.only(right: 30))
            ],
          ),
        ),
      ),
    );
  }
}
