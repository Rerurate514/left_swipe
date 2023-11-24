import 'package:flutter/material.dart';

import 'dart:math' as math;
import 'dart:async';

import './easeInOutAnimationGenerator.dart';
import './widgetExitAnimationController.dart';

class PositionedWidgetStack extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PositionedWidgetStackState();
}

class PositionedWidgetStackState extends State<PositionedWidgetStack> {
  var random = math.Random();
  List<Widget> _pages = [];

  int _selectPageIndex = 0;

  @override
  void initState() {
    super.initState();

    _pages = List.generate(10,
        (index) => _PositionedWidget(random.nextInt(1000), _onChangedCallback));
  }

  void _onChangedCallback() {
    setState(() {
      _selectPageIndex++;
    });

    _updatePagesForLoop();

    Future.delayed(
        const Duration(milliseconds: 100),
        () => {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      _pages[_selectPageIndex + 1],
                      _pages[_selectPageIndex],
                    ],
                  ),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    const begin = 0.0;
                    const end = 1.0;
                    const curve = Curves.easeInOutQuart;

                    var opacityTween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                    var opacityAnimation = animation.drive(opacityTween);

                    return FadeTransition(
                      opacity: opacityAnimation,
                      child: child,
                    );
                  },
                ),
              )
            });
  }

  void _updatePagesForLoop() {
    int pagesLen = _pages.length;

    if (_selectPageIndex < _pages.length - 2) return;

    _selectPageIndex = 0;
    List<Widget> newPages = [_pages[pagesLen - 2], _pages[pagesLen - 1]];
    _pages = List.generate(
        10, (i) => _PositionedWidget(random.nextInt(1000), _onChangedCallback));
    newPages += _pages;
    _pages = newPages;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _pages[_selectPageIndex + 1],
        _pages[_selectPageIndex],
      ],
    );
  }
}

class _PositionedWidget extends StatefulWidget {
  late int _colorSeed;
  late Function _onChangedCallback;

  _PositionedWidget(this._colorSeed, this._onChangedCallback);

  @override
  State<StatefulWidget> createState() =>
      _PositionedWidgetState(_colorSeed, _onChangedCallback);
}

class _PositionedWidgetState extends State<_PositionedWidget> {
  final int _ANGLE_ADJUST_VALUE = 10000; //二万だと結構回転する角度が良い感じになる
  final int _SWIPE_VELOCITY_LIMIT = 1000; //1000ぐらいで画面遷移するスワイプ速度限界がちょうどいい感じになる

  final double _INIT_ANIMATE_SEC = 1.0;

  double _currentPosX = 0.0;
  double _angle = 0.0;

  double _currentSwipeVelocity = 0.0;

  late final int _colorSeed;
  late final Function _onChangedCallback;

  late final _posInitializer = EaseInOutAnimationGenerator(0,_INIT_ANIMATE_SEC,256);
  late final _angleInitializer = EaseInOutAnimationGenerator(0,_INIT_ANIMATE_SEC,256);

  late final CancelableFuture<void> _cancelableFutures = CancelableFuture([_initPosXInEase(), _initAngleInEase()]);

  _PositionedWidgetState(this._colorSeed, this._onChangedCallback);

  void _onPanUpdateFunc(DragUpdateDetails details) {
    _cancelableFutures.cancel();
    setState(() {
      _currentPosX =
          details.localPosition.dx - (MediaQuery.of(context).size.width / 2);

      if(_angle.abs() < 1) _angle += _currentPosX / _ANGLE_ADJUST_VALUE;
      
    });
  }

  void _onPanEndFunc(DragEndDetails details) async {
    setState(() {
      _currentSwipeVelocity = details.velocity.pixelsPerSecond.dx;
    });

    if (details.velocity.pixelsPerSecond.dx.abs() > _SWIPE_VELOCITY_LIMIT) {
      _onChangedCallback();
      _doExitAnimation(details);
    } else {
      await Future.wait(_cancelableFutures.futures);
    }
  }

  Future<void> _doExitAnimation(DragEndDetails dragEndDetailsArg) async {
    WidgetExitAnimationController widgetExitAnimationController = 
      WidgetExitAnimationController(dragEndDetailsArg, _angle, _currentPosX);
    List streamList = widgetExitAnimationController.generateExitAnimationIterable();

    Future.wait([_doExitAnimationInPos(streamList),_doExitAnimationInAngle(streamList)]);
  }

  Future<void> _initPosXInEase() async {
    _posInitializer.doEaseInOutStream(_currentPosX).listen((newValueArg) {
      setState(() {
        _currentPosX = newValueArg;
      });
    });
  }

  Future<void> _initAngleInEase() async {
    _angleInitializer.doEaseInOutStream(_angle).listen((newValueArg) {
      setState(() {
        _angle = newValueArg;
      });
    });
  }

  Future<void> _doExitAnimationInPos(List streamListArg) async {
    streamListArg[0].listen((newCoodinateArg){
      setState(() {
        _currentPosX = newCoodinateArg;
      });
    });
  }

  Future<void> _doExitAnimationInAngle(List streamListArg) async {
    streamListArg[1].listen((newAngleArg){
      setState(() {
        _angle = newAngleArg;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: _currentPosX,
          child: GestureDetector(
              onPanUpdate: (details) => {_onPanUpdateFunc(details)},
              onPanEnd: (details) => {_onPanEndFunc(details)},
              child: Transform.rotate(
                  angle: _angle,
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Card(
                        elevation: 16,
                        color: Color.fromRGBO(
                            (_colorSeed * 100) % 255,
                            (_colorSeed + 100) % 255,
                            (_colorSeed * 100 + 150) % 255,
                            1),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        child: Center(
                            child: Text(
                          "X:$_currentPosX\nV:$_currentSwipeVelocity\nR:$_angle",
                          style: TextStyle(fontSize: 50),
                        )),
                      )))),
        )
      ],
    );
  }
}

class CancelableFuture<T>{
  final Iterable<Future<T>> _futures;
  Iterable<Future<T>> get futures => futures;

  final Completer<void> _cancelCompleter = Completer<void>();

  CancelableFuture(Iterable<Future<T>> futuresArg) : _futures = futuresArg;

  void cancel() => _cancelCompleter.complete();
}

