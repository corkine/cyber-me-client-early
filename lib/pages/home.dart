import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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
            child: const Class2Widget(),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.play_arrow),
        backgroundColor: Colors.lightBlueAccent,
        onPressed: () {},
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

class Class2Widget extends StatelessWidget {
  const Class2Widget({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final boxDecoration = BoxDecoration(
        color: Colors.yellow.shade200,
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(5), topRight: Radius.circular(20)),
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.orangeAccent.shade200, Colors.redAccent.shade200],
            stops: [0.0, 1]),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.shade400, blurRadius: 4, offset: Offset(0, 3))
        ]);
    final textStyle = TextStyle(
        fontSize: 28,
        color: Colors.white70,
        decoration: TextDecoration.underline,
        decorationStyle: TextDecorationStyle.dotted,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.normal);
    final simpleText = Text(
      'Hello World',
      style: textStyle,
      maxLines: 4,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.justify,
    );
    final richText = RichText(
      text: TextSpan(text: 'Hello World', style: textStyle, children: [
        TextSpan(text: ' to'),
        TextSpan(
            text: ' Corkine',
            style: TextStyle(
                color: Colors.deepOrange.shade900,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.bold))
      ]),
    );
    Container buildContainer(Widget widget) {
      return Container(
        height: 100,
        width: double.infinity,
        decoration: boxDecoration,
        child: Center(
          child: widget,
        ),
      );
    }

    const pt10 = Padding(padding: EdgeInsets.only(top: 10));
    const pl10 = Padding(padding: EdgeInsets.only(left: 10));
    return Column(
      children: [
        buildContainer(simpleText),
        pt10,
        buildContainer(richText),
        pt10,
        const Class2ColumnWidget(),
        pt10,
        pt10,
        const Class2RowWidget(pt10: pt10),
        pt10,
        pt10,
        const Class2ColumnRowWidget(pt10: pt10, pl10: pl10),
        pt10,
        pt10,
        const Class2TextButtonWidget(),
        pt10,
        pt10,
        const Class2ElevatedButtonWidget(pl10: pl10),
        pt10,
        pt10,
        const Class2IconButtonWidget(),
        pt10,
        pt10,
        const Class2ButtonBarWidget(),
        pt10,
        pt10,
        const Class2ImageIconWidget(),
        pt10,
        pt10,
        const Class2InputDecorationWidget(),
        const Class2FormWidget()
      ],
    );
  }
}

class Class2FormWidget extends StatefulWidget {
  const Class2FormWidget({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => Class2FormWidgetState();
}

class User {
  String name;
  int age;
}

class Class2FormWidgetState extends State<Class2FormWidget> {
  final formKey = GlobalKey<FormState>();
  var user = User();
  @override
  Widget build(BuildContext context) {
    return Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                  labelText: "Name",
                  hintText: 'Corkine',
                  hintStyle: TextStyle(color: Colors.grey.shade300)),
              validator: (v) => (v.isNotEmpty) ? null : 'Need Name',
              onSaved: (e) => user.name = e,
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Age",
                hintText: '23',
                hintStyle: TextStyle(color: Colors.grey.shade300),
              ),
              validator: (v) =>
                  int.tryParse(v) == null ? 'Need A Number' : null,
              onSaved: (e) => user.age = int.parse(e),
            ),
            ButtonBar(
              children: [
                TextButton(
                    onPressed: () {
                      if (formKey.currentState.validate()) {
                        formKey.currentState.save();
                        print('User ${user.name} ${user.age}');
                      }
                    },
                    child: Text('Submit'))
              ],
            )
          ],
        ));
  }
}

class Class2ImageIconWidget extends StatelessWidget {
  const Class2ImageIconWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.network('http://mazhangjing.com/static/cm-red.png',
            width: 100, alignment: Alignment.center),
        Image.asset(
          'asserts/images/girl.jpg',
          width: MediaQuery.of(context).size.width / 1.2,
        ),
        Icon(
          Icons.map,
          color: Colors.red,
          size: 80,
          semanticLabel: 'Map',
          textDirection: TextDirection.ltr,
        ),
      ],
    );
  }
}

class Class2InputDecorationWidget extends StatelessWidget {
  const Class2InputDecorationWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          keyboardType: TextInputType.number,
          style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
          decoration: InputDecoration(
              labelText: "Name",
              labelStyle: TextStyle(color: Colors.purple),
              border: OutlineInputBorder()),
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'Enter Notes: '),
        ),
      ],
    );
  }
}

class Class2ButtonBarWidget extends StatelessWidget {
  const Class2ButtonBarWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ButtonBar(
          children: [
            TextButton(onPressed: () {}, child: Text('OK')),
            TextButton(onPressed: () {}, child: Text('Cancel')),
          ],
        ),
        ButtonBar(
          alignment: MainAxisAlignment.spaceAround,
          buttonTextTheme: ButtonTextTheme.primary,
          buttonHeight: 20,
          buttonPadding: EdgeInsets.all(10),
          buttonMinWidth: 10,
          overflowDirection: VerticalDirection.down,
          children: [
            IconButton(icon: Icon(Icons.next_plan), onPressed: () {}),
            IconButton(icon: Icon(Icons.directions), onPressed: () {}),
            IconButton(icon: Icon(Icons.delete_forever), onPressed: () {}),
          ],
        ),
      ],
    );
  }
}

class Class2IconButtonWidget extends StatelessWidget {
  const Class2IconButtonWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.play_arrow),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.school),
          iconSize: 40,
          padding: EdgeInsets.all(10),
          visualDensity: VisualDensity.comfortable,
          onPressed: () {},
          color: Colors.pink,
          splashColor: Colors.green,
          hoverColor: Colors.lightBlue,
          focusColor: Colors.green,
          highlightColor: Colors.lightBlueAccent,
          mouseCursor: SystemMouseCursors.allScroll,
        ),
      ],
    );
  }
}

class Class2ElevatedButtonWidget extends StatelessWidget {
  const Class2ElevatedButtonWidget({
    Key key,
    @required this.pl10,
  }) : super(key: key);

  final Padding pl10;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ElevatedButton(onPressed: () {}, child: Text('Hello World')),
        pl10,
        ElevatedButton.icon(
            onPressed: () {},
            icon: Icon(
              Icons.ac_unit,
              size: 16,
            ),
            label: Text('Hello')),
        pl10,
        ElevatedButton(
          onPressed: () {},
          child: Icon(
            Icons.play_arrow,
            size: 16,
          ),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.redAccent)),
        )
      ],
    );
  }
}

class Class2TextButtonWidget extends StatelessWidget {
  const Class2TextButtonWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextButton(
            onPressed: () {},
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.green),
              foregroundColor: MaterialStateProperty.all(Colors.white),
              overlayColor: MaterialStateProperty.all(Colors.green.shade700),
              padding: MaterialStateProperty.all(EdgeInsets.all(15)),
            ),
            child: Text('Press Me!')),
        TextButton(
            onPressed: () {},
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Press Me!'),
            )),
        TextButton(onPressed: () {}, child: Icon(Icons.flag)),
        TextButton(
            onPressed: () {},
            child: Container(
              padding: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: Row(
                children: [
                  Icon(
                    Icons.flag,
                    color: Colors.white,
                  ),
                  Text(
                    'Hello World',
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            )),
      ],
    );
  }
}

class Class2ColumnRowWidget extends StatelessWidget {
  const Class2ColumnRowWidget({
    Key key,
    @required this.pt10,
    @required this.pl10,
  }) : super(key: key);

  final Padding pt10;
  final Padding pl10;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Column Single Text1'),
        pt10,
        Text('Column Single Text2'),
        pt10,
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('Nest Row 1'),
            pl10,
            Text('Nest Row 2'),
            pl10,
            Text('Nest Row 3'),
          ],
        ),
        pt10,
        Text('Column Single Text3'),
        pt10,
        Text('Column Single Text4'),
        pt10
      ],
    );
  }
}

class Class2RowWidget extends StatelessWidget {
  const Class2RowWidget({
    Key key,
    @required this.pt10,
  }) : super(key: key);

  final Padding pt10;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: [Text('Row1'), pt10, Text('Row2'), pt10, Text('Row3')],
    );
  }
}

class Class2ColumnWidget extends StatelessWidget {
  const Class2ColumnWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text('Column1'),
        Divider(),
        Text('Column2'),
        Divider(),
        Text('Column3')
      ],
    );
  }
}

class Class1Widget extends StatelessWidget {
  const Class1Widget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final container = Container(
      color: Colors.blue.shade100,
      width: 50,
      height: 50,
    );
    final padding16 = Padding(padding: EdgeInsets.all(16));
    return Column(
      children: [
        Row(
          children: [
            container,
            padding16,
            Expanded(
              child: container,
            ),
            padding16,
            container,
          ],
        ),
        padding16,
        const Class1RowWidget()
      ],
    );
  }
}

class Class1RowWidget extends StatelessWidget {
  const Class1RowWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              color: Colors.yellow,
              height: 60.0,
              width: 60.0,
            ),
            Padding(padding: EdgeInsets.all(6.0)),
            Container(
              color: Colors.amber,
              height: 60.0,
              width: 60.0,
            ),
            Padding(padding: EdgeInsets.all(6.0)),
            Container(
              color: Colors.brown,
              height: 60.0,
              width: 60.0,
            ),
            Divider(),
            Row(children: [const Class1AvatarWidget()]),
            Divider(),
            Text('End of the Line'),
            Image(
              image: AssetImage('asserts/images/girl.jpg'),
              width: MediaQuery.of(context).size.width - 50,
            )
          ],
        )
      ],
    );
  }
}

class Class1AvatarWidget extends StatelessWidget {
  const Class1AvatarWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.lightGreen,
      radius: 100.0,
      child: Stack(
        children: [
          Container(
            height: 100,
            width: 100,
            color: Colors.yellow,
          ),
          Container(
            height: 60,
            width: 60,
            color: Colors.yellow.shade200,
          ),
          Container(
            height: 40,
            width: 40,
            color: Colors.yellow.shade50,
          )
        ],
      ),
    );
  }
}
