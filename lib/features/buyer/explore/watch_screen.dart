import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:popcart/features/buyer/explore/widget/live_widget.dart';
import 'package:popcart/features/live/cubits/active_livestream/active_livestreams_cubit.dart';
import 'package:popcart/features/live/models/products.dart';
import 'package:popcart/features/user/cubits/cubit/profile_cubit.dart';

class WatchScreen extends StatefulWidget {
  const WatchScreen({super.key});

  @override
  State<WatchScreen> createState() => _WatchScreenState();
}

class _WatchScreenState extends State<WatchScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final profileCubit = context.watch<ProfileCubit>();
    final activeLivestreamsCubit = context.watch<ActiveLivestreamsCubit>();
    return profileCubit.state.maybeWhen(
      orElse: CupertinoActivityIndicator.new,
      loaded: (user) => RefreshIndicator.adaptive(
        onRefresh: () async {
          unawaited(activeLivestreamsCubit.getActiveLivestreams());
        },
        child: PageView.builder(
          scrollDirection: Axis.vertical,
          itemCount: activeLivestreamsCubit.state.maybeWhen(
            orElse: () => 4,
            success: (liveStreams) => liveStreams.length,
          ),
          onPageChanged: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          itemBuilder: (context, index) {
            return LiveWidget(
              liveStream: activeLivestreamsCubit.state.maybeWhen(
                orElse: LiveStream.empty,
                success: (liveStreams) => liveStreams[index],
              ), isActive: index == currentIndex,
            );
          },
        ),
      ),
    );
  }
}
