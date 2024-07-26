import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animations_masterclass/screens/music_player_detail_screen.dart';

class MusicPlayerScreen extends StatefulWidget {
  const MusicPlayerScreen({super.key});

  @override
  State<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  final PageController _pageController = PageController(viewportFraction: 0.8);

  int _currentPage = 0;

  ValueNotifier<double> _scroll = ValueNotifier(0.0);

  void _onPageChanged(int newPage) {
    setState(() {
      _currentPage = newPage;
    });
  }

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      if (_pageController.page == null) return;
      _scroll.value = _pageController.page!;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTap(int index) {
    Navigator.of(context).push(PageRouteBuilder(
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return FadeTransition(
            opacity: animation, child: MusicPlayerDetailScreen(index: index));
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Container(
              key: ValueKey(_currentPage),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image:
                          AssetImage('assets/covers/${_currentPage + 1}.jpg'))),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              color: Colors.black.withOpacity(0.5),
            ),
          ),
          PageView.builder(
            onPageChanged: _onPageChanged,
            controller: _pageController,
            itemBuilder: (context, index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ValueListenableBuilder(
                    valueListenable: _scroll,
                    builder: (BuildContext context, scroll, Widget? child) {
                      final difference = (scroll - index).abs();
                      final scale = 1 - difference * 0.2;
                      return GestureDetector(
                        onTap: () {
                          _onTap(index + 1);
                        },
                        child: Hero(
                          tag: '${index + 1}',
                          child: Transform.scale(
                            scale: scale,
                            child: Container(
                              height: 350,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.5),
                                        blurRadius: 10,
                                        spreadRadius: 2,
                                        offset: Offset(0, 8))
                                  ],
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage(
                                          'assets/covers/${index + 1}.jpg'))),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    'Interstella',
                    style: TextStyle(fontSize: 26, color: Colors.white),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Hans jimmber',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  )
                ],
              );
            },
            itemCount: 5,
            scrollDirection: Axis.horizontal,
          )
        ],
      ),
    );
  }
}
