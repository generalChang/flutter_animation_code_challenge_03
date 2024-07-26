import 'package:flutter/material.dart';

class MusicPlayerDetailScreen extends StatefulWidget {
  final int index;
  const MusicPlayerDetailScreen({super.key, required this.index});

  @override
  State<MusicPlayerDetailScreen> createState() =>
      _MusicPlayerDetailScreenState();
}

class _MusicPlayerDetailScreenState extends State<MusicPlayerDetailScreen>
    with SingleTickerProviderStateMixin {
  final int runningTime = 179;
  late final AnimationController _progressController;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
        vsync: this, duration: Duration(seconds: runningTime))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  String _formattedTime({required int seconds}) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;

    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = remainingSeconds.toString().padLeft(2, '0');

    return '$minutesStr:$secondsStr';
  }

  // void _onProgressBarDragStart(DragStartDetails details) {
  //   final size = MediaQuery.of(context).size;
  //   final progressBarWidth = size.width - 80;
  //   final jumpToRunningTime = details.localPosition.dx / progressBarWidth;
  //
  //   _progressController.forward(from: jumpToRunningTime);
  // }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('interstella '),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          Align(
            alignment: Alignment.center,
            child: Hero(
                tag: '${widget.index}',
                child: Container(
                  width: 350,
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
                          image:
                              AssetImage('assets/covers/${widget.index}.jpg'))),
                )),
          ),
          SizedBox(
            height: 50,
          ),
          AnimatedBuilder(
            animation: _progressController,
            builder: (BuildContext context, Widget? child) {
              return CustomPaint(
                size: Size(
                  size.width - 80,
                  5,
                ),
                painter:
                    _ProgressBar(progressValue: _progressController.value),
              );
            },
          ),
          SizedBox(
            height: 10,
          ),
          AnimatedBuilder(
            animation: _progressController,
            builder: (BuildContext context, Widget? child) {
              final playingTime =
                  (_progressController.value * runningTime).toInt();
              final remainingTime = runningTime - playingTime;

              final formattedPlayingTime = _formattedTime(seconds: playingTime);
              final formattedRemainingTime =
                  _formattedTime(seconds: remainingTime);
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Row(
                  children: [
                    Text(
                      formattedPlayingTime,
                      style:
                          TextStyle(fontSize: 12, color: Colors.grey.shade500),
                    ),
                    const Spacer(),
                    Text(
                      formattedRemainingTime,
                      style:
                          TextStyle(fontSize: 12, color: Colors.grey.shade500),
                    )
                  ],
                ),
              );
            },
          ),
          SizedBox(
            height: 20,
          ),
          const Text(
            'interstelar',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _ProgressBar extends CustomPainter {
  final double progressValue;

  const _ProgressBar({
    required this.progressValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final progress = size.width * progressValue;

    //background bar
    final trackPint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.fill;

    final trackRRect =
        RRect.fromLTRBR(0, 0, size.width, size.height, Radius.circular(10));

    canvas.drawRRect(trackRRect, trackPint);

    //progress bar
    final progressPaint = Paint()
      ..color = Colors.grey.shade500
      ..style = PaintingStyle.fill;

    final progressRRect =
        RRect.fromLTRBR(0, 0, progress, size.height, Radius.circular(10));

    canvas.drawRRect(progressRRect, progressPaint);

    //thumb
    canvas.drawCircle(Offset(progress, size.height / 2), 10, progressPaint);
  }

  @override
  bool shouldRepaint(covariant _ProgressBar oldDelegate) {
    return oldDelegate.progressValue != progressValue;
  }
}
