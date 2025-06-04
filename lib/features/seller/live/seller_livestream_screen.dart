import 'dart:convert';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_rtm/agora_rtm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:popcart/app/service_locator.dart';
import 'package:popcart/app/shared_prefs.dart';
import 'package:popcart/core/repository/livestreams_repo.dart';
import 'package:popcart/core/widgets/buttons.dart';
import 'package:popcart/env/env.dart';
import 'package:popcart/features/live/cubits/open_livestream/open_livestream_cubit.dart';
import 'package:popcart/features/user/cubits/cubit/profile_cubit.dart';
import 'package:popcart/features/user/models/user_model.dart';

class SellerLivestreamScreen extends StatefulHookWidget {
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
  int userJoined = 0;
  final List<String> _messages = [];
  late RtmClient rtmClient;
  bool _localUserJoined = false;
  bool showToast = false;
  String joinedUserId = '';

  @override
  void initState() {
    super.initState();
    initAgora();
    print('The channel name: ${widget.channelName}');
  }

  @override
  void dispose() {
    _engine
      ..leaveChannel()
      ..release();
    endLivestream();
    super.dispose();
  }

  Future<void> initRtm() async {
    final userId = locator<SharedPrefs>().userUid;
    final openLivestream = context.read<OpenLivestreamCubit>();
    final token = await openLivestream.generateAgoraRTMToken(userId: userId);
    if(token != null) {
      final (status, client) = await RTM(Env().agoraAppId, userId);
      if (status.error == true) {
      } else {
        rtmClient = client;
      }
      rtmClient.addListener(
          message: (event) {
            _messages.add(utf8.decode(event.message!));
            setState(() {});
          },
          linkState: (event) {
          });
      await loginToSignal(token);
    }
  }

  Future<void> loginToSignal(String token) async {
    final (status,response) = await rtmClient.login(token);
    if (status.error == true) {
    } else {
      await rtmClient.subscribe(widget.channelName);
    }
  }

  Future<void> setAgoraId(int id) async {
    await locator<LivestreamsRepo>().setSellerAgoraId(
      agoraId: id.toString(),
      livestreamId: widget.channelName,
    );
  }

  Future<void> endLivestream() async {
    await locator<LivestreamsRepo>().endLivestreamSession(
      livestreamId: widget.channelName,
    );
  }

  Future<void> initAgora() async {
    try {
      await [Permission.camera, Permission.microphone].request();
      _engine = createAgoraRtcEngine();
      await _engine.initialize(
        RtcEngineContext(
          appId: Env().agoraAppId,
          channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
        ),
      );
      await _engine.setClientRole(
        role: ClientRoleType.clientRoleBroadcaster,
        options: const ClientRoleOptions(
          audienceLatencyLevel:
          AudienceLatencyLevelType.audienceLatencyLevelUltraLowLatency,
        ),
      );
      _engine.registerEventHandler(
        RtcEngineEventHandler(
          onJoinChannelSuccess: (connection, elapsed) {
            setState(() {
              _localUserJoined = true;
            });
          },
          onUserJoined: (connection, remoteUid, elapsed) {
            setState(() {
              userJoined++;
              joinedUserId = '$remoteUid joined';
              showToast = true;
            });
            Future.delayed(const Duration(seconds: 2), () {
              setState(() => showToast = false);
            });
          },
          onUserOffline: (connection, remoteUid, reason) {
            setState(() {
              userJoined--;
            });
          },
          onError: (err, msg) async {
          },
        ),
      );
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
      await initRtm();
    } catch (e) {
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = context.watch<ProfileCubit>().state.maybeWhen(
          orElse: UserModel.empty,
          loaded: (user) => user,
        );

    return Scaffold(
      body: PopScope(
        canPop: false, // Prevents automatic popping
        onPopInvokedWithResult: (didPop, i) async {
          if (didPop) {
            return;
          }
          final result = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Are you sure?'),
              content: const Text('Do you want to end this livestream?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Yes'),
                ),
              ],
            ),
          );

          if (result != null && result && context.mounted) {
            context.pop();
          }
        },
        child: Stack(
          children: [
            Positioned.fill(
              child: _localUserJoined
                  ? AgoraVideoView(
                      controller: VideoViewController(
                        rtcEngine: _engine,
                        canvas: const VideoCanvas(
                          renderMode: RenderModeType.renderModeHidden,
                          uid: 0,
                        ),
                      ),
                    )
                  : const CupertinoActivityIndicator(),
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
                                userProfile.username,
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
                                  color:
                                      const Color(0xff4B4444).withOpacity(0.5),
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
                                        borderRadius:
                                            BorderRadius.circular(100),
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
                      if (showToast)
                        Positioned(
                          bottom: 100,
                          left: 20,
                          right: 20,
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16
                                  , vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text('User $joinedUserId joined',
                                  style: const TextStyle(color: Colors.white)),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              top: 400,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _messages.length,
                itemBuilder: (context, i) =>
                    ListTile(title: Text(_messages[i])),
              ),
            )
          ],
        ),
      ),
    );
  }
}
