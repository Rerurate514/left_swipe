import 'package:flutter/material.dart';

import 'dart:math' as math;

class PositionedWidgetStack extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => PositionedWidgetStackState();
}

class PositionedWidgetStackState extends State<PositionedWidgetStack>{
  var random = math.Random();

  List<Widget> _pages = [];

  int _selectPageIndex = 0;

  @override
  void initState(){
    super.initState();

    _pages = List.generate(10, (index) => PositionedWidget(random.nextInt(1000), _onChangedCallback));
  }

  void _onChangedCallback(){
        setState(() {  
      _selectPageIndex++;
    });

    _updatePages();

    //HACK 
    Future.delayed(const Duration(milliseconds: 300), () => {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => Stack(
            alignment: Alignment.center,
            children: <Widget>[
              _pages[_selectPageIndex + 1],
              _pages[_selectPageIndex],
            ],
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final resultWidget = Container(
              child: child,
            );

            return resultWidget;
          },
        ),
      )
    });
  }

  void _updatePages(){
    int pagesLen = _pages.length;

    if(_selectPageIndex < _pages.length - 2) return;

    _selectPageIndex = 0;
    List<Widget> newPages = [_pages[pagesLen - 2], _pages[pagesLen - 1]];
    _pages = List.generate(10, (i) => PositionedWidget(random.nextInt(1000), _onChangedCallback));
    newPages += _pages;
    _pages = newPages;
  }

  @override
  Widget build(BuildContext context){
    return Stack(children: [
      _pages[_selectPageIndex + 1],
      _pages[_selectPageIndex],
    ],);
  }
}

class PositionedWidget extends StatefulWidget {
  late int _colorSeed;
  late Function _onChangedCallback;

  PositionedWidget(this._colorSeed, this._onChangedCallback);

  @override
  State<StatefulWidget> createState() => PositionedWidgetState(_colorSeed, _onChangedCallback);
}

class PositionedWidgetState extends State<PositionedWidget> {
  final int _ANGLE_ADJUST_VALUE = 20000; //二万だと結構回転する角度が良い感じになる
  final int _SWIPE_VELOCITY_LIMIT = 1000;//1000ぐらいでスワイプ速度がちょうどいい感じになる


  double _currentPosX = 0.0;
  double _angle = 0.0;

  double _currentSwipeVelocity = 0.0;

  late int _colorSeed;
  late Function _onChangedCallback;

  PositionedWidgetState(this._colorSeed, this._onChangedCallback);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: _currentPosX,
          child: GestureDetector(
              onPanUpdate: (details) => {
                    setState(() {
                      _currentPosX = details.localPosition.dx -
                          (MediaQuery.of(context).size.width / 2);

                      _angle += _currentPosX / _ANGLE_ADJUST_VALUE;
                    })
                  },
              onPanEnd: (details) => {
                    setState(() {
                      _currentSwipeVelocity =
                          details.velocity.pixelsPerSecond.dx;
                    }),
                    if (details.velocity.pixelsPerSecond.dx.abs() > _SWIPE_VELOCITY_LIMIT)
                      {
                        _onChangedCallback(),
                      }
                    else
                      {
                        setState(() {
                          _currentPosX = 0;
                          _angle = 0;
                        })
                      },
                  },
              child: Transform.rotate(
                angle: _angle,
                child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(64)),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      color: Color.fromRGBO(
                          (_colorSeed * 100) % 255,
                          (_colorSeed + 100) % 255,
                          (_colorSeed * 100 + 150) % 255,
                          1),
                      child: Center(
                          child: Text(
                        "X:$_currentPosX\nV:$_currentSwipeVelocity",
                        style: TextStyle(fontSize: 60),
                      )),
                    )),
              )),
        )
      ],
    );
  }
}