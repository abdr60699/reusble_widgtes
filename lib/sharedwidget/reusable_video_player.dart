
// reusable_video_player.dart
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// Simple video player wrapper using video_player package.
class ReusableVideoPlayer extends StatefulWidget {
  final String url; // network / asset path
  final bool autoPlay;
  final bool looping;

  const ReusableVideoPlayer({Key? key, required this.url, this.autoPlay = false, this.looping = false}) : super(key: key);

  @override
  State<ReusableVideoPlayer> createState() => _ReusableVideoPlayerState();
}

class _ReusableVideoPlayerState extends State<ReusableVideoPlayer> {
  VideoPlayerController? _controller;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        setState(() => _initialized = true);
        if (widget.autoPlay) _controller?.play();
      });
    _controller?.setLooping(widget.looping);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) return const Center(child: CircularProgressIndicator());
    return AspectRatio(
      aspectRatio: _controller!.value.aspectRatio,
      child: Stack(
        children: [
          VideoPlayer(_controller!),
          Align(
            alignment: Alignment.bottomCenter,
            child: VideoProgressIndicator(_controller!, allowScrubbing: true),
          ),
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  if (_controller!.value.isPlaying) _controller!.pause();
                  else _controller!.play();
                });
              },
              child: Center(
                child: Icon(
                  _controller!.value.isPlaying ? Icons.pause_circle : Icons.play_circle,
                  size: 56,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
