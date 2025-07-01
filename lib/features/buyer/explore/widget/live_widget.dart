import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_rtm/agora_rtm.dart';
import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keyboard_attachable/keyboard_attachable.dart';
import 'package:popcart/app/service_locator.dart';
import 'package:popcart/app/shared_prefs.dart';
import 'package:popcart/core/colors.dart';
import 'package:popcart/core/utils.dart';
import 'package:popcart/env/env.dart';
import 'package:popcart/features/live/cubits/open_livestream/open_livestream_cubit.dart';
import 'package:popcart/features/live/models/products.dart';
import 'package:popcart/features/seller/live/seller_livestream_screen.dart';
import 'package:popcart/features/seller/models/video_post_response.dart';
import 'package:popcart/gen/assets.gen.dart';

class LiveWidget extends StatefulWidget {
  const LiveWidget(
      {this.liveStream, required this.isActive, super.key, this.videoPost});

  final LiveStream? liveStream;
  final bool isActive;
  final VideoPost? videoPost;

  @override
  State<LiveWidget> createState() => _LiveWidgetState();
}

class _LiveWidgetState extends State<LiveWidget>
    with AutomaticKeepAliveClientMixin {
  late CachedVideoPlayerPlusController _videoPlayerController;
  int? _remoteUid;
  late ValueNotifier<bool> isPlaying;
  bool showPlayButton = false;
  late RtcEngine _engine;
  late ValueNotifier<int> userJoined;
  late RtmClient rtmClient;
  late final TextEditingController _controller;
  late final ValueNotifier<List<MessageModel>> messages;
  late final ScrollController scrollController;
  bool joinedLive = false;
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
    userJoined = ValueNotifier(0);
    isPlaying = ValueNotifier(false);
    showPlayButton = false;
    _controller = TextEditingController();
    scrollController = ScrollController();
    messages = ValueNotifier([]);
    thumbnailNotifier = ValueNotifier(null);
    if (widget.isActive) configureVideo();
  }

  void configureVideo() {
    if (widget.liveStream != null) {
      generateToken();
    } else {
      _videoPlayerController = CachedVideoPlayerPlusController.networkUrl(
        Uri.parse(widget.videoPost!.video),
        invalidateCacheIfOlderThan: const Duration(days: 7),
      )
        ..addListener(_videoListener)
        ..initialize().then((_) {
          _videoPlayerController
            ..setLooping(true)
            ..play();
          showPlayButton = true;
          setState(() {});
        });
      generateThumbnail(widget.videoPost!.video).then((thumb) {
        thumbnailNotifier.value = thumb;
      });
    }
  }

  Future<void> generateToken() async {
    try {
      _remoteUid = null;
      final openLiveStreamCubit = context.read<OpenLivestreamCubit>();
      final token = await openLiveStreamCubit.generateAgoraToken(
        channelName: widget.liveStream!.id,
        agoraRole: 2,
        uid: 0,
      );
      if (token != null) {
        await initAgora(token);
      }
    } catch (e) {}
  }

  @override
  void dispose() {
    super.dispose();
    if (widget.liveStream != null) {
      leaveChannel();
    } else {
      if (_videoPlayerController.value.isInitialized) {
        _videoPlayerController
          ..removeListener(_videoListener)
          ..dispose();
      }
    }
  }

  Future<void> leaveChannel() async {
    try {
      if (joinedLive) {
        final username = locator<SharedPrefs>().username;
        await rtmClient.publish(
          widget.liveStream!.id,
          '$username left',
          customType: kLeaveNotification,
        );
        rtmClient
          ..logout()
          ..release();
      } else {
        _engine
          ..leaveChannel()
          ..release();
      }
    } catch (e) {}
  }

  Widget _renderVideo() {
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine,
          canvas: VideoCanvas(
            uid: _remoteUid,
            renderMode: RenderModeType.renderModeHidden,
          ),
          connection: RtcConnection(channelId: widget.liveStream!.id),
        ),
      );
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }

  void _videoListener() {
    if (_videoPlayerController.value.isInitialized) {
      isPlaying.value = _videoPlayerController.value.isPlaying;
    }
  }

  Future<void> initAgora(String token) async {
    try {
      _engine = createAgoraRtcEngine();
      await _engine.initialize(
        RtcEngineContext(
          appId: Env().agoraAppId,
        ),
      );
      _engine.registerEventHandler(
        RtcEngineEventHandler(
          onUserMuteVideo: (connection, remoteUid, muted) {
            if (remoteUid == _remoteUid) {
              isPlaying.value = muted;
            }
          },
          onUserOffline: (connection, remoteUid, reason) {},
          onJoinChannelSuccess: (connection, elapsed) {},
          onUserJoined: (connection, remoteUid, elapsed) {
            setState(() {
              showPlayButton = true;
              _remoteUid = remoteUid;
            });
          },
          onError: (err, msg) async {
            await context.showError(msg);
          },
        ),
      );
      await _engine.joinChannel(
        token: token,
        channelId: widget.liveStream!.id,
        uid: 0,
        options: const ChannelMediaOptions(
          channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
          clientRoleType: ClientRoleType.clientRoleAudience,
          autoSubscribeVideo: true,
          autoSubscribeAudio: true,
        ),
      );
    } catch (e) {
      log(e.toString(), name: 'Agora Error');
    }
  }

  Future<void> initRtm() async {
    try {
      setState(() {
        joinedLive = true;
      });
      final userId = locator<SharedPrefs>().userUid;
      final (status, client) = await RTM(Env().agoraAppId, userId);
      if (status.error == true) {
      } else {
        rtmClient = client;
      }
      rtmClient.addListener(
          message: (event) {
            final messageText = utf8.decode(event.message ?? []);
            final type = event.customType;
            switch (type) {
              case kViewerCountUpdate:
                userJoined.value = int.tryParse(messageText) ?? 0;
              case kJoinNotification:
              case kLeaveNotification:
                //Do nothing
                break;
              default:
                final updated = List<MessageModel>.from(messages.value)
                  ..add(
                    MessageModel(
                      userId: event.publisher ?? '',
                      message: messageText,
                    ),
                  );
                messages.value = updated;
                scrollToBottom();
            }
          },
          linkState: (event) {});
      await loginToSignal();
    } catch (e) {}
  }

  Future<void> _send() async {
    try {
      final username = locator<SharedPrefs>().username;
      final (status, response) = await rtmClient.publish(
          widget.liveStream!.id, '$username: ${_controller.text}',
          customType: kPlainText);
      if (status.error == true) {
      } else {
        final userId = locator<SharedPrefs>().userUid;
        final updated = List<MessageModel>.from(messages.value)
          ..add(MessageModel(
              message: '$username: ${_controller.text}', userId: userId));
        messages.value = updated;
        _controller.clear();
        scrollToBottom();
      }
    } catch (e) {
      print('Failed to publish message: $e');
    }
  }

  int retryCount = 0;

  Future<void> loginToSignal() async {
    try {
      final openLivestream = context.read<OpenLivestreamCubit>();
      final userId = locator<SharedPrefs>().userUid;
      final token = await openLivestream.generateAgoraRTMToken(userId: userId);
      if (token != null) {
        final (status, response) = await rtmClient.login(token);
        if (!status.error) {
          final (subStatus, subResponse) =
              await rtmClient.subscribe(widget.liveStream!.id);
          if (subStatus.error) {
          } else {
            //User has successfully connected to the live stream.
            // Now send a message to register the count
            final username = locator<SharedPrefs>().username;
            await rtmClient.publish(widget.liveStream!.id, '$username joined',
                customType: kJoinNotification);
          }
        }
      }
    } catch (e) {
      if (retryCount < 3) {
        retryCount++;
        await loginToSignal();
      }
    }
  }

  Future<void> showProductModal() async {
    // final product = await showModalBottomSheet<Product>(
    //   context: context,
    //   isScrollControlled: true,
    //   builder: (_) => Container(
    //     height: MediaQuery.of(context).size.height * 0.8,
    //     decoration: BoxDecoration(
    //       color: Theme.of(context).scaffoldBackgroundColor,
    //       borderRadius: const BorderRadius.only(
    //         topLeft: Radius.circular(16),
    //         topRight: Radius.circular(16),
    //       ),
    //     ),
    //     child: ProductModal(
    //       sellerId: widget.liveStream.user.id,
    //       products: widget.liveStream.products,
    //     ),
    //   ),
    // );

    // if (product != null) {
    // print(product);
    // context.go('/product/${product.id}');
    // }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GestureDetector(
        onTap: () async {
          // await initRtm();
          if (widget.videoPost != null) {
            if (_videoPlayerController.value.isPlaying) {
              await _videoPlayerController.pause();
            } else {
              await _videoPlayerController.play();
            }
          } else {}
        },
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: widget.liveStream != null
                  ? _renderVideo()
                  : ValueListenableBuilder<Uint8List?>(
                      valueListenable: thumbnailNotifier,
                      builder: (_, thumbnail, __) {
                        return Stack(
                          fit: StackFit.expand,
                          children: [
                            if (_videoPlayerController.value.isInitialized &&
                                mounted)
                              AspectRatio(
                                aspectRatio:
                                    _videoPlayerController.value.aspectRatio,
                                child: CachedVideoPlayerPlus(
                                    _videoPlayerController),
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
            if (widget.liveStream != null)
              Positioned.fill(
                bottom: 100,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Spacer(),
                      IntrinsicWidth(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xffcc0000),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Row(
                            children: [
                              AppAssets.icons.radar.svg(),
                              const SizedBox(
                                width: 5,
                              ),
                              const Text(
                                'Live',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 12,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            widget.liveStream!.user.username,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            else
              const SizedBox(),
            Visibility(
              visible: joinedLive,
              child: Positioned.fill(
                top: 50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SafeArea(
                    maintainBottomViewPadding: true,
                    child: FooterLayout(
                      footer: KeyboardAttachable(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxHeight:
                                      MediaQuery.of(context).size.height * 0.4,
                                ),
                                child: SingleChildScrollView(
                                  reverse: true,
                                  child: ValueListenableBuilder<
                                      List<MessageModel>>(
                                    valueListenable: messages,
                                    builder: (context, messages, _) {
                                      return ListView.builder(
                                        shrinkWrap: true,
                                        controller: scrollController,
                                        itemCount: messages.length,
                                        padding: EdgeInsets.zero,
                                        itemBuilder: (context, i) => ListTile(
                                          contentPadding: EdgeInsets.zero,
                                          minVerticalPadding: 0,
                                          visualDensity: VisualDensity.compact,
                                          dense: true,
                                          leading: const Icon(
                                            Icons.account_circle_rounded,
                                            color: AppColors.white,
                                          ),
                                          title: Text(messages[i].message,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
                                              )),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Flexible(
                                    child: chatBox(),
                                  ),
                                  const SizedBox(width: 16),
                                  GestureDetector(
                                    onTap: showProductModal,
                                    behavior: HitTestBehavior.opaque,
                                    child: Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: Colors.white, width: 0.5),
                                      ),
                                      child: AppAssets.icons.storefront.svg(),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
                child: ValueListenableBuilder<bool>(
              valueListenable: isPlaying,
              builder: (_, playing, __) {
                return Center(
                  child: Visibility(
                    visible: !isPlaying.value &&
                        showPlayButton &&
                        widget.videoPost != null,
                    child: SizedBox(
                        width: 40,
                        height: 40,
                        child: AppAssets.icons.play.svg()),
                  ),
                );
              },
            )),
            if (widget.videoPost != null)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: ValueListenableBuilder<CachedVideoPlayerPlusValue>(
                  valueListenable: _videoPlayerController,
                  builder: (context, value, _) {
                    if (!value.isInitialized) return const SizedBox();
                    return SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 0.1,
                        thumbShape:
                            const RoundSliderThumbShape(enabledThumbRadius: 2),
                        overlayShape:
                            const RoundSliderOverlayShape(overlayRadius: 0),
                        overlayColor: Colors.transparent,
                      ),
                      child: Slider(
                        max: value.duration.inMilliseconds.toDouble(),
                        value: value.position.inMilliseconds
                            .clamp(0, value.duration.inMilliseconds)
                            .toDouble(),
                        onChanged: (newValue) {
                          _videoPlayerController
                              .seekTo(Duration(milliseconds: newValue.toInt()));
                        },
                        activeColor: AppColors.white,
                        inactiveColor: AppColors.grey,
                      ),
                    );
                  },
                ),
              )
          ],
        ),
      ),
    );
  }

  TextField chatBox() {
    return TextField(
      controller: _controller,
      onSubmitted: (value) {
        if (value.isEmpty && _controller.text.isEmpty) return;
        _send();
      },
      textInputAction: TextInputAction.send,
      onTapOutside: (event) => FocusScope.of(context).unfocus(),
      cursorColor: AppColors.white,
      decoration: InputDecoration(
        hintText: 'Type a message...',
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(100),
          ),
          borderSide: BorderSide(color: Colors.white, width: 0.5),
        ),
        suffixIcon: IconButton(
          icon: AppAssets.icons.send.svg(),
          onPressed: () {
            if (_controller.text.isEmpty) return;
            _send();
          },
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(100),
          ),
          borderSide: BorderSide(color: Colors.white, width: 0.5),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => widget.liveStream != null;

  @override
  void didUpdateWidget(covariant LiveWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      if (widget.liveStream != null) {
        generateToken();
      }
    } else if (!widget.isActive && oldWidget.isActive) {
      if (widget.liveStream != null) {
        leaveChannel();
      }
    }
  }
}
