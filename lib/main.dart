import 'package:flutter/material.dart';
import 'package:learn_flutter/pages/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter 101',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Home(),
    );
  }
}
