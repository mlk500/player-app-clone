import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../model/task_model.dart';
import '../screens/audioWidget.dart';

class MediaWidget extends StatelessWidget {
  final Media media;

  const MediaWidget({Key? key, required this.media}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double mediaSize = constraints.maxWidth > 600 ? 150 : 100;
        switch (media.mediaType) {
          case 'image/png':
          case 'image/jpeg':
            return _buildImage(media, mediaSize);
          case 'video/mp4':
          case 'video/quicktime':
           case 'video/mov':
            return VideoWidget(videoUrl: media.mediaUrl);
          case 'audio/mpeg':
          case 'audio/wav':
          case 'audio/flac':
          
            return AudioWidget(audioUrl: media.mediaUrl);
          default:
            return const Text('Unsupported media type');
        }
      },
    );
  }

  Widget _buildImage(Media media, double mediaSize) {
    return SizedBox(
      width: mediaSize,
      height: mediaSize,
      child: Image.network(
        media.mediaUrl,
        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                  : null,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Text('Error loading image: $error');
        },
      ),
    );
  }
}


class VideoWidget extends StatefulWidget {
  final String videoUrl;

  const VideoWidget({super.key, required this.videoUrl});

  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final videoWidth = screenWidth * 0.75; // 80% of the screen width
    final videoHeight = videoWidth / (16 / 9); // Adjust the height based on a 16:9 aspect ratio

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _controller.value.isInitialized
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8.0), // Optional: round corners
                child: SizedBox(
                  width: videoWidth,
                  height: videoHeight,
                  child: VideoPlayer(_controller),
                ),
              )
            : const CircularProgressIndicator(),
        if (_controller.value.isInitialized)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: VideoProgressIndicator(_controller, allowScrubbing: true),
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.replay_10),
              onPressed: () {
                final position = _controller.value.position;
                _controller.seekTo(position - const Duration(seconds: 10));
              },
            ),
            IconButton(
              icon: Icon(
                _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
              ),
              onPressed: () {
                setState(() {
                  _controller.value.isPlaying ? _controller.pause() : _controller.play();
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.restart_alt),
              onPressed: () {
                _controller.seekTo(Duration.zero);
                _controller.play();
              },
            ),
            IconButton(
              icon: const Icon(Icons.stop),
              onPressed: () {
                _controller.pause();
                _controller.seekTo(Duration.zero);
              },
            ),
          ],
        ),
      ],
    );
  }

}
