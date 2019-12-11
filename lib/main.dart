import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Circle Clock',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        backgroundColor: Color(0xffffffdd),
        body: SafeArea(
          child: CircleClock(),
        ),
      ),
    );
  }
}

const double FONT_SIZE = 20;

class CircleClock extends StatefulWidget {
  @override
  _CircleClockState createState() => _CircleClockState();
}

class _CircleClockState extends State<CircleClock> {
  DateTime _dateTime = DateTime.now();
  Timer _timer;

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      _timer = Timer(
        Duration(minutes: 1) -
            Duration(seconds: _dateTime.second) -
            Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double dishMove = screenWidth / 2;

    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Transform(
            transform: Matrix4.translationValues(-dishMove * 1.4, 0, 0)
              ..scale(1.2),
            child: Dish(24, screenWidth, _dateTime.hour)),
        Transform(
            transform: Matrix4.translationValues(dishMove, 0, 0)..scale(1.2),
            child: DishRev(60, screenWidth, _dateTime.minute ~/ 5 * 5))
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _updateTime();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

class Dish extends StatelessWidget {
  const Dish(this.quantity, this.diameter, this.lightNum);

  final int quantity;
  final double diameter;
  final int lightNum;

  final double startAngle = pi / 2; //調整起始位置

  @override
  Widget build(BuildContext context) {
    double radius = diameter / 2; //圓盤半徑
    double pointRadius = radius - FONT_SIZE; //擺放數字的半徑

    List<Widget> points = [
      Container(
        width: diameter,
        height: diameter,
        decoration: new BoxDecoration(
          color: Color(0xff8acbc7),
          border: Border.all(color: Colors.white, width: 2),
          shape: BoxShape.circle,
        ),
      )
    ];

    //計算每個數字的值
    double signalAngle = pi * 2 / quantity;
    //正好會在0度的index
    int lightIndex = startAngle ~/ signalAngle;

    //按比例產生數字
    for (int i = 0; i < quantity; i++) {
      double angle = signalAngle * i - startAngle; //調整角度與順序
      double dx = pointRadius * cos(angle);
      double dy = pointRadius * sin(angle);

      //修正顯示數值
      int index = (i - lightIndex + lightNum + quantity) % quantity;
      Widget point = getNormalPoint(index, dx, dy);
      points.add(point);
    }

    return Container(
      width: diameter,
      height: diameter,
      child: Stack(
        alignment: Alignment.center,
        children: points,
      ),
    );
  }
}

class DishRev extends StatelessWidget {
  const DishRev(this.maxPoint, this.diameter, this.lightNum);

  final int maxPoint;
  final double diameter;
  final int lightNum;

  final double fontSize = 20;
  final double startAngle = pi / 2 - pi;

  @override
  Widget build(BuildContext context) {
    double radius = diameter / 2;
    double pointRadius = radius - FONT_SIZE;

    List<Widget> points = [
      Container(
        width: diameter,
        height: diameter,
        decoration: new BoxDecoration(
          color: Color(0xff8acbc7),
          border: Border.all(color: Colors.white, width: 2),
          shape: BoxShape.circle,
        ),
      )
    ];

    int quantity = maxPoint ~/ 5;
    double signalAngle = pi * 2 / quantity;
    //正好會在180度的index
    int lightIndex = pi * 1.5 ~/ signalAngle;

    for (int i = 0; i < quantity; i++) {
      double angle = startAngle - signalAngle * i;
      double dx = pointRadius * cos(angle);
      double dy = pointRadius * sin(angle);

      //修正顯示數值
      int index = ((i + lightIndex) * 5 + lightNum + maxPoint) % maxPoint;
      Widget point = getNormalPoint(index, dx, dy);
      points.add(point);
    }

    return Container(
      width: diameter,
      height: diameter,
      child: Stack(
        alignment: Alignment.center,
        children: points,
      ),
    );
  }
}

Widget getNormalPoint(int num, double dx, double dy) {
  return Transform.translate(
    offset: Offset(dx, dy),
    child: Text(
      '$num',
      style: TextStyle(
          fontSize: FONT_SIZE,
          color: Color(0xffffffdd),
          fontWeight: FontWeight.w300),
    ),
  );
}
