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