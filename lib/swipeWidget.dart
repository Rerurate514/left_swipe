import 'package:flutter/material.dart';
import 'dart:math' as math;

class SwipeWidget extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => SwipeWidgetState();
}

class SwipeWidgetState extends State<SwipeWidget>{
  int _selectPageIndex = 0;

  var random = math.Random();

  List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _pages = List.generate(
        5, (index) => _SwipeView(_onPageChanged, random.nextInt(1000)));
  }

  
  void _onPageChanged() {
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
    _pages = List.generate(5, (i) => _SwipeView(_onPageChanged, random.nextInt(1000)));
    newPages += _pages;
    _pages = newPages;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          _pages[_selectPageIndex + 1],
          _pages[_selectPageIndex],
        ],
      ),
    );
  }
}

//--------------------------------------


class _SwipeView extends StatefulWidget {
  late Function onChangedCallback;
  late int colorSeed;

  _SwipeView(this.onChangedCallback, this.colorSeed);

  @override
  State<StatefulWidget> createState() =>
      _SwipeViewState(onChangedCallback, colorSeed);
}

class _SwipeViewState extends State<_SwipeView> {

  late PageController _pageController;
  int _selectPageIndex = 1;

  final Function _onChangedCallback;
  final int _colorSeed;

  _SwipeViewState(this._onChangedCallback, this._colorSeed);

  List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectPageIndex);
    _pages = [_LeftSwipePage(), _MainSwipePage(_colorSeed), _RightSwipePage()];
  }

  void _onPageChanged(int indexArg) {
    setState(() {
      _selectPageIndex = indexArg;
      _pageController.animateToPage(
        indexArg,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutSine,
      );
    });
    _onChangedCallback();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: _pages,
        //scrollBehavior: CustomScrollBehavior(),
      ),
    );
  }
}

//----------------------------------------------

class _MainSwipePage extends StatelessWidget {
  late final int _colorSeed;

  _MainSwipePage(this._colorSeed);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16)
        ),
        elevation: 32,
        child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Color.fromRGBO(
          (_colorSeed * 100) % 255, 
          (_colorSeed + 100) % 255,
          (_colorSeed * 100 + 150) % 255,
          1),
      ),
      )
    );
  }
}

//----------------------------

class _RightSwipePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
          child: Stack(
          alignment: Alignment.centerLeft, 
        children: [
      // Icon(
      //   Icons.favorite,
      //   size: 200,
      //   color: Colors.pink,
      // )
    ]),
        ));
  }
}

//-----------------------------------------------

class _LeftSwipePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Stack(
          alignment: Alignment.centerRight, 
        children: [
      // Icon(
      //   Icons.heart_broken,
      //   size: 200,
      //   color: Colors.purple,
      // )
    ]));
  }
}
