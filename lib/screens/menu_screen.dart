import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animations_masterclass/screens/apple_watch_screen.dart';
import 'package:flutter_animations_masterclass/screens/explicit_animation_screen.dart';
import 'package:flutter_animations_masterclass/screens/implicit_animation_screen.dart';
import 'package:flutter_animations_masterclass/screens/music_player_screen.dart';
import 'package:flutter_animations_masterclass/screens/tinder_clone_screen.dart';
import 'package:flutter_animations_masterclass/screens/swiping_card_screen.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  void _goToScreen({required BuildContext context, required Widget screen}) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => screen));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('flutter animation'),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () {
                  _goToScreen(
                      context: context, screen: ImplicitAnimationScreen());
                },
                child: Text('Implicit animations')),
            ElevatedButton(
                onPressed: () {
                  _goToScreen(
                      context: context, screen: ExplicitAnimationScreen());
                },
                child: Text('explicit animations')),
            ElevatedButton(
                onPressed: () {
                  _goToScreen(context: context, screen: AppleWatchScreen());
                },
                child: Text('apple watch')),
            ElevatedButton(
                onPressed: () {
                  _goToScreen(context: context, screen: SwipingCardScreen());
                },
                child: Text('swiping card')),
            ElevatedButton(
                onPressed: () {
                  _goToScreen(context: context, screen: TinderCloneScreen());
                },
                child: Text('tinder clone')),
            ElevatedButton(
                onPressed: () {
                  _goToScreen(context: context, screen: MusicPlayerScreen());
                },
                child: Text('music player')),
          ],
        ),
      ),
    );
  }
}
