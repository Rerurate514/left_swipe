import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:left_swipe/swipeWidget.dart';
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
            background: const Color.fromRGBO(0, 0, 0, 0)),
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
  @override
  Widget build(BuildContext context) {
    return PositionedWidget();
  }
}

class PositionedWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PositionedWidgetState();
}

class PositionedWidgetState extends State<PositionedWidget> {
  double _currentPosX = 0.0;
  double _angle = 0.0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset("images/sample2.jpeg"),
        Positioned(
          left: _currentPosX,
          child: GestureDetector(
              onPanUpdate: (details) => {
                    setState(() {
                      _currentPosX = details.localPosition.dx -
                          (MediaQuery.of(context).size.width / 2);
                      _angle += _currentPosX / 20000;
                    })
                  },
              onPanEnd: (details) => {
                    setState(() {
                      // _currentPosX = 0;
                      // _angle = 0;
                    })
                  },
              child: Transform.rotate(
                angle: _angle,
                child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(64)),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      color: Colors.white,
                      child: Image.asset("images/sample.jpg"),
                    )),
              )),
        )
        //
      ],
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
