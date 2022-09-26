import 'dart:isolate';

import 'package:flutter/material.dart';

import '../isolates/logo_main_loop.dart';

class AnimatedLogo extends StatefulWidget {
  const AnimatedLogo({
    required this.text,
    Key? key,
  }) : super(key: key);

  final String text;

  @override
  State<AnimatedLogo> createState() => _AnimatedLogoState();
}

class _AnimatedLogoState extends State<AnimatedLogo> {
  double positionX = 0;

  late ReceivePort _receivePort;
  late Isolate _isolateLoop;

  @override
  void initState() {
    super.initState();
    startIsolateLoop();
  }

  void startIsolateLoop() async {
    _receivePort = ReceivePort();
    _isolateLoop = await Isolate.spawn(
      animatedLogoLoop,
      _receivePort.sendPort,
    );
    _receivePort.listen((isRunning) {
      if (isRunning) {
        setState(() {
          positionX = positionX > 150 ? 0 : positionX + 0.5;
        });
      }
    });
  }

  @override
  void dispose() {
    _receivePort.close();
    _isolateLoop.kill(priority: 0);
    super.dispose();
  }

  TextStyle getTextStyle() => TextStyle(
        color: Theme.of(context).colorScheme.primary,
        fontStyle: FontStyle.italic,
        fontSize: 15,
        fontWeight: FontWeight.bold,
      );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Image.asset(
            'assets/images/logo.png',
          ),
          Positioned(
            left: positionX,
            child: Text(
              widget.text,
              style: getTextStyle(),
            ),
          ),
          Positioned(
            left: positionX - 150,
            child: Text(
              widget.text,
              style: getTextStyle(),
            ),
          )
        ],
      ),
    );
  }
}
