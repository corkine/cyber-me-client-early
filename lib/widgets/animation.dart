import 'dart:math';

import 'package:flutter/material.dart';

class AnimationDemo {
  static void runAnimation() {
    return runApp(AnimationDemo2());
  }
}

class AnimationDemo1 extends StatefulWidget {
  @override
  _AnimationDemo1State createState() => _AnimationDemo1State();
}

class _AnimationDemo1State extends State<AnimationDemo1>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;
  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: Duration(seconds: 10), vsync: this)
          ..repeat();
    _controller.addListener(() {
      if (!_controller.isAnimating) _controller.reverse();
    });
    _animation = CurvedAnimation(parent: _controller, curve: Curves.linear);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animation Demo',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(title: Text('Animation Demo')),
          body: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                  onTap: () => _controller.isAnimating
                      ? _controller.stop()
                      : _controller.forward(),
                  child: RotationTransition(
                      turns: _animation,
                      child: Image.network(
                          'https://static2.mazhangjing.com/20210405/5f96cd6_galaxy.jpg'))),
              AnimatedBuilder(
                  child: Container(
                      width: double.infinity, height: 10, color: Colors.red),
                  animation: _controller,
                  builder: (c, w) =>
                      Opacity(opacity: _animation.value, child: w)),
              AnimatedBuilder(
                  animation: _controller,
                  builder: (c, w) {
                    return Slider.adaptive(
                        value: _animation.value,
                        onChanged: (v) {
                          _controller.forward(from: v);
                        });
                  })
            ],
          ))),
    );
  }

  var _sliderValue = 0.0;
  var _newColor = Colors.white;

  Column buildSimpleAnimation2() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          child: TweenAnimationBuilder(
              child: Image.asset('asserts/images/animal.png', width: 100),
              duration: Duration(milliseconds: 500),
              tween: ColorTween(begin: Colors.white, end: _newColor),
              curve: Curves.easeInOut,
              onEnd: () {
                setState(() => _newColor = Colors.white);
              },
              builder: (c, Color o, Widget image) {
                return ColorFiltered(
                    colorFilter: ColorFilter.mode(o, BlendMode.modulate),
                    child: image);
              }),
        ),
        Slider.adaptive(
            value: _sliderValue,
            onChanged: (newValue) {
              setState(() {
                _sliderValue = newValue;
                _newColor = Color.lerp(Colors.white, Colors.orange, newValue);
              });
            })
      ],
    );
  }

  FutureBuilder<double> buildSimpleAnimation1() {
    return FutureBuilder(
      future: Future.delayed(Duration(seconds: 1), () {
        return 0.0;
      }),
      builder: (c, s) {
        var _width = 0.0;
        var _color = Colors.grey;
        switch (s.connectionState) {
          case ConnectionState.done:
            _width = 200.0;
            _color = Colors.orange;
            break;
          default:
        }
        return AnimatedContainer(
          duration: Duration(seconds: 3),
          curve: Curves.easeIn,
          color: _color,
          width: _width,
          height: _width,
          child: Center(
              child: Image(
            image: AssetImage('asserts/images/animal.png'),
            height: _width / 2,
            width: _width / 2,
          )),
        );
      },
    );
  }
}

class AnimationDemo2 extends StatefulWidget {
  @override
  _AnimationDemo2State createState() => _AnimationDemo2State();
}

class _AnimationDemo2State extends State<AnimationDemo2>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  @override void initState() {
    super.initState();
    _controller = AnimationController(duration: Duration(seconds: 1), vsync: this)..repeat();
  }
  @override void dispose() {
    _controller.dispose(); super.dispose();
  }
  @override Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(),
        body: Stack(children: [
          BeamTranslation(animation: _controller),
          Container(
            alignment: Alignment(0, 0),
            child: Image.network(
              'https://static2.mazhangjing.com/20210406/b48f8e9_ufo.jpg',
              width: 300,
            ),
          ),
        ]),
      ),
    );
  }
}

class BeamTranslation extends AnimatedWidget {
  final Widget _child;
  const BeamTranslation({Key key, Animation<double> animation, Widget child})
      : _child = child,
        super(key: key, listenable: animation);
  @override
  Widget build(BuildContext context) {
    Animation<double> _animation = listenable;
    return AnimatedBuilder(
        animation: _animation,
        builder: (c, w) => ClipPath(
              clipper: const BeamClipper(),
              child: Container(
                  height: 1000,
                  decoration: BoxDecoration(
                      gradient: RadialGradient(
                          radius: 1.5,
                          colors: [Colors.yellowAccent, Colors.white],
                          stops: [0, _animation.value]))),
            ));
  }
}

class BeamClipper extends CustomClipper<Path> {
  const BeamClipper();
  @override
  Path getClip(Size size) {
    return Path()
      ..lineTo(size.width / 2, size.height / 2)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..lineTo(size.width / 2, size.height / 2)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    throw UnimplementedError();
  }
}
