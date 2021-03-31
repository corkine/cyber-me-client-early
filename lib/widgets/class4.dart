import 'package:flutter/material.dart';

class Gratitude extends StatefulWidget {
  final String value;
  Gratitude({Key key, this.value}) : super(key: key);
  @override
  _GratitudeState createState() => _GratitudeState();
}

class _GratitudeState extends State<Gratitude> {
  List<String> _gratitudeList = [];
  String _selectGratitude;
  int _radioValue;
  @override
  initState() {
    super.initState();
    _gratitudeList..add('Family')..add('School')..add('Friends');
    _radioValue = _gratitudeList.indexOf(widget.value);
  }

  _radioOnChanged(int i) {
    setState(() {
      _radioValue = i;
      _selectGratitude = _gratitudeList[i];
      print('Select $_radioValue - $_selectGratitude');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('选择你认为重要的'),
        actions: [
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(_selectGratitude);
              },
              child: Icon(Icons.done))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: [
              Flexible(
                child: RadioListTile(
                    title: Text('Family'),
                    value: 0,
                    groupValue: _radioValue,
                    onChanged: (index) => _radioOnChanged(index)),
              ),
              Flexible(
                child: RadioListTile(
                    title: Text('School'),
                    value: 1,
                    groupValue: _radioValue,
                    onChanged: (index) => _radioOnChanged(index)),
              ),
              Flexible(
                child: RadioListTile(
                    title: Text('Friends'),
                    value: 2,
                    groupValue: _radioValue,
                    onChanged: (index) => _radioOnChanged(index)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class Class4LeftDrawer extends StatelessWidget {
  const Class4LeftDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(children: [
        UserAccountsDrawerHeader(
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.centerLeft,
                  image: AssetImage('asserts/images/girl.jpg'))),
          accountEmail: Text('corkine@outlook.com'),
          accountName: Text('Corkine Ma'),
          currentAccountPicture: Icon(Icons.face),
          otherAccountsPictures: [Icon(Icons.bookmark)],
        ),
        ListTile(
          leading: Icon(Icons.adb_sharp),
          title: Text('Hello'),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(Icons.adb_sharp),
          title: Text('Hello2'),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(Icons.adb_sharp),
          title: Text('Hello3'),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(Icons.adb_sharp),
          title: Text('Hello4'),
          onTap: () {},
        ),
        Builder(
          builder: (content) => ListTile(
            leading: Icon(Icons.adb_sharp),
            title: Text('Show End Drawer'),
            onTap: () {
              Scaffold.of(content).openEndDrawer();
            },
          ),
        ),
      ]),
    );
  }
}

class Class4Drawer extends StatelessWidget {
  const Class4Drawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(children: [
        DrawerHeader(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10,bottom: 2),
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.white38,
                  child: Text('C',style: TextStyle(fontSize: 27),),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Corkine',
                      style: TextStyle(color: Colors.white, fontSize: 30)),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 4,top: 2.4),
                        child: Icon(Icons.email_outlined, color: Colors.white, size: 13,),
                      ),
                      Text(
                        'corkine@outlook.com',
                        style: TextStyle(color: Colors.white, fontSize: 13),
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
          decoration: BoxDecoration(color: Colors.blue),
        ),
        ListTile(
          leading: Icon(Icons.adb_sharp),
          title: Text('Hello'),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(Icons.adb_sharp),
          title: Text('Hello2'),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(Icons.adb_sharp),
          title: Text('Hello3'),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(Icons.adb_sharp),
          title: Text('Hello4'),
          onTap: () {},
        ),
        Builder(
          builder: (content) => ListTile(
            leading: Icon(Icons.adb_sharp),
            title: Text('Show Drawer'),
            onTap: () {
              Scaffold.of(content).openDrawer();
            },
          ),
        ),
      ]),
    );
  }
}