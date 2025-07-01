import 'package:flutter/material.dart';
import 'package:popcart/features/seller/account/post_reels.dart';
import 'package:popcart/features/seller/models/video_post_response.dart';

class ProfilePosts extends StatefulWidget {
  const ProfilePosts({required this.index, required this.posts, super.key});

  final int index;
  final List<VideoPost> posts;

  @override
  State<ProfilePosts> createState() => _ProfilePostsState();
}

class _ProfilePostsState extends State<ProfilePosts> {
  late final PageController _pageController;
  final ValueNotifier<int> currentIndex = ValueNotifier(0);
  @override
  void initState() {
    _pageController = PageController(initialPage: widget.index);
    currentIndex.value = widget.index;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      scrollDirection: Axis.vertical,
      itemCount: widget.posts.length,
      onPageChanged: (index) {
        currentIndex.value = index;
      },
      itemBuilder: (context, index) {
        return ValueListenableBuilder<int>(
          valueListenable: currentIndex,
          builder: (_, position, __) {
            return PostReels(
              video: widget.posts[index],
              isActive: position == currentIndex.value,
            );
          },
        );
      },
    );
  }
}
