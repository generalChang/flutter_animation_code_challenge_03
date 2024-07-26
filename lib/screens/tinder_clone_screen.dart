import 'dart:math';

import 'package:flutter/material.dart';

// 복습용으로 만들었습니다.
class TinderCloneScreen extends StatefulWidget {
  const TinderCloneScreen({super.key});

  @override
  State<TinderCloneScreen> createState() => _TinderCloneScreenState();
}

class _TinderCloneScreenState extends State<TinderCloneScreen>
    with SingleTickerProviderStateMixin {
  late final size = MediaQuery.of(context).size;

  late final AnimationController _animationController = AnimationController(
      vsync: this,
      lowerBound: -(size.width + 100),
      upperBound: size.width + 100,
      duration: const Duration(milliseconds: 1000),
      value: 0.0);

  late final Tween<double> _cardRotation = Tween(
    begin: -15.0,
    end: 15.0,
  );

  late final Tween<double> _cardScale = Tween(begin: 0.8, end: 1.0);

  late final Tween<double> _closeButtonScale = Tween(begin: 1.0, end: 1.3);
  late final Tween<double> _checkButtonScale = Tween(begin: 1.0, end: 1.3);
  late final Tween<double> _closeButtonOpacity = Tween(begin: 0.0, end: 1.0);
  late final Tween<double> _checkButtonOpacity = Tween(begin: 0.0, end: 1.0);

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    final positionX = details.delta.dx;
    _animationController.value += positionX;
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    final dropzone = size.width - 170;
    final factor = _animationController.value.isNegative ? -1 : 1;

    if (_animationController.value.abs() > dropzone) {
      _animationController
          .animateTo((size.width + 100) * factor, curve: Curves.bounceOut)
          .whenComplete(_whenCardGoOutComplete);
    } else {
      _animationController.animateTo(0, curve: Curves.bounceOut);
    }
  }

  void _whenCardGoOutComplete() {
    setState(() {
      _animationController.value = 0;
      _haniImageIndex =
          _haniImageIndex == _haniImageLength ? 1 : _haniImageIndex + 1;
    });
  }

  void _onClosebuttonTap() {
    _animationController
        .animateTo((size.width + 100) * -1, curve: Curves.easeOut)
        .whenComplete(_whenCardGoOutComplete);
  }

  void _onCheckbuttonTap() {
    _animationController
        .animateTo(size.width + 100, curve: Curves.easeOut)
        .whenComplete(_whenCardGoOutComplete);
  }

  final int _haniImageLength = 7;
  int _haniImageIndex = 1;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Newjeans Hani'),
      ),
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (BuildContext context, Widget? child) {
          // 첫 앵글은 0도여야한다. (animation timeline은 0.5에 위치해있어야함)
          // animation timeline의 범위는 0~1이어야한다. 그러면 transform 을 통해 보간된 값을 받을 수 있따.
          final angle = _cardRotation.transform(
                  (_animationController.value / size.width + 1) / 2) /
              180 *
              pi;

          final scale = _cardScale
              .transform((_animationController.value.abs() / size.width));

          final closeButtonScale = _closeButtonScale.transform(
              _animationController.value.isNegative
                  ? _animationController.value.abs() / size.width
                  : 0.0);
          final closeButtonOpacity = _closeButtonOpacity.transform(
              _animationController.value.isNegative
                  ? _animationController.value.abs() / size.width
                  : 0.0);

          final checkButtonScale = _checkButtonScale.transform(
              _animationController.value > 0
                  ? _animationController.value / size.width
                  : 0.0);

          final checkButtonOpacity = _checkButtonOpacity.transform(
              _animationController.value > 0
                  ? _animationController.value / size.width
                  : 0.0);

          return Stack(
            alignment: Alignment.topCenter,
            children: [
              Positioned(
                top: 70,
                child: Transform.scale(
                  scale: min(scale, 1.0),
                  child: _TinderCard(
                    imageIndex: _haniImageIndex == _haniImageLength
                        ? 1
                        : _haniImageIndex + 1,
                  ),
                ),
              ),
              Positioned(
                top: 70,
                child: Transform.rotate(
                  angle: angle,
                  child: Transform.translate(
                    offset: Offset(_animationController.value, 0),
                    child: GestureDetector(
                      onHorizontalDragUpdate: _onHorizontalDragUpdate,
                      onHorizontalDragEnd: _onHorizontalDragEnd,
                      child: _TinderCard(
                        imageIndex: _haniImageIndex,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                  bottom: size.height * 0.1,
                  child: Row(
                    children: [
                      Transform.scale(
                        scale: min(closeButtonScale, 1.3),
                        child: _TinderButton(
                          icon: Icons.close,
                          opacity: min(closeButtonOpacity, 1.0),
                          onTap: _onClosebuttonTap,
                          primaryColor: Colors.red.shade500,
                        ),
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      Transform.scale(
                        scale: min(checkButtonScale, 1.3),
                        child: _TinderButton(
                          icon: Icons.check,
                          opacity: min(checkButtonOpacity, 1.0),
                          onTap: _onCheckbuttonTap,
                          primaryColor: Colors.green.shade500,
                        ),
                      ),
                    ],
                  ))
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }
}

class _TinderCard extends StatelessWidget {
  final int imageIndex;
  const _TinderCard({required this.imageIndex});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: size.width * 0.8,
        height: size.height * 0.5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
              image: AssetImage('assets/images/hani_${imageIndex}.jpg'),
              fit: BoxFit.cover),
        ),
      ),
    );
  }
}

class _TinderButton extends StatelessWidget {
  final Color primaryColor;
  final double opacity;
  final IconData icon;
  final VoidCallback onTap;
  const _TinderButton(
      {super.key,
      required this.primaryColor,
      required this.opacity,
      required this.icon,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Material(
        borderRadius: BorderRadius.circular(30),
        elevation: 10,
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
              border: Border.all(width: 6, color: Colors.white),
              color: primaryColor.withOpacity(opacity),
              borderRadius: BorderRadius.circular(30)),
          child: Icon(
            icon,
            size: 40,
            color: opacity > 0.5 ? Colors.white : primaryColor,
          ),
        ),
      ),
    );
  }
}
