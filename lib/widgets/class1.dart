import 'package:flutter/material.dart';

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
