import 'dart:typed_data';
import 'dart:ui';

import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:popcart/core/colors.dart';
import 'package:popcart/core/utils.dart';
import 'package:popcart/core/widgets/buttons.dart';
import 'package:popcart/features/seller/models/video_post_response.dart';

class PostReels extends StatefulWidget {
  const PostReels({required this.video, required this.isActive, super.key});

  final VideoPost video;
  final bool isActive;

  @override
  State<PostReels> createState() => _PostReelsState();
}

class _PostReelsState extends State<PostReels>
    with AutomaticKeepAliveClientMixin {
  late CachedVideoPlayerPlusController _videoPlayerController;
  late ValueNotifier<bool> isPlaying;
  late final ScrollController scrollController;
  late ValueNotifier<Uint8List?> thumbnailNotifier;

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    isPlaying = ValueNotifier(false);
    scrollController = ScrollController();
    thumbnailNotifier = ValueNotifier(null);
    configureVideo();
  }

  void configureVideo() {
    generateThumbnail(widget.video.video).then((thumb) {
      thumbnailNotifier.value = thumb;
    });
    _videoPlayerController = CachedVideoPlayerPlusController.networkUrl(
      Uri.parse(widget.video.video),
      invalidateCacheIfOlderThan: const Duration(days: 7),
    )
      ..addListener(_videoListener)
      ..initialize().then((_) {
        if (mounted && widget.isActive) {
          _videoPlayerController.play();
          setState(() {});
        }
      });
  }

  @override
  void dispose() {
    super.dispose();
    thumbnailNotifier.dispose();
    scrollController.dispose();
    isPlaying.dispose();
    if (_videoPlayerController.value.isInitialized) {
      _videoPlayerController
        ..removeListener(_videoListener)
        ..dispose();
    }
  }

  void _videoListener() {
    final position = _videoPlayerController.value.position;
    final duration = _videoPlayerController.value.duration;

    if (_videoPlayerController.value.isInitialized &&
        !_videoPlayerController.value.isPlaying &&
        position >= duration) {
      _videoPlayerController
        ..seekTo(Duration.zero)
        ..play();
      setState(() {});
    }
    isPlaying.value = _videoPlayerController.value.isPlaying;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(

      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: GestureDetector(
          onTap: () async {
            if (_videoPlayerController.value.isPlaying) {
              await _videoPlayerController.pause();
            } else {
              await _videoPlayerController.play();
            }
          },
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 0,
                child: ValueListenableBuilder<Uint8List?>(
                  valueListenable: thumbnailNotifier,
                  builder: (_, thumbnail, __) {
                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        if (_videoPlayerController.value.isInitialized && mounted)
                          AspectRatio(
                            aspectRatio:
                                _videoPlayerController.value.aspectRatio,
                            child:
                                CachedVideoPlayerPlus(_videoPlayerController),
                          ),
                        if (thumbnail != null)
                          AnimatedOpacity(
                            opacity:
                                (_videoPlayerController.value.isInitialized)
                                    ? 0
                                    : 1,
                            duration: const Duration(milliseconds: 300),
                            child: ImageFiltered(
                              imageFilter:
                                  ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                              child: Image.memory(
                                thumbnail,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
              Positioned.fill(
                  child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black54,
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black87,
                    ],
                    stops: [0.0, 0.3, 0.7, 1.0],
                  ),
                ),
              )),
              Positioned(
                  top: 80,
                  left: 20,
                  child: AppBackButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )),
              Positioned(
                left: 20,
                right: 20,
                bottom: 50,
                child: Row(
                  children: [
                    ValueListenableBuilder<bool>(
                      valueListenable: isPlaying,
                      builder: (_, playing, __) {
                        return Icon(
                            playing ? Icons.pause : Icons.play_arrow_rounded);
                      },
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(formatDuration(_videoPlayerController.value.position)),
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: ValueListenableBuilder<CachedVideoPlayerPlusValue>(
                        valueListenable: _videoPlayerController,
                        builder: (context, value, _) {
                          if (!value.isInitialized) return const SizedBox();
                          return SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              trackHeight: 0.1,
                              thumbShape: const RoundSliderThumbShape(
                                  enabledThumbRadius: 2),
                              overlayShape: const RoundSliderOverlayShape(
                                  overlayRadius: 0),
                              overlayColor: Colors.transparent,
                            ),
                            child: Slider(
                              max: value.duration.inMilliseconds.toDouble(),
                              value: value.position.inMilliseconds
                                  .clamp(0, value.duration.inMilliseconds)
                                  .toDouble(),
                              onChanged: (newValue) {
                                _videoPlayerController.seekTo(
                                    Duration(milliseconds: newValue.toInt()));
                              },
                              activeColor: AppColors.white,
                              inactiveColor: AppColors.white,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(formatDuration(_videoPlayerController.value.duration)),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void didUpdateWidget(covariant PostReels oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isActive && !oldWidget.isActive) {
      configureVideo();
    } else if (!widget.isActive && oldWidget.isActive) {
      if (_videoPlayerController.value.isInitialized) {
        _videoPlayerController
          ..removeListener(_videoListener)
          ..dispose();
      }
    }
  }
}
