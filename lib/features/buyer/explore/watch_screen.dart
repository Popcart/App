import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:popcart/features/buyer/explore/widget/live_widget.dart';
import 'package:popcart/features/live/cubits/watch/watch_cubit.dart';
import 'package:popcart/features/live/models/products.dart';

class WatchScreen extends StatefulWidget {
  const WatchScreen({super.key});

  @override
  State<WatchScreen> createState() => _WatchScreenState();
}

class _WatchScreenState extends State<WatchScreen> {
  final ValueNotifier<int> currentIndex = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    context.read<WatchCubit>().getActiveLivestreams();
  }

  @override
  Widget build(BuildContext context) {
    final watchCubit = context.watch<WatchCubit>();
    return RefreshIndicator.adaptive(
        onRefresh: () async {
          unawaited(watchCubit.getActiveLivestreams());
        },
        child: PageView.builder(
          scrollDirection: Axis.vertical,
          itemCount: watchCubit.state.maybeWhen(
            orElse: () => 0,
            success: (liveStreams) => liveStreams.length,
          ),
          onPageChanged: (index) {
            currentIndex.value = index;
          },
          itemBuilder: (context, index) {
            return ValueListenableBuilder<int>(
              valueListenable: currentIndex,
              builder: (_, position, __) {
                return LiveWidget(
                  liveStream: watchCubit.state.maybeWhen(
                    orElse: LiveStream.empty,
                    success: (liveStreams) => liveStreams[index],
                  ), isActive: position == index,
                );
              },
            );
          },
        ),
    );
  }
}
