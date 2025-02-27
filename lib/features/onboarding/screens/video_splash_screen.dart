import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:popcart/app/router_paths.dart';
import 'package:popcart/core/widgets/animated_widgets.dart';
import 'package:popcart/l10n/arb/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: const Color(0xff111214),
      body: Stack(
        children: [
          Positioned.fill(
            child: switch (loading) {
              true => const SizedBox(),
              false => Image.file(
                  splashVideoFile,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                )
            },
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
