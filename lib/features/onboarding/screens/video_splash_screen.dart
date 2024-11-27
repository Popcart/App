import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class VideoSplashScreen extends StatefulWidget {
  const VideoSplashScreen({super.key});

  @override
  State<VideoSplashScreen> createState() => _VideoSplashScreenState();
}

class _VideoSplashScreenState extends State<VideoSplashScreen> {
  late final File splashVideoFile;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    getSplashFile();
  }

  Future<void> getSplashFile() async {
    final savePath = await getTemporaryDirectory();
    final filePath = '${savePath.path}/splash.gif';
    splashVideoFile = File(filePath);
    loading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff111214),
      body: switch (loading) {
        true => const SizedBox(),
        false => Image.file(
            splashVideoFile,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          )
      },
    );
  }
}
