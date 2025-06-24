import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:popcart/features/buyer/live/widget/live_stream_card.dart';
import 'package:popcart/features/live/cubits/active_livestream/active_livestreams_cubit.dart';
import 'package:popcart/features/live/models/products.dart';
import 'package:popcart/features/user/cubits/cubit/profile_cubit.dart';
import 'package:skeletonizer/skeletonizer.dart';

class LiveRooms extends StatefulWidget {
  const LiveRooms({super.key});

  @override
  State<LiveRooms> createState() => _LiveRoomsState();
}

class _LiveRoomsState extends State<LiveRooms> {
  @override
  Widget build(BuildContext context) {
    final profileCubit = context.watch<ProfileCubit>();
    final activeLivestreamsCubit = context.watch<ActiveLivestreamsCubit>();
    return Scaffold(
      body: profileCubit.state.maybeWhen(
        orElse: () => const Center(child: CircularProgressIndicator()),
        loaded: (user) => RefreshIndicator.adaptive(
          onRefresh: () async {
            unawaited(activeLivestreamsCubit.getActiveLivestreams());
          },
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
            ),
            itemCount: activeLivestreamsCubit.state.maybeWhen(
              orElse: () => 4,
              success: (liveStreams) => liveStreams.length,
            ),
            itemBuilder: (_, index) => Skeletonizer(
              enabled: activeLivestreamsCubit.state.maybeWhen(
                orElse: () => false,
                loading: () => true,
              ),
              child: LiveStreamCard(
                liveStream: activeLivestreamsCubit.state.maybeWhen(
                  orElse: LiveStream.empty,
                  success: (liveStreams) => liveStreams[index],
                ), isScheduled: false,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
