import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:popcart/app/app.module.dart';
import 'package:popcart/app/shared_prefs.dart';
import 'package:popcart/core/colors.dart';
import 'package:popcart/core/utils.dart';
import 'package:popcart/core/widgets/widgets.dart';
import 'package:popcart/features/common/cubits/cubit/profile_cubit.dart';
import 'package:popcart/features/seller/cubits/pop_play/pop_play_cubit.dart';
import 'package:popcart/gen/assets.gen.dart';
import 'package:popcart/route/route_constants.dart';

class SellerProfileScreen extends StatefulWidget {
  const SellerProfileScreen({super.key});

  @override
  State<SellerProfileScreen> createState() => _SellerProfileScreenState();
}

class _SellerProfileScreenState extends State<SellerProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final tabs = [
    'Live Rooms',
    'Upcoming',
  ];

  void _onTabTap(int index) {
    _tabController.animateTo(index,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }

  @override
  void initState() {
    _tabController = TabController(length: tabs.length, vsync: this);
    context
        .read<PopPlayCubit>()
        .getPosts(userId: locator<SharedPrefs>().userUid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final popPlayCubit = context.watch<PopPlayCubit>();
    final profileCubit = context.watch<ProfileCubit>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, sellerSettings);
            },
            icon: AppAssets.icons.gear.themedIcon(context),
          ),
        ],
      ),
      body: profileCubit.state.maybeWhen(
        orElse: () => const Center(child: CircularProgressIndicator()),
        loaded: (user) => Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 36,
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${user.firstName} ${user.lastName}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '@${user.username}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  backgroundColor: const Color(0xff111214),
                  fixedSize: const Size(double.infinity, 48),
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  side: const BorderSide(
                    color: AppColors.orange,
                  ),
                ),
                child: const Text(
                  'View Profile',
                  style: TextStyle(
                    color: AppColors.orange,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              TabBar(
                tabs: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppAssets.icons.play.svg(),
                      const SizedBox(
                        width: 15,
                      ),
                      const Text('Pop-play',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 15))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppAssets.icons.profile.svg(),
                      const SizedBox(
                        width: 15,
                      ),
                      const Text(
                        'Account',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 15),
                      )
                    ],
                  )
                ],
                labelPadding: const EdgeInsets.only(bottom: 10),
                indicatorColor: AppColors.white,
                dividerColor: Colors.transparent,
                labelColor: AppColors.white,
                controller: _tabController,
                onTap: _onTabTap,
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: TabBarView(
                    controller: _tabController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      popPlayCubit.state.maybeWhen(
                          orElse: () =>
                              const Center(child: CircularProgressIndicator()),
                          loaded: (posts) => RefreshIndicator.adaptive(
                                onRefresh: () async {
                                  unawaited(
                                    popPlayCubit.getPosts(
                                      userId: locator<SharedPrefs>().userUid,
                                    ),
                                  );
                                },
                                child: GridView.builder(
                                    gridDelegate:
                                        const
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 16,
                                      crossAxisSpacing: 16,
                                    ),
                                    itemCount: posts.length,
                                    itemBuilder: (_, index) {
                                      return FutureBuilder<Uint8List?>(
                                        future: generateThumbnail(
                                            posts[index].video,),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const SizedBox(
                                              width: 20,
                                              height: 20,
                                              child:
                                                  CupertinoActivityIndicator(),
                                            );
                                          } else if (snapshot.hasData || !snapshot.hasData) {
                                            return GestureDetector(
                                              onTap: () {
                                                Navigator.pushNamed(
                                                    context, popPlayScreen,
                                                    arguments: {
                                                      'index': index,
                                                      'posts': posts
                                                    });
                                              },
                                              child: Stack(children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  child: snapshot.data != null ? Image.memory(
                                                      width: double.infinity,
                                                      snapshot.data!,
                                                      fit: BoxFit.cover) : userThumbnail(posts[index].caption),
                                                ),
                                                Positioned.fill(
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(8),
                                                        gradient: const LinearGradient(
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
                                                Positioned(
                                                    right: 10,
                                                    top: 10,
                                                    child: GestureDetector(
                                                      onTap: () async {
                                                        final result = await showAdaptiveDialog<bool>(
                                                          context: context,
                                                          builder: (context) => AlertDialog.adaptive(
                                                            title: const Text('Deleting post'),
                                                            content: const Text('Do you want to delete this post?'),
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
                                                          await context
                                                              .read<
                                                              PopPlayCubit>()
                                                              .deletePosts(
                                                              postId:
                                                              posts[index]
                                                                  .id,
                                                              existingPosts: posts);
                                                        }

                                                      },
                                                      child: AppAssets
                                                          .icons.deletePost
                                                          .svg(),
                                                    )),
                                                Positioned(
                                                    bottom: 10,
                                                    left: 10,
                                                    child: Row(
                                                      children: [
                                                        AppAssets.icons.eye
                                                            .svg(),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Text(posts[index].views
                                                            .toString())
                                                      ],
                                                    )),
                                              ]),
                                            );
                                          } else {
                                            return const Icon(Icons.error);
                                          }
                                        },
                                      );
                                    }),
                              )),
                      SingleChildScrollView(
                        child: GridView.count(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          shrinkWrap: true,
                          childAspectRatio: 1.2,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            actionCard(
                              title: 'Messages',
                              icon: AppAssets.icons.messages.svg(),
                              onTap: () {},
                            ),
                            actionCard(
                              title: 'Purchases',
                              icon: AppAssets.icons.purchases.svg(),
                              onTap: () {},
                            ),
                            actionCard(
                              title: 'Boosts',
                              icon: AppAssets.icons.boosts.svg(),
                              onTap: () {},
                            ),
                            actionCard(
                              title: 'Rewards',
                              icon: AppAssets.icons.rewards.svg(),
                              onTap: () {},
                            ),
                            actionCard(
                              title: 'Bookmarks',
                              icon: AppAssets.icons.bookmark.svg(),
                              onTap: () {},
                            ),
                            actionCard(
                              title: 'Interests',
                              icon: AppAssets.icons.interests.svg(),
                              onTap: () {},
                            ),
                          ],
                        ),
                      ),
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
