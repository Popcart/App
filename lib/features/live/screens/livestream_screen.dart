import 'dart:developer';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:popcart/env/env.dart';

class LivestreamScreen extends StatefulWidget {
  const LivestreamScreen({
    required this.channelName,
    required this.isBroadcaster,
    required this.token,
    super.key,
  });

  final String channelName;
  final String token;
  final bool isBroadcaster;

  @override
  State<LivestreamScreen> createState() => _LivestreamScreenState();
}

class _LivestreamScreenState extends State<LivestreamScreen> {
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
            debugPrint('Local user joined: ${connection.localUid}');
            setState(() {
              _localUserJoined = true;
            });
          },
          onUserJoined: (connection, remoteUid, elapsed) {
            debugPrint('Remote user joined: $remoteUid');
            setState(() {});
          },
          onUserOffline: (connection, remoteUid, reason) {
            debugPrint('Remote user left: $remoteUid');
            setState(() {});
          },
        ),
      );
      // Set client role
      if (widget.isBroadcaster) {
        await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
      } else {
        await _engine.setClientRole(role: ClientRoleType.clientRoleAudience);
      }
      // Join channel
      await _engine.joinChannel(
        token: widget.token,
        channelId: widget.channelName,
        uid: 0,
        options: const ChannelMediaOptions(),
      );
    } catch (e) {
      log(e.toString(), name: 'Agora Error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return _renderVideo();
  }

  Widget _renderVideo() {
    if (widget.isBroadcaster) {
      return _localUserJoined
          ? AgoraVideoView(
              controller: VideoViewController(
                rtcEngine: _engine,
                canvas: const VideoCanvas(uid: 0),
              ),
            )
          : const CupertinoActivityIndicator();
    } else {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine,
          canvas: const VideoCanvas(uid: 0),
          connection: RtcConnection(channelId: widget.channelName),
        ),
      );
    }
  }

  // Future<void> _toggleCamera() async {
  //   await _engine.enableLocalVideo(!_engine.isCameraEnabled);
  // }

  // Future<void> _toggleMic() async {
  //   await _engine.enableLocalAudio(!_engine.isMicrophoneEnabled);
  // }
}
