import 'package:flutter/material.dart';

import 'dart:math';
import 'dart:ui';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: ''),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
        duration: const Duration(milliseconds: 1500),
        vsync: this,
        reverseDuration: const Duration(microseconds: 1000));
    _controller.repeat(reverse: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var matrix = Matrix4.identity();

    return Scaffold(
        body: ColoredBox(
      color: Colors.black,
      child: Align(
        alignment: Alignment.topCenter,
        child: AnimatedBuilder(
          builder: (BuildContext context, Widget? child) {
            return SizedBox(
              width: 400,
              height: 400,
              child: CustomPaint(
                painter: CustomHeart(_controller.value),
              ),
            );
          },
          animation: _controller,
        ),
      ),
    ));
  }
}

class CustomDoc extends CustomPainter {
  CustomDoc();

  @override
  void paint(Canvas canvas, Size size) {
    var width = size.width;
    var height = size.height;
    var path = Path();
    var paint = Paint()..color = Colors.blue;

    canvas.drawCircle(Offset(width / 2, height / 2), 2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class CustomHeart extends CustomPainter {
  final double value;
  CustomHeart(this.value);

  @override
  void paint(Canvas canvas, Size size) {
    var width = size.width;
    var height = size.height;
    var path = Path();
    var paint = Paint()..color = Colors.transparent;

    var ratioX1 = 20 + (50 - 20) * value;
    var ratioY1 = 27 + (50 - 27) * value;
    var ratioX2 = (5 - 0) * value;
    var ratioY2 = 80 + (55 - 80) * value;

    var positionTopX = 50;
    var positionTopY = 60 + (68 - 60) * value;

    path.moveTo(width * positionTopX / 100, height * positionTopY / 100);
    path.cubicTo(width * ratioX1 / 100, height * ratioY1 / 100,
        width * ratioX2 / 100, height * ratioY2 / 100, width / 2, height);
    path.cubicTo(
        width * (100 - ratioX2) / 100,
        height * ratioY2 / 100,
        width * (100 - ratioX1) / 100,
        height * ratioY1 / 100,
        width * positionTopX / 100,
        height * positionTopY / 100);
    path.close();

    var path1 = Path();
    var paint1 = Paint()
      ..color = Colors.red.withOpacity(0.8)
      ..style = PaintingStyle.fill
      ..strokeWidth = 2
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.square;
    var paint2 = Paint()
      ..color = Colors.pink.withOpacity(0.7)
      ..style = PaintingStyle.fill
      ..strokeWidth = 2
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.square;
    var ratioX11 = 30;
    var ratioY11 = 20;
    var ratioX21 = -10;
    var ratioY21 = 70;

    var positionTopX1 = 50;
    var positionTopY1 = 63;

    path1.moveTo(width * positionTopX1 / 100, height * positionTopY1 / 100);
    path1.cubicTo(width * ratioX11 / 100, height * ratioY11 / 100,
        width * ratioX21 / 100, height * ratioY21 / 100, width / 2, height + 5);
    path1.cubicTo(
        width * (100 - ratioX21) / 100,
        height * ratioY21 / 100,
        width * (100 - ratioX11) / 100,
        height * ratioY11 / 100,
        width * positionTopX1 / 100,
        height * positionTopY1 / 100);

    double dashWidth1 = 1;
    double dashSpace1 = 0;
    double distance1 = 0.0;
    double centerX1 = width / 2;
    double centerY1 = (height * positionTopY1 / 100 + height) / 2;
    for (PathMetric pathMetric in path1.computeMetrics()) {
      while (distance1 < pathMetric.length) {
        var offset = pathMetric.getTangentForOffset(distance1)?.position ??
            const Offset(0, 0);

        var dashPathTemp1 = _drawOutput(offset, centerX1, centerY1);
        canvas.drawPath(dashPathTemp1, paint2);
        distance1 += dashWidth1;
        distance1 += dashSpace1;
      }
    }

    Path dashPath = Path();

    double dashWidth = 1;
    double dashSpace = 0;
    double distance = 0.0;
    double centerX = width / 2;
    double centerY = (height * positionTopY / 100 + height) / 2;

    for (PathMetric pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        var offset = pathMetric.getTangentForOffset(distance)?.position ??
            const Offset(0, 0);

        dashPath.addOval(Rect.fromCircle(center: offset, radius: 1));
        var dashPathTemp = _drawInput(offset, centerX, centerY);
        canvas.drawPath(dashPathTemp, paint1);
        distance += dashWidth;
        distance += dashSpace;
      }
    }

    path1.close();
    canvas.drawPath(dashPath, paint);
  }

  Path _drawOutput(Offset offset, double centerX, double centerY) {
    Path pathTemp = Path();
    pathTemp.moveTo(offset.dx, offset.dy);
    pathTemp.lineTo(centerX, centerY);
    pathTemp.close();
    Path dashPathTemp = Path();
    double dashWidth1 = 1.0;
    double dashSpace1 = 0.5;
    double distance1 = 0.0;
    for (PathMetric pathMetric1 in pathTemp.computeMetrics()) {
      while (distance1 < pathMetric1.length) {
        var offset1 = pathMetric1.getTangentForOffset(distance1)?.position ??
            const Offset(0, 0);
        var radius = 0.0;
        if (distance1 < pathMetric1.length / 40) {
          radius = randomTime(4, 0.6);
        } else if (distance1 < pathMetric1.length / 10) {
          radius = randomTime(3, 0.5);
        } else if (distance1 < pathMetric1.length / 9) {
          radius = randomTime(2, 0.5);
        } else if (distance1 < pathMetric1.length / 8) {
          radius = randomTime(3, 0.6);
        } else if (distance1 < pathMetric1.length / 7) {
          radius = randomTime(3, 0.7);
        } else if (distance1 < pathMetric1.length / 6) {
          radius = randomTime(3, 0.8);
        }
        if (radius != 0.0) {
          dashPathTemp
              .addOval(Rect.fromCircle(center: offset1, radius: radius));
        }
        distance1 += dashWidth1;
        distance1 += dashSpace1;
      }
    }
    return dashPathTemp;
  }

  Path _drawInput(Offset offset, double centerX, double centerY) {
    Path pathTemp = Path();
    pathTemp.moveTo(offset.dx, offset.dy);
    pathTemp.lineTo(centerX, centerY);
    pathTemp.close();
    Path dashPathTemp = Path();
    double dashWidth1 = 1.0;
    double dashSpace1 = 0;
    double distance1 = 0.0;
    for (PathMetric pathMetric1 in pathTemp.computeMetrics()) {
      while (distance1 < pathMetric1.length) {
        var offset1 = pathMetric1.getTangentForOffset(distance1)?.position ??
            const Offset(0, 0);
        var radius = 0.0;
        if (distance1 < pathMetric1.length / 15) {
          radius = randomTime(1, 0.9);
        } else if (distance1 < pathMetric1.length / 10) {
          radius = randomTime(2, 0.9);
        } else if (distance1 < pathMetric1.length / 9) {
          radius = randomTime(2, 0.9);
        } else if (distance1 < pathMetric1.length / 8) {
          radius = randomTime(2, 0.8);
        } else if (distance1 < pathMetric1.length / 7) {
          radius = randomTime(2, 0.7);
        } else if (distance1 < pathMetric1.length / 6) {
          radius = randomTime(2, 0.6);
        } else if (distance1 < pathMetric1.length / 5) {
          radius = randomTime(2, 0.5);
        } else if (distance1 < pathMetric1.length / 4) {
          radius = randomTime(2, 0.4);
        } else if (distance1 < pathMetric1.length / 3) {
          radius = randomTime(2, 0.3);
        } else if (distance1 < pathMetric1.length / 3 + 5) {
          radius = randomTime(1, 0.2);
        }

        if (radius != 0.0) {
          dashPathTemp
              .addOval(Rect.fromCircle(center: offset1, radius: radius));
        }
        distance1 += dashWidth1;
        distance1 += dashSpace1;
      }
    }
    return dashPathTemp;
  }

  double randomTime(int time, double radius) {
    var radiusTemp = radius;
    for (var i = 0; i < time; i++) {
      if (Random().nextBool()) {
        radiusTemp = 0.0;
      }
    }
    return radiusTemp;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
