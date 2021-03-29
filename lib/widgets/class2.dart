import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:learn_flutter/models/user.dart';

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