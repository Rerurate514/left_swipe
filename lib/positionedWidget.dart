import 'package:flutter/material.dart';

import 'dart:math' as math;
import 'dart:async';

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

    //HACK
    Future.delayed(
        const Duration(milliseconds: 1),
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
                    final resultWidget = Container(
                      child: child,
                    );

                    return resultWidget;
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
  final int _ANGLE_ADJUST_VALUE = 20000; //二万だと結構回転する角度が良い感じになる
  final int _SWIPE_VELOCITY_LIMIT = 1000; //1000ぐらいで画面遷移するスワイプ速度限界がちょうどいい感じになる

  double _currentPosX = 0.0;
  double _angle = 0.0;

  double _currentSwipeVelocity = 0.0;

  late final int _colorSeed;
  late final Function _onChangedCallback;

  final _posInitializer = EaseInOutInitializer(0, 1);
  final _angleInitializer = EaseInOutInitializer(0, 1);

  _PositionedWidgetState(this._colorSeed, this._onChangedCallback);

  void _onPanUpdateFunc(DragUpdateDetails details) {
    setState(() {
      _currentPosX =
          details.localPosition.dx - (MediaQuery.of(context).size.width / 2);

      _angle += _currentPosX / _ANGLE_ADJUST_VALUE;
    });
  }

  void _onPanEndFunc(DragEndDetails details) async {
    setState(() {
      _currentSwipeVelocity = details.velocity.pixelsPerSecond.dx;
    });

    if (details.velocity.pixelsPerSecond.dx.abs() > _SWIPE_VELOCITY_LIMIT) {
      _onChangedCallback();
    } else {


      await Future.wait([
        _initPosXInEase(),
        _initAngleInEase()
      ]);
        
      // await Future.wait([
      //   _initPosXInEase(),
      //   _initAngleInEase()
      // ]);
    }
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

class EaseInOutInitializer {
  late final double _initValue;
  late final double _needAllTimeSec;
  late final int _dt;
  final int _PARTITION_VALUE = 32;//ここの値が高いほどアニメーションが滑らかになる。

  double _beforeEaseValue = 0.0;

  EaseInOutInitializer(
    this._initValue,
    this._needAllTimeSec,
  ){
    _dt = (_needAllTimeSec / _PARTITION_VALUE * 1000).toInt();
  }

  Stream<double> doEaseInOutStream(double currentValueArg) async* {
    for(final newValueArg in _generateEaseInOut(currentValueArg)){
      await Future.delayed(Duration(milliseconds: _dt));
      yield newValueArg;
    }
  }

  Iterable<double> _generateEaseInOut(double currentValueArg) sync* {
    final double delta = currentValueArg - _initValue;
    final double dx = delta / _PARTITION_VALUE;
    final double dt = _dt / 1000;
    final int EASE_ADJUST_VALUE = _PARTITION_VALUE;

    double dtSum = 0.0;
    double result = currentValueArg;
    _beforeEaseValue = 0.0;

    for (int i = 0; i < _PARTITION_VALUE; i++, dtSum += dt) {
      var easeDelta = _calcEaseDelta(dtSum) * EASE_ADJUST_VALUE;
      result -= dx * easeDelta;
      yield result;
    }
  }

  /// 0.0 < t < 1.0
  double _calcEaseDelta(double t) {
    if (t < 0.0 || t > 1.0){
      throw ArgumentError(
          "Failed to invalid value in _calcEaseDelta method, current [t] => $t, valid range = 0.0 < t < 1.0");
    }
    double easeValue = _easeInOut(t);
    double result = easeValue - _beforeEaseValue;
    _beforeEaseValue = easeValue;
    return result;
  }

  /// 0.0 < t < 1.0
  double _easeInOut(double t) {
    if (t < 0.0 || t > 1.0){
      throw ArgumentError(
          "Failed to invalid value in _easeInOut method, current [t] => $t, valid range = 0.0 < t < 1.0");
    }
    double result =
        t < 0.5 ? 4 * t * t * t : (t - 1) * (2 * t - 2) * (2 * t - 2) + 1;
    return result;
  }
}
