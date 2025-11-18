
// reusable_audio_player.dart
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

/// Simple audio player controls using audioplayers package.
class ReusableAudioPlayer extends StatefulWidget {
  final String url;
  final bool autoPlay;

  const ReusableAudioPlayer({Key? key, required this.url, this.autoPlay = false}) : super(key: key);

  @override
  State<ReusableAudioPlayer> createState() => _ReusableAudioPlayerState();
}

class _ReusableAudioPlayerState extends State<ReusableAudioPlayer> {
  final AudioPlayer _player = AudioPlayer();
  PlayerState _state = PlayerState.stopped;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _player.onPlayerStateChanged.listen((s) => setState(() => _state = s));
    _player.onDurationChanged.listen((d) => setState(() => _duration = d));
    _player.onPositionChanged.listen((p) => setState(() => _position = p));
    if (widget.autoPlay) _player.play(UrlSource(widget.url));
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPlaying = _state == PlayerState.playing;
    return Row(
      children: [
        IconButton(
          icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
          onPressed: () {
            if (isPlaying) _player.pause();
            else _player.play(UrlSource(widget.url));
          },
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Slider(
                value: _position.inMilliseconds.toDouble().clamp(0, _duration.inMilliseconds.toDouble()),
                max: _duration.inMilliseconds.toDouble().clamp(1, double.infinity),
                onChanged: (v) {
                  _player.seek(Duration(milliseconds: v.toInt()));
                },
              ),
              Text('${_position.toString().split('.').first} / ${_duration.toString().split('.').first}', style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ],
    );
  }
}
