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
import 'package:popcart/core/colors.dart';
import 'package:popcart/core/repository/livestreams_repo.dart';
import 'package:popcart/core/utils.dart';
import 'package:popcart/core/widgets/buttons.dart';
import 'package:popcart/env/env.dart';
import 'package:popcart/features/live/cubits/open_livestream/open_livestream_cubit.dart';
import 'package:popcart/features/user/cubits/cubit/profile_cubit.dart';
import 'package:popcart/features/user/models/user_model.dart';

class MessageModel {
  MessageModel({
    required this.userId,
    required this.message,
  });

  final String userId;
  final String message;
}

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

class _SellerLivestreamScreenState extends State<SellerLivestreamScreen>
    with WidgetsBindingObserver {
  late RtcEngine _engine;
  final ValueNotifier<int> userJoined = ValueNotifier(0);
  final ValueNotifier<List<MessageModel>> messages = ValueNotifier([]);
  late RtmClient rtmClient;
  bool _localUserJoined = false;
  bool showToast = false;
  String joinedUserId = '';
  final ScrollController scrollController = ScrollController();

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
    WidgetsBinding.instance.addObserver(this);
    initAgora();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      _engine
        ..leaveChannel()
        ..release();
      endLivestream();
    } else if (state == AppLifecycleState.paused) {
      _engine.disableVideo();
    } else if (state == AppLifecycleState.resumed) {
      _engine.enableVideo();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _engine
      ..leaveChannel()
      ..release();
    endLivestream();
    super.dispose();
  }

  Future<void> initRtm() async {
    final userId = locator<SharedPrefs>().userUid;
    final (status, client) = await RTM(Env().agoraAppId, userId);
    if (status.error == true) {
    } else {
      rtmClient = client;
    }
    rtmClient.addListener(
        message: (event) {
          final updated = List<MessageModel>.from(messages.value)
            ..add(MessageModel(
                userId: event.publisher ?? "",
                message: utf8.decode(event.message!)));
          messages.value = updated;
          scrollToBottom();
        },
        linkState: (event) {});
    await loginToSignal();
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
          final (subStatus, subResponse) = await rtmClient.subscribe(widget.channelName);
          if (subStatus.error) {
            print('${subStatus.operation} failed due to ${subStatus.reason}, error code: ${subStatus.errorCode}');
          } else {
            print('subscribe channel: ${widget.channelName} success!');
          }
        }
      }
    } catch (e) {
      print("Error logging in: $e");
      if (retryCount < 3) {
        retryCount++;
        await loginToSignal();
      }
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
            userJoined.value++;
            setState(() {
              joinedUserId = '$remoteUid joined';
              showToast = true;
            });
            Future.delayed(const Duration(seconds: 2), () {
              setState(() => showToast = false);
            });
          },
          onUserOffline: (connection, remoteUid, reason) {
            userJoined.value--;
            setState(() {
              joinedUserId = '$remoteUid left';
              showToast = true;
            });
            Future.delayed(const Duration(seconds: 2), () {
              setState(() => showToast = false);
            });
          },
          onError: (err, msg) async {},
        ),
      );
      await _engine.joinChannel(
        token: widget.token,
        channelId: widget.channelName,
        uid: 0,
        options: const ChannelMediaOptions(),
      );
      await _engine.enableAudio();
      await _engine.enableVideo();
      await _engine.startPreview();
      await initRtm();
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = context.watch<ProfileCubit>().state.maybeWhen(
          orElse: UserModel.empty,
          loaded: (user) => user,
        );

    return Scaffold(
      body: PopScope(
        canPop: false,
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
              top: 50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppBackButton(
                      onPressed: () async {
                        final result = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Are you sure?'),
                            content: const Text(
                                'Do you want to end this livestream?'),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: const Text('Yes'),
                              ),
                            ],
                          ),
                        );

                        if (result != null && result && context.mounted) {
                          context.pop();
                        }
                      },
                    ),
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
                                  ValueListenableBuilder<int>(
                                      valueListenable: userJoined,
                                      builder: (context, count, _) {
                                        return Text(
                                          count.toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        );
                                      }),
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
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(joinedUserId,
                            style: const TextStyle(color: Colors.white)),
                      ),
                  ],
                ),
              ),
            ),
            Positioned.fill(
              top: 400,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ValueListenableBuilder<List<MessageModel>>(
                    valueListenable: messages,
                    builder: (context, messages, _) {
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: messages.length,
                          controller: scrollController,
                          itemBuilder: (context, i) => ListTile(
                                leading: const Icon(
                                  Icons.account_circle_rounded,
                                  color: AppColors.white,
                                ),
                                title: Text(messages[i].userId,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    )),
                                subtitle: Text(messages[i].message,
                                    style: TextStyle(
                                      fontSize: 12,
                                      overflow: TextOverflow.clip,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white.withOpacity(0.8),
                                    )),
                              ));
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
