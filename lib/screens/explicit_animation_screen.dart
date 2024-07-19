import 'dart:async';

import 'package:flutter/material.dart';

class ExplicitAnimationScreen extends StatefulWidget {
  const ExplicitAnimationScreen({super.key});

  @override
  State<ExplicitAnimationScreen> createState() =>
      _ExplicitAnimationScreenState();
}

class _ExplicitAnimationScreenState extends State<ExplicitAnimationScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  )..addListener(() {
      // 컨트롤러가 애니메이팅 하는 값이 바뀔때마다 호출됨
      _value.value = _controller.value;
    });

  late final CurvedAnimation _curved =
      CurvedAnimation(parent: _controller, curve: Curves.elasticInOut);

  late final Animation<Decoration> _decoration = DecorationTween(
          begin: BoxDecoration(
              color: Colors.amber, borderRadius: BorderRadius.circular(20)),
          end: BoxDecoration(
              color: Colors.red, borderRadius: BorderRadius.circular(120)))
      .animate(_curved);

  late final Animation<double> _rotation =
      Tween(begin: 0.0, end: 2.0).animate(_curved);

  late final Animation<double> _scale =
      Tween(begin: 1.0, end: 1.1).animate(_curved);

  late final Animation<Offset> _offset =
      Tween(begin: Offset.zero, end: Offset(0, 0.5)).animate(_curved);

  void _play() {
    _controller.forward();
  }

  void _pause() {
    _controller.stop();
  }

  void _rewind() {
    _controller.reverse();
  }

  ValueNotifier _value = ValueNotifier(0.0);

  void _onChange(double value) {
    _controller.animateTo(value);
  }

  bool _looping = false;

  void _toggleLooping() {
    if (_looping) {
      _controller.stop();
    } else {
      _controller.repeat(reverse: true);
    }
    setState(() {
      _looping = !_looping;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('explicit animation screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SlideTransition(
              position: _offset,
              child: ScaleTransition(
                scale: _scale,
                child: RotationTransition(
                  turns: _rotation,
                  child: DecoratedBoxTransition(
                      decoration: _decoration,
                      child: SizedBox(
                        width: 400,
                        height: 400,
                      )),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: _play, child: Text('play')),
                ElevatedButton(onPressed: _pause, child: Text('pause')),
                ElevatedButton(onPressed: _rewind, child: Text('rewind')),
                ElevatedButton(
                    onPressed: _toggleLooping,
                    child: Text(_looping ? 'stop looping' : 'start looping')),
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            ValueListenableBuilder(
                valueListenable: _value,
                builder: (context, value, child) {
                  return Slider(value: value, onChanged: _onChange);
                })
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
