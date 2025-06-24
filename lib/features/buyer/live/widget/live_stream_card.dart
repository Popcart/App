import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:popcart/core/colors.dart';
import 'package:popcart/core/utils.dart';
import 'package:popcart/features/buyer/live/buyer_livestream_screen.dart';
import 'package:popcart/features/live/cubits/open_livestream/open_livestream_cubit.dart';
import 'package:popcart/features/live/models/products.dart';
import 'package:popcart/gen/assets.gen.dart';

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
          onTap: () async {
            if (isScheduled) return;
            final token = await openLivestreamCubit.generateAgoraToken(
              channelName: liveStream.id,
              agoraRole: 2,
              uid: 0,
            );

            if (token == null) {
              if (context.mounted) {
                await context.showError('Failed to generate token');
              }
              return;
            }

            if (!context.mounted) return;

            await Navigator.push<BuyerLivestreamScreen>(
              context,
              MaterialPageRoute<BuyerLivestreamScreen>(
                builder: (_) => BuyerLivestreamScreen(
                  liveStream: liveStream,
                  token: token,
                ),
              ),
            );
          },
          child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: liveStream.thumbnail != null
                    ? DecorationImage(
                        image: NetworkImage(liveStream.thumbnail!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: Stack(
                children: [
                  if (liveStream.thumbnail == null)
                    userThumbnail(liveStream.user.username)
                  else
                    const SizedBox.shrink(),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
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
                  ),
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
