import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:popcart/app/router_paths.dart';
import 'package:popcart/core/colors.dart';
import 'package:popcart/core/utils.dart';
import 'package:popcart/core/widgets/animated_widgets.dart';
import 'package:popcart/features/live/cubits/active_livestream/active_livestreams_cubit.dart';
import 'package:popcart/features/live/cubits/open_livestream/open_livestream_cubit.dart';
import 'package:popcart/features/live/models/products.dart';
import 'package:popcart/features/onboarding/cubits/interest_list/interest_list_cubit.dart';
import 'package:popcart/features/onboarding/models/onboarding_models.dart';
import 'package:popcart/features/user/cubits/cubit/profile_cubit.dart';
import 'package:popcart/features/user/models/user_model.dart';
import 'package:popcart/gen/assets.gen.dart';
import 'package:skeletonizer/skeletonizer.dart';

class LiveScreen extends HookWidget {
  const LiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final interestListCubit = context.watch<InterestListCubit>();
    final profileCubit = context.watch<ProfileCubit>();
    final activeLivestreamsCubit = context.watch<ActiveLivestreamsCubit>();
    final selectedInterest = useState<ProductCategory?>(null);
    return Scaffold(
      floatingActionButton: profileCubit.state.maybeWhen(
        orElse: () => null,
        loaded: (user) => switch (user.userType) {
          UserType.seller => FloatingActionButton.extended(
              onPressed: () {
                context.pushNamed(
                  AppPath.authorizedUser.live.scheduleSession.path,
                );
              },
              label: const Text('Go Live'),
              icon: const Icon(Icons.live_tv),
            ),
          UserType.buyer => null,
        },
      ),
      body: SafeArea(
        child: RefreshIndicator.adaptive(
          onRefresh: () async {
            unawaited(activeLivestreamsCubit.getActiveLivestreams());
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SearchTextField(),
                const SizedBox(height: 16),
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const ClampingScrollPhysics(),
                    itemCount: interestListCubit.state.maybeWhen(
                      orElse: () => 0,
                      loaded: (interests) => interests.length,
                    ),
                    itemBuilder: (context, index) {
                      final interest = interestListCubit.state.maybeWhen(
                        orElse: ProductCategory.init,
                        loaded: (interests) => interests[index],
                      );
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () {
                            selectedInterest.value = interest;
                          },
                          child: Chip(
                            label: Text(interest.name),
                            labelStyle: TextStyle(
                              color: selectedInterest.value == interest
                                  ? Colors.white
                                  : const Color(0xff676C75),
                              fontWeight: selectedInterest.value == interest
                                  ? FontWeight.w500
                                  : FontWeight.normal,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(80),
                            ),
                            backgroundColor: selectedInterest.value == interest
                                ? const Color(0xff676C75)
                                : const Color(0xff111214),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  width: double.infinity,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xff24262B),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Spacer(),
                        Text(
                          'JOGGERS',
                          style: TextStyle(
                            fontSize: 28,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '''Discover trending vintage styles from iconic brands like Levi's, Carhartt, Diesel & more.''',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 270,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (_, index) => Skeletonizer(
                      enabled: activeLivestreamsCubit.state.maybeWhen(
                        orElse: () => false,
                        loading: () => true,
                      ),
                      child: ActiveLiveStream(
                        liveStream: activeLivestreamsCubit.state.maybeWhen(
                          orElse: LiveStream.empty,
                          success: (liveStreams) => liveStreams[index],
                        ),
                      ),
                    ),
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemCount: activeLivestreamsCubit.state.maybeWhen(
                      orElse: () => 10,
                      success: (liveStreams) => liveStreams.length,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xff3B3C40),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xff24262B),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Column(
                          children: [
                            Text(
                              'Your Rewards',
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '₦0',
                              style: TextStyle(
                                fontSize: 32,
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Want to earn cash?',
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Flexible(
                            flex: 3,
                            child: Text(
                              '''Earn up to ₦2000 when your friends sign up to Popcart and make a purchase''',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Flexible(
                            child: BouncingEffect(
                              onTap: () {},
                              child: Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: AppColors.orange,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Center(
                                  child: IconButton(
                                    visualDensity: const VisualDensity(
                                      horizontal: -4,
                                      vertical: -4,
                                    ),
                                    icon: const Icon(
                                      Icons.arrow_forward_ios,
                                      color: AppColors.white,
                                    ),
                                    onPressed: () {},
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SearchTextField extends StatelessWidget {
  const SearchTextField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search popcart',
        hintStyle: const TextStyle(color: Color(0xffD7D8D9), fontSize: 16),
        prefixIcon: Padding(
          padding: const EdgeInsets.all(12),
          child: AppAssets.icons.search.svg(),
        ),
        fillColor: const Color(0xff24262B),
        filled: true,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class ActiveLiveStream extends HookWidget {
  const ActiveLiveStream({required this.liveStream, super.key});

  final LiveStream liveStream;

  @override
  Widget build(BuildContext context) {
    final openLivestreamCubit = useMemoized(OpenLivestreamCubit.new);
    final userId = context.read<ProfileCubit>().state.maybeWhen(
          orElse: () => '',
          loaded: (user) => user.id,
        );
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        openLivestreamCubit.generateAgoraToken(
          channelName: liveStream.id,
          agoraRole: userId == liveStream.user.id ? 0 : 1,
          uid: userId == liveStream.user.id ? 0 : 1,
        );
      },
      child: BlocListener<OpenLivestreamCubit, OpenLivestreamState>(
        bloc: openLivestreamCubit,
        listener: (context, state) {
          state.whenOrNull(
            error: (message) => context.showError(message),
            generateTokenSuccess: (token) {
              if (userId == liveStream.user.id) {
                context.pushNamed(
                  AppPath.authorizedUser.live.sellerLivestream.path,
                  extra: true,
                  queryParameters: {
                    'token': token,
                    'channelName': liveStream.id,
                  },
                );
              }
              context.pushNamed(
                AppPath.authorizedUser.live.buyerLivestream.path,
                extra: liveStream,
                queryParameters: {
                  'token': token,
                  
                },
              );
            },
          );
        },
        child: Container(
          width: 270,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xff24262B),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xff4B4444).withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.remove_red_eye_outlined,
                          color: Colors.white,
                          size: 12,
                        ),
                        SizedBox(width: 4),
                        Text(
                          '0',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xffcc0000),
                      borderRadius: BorderRadius.circular(100),
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
      ),
    );
  }
}
