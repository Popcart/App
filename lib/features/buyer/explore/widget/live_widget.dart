import 'dart:convert';
import 'dart:developer';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_rtm/agora_rtm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keyboard_attachable/keyboard_attachable.dart';
import 'package:popcart/app/service_locator.dart';
import 'package:popcart/app/shared_prefs.dart';
import 'package:popcart/core/colors.dart';
import 'package:popcart/core/utils.dart';
import 'package:popcart/env/env.dart';
import 'package:popcart/features/buyer/live/buyer_livestream_screen.dart';
import 'package:popcart/features/live/cubits/open_livestream/open_livestream_cubit.dart';
import 'package:popcart/features/live/models/products.dart';
import 'package:popcart/features/seller/live/seller_livestream_screen.dart';
import 'package:popcart/gen/assets.gen.dart';

class LiveWidget extends StatefulWidget {
  const LiveWidget(
      {required this.liveStream, required this.isActive, super.key});

  final LiveStream liveStream;
  final bool isActive;

  @override
  State<LiveWidget> createState() => _LiveWidgetState();
}

class _LiveWidgetState extends State<LiveWidget>
    with AutomaticKeepAliveClientMixin {
  int? _remoteUid;
  late RtcEngine _engine;
  bool? videoDisabled;
  final ValueNotifier<int> userJoined = ValueNotifier(0);
  late RtmClient rtmClient;
  final _controller = TextEditingController();
  final ValueNotifier<List<MessageModel>> messages = ValueNotifier([]);
  final ScrollController scrollController = ScrollController();
  bool joinedLive = false;

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
    generateToken();
  }

  Future<void> generateToken() async {
    _remoteUid = null;
    final openLiveStreamCubit = context.read<OpenLivestreamCubit>();
    final token = await openLiveStreamCubit.generateAgoraToken(
      channelName: widget.liveStream.id,
      agoraRole: 2,
      uid: 0,
    );
    if (token != null) {
      await initAgora(token);
    }
  }

  @override
  void dispose() {
    leaveChannel();
    super.dispose();
  }

  Future<void> leaveChannel() async {
    if (joinedLive) {
      final username = locator<SharedPrefs>().username;
      await rtmClient.publish(
        widget.liveStream.id,
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
          connection: RtcConnection(channelId: widget.liveStream.id),
        ),
      );
    } else {
      return const CupertinoActivityIndicator();
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
              setState(() {
                videoDisabled = muted;
              });
            }
          },
          onUserOffline: (connection, remoteUid, reason) {},
          onJoinChannelSuccess: (connection, elapsed) {},
          onUserJoined: (connection, remoteUid, elapsed) {
            setState(() {
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
        channelId: widget.liveStream.id,
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
          widget.liveStream.id, '$username: ${_controller.text}',
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
              await rtmClient.subscribe(widget.liveStream.id);
          if (subStatus.error) {
          } else {
            //User has successfully connected to the live stream.
            // Now send a message to register the count
            final username = locator<SharedPrefs>().username;
            await rtmClient.publish(widget.liveStream.id, '$username joined',
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
    final product = await showModalBottomSheet<Product>(
      context: context,
      isScrollControlled: true,
      builder: (_) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: ProductModal(
          sellerId: widget.liveStream.user.id,
          products: widget.liveStream.products,
        ),
      ),
    );

    if (product != null) {
      // print(product);
      // context.go('/product/${product.id}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GestureDetector(
        onTap: () async {
          // await initRtm();
        },
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: _renderVideo(),
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
            Positioned.fill(
              bottom: 100,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Spacer(),
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
                            SizedBox(
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
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 12,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          widget.liveStream.user.username,
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
            ),
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
            Center(
              child: Visibility(
                  visible: videoDisabled != null && videoDisabled == true,
                  child: const Text('Video is paused')),
            ),
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
  bool get wantKeepAlive => true;

  @override
  void didUpdateWidget(covariant LiveWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isActive && !oldWidget.isActive) {
      generateToken();
    } else if (!widget.isActive && oldWidget.isActive) {
      leaveChannel();
    }
  }
}
