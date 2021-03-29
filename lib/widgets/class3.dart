import 'package:flutter/material.dart';
import 'package:learn_flutter/utils/padding.dart';

class Class3Widget extends StatefulWidget {
  const Class3Widget({Key key}) : super(key: key);
  @override
  _Class3WidgetState createState() => _Class3WidgetState();
}

class _Class3WidgetState extends State<Class3Widget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        pt10,
        const Class3AnimationContainerWidget(),
        pt10,
        const Class3AnimatedCrossFade(),
        pt10,
        const Class3AnimatedOpacity(),
        pt10,
        SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: const Class3AnimationControllerWidget2())
      ],
    );
  }
}

class Class3AnimationControllerWidget extends StatefulWidget {
  const Class3AnimationControllerWidget({Key key}) : super(key: key);
  @override
  _Class3AnimationControllerWidgetState createState() =>
      _Class3AnimationControllerWidgetState();
}

class _Class3AnimationControllerWidgetState
    extends State<Class3AnimationControllerWidget>
    with TickerProviderStateMixin {
  AnimationController _floatUpController;
  AnimationController _growSizeController;
  Animation<double> _floatUp;
  Animation<double> _growSize;

  @override void initState() {
    super.initState();
    _floatUpController = AnimationController(duration: Duration(seconds: 4), vsync: this);
    _growSizeController = AnimationController(duration: Duration(seconds: 2), vsync: this);
  }

  @override
  void dispose() {
    _floatUpController.dispose();
    _growSizeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _ballHeight = MediaQuery.of(context).size.height / 2;
    var _ballWidth = MediaQuery.of(context).size.width / 3;
    var _ballBottomLocation = MediaQuery.of(context).size.height - _ballHeight;
    _floatUp = Tween(begin: _ballBottomLocation, end: 0.0).animate(
        CurvedAnimation(parent: _floatUpController, curve: Curves.fastOutSlowIn));
    _growSize = Tween(begin: 50.0, end: _ballWidth).animate(
        CurvedAnimation(parent: _growSizeController, curve: Curves.easeInOut));
    return AnimatedBuilder(
      animation: _floatUp,
      builder: (context, child) {
        return Container(
          child: child,
          margin: EdgeInsets.only(top: _floatUp.value),
          width: _growSize.value,
        );
      },
      child: GestureDetector(
        onTap: () {
          if (_floatUpController.isCompleted) {
            _floatUpController.reverse();
            _growSizeController.reverse();
          } else {
            _floatUpController.forward();
            _growSizeController.forward();
          }
        },
        child: Image.asset('asserts/images/ball.png',
            height: _ballHeight, width: _ballWidth),
      ),
    );
  }
}

class Class3AnimationControllerWidget2 extends StatefulWidget {
  const Class3AnimationControllerWidget2({Key key}) : super(key: key);
  @override
  _Class3AnimationControllerWidgetState2 createState() =>
      _Class3AnimationControllerWidgetState2();
}

class _Class3AnimationControllerWidgetState2
    extends State<Class3AnimationControllerWidget2>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _floatUp;
  Animation<double> _growSize;

  @override void initState() {
    super.initState();
    _controller = AnimationController(duration: Duration(seconds: 4), vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _ballHeight = MediaQuery.of(context).size.height / 2;
    var _ballWidth = MediaQuery.of(context).size.width / 3;
    var _ballBottomLocation = MediaQuery.of(context).size.height - _ballHeight;
    _floatUp = Tween(begin: _ballBottomLocation, end: 0.0).animate(
        CurvedAnimation(parent: _controller, curve: Interval(0.0,1.0,curve: Curves.fastOutSlowIn)));
    _growSize = Tween(begin: 50.0, end: _ballWidth).animate(
        CurvedAnimation(parent: _controller, curve: Interval(0.0, 1.0, curve: Curves.easeInOut)));
    return AnimatedBuilder(
      animation: _floatUp,
      builder: (context, child) {
        return Container(
          child: child,
          margin: EdgeInsets.only(top: _floatUp.value),
          width: _growSize.value,
        );
      },
      child: GestureDetector(
        onTap: () {
          if (_controller.isCompleted) _controller.reverse();
          else _controller.forward();
        },
        child: Image.asset('asserts/images/ball.png',
            height: _ballHeight, width: _ballWidth),
      ),
    );
  }
}

class Class3AnimatedOpacity extends StatefulWidget {
  const Class3AnimatedOpacity({Key key}) : super(key: key);
  @override
  _Class3AnimatedOpacityState createState() => _Class3AnimatedOpacityState();
}

class _Class3AnimatedOpacityState extends State<Class3AnimatedOpacity> {
  double _opacity = 1;
  Color _color = Colors.white;
  void _changeOpacity() => setState(() {
    _opacity == 0.3 ? _opacity = 1 : _opacity = 0.3;
    _color == Colors.white ? _color = Colors.black : _color = Colors.white;
  });
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        AnimatedOpacity(
          opacity: _opacity,
          duration: Duration(milliseconds: 500),
          child: Container(
            width: 200,
            height: 100,
            color: Colors.green,
          ),
        ),
        Positioned.fill(
            top: 70,
            child: TextButton(
              onPressed: () => _changeOpacity(),
              child: Text(
                'Change Opacity',
                style: TextStyle(color: _color),
              ),
            ))
      ],
    );
  }
}

class Class3AnimationContainerWidget extends StatefulWidget {
  const Class3AnimationContainerWidget({Key key}) : super(key: key);
  @override
  _Class3AnimationContainerWidgetState createState() =>
      _Class3AnimationContainerWidgetState();
}

class _Class3AnimationContainerWidgetState
    extends State<Class3AnimationContainerWidget> {
  var _height = 100.0;
  var _width = 100.0;
  var _color = Colors.pinkAccent;
  var _radius = 0.0;
  _increaseWidth() =>
      setState(() => _width = _width >= 320 ? 100 : _width += 50);
  _changeColor() => setState(() => _color == Colors.orangeAccent
      ? _color = Colors.pinkAccent
      : _color = Colors.orangeAccent);
  _changeRadius() => setState(() => _radius > 50 ? _radius = 0 : _radius += 30);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedContainer(
          duration: Duration(milliseconds: 500),
          curve: Curves.easeIn,
          height: _height,
          width: _width,
          decoration: BoxDecoration(
              color: _color,
              borderRadius: BorderRadius.all(Radius.circular(_radius))),
        ),
        ButtonBar(
          alignment: MainAxisAlignment.center,
          children: [
            TextButton(
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Text('Change Width'),
              ),
              onPressed: () => _increaseWidth(),
            ),
            TextButton(
              child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text('Change Color')),
              onPressed: () => _changeColor(),
            ),
            TextButton(
              child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text('Change Radius')),
              onPressed: () => _changeRadius(),
            ),
            TextButton(
              child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text('Change All')),
              onPressed: () {
                _changeRadius();
                _changeColor();
                _increaseWidth();
              },
            ),
          ],
        )
      ],
    );
  }
}

class Class3AnimatedCrossFade extends StatefulWidget {
  const Class3AnimatedCrossFade({Key key}) : super(key: key);
  @override
  _Class3AnimatedCrossFadeState createState() =>
      _Class3AnimatedCrossFadeState();
}

class _Class3AnimatedCrossFadeState extends State<Class3AnimatedCrossFade> {
  bool _showAcorn = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedCrossFade(
          sizeCurve: Curves.bounceOut,
          duration: Duration(milliseconds: 500),
          crossFadeState:
          _showAcorn ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          firstChild: Container(
              width: 200,
              color: Colors.orangeAccent,
              padding: EdgeInsets.all(20),
              child: Image.asset('asserts/images/acorn.png')),
          secondChild: Container(
              width: 200,
              padding: EdgeInsets.all(20),
              color: Colors.brown,
              child: Image.asset('asserts/images/animal.png')),
        ),
        pt10,
        TextButton(
            onPressed: () => setState(() => _showAcorn = !_showAcorn),
            child: Padding(
              padding: EdgeInsets.only(left: 5, right: 5),
              child: Text('Fade'),
            ))
      ],
    );
  }
}