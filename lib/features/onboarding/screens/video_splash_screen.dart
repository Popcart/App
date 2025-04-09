import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:popcart/app/router_paths.dart';
import 'package:popcart/core/colors.dart';
import 'package:popcart/core/widgets/animated_widgets.dart';
import 'package:popcart/l10n/arb/app_localizations.dart';
import 'package:video_player/video_player.dart';

class VideoSplashScreen extends StatefulWidget {
  const VideoSplashScreen({super.key});

  @override
  State<VideoSplashScreen> createState() => _VideoSplashScreenState();
}

class _VideoSplashScreenState extends State<VideoSplashScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset("assets/animations/popcart.mp4");
    _controller..addListener(() {
      setState(() {});
    })
    ..setLooping(true);
    _controller.initialize().then((_) => setState(() {}));
    _controller.play();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.orange,
      body: Stack(
        children: [
          // Positioned.fill(
          //   child: switch (loading) {
          //     true => const SizedBox(),
          //     false => Image.file(
          //         splashVideoFile,
          //         width: double.infinity,
          //         height: double.infinity,
          //         fit: BoxFit.cover,
          //       )
          //   },
          // ),
          Positioned.fill(
            child: _controller.value.isInitialized
                ? FittedBox(
              fit: BoxFit.fitWidth,
              child: SizedBox(
                width: _controller.value.size.width,
                height: _controller.value.size.height,
                child: Container(
                  padding: const EdgeInsets.only(left: 0.0, top: 15),
                  child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller)),
                ),
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
                  // const SizedBox(
                  //   width: double.infinity,
                  // ),
                  BouncingEffect(
                    onTap: () {
                      _controller.pause();
                      context.push(AppPath.auth.path);
                    },
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: ElevatedButton(
                        onPressed: () {
                          // context.go(AppPath.auth.path);
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
