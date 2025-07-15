import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:popcart/features/buyer/live/widget/live_stream_card.dart';
import 'package:popcart/features/live/cubits/active_livestream/active_livestreams_cubit.dart';
import 'package:popcart/features/live/models/products.dart';
import 'package:popcart/features/common/cubits/cubit/profile_cubit.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ScheduledRooms extends StatefulWidget {
  const ScheduledRooms({super.key});

  @override
  State<ScheduledRooms> createState() => _ScheduledRoomsState();
}

class _ScheduledRoomsState extends State<ScheduledRooms> {
  @override
  Widget build(BuildContext context) {
    final profileCubit = context.watch<ProfileCubit>();
    final scheduledLivestreamsCubit = context.watch<ScheduledLivestreamsCubit>();
    return Scaffold(
      body: profileCubit.state.maybeWhen(
        orElse: () => const Center(child: CircularProgressIndicator()),
        loaded: (user) => RefreshIndicator.adaptive(
          onRefresh: () async {
            unawaited(scheduledLivestreamsCubit.getScheduledLivestreams());
          },
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
            ),
            itemCount: scheduledLivestreamsCubit.state.maybeWhen(
              orElse: () => 4,
              success: (liveStreams) => liveStreams.length,
            ),
            itemBuilder: (_, index) => Skeletonizer(
              enabled: scheduledLivestreamsCubit.state.maybeWhen(
                orElse: () => false,
                loading: () => true,
              ),
              child: LiveStreamCard(
                liveStream: scheduledLivestreamsCubit.state.maybeWhen(
                  orElse: LiveStream.empty,
                  success: (liveStreams) => liveStreams[index],
                ), isScheduled: true,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
