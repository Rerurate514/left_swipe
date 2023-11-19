import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:left_swipe/backSwipe.dart';
import 'package:left_swipe/swipePage.dart';
import 'package:left_swipe/toSwipedPage.dart';
import 'dart:math' as math;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      scrollBehavior: MyCustomScrollBehavior(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            background: Color.fromRGBO(0, 0, 0, 0)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late PageController _pageController;
  int _selectPageIndex = 0;

  var random = math.Random();

  List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectPageIndex);
    _pages = List.generate(
        5, (index) => _SwipeView(_onPageChanged, random.nextInt(1000)));
  }

  
  void _onPageChanged() {
    setState(() {  
      _selectPageIndex++;
    });
    

    int pagesLen = _pages.length;
    if(_selectPageIndex >= _pages.length - 2) {
      _selectPageIndex = 0;
      List<Widget> newPages = [_pages[pagesLen - 2], _pages[pagesLen - 1]];
      _pages = List.generate(5, (i) => _SwipeView(_onPageChanged, random.nextInt(1000)));
      newPages += _pages;
      _pages = newPages;
    }

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
          const begin = 0.0;
          const end = 1.0;
          var tween = Tween<double>(begin: begin, end: end);
          var tweenAnimation = tween.animate(animation);

          final resultWidget = Container(
            child: child,
          );

          return resultWidget;
        },
      ),
    );
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

class _SwipeView extends StatefulWidget {
  late Function onChangedCallback;
  late int colorSeed;

  _SwipeView(this.onChangedCallback, this.colorSeed);

  @override
  State<StatefulWidget> createState() =>
      _SwipeViewState(onChangedCallback, colorSeed);
}

class _SwipeViewState extends State<_SwipeView> {
  late AnimationController _animationController;
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
    _pages = [BackSwipePage(), SwipePage(_colorSeed), ToSwipePage()];
  }

  void _onPageChanged(int indexArg) {
    setState(() {
      _selectPageIndex = indexArg;
      _pageController.animateToPage(
        indexArg,
        duration: const Duration(milliseconds: 500),
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

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        // etc.
      };
}

class CustomScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics();
  }

  @override
  Widget buildScrollbar(
      BuildContext context, Widget child, ScrollableDetails details) {
    return Scrollbar(
      child: child,
      controller: details.controller,
      showTrackOnHover: true,
      radius: Radius.circular(20),
      interactive: true,
      notificationPredicate: (notification) => true,
    );
  }
}

