import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../../widgets/appbar/app_bar_widget.dart';

class PlayVideo extends StatefulWidget {
  final String nameConversion;
  final String path;

  const PlayVideo({
    Key? key,
    required this.nameConversion,
    required this.path,
  }) : super(key: key);

  @override
  State<PlayVideo> createState() => _PlayVideoState();
}

class _PlayVideoState extends State<PlayVideo> {
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _chewieController = ChewieController(
      videoPlayerController: VideoPlayerController.network(widget.path),
      // aspectRatio: 1,
      autoInitialize: true,
      autoPlay: true,
      looping: false,
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Column(
            children: [
              const Icon(Icons.error_outline),
              const SizedBox(height: 50),
              Text(
                errorMessage,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AppBarWidget(
            title: widget.nameConversion,
            onBackPressed: () {
              _chewieController.dispose();
              Navigator.of(context).pop();
            },
            colorIcon: Theme.of(context).iconTheme.color!,
            showBackButton: true,
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
              child: Chewie(controller: _chewieController),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _chewieController.dispose();
  }
}
