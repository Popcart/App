import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:popcart/app/router_paths.dart';
import 'package:popcart/core/colors.dart' show AppColors;
import 'package:popcart/core/utils.dart';
import 'package:popcart/core/widgets/widgets.dart';
import 'package:popcart/features/buyer/live/live_rooms.dart';
import 'package:popcart/features/buyer/live/scheduled_rooms.dart';
import 'package:popcart/features/live/cubits/active_livestream/active_livestreams_cubit.dart';
import 'package:popcart/features/live/cubits/open_livestream/open_livestream_cubit.dart';
import 'package:popcart/features/live/models/products.dart';
import 'package:popcart/features/user/cubits/cubit/profile_cubit.dart';
import 'package:popcart/gen/assets.gen.dart';
import 'package:skeletonizer/skeletonizer.dart';

class BuyerLiveScreen extends StatefulWidget {
  const BuyerLiveScreen({super.key});

  @override
  State<BuyerLiveScreen> createState() => _BuyerLiveScreenState();
}

class _BuyerLiveScreenState extends State<BuyerLiveScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;

  final tabs = [
    'Live Rooms',
    'Upcoming',
  ];

  void _onTabTap(int index) {
    setState(() => _selectedIndex = index);
    _tabController.animateTo(index,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }

  @override
  void initState() {
    _tabController = TabController(length: tabs.length, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live'),
        automaticallyImplyLeading: false,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            CustomTabBar(
              tabs: tabs,
              selectedIndex: _selectedIndex,
              onTap: _onTabTap,
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: TabBarView(
                  controller: _tabController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: const [LiveRooms(), ScheduledRooms()]),
            ),
          ],
        ),
      ),
    );
  }
}

class LiveStreamCard extends StatelessWidget {
  const LiveStreamCard(
      {required this.liveStream, required this.isScheduled, super.key});

  final LiveStream liveStream;
  final bool isScheduled;

  @override
  Widget build(BuildContext context) {
    final openLivestreamCubit = context.read<OpenLivestreamCubit>();
    return Column(children: [
      Expanded(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            if (isScheduled) return;
            openLivestreamCubit.generateAgoraToken(
              channelName: liveStream.id,
              agoraRole: 2,
              uid: 0,
            );
          },
          child: BlocListener<OpenLivestreamCubit, OpenLivestreamState>(
            bloc: openLivestreamCubit,
            listener: (context, state) {
              state.whenOrNull(
                error: (message) => context.showError(message),
                generateTokenSuccess: (token) async {
                  await context.pushNamed(
                    AppPath.authorizedUser.buyer.buyerLive.goLive.path,
                    extra: liveStream,
                    queryParameters: {
                      'token': token,
                    },
                  );
                },
              );
            },
            child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Stack(
                  children: [
                    userThumbnail(liveStream.user.username),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AppAssets.icons.auction.svg(),
                              Text(
                                timeAgo(!isScheduled
                                    ? liveStream.createdAt.toString()
                                    : liveStream.startTime.toString()),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              const CircleAvatar(radius: 12),
                              const SizedBox(width: 12),
                              Text(
                                liveStream.user.username,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            liveStream.title,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
          ),
        ),
      ),
      if (isScheduled)
        GestureDetector(
          onTap: () {},
          child: Container(
            margin: const EdgeInsets.only(top: 12),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppColors.textFieldFillColor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppAssets.icons.notifications.svg(),
                const SizedBox(
                  width: 20,
                ),
                const Text('Remind me',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    )),
              ],
            ),
          ),
        )
    ]);
  }
}
