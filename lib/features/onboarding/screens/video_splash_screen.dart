import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:popcart/core/colors.dart';
import 'package:popcart/gen/assets.gen.dart';
import 'package:popcart/l10n/arb/app_localizations.dart';
import 'package:popcart/route/route_constants.dart';
import 'package:video_player/video_player.dart';

class VideoSplashScreen extends StatefulWidget {
  const VideoSplashScreen({super.key});

  @override
  State<VideoSplashScreen> createState() => _VideoSplashScreenState();
}

class _VideoSplashScreenState extends State<VideoSplashScreen>
    with WidgetsBindingObserver {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initVideoPlayer();
    });
  }

  void initVideoPlayer() {
    _controller = VideoPlayerController.asset(AppAssets.animations.splashAnimation)
      ..setVolume(0)
      ..setLooping(true);

    _controller!.initialize().then((_) {
      if (mounted) {
        setState(() {});
        _controller!.play();
      }
    }).catchError((e) {
      debugPrint('Video player init error: $e');
    });
  }


  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
        _pauseVideo();
      case AppLifecycleState.resumed:
        _playVideo();
      default:
        break;
    }
  }

  Future<void> _playVideo() async {
    if (!mounted) return;
    if (!_controller!.value.isInitialized) return;
    if (_controller!.value.isPlaying) return;
    try {
      await _controller!.play();
      if (!_controller!.value.isLooping) await _controller!.setLooping(true);
    } on PlatformException catch (e) {}
  }

  void _pauseVideo() {
    if (!_controller!.value.isInitialized) return;
    if (!_controller!.value.isPlaying) return;
    _controller!.pause();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (_controller == null || !_controller!.value.isInitialized) {
      return Container(
        color: AppColors.orange,
      );
    }
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          Positioned.fill(
            child: _controller!.value.isInitialized
                ? FittedBox(
                    fit: BoxFit.fitHeight,
                    child: SizedBox(
                      width: _controller!.value.size.width,
                      height: _controller!.value.size.height,
                      child: AspectRatio(
                          aspectRatio: _controller!.value.aspectRatio,
                          child: VideoPlayer(_controller!)),
                    ),
                  )
                : Container(),
          ),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Spacer(),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, loginScreenRoute);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffEDEAE9),
                      ),
                      child: Text(
                        l10n.get_started,
                        style: const TextStyle(
                          color: Color(0xffF97316),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    l10n.get_started_sub,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
