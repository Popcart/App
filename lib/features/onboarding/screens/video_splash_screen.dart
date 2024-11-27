import 'package:flutter/material.dart';
import 'package:popcart/gen/assets.gen.dart';

class VideoSplashScreen extends StatelessWidget {
  const VideoSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppAssets.images.onboardingVideo.image(
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }
}
