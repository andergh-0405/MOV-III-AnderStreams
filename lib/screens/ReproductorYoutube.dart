import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class Reproductoryoutube extends StatefulWidget {
  final String url;
  const Reproductoryoutube({required this.url, super.key});

  @override
  State<Reproductoryoutube> createState() => _ReproductoryoutubeState();
}

class _ReproductoryoutubeState extends State<Reproductoryoutube> {
  late YoutubePlayerController _controller;
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    String? videoId = _extraerId(widget.url);

    if (videoId != null && videoId.isNotEmpty) {
      _controller = YoutubePlayerController.fromVideoId(
        videoId: videoId,
        autoPlay: true,
        params: const YoutubePlayerParams(
          showControls: true,
          showFullscreenButton: true,
          mute: false,
        ),
      );
    } else {
      _isError = true;
    }
  }

  String? _extraerId(String url) {
    return YoutubePlayerController.convertUrlToId(url);
  }

  @override
  void dispose() {
    if (!_isError) {
      try {
        _controller.close();
      } catch (e) {}
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isError) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: const Center(
          child: Text(
            "Error al cargar el video.\nEl enlace no es válido.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 18),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: YoutubePlayer(controller: _controller, aspectRatio: 16 / 9),
      ),
    );
  }
}
