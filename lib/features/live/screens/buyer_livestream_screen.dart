import 'dart:developer';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:popcart/core/utils.dart';
import 'package:popcart/env/env.dart';
import 'package:popcart/features/onboarding/screens/enter_phone_number_screen.dart';

class BuyerLivestreamScreen extends StatefulWidget {
  const BuyerLivestreamScreen({
    required this.channelName,
    required this.token,
    super.key,
  });

  final String channelName;
  final String token;

  @override
  State<BuyerLivestreamScreen> createState() => _BuyerLivestreamScreenState();
}

class _BuyerLivestreamScreenState extends State<BuyerLivestreamScreen> {
  late RtcEngine _engine;
  bool _localUserJoined = false;

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
        channelId: widget.channelName,
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
    return Stack(
      children: [
        Positioned.fill(child: _renderVideo()),
        const Positioned.fill(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppBackButton(),
                  SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _renderVideo() {
    // if (widget.isBroadcaster) {
    return _localUserJoined
        ? AgoraVideoView(
            controller: VideoViewController(
              rtcEngine: _engine,
              canvas: const VideoCanvas(
                renderMode: RenderModeType.renderModeHidden,
                uid: 1944506866,
              ),
            ),
          )
        : const CupertinoActivityIndicator();
  }
}
