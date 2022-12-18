import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class WordAudioPlayer extends StatefulWidget {
  final String audioUrl;
  const WordAudioPlayer({required this.audioUrl, Key? key}) : super(key: key);

  @override
  WordAudioPlayerState createState() => WordAudioPlayerState();
}

class WordAudioPlayerState extends State<WordAudioPlayer> {
  late final AudioPlayer player;
  bool isPlayed = false;

  @override
  void initState() {
    super.initState();
    setPlayer();
  }

  void setPlayer() {
    player = AudioPlayer();
    player.onPlayerComplete.listen((event) {
      setState(() {
        isPlayed = false;
      });
    });
  }

  _onPress() async {
    if (isPlayed) {
      setState(() {
        isPlayed = false;
      });
      player.stop();
    } else {
      setState(() {
        isPlayed = true;
      });
      await player.setSourceUrl(widget.audioUrl);
      player.resume();
    }
  }

  @override
  void dispose() {
    super.dispose();
    player.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: _onPress,
      icon: Icon(
        isPlayed ? Icons.stop_circle_outlined : Icons.volume_up_sharp,
      ),
    );
  }
}
