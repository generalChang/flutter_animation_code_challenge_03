import 'dart:math';

import 'package:flutter/material.dart';

class SwipingCardScreen extends StatefulWidget {
  const SwipingCardScreen({super.key});

  @override
  State<SwipingCardScreen> createState() => _SwipingCardScreenState();
}

class _SwipingCardScreenState extends State<SwipingCardScreen>
    with SingleTickerProviderStateMixin {
  late final size = MediaQuery.of(context).size;

  late final AnimationController _position = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
      lowerBound: (size.width + 100) * -1,
      upperBound: (size.width + 100),
      value: 0.0);

  late final Tween<double> _rotation = Tween(begin: -15, end: 15);

  late final Tween<double> _scale = Tween(begin: 0.8, end: 1);

  late final Tween<double> _closeButtonScale = Tween(begin: 1.0, end: 1.2);
  late final Tween<double> _checkButtonScale = Tween(begin: 1.0, end: 1.2);

  late final Tween<double> _closeButtonOpacity = Tween(begin: 0.0, end: 1.0);

  late final Tween<double> _checkbuttonOpacity = Tween(begin: 0.0, end: 1.0);

  int _index = 1;

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    // details.delta : 드래그가 발생할때마다 움직인 양
    _position.value += details.delta.dx;
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    final bound = size.width - 150;
    final dropZone = size.width + 100;
    if (_position.value.abs() >= bound) {
      final factor = _position.value.isNegative ? -1 : 1;
      _position.animateTo(dropZone * factor).whenComplete(_whenComplete);
    } else {
      _position.animateTo(0, curve: Curves.bounceOut);
    }
  }

  void _onButtonTap({required int factor}) {
    final dropZone = size.width + 100;
    _position
        .animateTo(dropZone * factor, curve: Curves.easeOut)
        .whenComplete(_whenComplete);
  }

  void _whenComplete() {
    _position.value = 0;
    setState(() {
      _index = _index == 5 ? 1 : _index + 1;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _position.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('swiping card'),
      ),
      body: AnimatedBuilder(
        animation: _position,
        builder: (BuildContext context, Widget? child) {
          // 0 ~ 1에 대응되는 보간된 rotation value 값을 반환한다.
          final angle =
              _rotation.transform((_position.value / size.width + 1) / 2) *
                  pi /
                  180;

          final scale = _scale.transform(_position.value.abs() / size.width);

          final closeButtonInterval = _position.value.isNegative
              ? _position.value.abs() / size.width
              : 0.0;

          final checkButtonInterval =
              _position.value > 0 ? _position.value / size.width : 0.0;

          final closeButtonScale =
              _closeButtonScale.transform(closeButtonInterval);

          final closeButtonOpacity =
              _closeButtonOpacity.transform(closeButtonInterval);

          final checkButtonScale =
              _checkButtonScale.transform(checkButtonInterval);

          final checkButtonOpacity =
              _checkbuttonOpacity.transform(checkButtonInterval);

          return Stack(
            alignment: Alignment.topCenter,
            children: [
              Positioned(
                top: 100,
                child: Transform.scale(
                    scale: min(scale, 1.0),
                    child: Card(index: _index == 5 ? 1 : _index + 1)),
              ),
              Positioned(
                top: 100,
                child: GestureDetector(
                  onHorizontalDragUpdate: _onHorizontalDragUpdate,
                  onHorizontalDragEnd: _onHorizontalDragEnd,
                  child: Transform.translate(
                    offset: Offset(_position.value, 0),
                    child: Transform.rotate(
                        angle: angle,
                        child: Card(
                          index: _index,
                        )),
                  ),
                ),
              ),
              Positioned(
                  bottom: size.height * 0.1,
                  width: size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Transform.scale(
                        scale: min(closeButtonScale, 1.2),
                        child: SwipeButton(
                            onTap: () {
                              _onButtonTap(factor: -1);
                            },
                            primaryColor: Colors.red.shade500,
                            icon: Icons.close,
                            opacity: min(closeButtonOpacity, 1.0)),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Transform.scale(
                        scale: min(checkButtonScale, 1.2),
                        child: SwipeButton(
                            onTap: () {
                              _onButtonTap(factor: 1);
                            },
                            primaryColor: Colors.green.shade500,
                            icon: Icons.check,
                            opacity: min(checkButtonOpacity, 1.0)),
                      ),
                    ],
                  ))
            ],
          );
        },
      ),
    );
  }
}

class Card extends StatelessWidget {
  final int index;

  const Card({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(10),
      clipBehavior: Clip.hardEdge,
      child: SizedBox(
        width: size.width * 0.8,
        height: size.height * 0.5,
        child: Image.asset(
          'assets/covers/${index}.jpg',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class SwipeButton extends StatelessWidget {
  // 버튼의 메인 컬러
  final Color primaryColor;
  // 버튼의 아이콘
  final IconData icon;
  // 버튼의 투명도
  final double opacity;
  // 버튼 제스쳐 핸들러
  final VoidCallback onTap;

  const SwipeButton(
      {super.key,
      required this.onTap,
      required this.primaryColor,
      required this.icon,
      required this.opacity});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Material(
        elevation: 10,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(opacity),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white, width: 5),
          ),
          child: Icon(
            icon,
            color: opacity > 0.7 ? Colors.white : primaryColor,
            size: 40,
          ),
        ),
      ),
    );
  }
}
