import 'dart:developer';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:keyboard_attachable/keyboard_attachable.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:popcart/core/utils.dart';
import 'package:popcart/env/env.dart';
import 'package:popcart/features/live/models/products.dart';
import 'package:popcart/features/onboarding/screens/enter_phone_number_screen.dart';

class BuyerLivestreamScreen extends StatefulWidget {
  const BuyerLivestreamScreen({
    required this.liveStream,
    required this.token,
    super.key,
  });

  final LiveStream liveStream;
  final String token;
  @override
  State<BuyerLivestreamScreen> createState() => _BuyerLivestreamScreenState();
}

class _BuyerLivestreamScreenState extends State<BuyerLivestreamScreen> {
  late RtcEngine _engine;
  bool _localUserJoined = false;
  int userJoined = 0;

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  @override
  void dispose() {
    _engine
      ..leaveChannel()
      ..release();
    super.dispose();
  }

  void closeLivestream() {
    showCupertinoDialog<void>(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: const Text('Livestream Ended'),
        content: const Text('The seller has ended the livestream'),
        actions: [
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () {
              context.pop();
            },
          ),
        ],
      ),
    ).then((_) {
      if (mounted) {
        context.pop();
      }
    });
  }

  Future<void> initAgora() async {
    try {
      await [Permission.camera, Permission.microphone].request();
      // Create RTC Engine
      _engine = createAgoraRtcEngine();
      await _engine.initialize(
        RtcEngineContext(
          appId: Env().agoraAppId,
          channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
        ),
      );
      // Set up event handlers
      _engine.registerEventHandler(
        RtcEngineEventHandler(
          onUserOffline: (connection, remoteUid, reason) {
            log(
              connection.toJson().toString(),
              name: 'AGORA onUserOffline connection',
            );
            log(remoteUid.toString(), name: 'AGORA onUserOffline remoteUid');
            log(reason.toString(), name: 'AGORA onUserOffline reason');
            if (remoteUid.toString() == widget.liveStream.agoraId) {
              closeLivestream();
            }
          },
          onJoinChannelSuccess: (connection, elapsed) {
            log(
              connection.toJson().toString(),
              name: 'AGORA onJoinChannelSuccess connection',
            );
            log(elapsed.toString(), name: 'AGORA onJoinChannelSuccess elapsed');
            setState(() {
              _localUserJoined = true;
            });
          },
          onError: (err, msg) async {
            log(err.toString(), name: 'AGORA onError err');
            log(msg, name: 'AGORA onError msg');
            await context.showError(msg);
            if (mounted) {
              context.pop();
            }
          },
        ),
      );
      await _engine.setClientRole(role: ClientRoleType.clientRoleAudience);
      await _engine.joinChannel(
        token: widget.token,
        channelId: widget.liveStream.id,
        uid: 1,
        options: const ChannelMediaOptions(
          publishMicrophoneTrack: false,
          publishCameraTrack: false,
          autoSubscribeAudio: true,
          autoSubscribeVideo: true,
          clientRoleType: ClientRoleType.clientRoleAudience,
        ),
      );
      // await _engine.enableAudio();
      // await _engine.enableVideo();
      await _engine.startPreview();
    } catch (e) {
      log(e.toString(), name: 'Agora Error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: _renderVideo(),
          ),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AppBackButton(),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 12,
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.liveStream.user.username,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            const Text(
                              '0 followers',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xfff97316),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Follow',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xff4B4444)
                                    .withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.remove_red_eye_outlined,
                                    color: Colors.white,
                                    size: 12,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    userJoined.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xffcc0000),
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: const Text(
                                      'Live',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Positioned.fill(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: SafeArea(
                maintainBottomViewPadding: true,
                child: FooterLayout(
                  footer: KeyboardAttachable(
                    child: Row(
                      children: [
                        Flexible(flex: 7, child: TextField()),
                        Flexible(
                          child: CircleAvatar(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _renderVideo() {
    // if (widget.isBroadcaster) {
    return _localUserJoined
        ? AgoraVideoView(
            controller: VideoViewController(
              rtcEngine: _engine,
              canvas: VideoCanvas(
                renderMode: RenderModeType.renderModeHidden,
                uid: int.tryParse(widget.liveStream.agoraId) ?? 0,
              ),
            ),
          )
        : const CupertinoActivityIndicator();
  }
}
