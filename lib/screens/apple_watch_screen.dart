import 'dart:math';

import 'package:flutter/material.dart';

class AppleWatchScreen extends StatefulWidget {
  const AppleWatchScreen({super.key});

  @override
  State<AppleWatchScreen> createState() => _AppleWatchScreenState();
}

class _AppleWatchScreenState extends State<AppleWatchScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  late CurvedAnimation _curve;

  late Animation<double> _redCircleProgressAnimation;
  late Animation<double> _greenCircleProgressAnimation;
  late Animation<double> _blueCircleProgressAnimation;

  @override
  void initState() {
    super.initState();

    final random = Random();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    )..forward();

    _curve =
        CurvedAnimation(parent: _animationController, curve: Curves.bounceOut);

    // value is  >= 0.005  and  < 2.0
    final redCircleProgressEnd = random.nextDouble() * 1.995 + 0.005;
    final greenCircleProgressEnd = random.nextDouble() * 1.995 + 0.005;
    final blueCircleProgressEnd = random.nextDouble() * 1.995 + 0.005;

    _redCircleProgressAnimation =
        Tween<double>(begin: 0.005, end: redCircleProgressEnd).animate(_curve);

    _greenCircleProgressAnimation =
        Tween<double>(begin: 0.005, end: greenCircleProgressEnd)
            .animate(_curve);

    _blueCircleProgressAnimation =
        Tween<double>(begin: 0.005, end: blueCircleProgressEnd).animate(_curve);
  }

  void _animateValues() {
    final redCircleNewStart = _redCircleProgressAnimation.value;
    final greenCircleNewStart = _greenCircleProgressAnimation.value;
    final blueCircleNewStart = _blueCircleProgressAnimation.value;

    final random = Random();

    final redCircleProgressEnd = random.nextDouble() * 1.995 + 0.005;
    final greenCircleProgressEnd = random.nextDouble() * 1.995 + 0.005;
    final blueCircleProgressEnd = random.nextDouble() * 1.995 + 0.005;
    setState(() {
      _redCircleProgressAnimation =
          Tween<double>(begin: redCircleNewStart, end: redCircleProgressEnd)
              .animate(_curve);

      _greenCircleProgressAnimation =
          Tween<double>(begin: greenCircleNewStart, end: greenCircleProgressEnd)
              .animate(_curve);

      _blueCircleProgressAnimation =
          Tween<double>(begin: blueCircleNewStart, end: blueCircleProgressEnd)
              .animate(_curve);
    });

    _animationController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('apple watch'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _animateValues,
        child: Icon(Icons.refresh),
      ),
      body: Center(
          // CustomPaint는 커스텀 페인터를 그리는 캔버스 위젯임
          child: AnimatedBuilder(
        animation: Listenable.merge([
          _redCircleProgressAnimation,
          _greenCircleProgressAnimation,
          _blueCircleProgressAnimation
        ]),
        builder: (BuildContext context, Widget? child) {
          return CustomPaint(
            painter: AppleWatchPainter(
                redCircleProgress: _redCircleProgressAnimation.value,
                greenCircleProgress: _greenCircleProgressAnimation.value,
                blueCircleProgress: _blueCircleProgressAnimation.value),
            size: const Size(400, 400),
          );
        },
      )),
    );
  }
}

// CustomPainter : 화면에 그리고 싶은 것을 커스텀하게 표현할 수 있음.
class AppleWatchPainter extends CustomPainter {
  final double redCircleProgress;
  final double greenCircleProgress;
  final double blueCircleProgress;

  const AppleWatchPainter(
      {required this.redCircleProgress,
      required this.greenCircleProgress,
      required this.blueCircleProgress});

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint

    final center = Offset(size.width / 2, size.height / 2);
    final redCirclePaint = Paint()
      ..color = Colors.red.shade500.withOpacity(0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 25;

    final redCircleRadius = (size.width / 2) * 0.9;
    final greenCircleRadius = (size.width / 2) * 0.76;
    final blueCircleRadius = (size.width / 2) * 0.62;

    const startingAngle = -0.5 * pi;

    canvas.drawCircle(center, redCircleRadius, redCirclePaint);

    final greenCirclePaint = Paint()
      ..color = Colors.green.shade500.withOpacity(0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 25;

    canvas.drawCircle(center, greenCircleRadius, greenCirclePaint);

    final blueCirclePaint = Paint()
      ..color = Colors.blue.shade500.withOpacity(0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 25;

    canvas.drawCircle(center, blueCircleRadius, blueCirclePaint);

    final redArcRect = Rect.fromCircle(
      center: center,
      radius: redCircleRadius,
    );
    final redArcPaint = Paint()
      ..color = Colors.red.shade400
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 25;
    canvas.drawArc(
        redArcRect, startingAngle, redCircleProgress * pi, false, redArcPaint);

    final greenArcRect = Rect.fromCircle(
      center: center,
      radius: greenCircleRadius,
    );
    final greenArcPaint = Paint()
      ..color = Colors.green.shade400
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 25;

    canvas.drawArc(greenArcRect, startingAngle, greenCircleProgress * pi, false,
        greenArcPaint);

    final blueArcRect = Rect.fromCircle(
      center: center,
      radius: blueCircleRadius,
    );
    final blueArcPaint = Paint()
      ..color = Colors.blue.shade400
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 25;

    canvas.drawArc(blueArcRect, startingAngle, blueCircleProgress * pi, false,
        blueArcPaint);
  }

  @override
  bool shouldRepaint(covariant AppleWatchPainter oldDelegate) {
    return oldDelegate.redCircleProgress != redCircleProgress ||
        oldDelegate.greenCircleProgress != greenCircleProgress ||
        oldDelegate.blueCircleProgress != blueCircleProgress;
  }
}
