import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class Reproductorpeliculasscreen extends StatefulWidget {
  
  final String videoUrl;
  final String thumbnail;

  const Reproductorpeliculasscreen({
    required this.videoUrl,
    required this.thumbnail,
    super.key,
  });

  @override
  State<Reproductorpeliculasscreen> createState() => _ReproductorpeliculasscreenState();
}

class _ReproductorpeliculasscreenState extends State<Reproductorpeliculasscreen> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  
  bool _reproduciendo = false;
  bool _cargandoVideo = false;

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  Future<void> _iniciarVideo() async {
    if (widget.videoUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Esta película no tiene video disponible"), backgroundColor: Colors.orange),
      );
      return;
    }

    setState(() => _cargandoVideo = true);

    try {
      _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
      await _videoPlayerController!.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        autoPlay: true,
        looping: false,
        aspectRatio: _videoPlayerController!.value.aspectRatio,
        materialProgressColors: ChewieProgressColors(
          playedColor: Colors.red,
          handleColor: Colors.red,
          backgroundColor: Colors.grey,
          bufferedColor: Colors.white30,
        ),
      );

      setState(() {
        _reproduciendo = true;
        _cargandoVideo = false;
      });
    } catch (e) {
      setState(() => _cargandoVideo = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error al cargar el video"), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 230, // Altura del reproductor
      color: Colors.black,
      child: _reproduciendo && _chewieController != null
          ? Chewie(controller: _chewieController!)
          : Stack(
              alignment: Alignment.center,
              children: [
                Image.network(
                  widget.thumbnail,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  opacity: const AlwaysStoppedAnimation(0.6),
                ),
                _cargandoVideo
                    ? const CircularProgressIndicator(color: Colors.red)
                    : IconButton(
                        iconSize: 70,
                        icon: const Icon(Icons.play_circle_fill, color: Colors.red),
                        onPressed: _iniciarVideo,
                      ),
              ],
            ),
    );
  }
}