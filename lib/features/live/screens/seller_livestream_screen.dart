import 'dart:developer';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:popcart/core/utils.dart';
import 'package:popcart/env/env.dart';
import 'package:popcart/features/onboarding/screens/enter_phone_number_screen.dart';

class SellerLivestreamScreen extends StatefulWidget {
  const SellerLivestreamScreen({
    required this.channelName,
    required this.token,
    super.key,
  });

  final String channelName;
  final String token;

  @override
  State<SellerLivestreamScreen> createState() => _SellerLivestreamScreenState();
}

class _SellerLivestreamScreenState extends State<SellerLivestreamScreen> {
  late RtcEngine _engine;
  bool _localUserJoined = false;
  int _remoteUid = 0;
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
            setState(() {
              _localUserJoined = true;
              _remoteUid = connection.localUid ?? 0;
            });
          },
          onUserJoined: (connection, remoteUid, elapsed) {
            log(
              connection.toJson().toString(),
              name: 'AGORA onUserJoined connection',
            );
            log(remoteUid.toString(), name: 'AGORA onUserJoined remoteUid');
            setState(() {});
          },
          onUserOffline: (connection, remoteUid, reason) {
            log(
              connection.toJson().toString(),
              name: 'AGORA onUserOffline connection',
            );
            log(remoteUid.toString(), name: 'AGORA onUserOffline remoteUid');
            log(reason.toString(), name: 'AGORA onUserOffline reason');
            setState(() {});
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
      // Set client role
      // if (widget.isBroadcaster) {
      await _engine.setClientRole(
        role: ClientRoleType.clientRoleBroadcaster,
        options: const ClientRoleOptions(
          audienceLatencyLevel:
              AudienceLatencyLevelType.audienceLatencyLevelUltraLowLatency,
        ),
      );
      // } else {
      //   await _engine.setClientRole(role: ClientRoleType.clientRoleAudience);
      // }
      // Join channel
      await _engine.joinChannel(
        token: widget.token,
        channelId: widget.channelName,
        uid: 0,
        options: const ChannelMediaOptions(
          publishMicrophoneTrack: true,
          publishCameraTrack: true,
          autoSubscribeAudio: true,
          autoSubscribeVideo: true,
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
        ),
      );
      await _engine.enableAudio();
      await _engine.enableVideo();
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
                uid: 0,
              ),
            ),
          )
        : const CupertinoActivityIndicator();
  }
}
