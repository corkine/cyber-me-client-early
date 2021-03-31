import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:learn_flutter/utils/padding.dart';

class Class5ListViewHttpDemo extends StatefulWidget {
  const Class5ListViewHttpDemo({Key key}) : super(key: key);
  @override
  _Class5ListViewHttpDemoState createState() => _Class5ListViewHttpDemoState();
}

class _Class5ListViewHttpDemoState extends State<Class5ListViewHttpDemo> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: http
          .get(Uri.parse('https://status.mazhangjing.com/status'))
          .then((value) => json.decode(Utf8Codec().decode(value.bodyBytes))),
      builder: (c, s) => Scaffold(
          appBar: AppBar(title: Text('Server Status')),
          body: s.connectionState == ConnectionState.done
              ? s.hasError
              ? Center(child: Text('Error'))
              : ListView.builder(
              itemCount: (s.data as List<dynamic>).length,
              itemBuilder: (c, i) => ListTile(
                leading: CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.blue.shade100,
                  child: Text('${s.data[i]['healthy']}'),
                ),
                title: Text('${s.data[i]['name']}'),
                subtitle: Text('${s.data[i]['websiteUrl']}'),
                onTap: () {},
              ))
              : Center(child: CircularProgressIndicator())),
    );
  }
}

class Class5GridViewHttpDemo extends StatefulWidget {
  const Class5GridViewHttpDemo({Key key}) : super(key: key);
  @override
  _Class5GridViewHttpDemoState createState() => _Class5GridViewHttpDemoState();
}

class _Class5GridViewHttpDemoState extends State<Class5GridViewHttpDemo> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: http
            .get(Uri.parse('https://status.mazhangjing.com/goods/data?'
            '&hideRemove=true&user=corkine&password=mzj960032'))
            .then((value) => json.decode(Utf8Codec().decode(value.bodyBytes))),
        builder: (c, s) => Scaffold(
          appBar: AppBar(title: Text('GridView Demo')),
          body: s.connectionState == ConnectionState.done
              ? s.hasError
              ? Center(child: Text('Error ${s.error.toString()}'))
              : GridView.builder(
            itemCount: (s.data as List).length,
            padding: EdgeInsets.all(3),
            gridDelegate:
            SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 175),
            itemBuilder: (c, i) => Card(
                child: Tooltip(
                  message: s.data[i]['name'],
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: s.data[i]['picture'] != null
                                ? NetworkImage(s.data[i]['picture'].toString().replaceFirst('http://', 'https://'))
                                : AssetImage(
                                'asserts/images/acorn.png'),
                            fit: BoxFit.cover)),
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      height: 20,
                      width: double.infinity,
                      color: Colors.white54,
                      child: Text(s.data[i]['name'],
                          overflow: TextOverflow.ellipsis),
                    ),
                  ),
                )),
          )
              : Center(child: CircularProgressIndicator()),
        ));
  }
}

class Class5StackDemo extends StatefulWidget {
  const Class5StackDemo({Key key}) : super(key: key);
  @override
  _Class5StackDemoState createState() => _Class5StackDemoState();
}

class _Class5StackDemoState extends State<Class5StackDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stack Demo'),
      ),
      body: Center(
        child: Stack(
          children: [
            Image.asset('asserts/images/girl.jpg'),
            Positioned(
                right: 0,
                child: FractionalTranslation(
                  translation: Offset(0.2, -0.2),
                  child: Icon(
                    Icons.bookmark,
                    color: Colors.red.withOpacity(0.7),
                    size: 100,
                  ),
                )),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                alignment: Alignment.center,
                color: Colors.white38,
                child: Text(
                  'Beautiful Girl',
                  style: TextStyle(
                      color: Colors.white70,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Arial'),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Class5SliverApp extends StatefulWidget {
  const Class5SliverApp({Key key}) : super(key: key);
  @override
  _Class5SliverAppState createState() => _Class5SliverAppState();
}

class _Class5SliverAppState extends State<Class5SliverApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.brown,
            forceElevated: true,
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('SliverApp'),
              background: Image(
                image: AssetImage('asserts/images/animal.png'),
                fit: BoxFit.fitWidth,
              ),
            ),
            actions: [
              IconButton(
                  icon: Icon(Icons.motion_photos_on_rounded), onPressed: () {})
            ],
          ),
          SliverList(
              delegate: SliverChildListDelegate(List.generate(
                  3,
                      (index) => ListTile(
                    leading: CircleAvatar(
                      child: Text('${index + 1}'),
                      backgroundColor: Colors.lightGreen,
                      foregroundColor: Colors.white,
                    ),
                    title: Text('Row ${index + 1}'),
                    subtitle: Text('Subtitle ${index + 1}'),
                    trailing: Icon(Icons.star_border),
                  )))),
          SliverGrid(
              delegate: SliverChildBuilderDelegate(
                      (c, index) => Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.child_friendly,
                          size: 48,
                          color: Colors.amber,
                        ),
                        Divider(),
                        Text('Grid ${index + 1}')
                      ],
                    ),
                  ),
                  childCount: 10),
              gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3))
        ],
      ),
    );
  }
}

class RealAppLayout extends StatefulWidget {
  const RealAppLayout({Key key}) : super(key: key);
  @override
  _RealAppLayoutState createState() => _RealAppLayoutState();
}

class _RealAppLayoutState extends State<RealAppLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 50,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: Icon(
          Icons.menu,
          color: Colors.grey,
        ),
        title: Center(
            child: Text(
              'Layouts',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54),
            )),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: Icon(
                Icons.wb_cloudy_outlined,
                color: Colors.grey,
              ),
              onPressed: () {},
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(
                          'https://static2.mazhangjing.com/20210331/'
                              'bca5523_3651580255_1796619115.jpg'),
                      fit: BoxFit.cover,
                      alignment: Alignment(0, 0.05))),
              height: 200,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
              child: Text(
                'My Birthday',
                style: TextStyle(
                  fontSize: 40,
                  fontFamily: 'Arial',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
              child: Text(
                "It's going to be a great birthday. We are going out for dinner at my"
                    "favorite place, then watch a movie after we go to the gelateria for"
                    "ice cream and espresso.",
                style: TextStyle(color: Colors.black45),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 15, left: 5),
                    child: Icon(
                      Icons.wb_sunny,
                      color: Colors.orange,
                      size: 30,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '32° Clear',
                        style: TextStyle(
                            color: Colors.orange, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '4500 San Alpho Drive, Dallas, TX United States',
                        style: TextStyle(color: Colors.black26, fontSize: 13),
                      )
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                children: List.generate(
                    7, (index) => LabelWidget(text: 'Gift ${index + 1}'))
                    .toList(),
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                              'https://static2.mazhangjing.com/20210331/'
                                  'a1d368f_adaf2edda3cc7cd9a63a7d1d9fac0d39b90e9116.jpeg'),
                          radius: 40,
                        ),
                        Padding(padding: EdgeInsets.all(10)),
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                              'https://static2.mazhangjing.com/20210331/5fcbd46_src=http___pic.'
                                  '3490.cn_edit_2017_07-10_20170710102053125312.jpg&refer=http___pic.3490.jfif'),
                          radius: 40,
                        ),
                        Padding(padding: EdgeInsets.all(10)),
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                              'https://static2.mazhangjing.com/20210331/64d346c_src=http___www.jonkoonce.com_editor_attached_image_'
                                  '20150127_20150127085175897589.jpg&refer=http___www.jonkoonce.jfif'),
                          radius: 40,
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 3, right: 8),
                      child: Column(
                        children: [
                          Icon(Icons.cake),
                          Icon(Icons.star_border),
                          Icon(Icons.music_note_outlined)
                        ],
                      ),
                    )
                  ],
                )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(child: TextButton(onPressed: (){
                Navigator.of(context).pop();
              }, child: Text('BACK'))),
            )
          ],
        ),
      ),
    );
  }
}

class LabelWidget extends StatelessWidget {
  final String text;
  const LabelWidget({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var d = Padding(padding: EdgeInsets.only(left: 2, right: 2, top: 4, bottom: 4),child: Chip(
      label: Text('$text'),
      avatar: Icon(Icons.cake_outlined),
      shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.grey,width: 1),
          borderRadius: BorderRadius.circular(4)),
      backgroundColor: Colors.grey.shade100,
    ),);
    var f = Container(
      alignment: Alignment.center,
      width: 75,
      margin: EdgeInsets.only(left: 3, right: 3, top: 5, bottom: 5),
      padding: EdgeInsets.all(3),
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          border: Border(
            top: BorderSide(color: Colors.grey.shade300, width: 1.5),
            bottom: BorderSide(color: Colors.grey.shade300, width: 1.5),
            left: BorderSide(color: Colors.grey.shade300, width: 1.5),
            right: BorderSide(color: Colors.grey.shade300, width: 1.5),
          ),
          borderRadius: BorderRadius.circular(6)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 5.0),
            child: Icon(
              Icons.cake_outlined,
              color: Colors.lightBlue.shade200,
            ),
          ),
          Text(
            '$text',
            style: TextStyle(fontSize: 13),
          )
        ],
      ),
    );
    return f;
  }
}

class Class5Widget extends StatefulWidget {
  const Class5Widget({Key key}) : super(key: key);
  @override
  _Class5WidgetState createState() => _Class5WidgetState();
}

class _Class5WidgetState extends State<Class5Widget> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Card(
          child: buildContainer('Hello World'),
          color: Colors.pinkAccent,
        ),
        Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(20),
                  topRight: Radius.circular(20))),
          child: buildContainer('Hello World'),
          color: Colors.green,
          shadowColor: Colors.grey,
          elevation: 4,
        ),
        Card(
          shape: StadiumBorder(),
          child: buildContainer('Hello World'),
          color: Colors.blue,
          shadowColor: Colors.grey,
          elevation: 4,
        ),
        Card(
          shape: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.deepOrange)),
          child: buildContainer('Hello World'),
          color: Colors.blueGrey,
          shadowColor: Colors.grey,
          elevation: 4,
        ),
        Card(
          shape:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.brown)),
          child: buildContainer('Hello World'),
          color: Colors.orangeAccent,
          shadowColor: Colors.grey,
          elevation: 4,
        ),
        pt10,
        ListTile(
          title: Text('Design'),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(Icons.app_registration),
          title: Text('Design'),
          trailing: IconButton(
            icon: Icon(Icons.bookmark_outline),
            onPressed: () {},
          ),
          onTap: () {},
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
        ),
        ListTile(
          leading: Icon(Icons.app_registration),
          title: Text('Design'),
          subtitle: Text('Design The App'),
          trailing: IconButton(
            icon: Icon(Icons.bookmark),
            onPressed: () {},
          ),
          onTap: () {},
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
        ),
        ListTile(
          leading: Icon(Icons.app_registration),
          title: Text('Design'),
          subtitle: Text('Design The App'),
          trailing: IconButton(
            icon: Icon(Icons.bookmark),
            onPressed: () {},
          ),
          onTap: () {},
          tileColor: Colors.purple.shade100,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
        ),
        ListTile(
          leading: SizedBox(
              height: 30, child: Image.asset('asserts/images/animal.png')),
          title: Text('Show ListView.builder (http)'),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return const Class5ListViewHttpDemo();
            }));
          },
        ),
        ListTile(
          leading: SizedBox(
              height: 30, child: Image.asset('asserts/images/acorn.png')),
          title: Text('Show GridView.count'),
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (c) => Class5GridViewHttpDemo()));
          },
        ),
        ListTile(
          leading: SizedBox(
              height: 30, child: Image.asset('asserts/images/ball.png')),
          title: Text('Show Stack'),
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (c) => Class5StackDemo()));
          },
        ),
        ListTile(
          leading: SizedBox(
              height: 30, child: Image.asset('asserts/images/ball.png')),
          title: Text('Show Slivers'),
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (c) => Class5SliverApp()));
          },
        ),
        ListTile(
          leading: SizedBox(
              height: 30, child: Image.asset('asserts/images/ball.png')),
          title: Text('Show Real App layout'),
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (c) => RealAppLayout()));
          },
        ),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            Chip(label: Text('HELLO')),
            Chip(
              label: Text('HELLO'),
              labelStyle: TextStyle(
                  fontSize: 15,
                  color: Colors.red,
                  decoration: TextDecoration.underline),
            ),
            Chip(
              label: Text('HELLO'),
              avatar: CircleAvatar(
                child: Text('H'),
              ),
            ),
            Chip(
              label: Text('HELLO'),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
            ),
            Chip(
              label: Text('HELLO'),
              labelPadding: EdgeInsets.all(10),
            ),
            Chip(
              label: Text('HELLO'),
              deleteIcon: Icon(Icons.delete),
              onDeleted: () {},
            ),
            ActionChip(label: Text('HELLO'), onPressed: (){}),
            RawChip(label: Text('HELLO'),
              showCheckmark: true,selected: true,
              onPressed: (){},)
          ],
        )
      ],
    );
  }

  Container buildContainer(String content) {
    return Container(
      padding: EdgeInsets.only(left: 20),
      alignment: AlignmentDirectional.centerStart,
      height: 50,
      width: double.infinity,
      child: Text(
        '$content',
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }
}

