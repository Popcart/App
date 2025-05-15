import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:popcart/app/app.module.dart';
import 'package:popcart/core/colors.dart';
import 'package:popcart/core/widgets/widgets.dart';
import 'package:popcart/gen/assets.gen.dart';

class BuyerProfileScreen extends StatelessWidget {
  const BuyerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        actions: [
          IconButton(
            onPressed: () {
              context.pushNamed(AppPath.authorizedUser.seller.sellerAccount.settings.path);
            },
            icon: AppAssets.icons.gear.themedIcon(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Row(
              children: [
                CircleAvatar(
                  radius: 36,
                ),
                SizedBox(width: 20),
                Column(
                  children: [
                    Text(
                      'John Doe',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '2 followings',
                      style: TextStyle(
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
                  borderRadius: BorderRadius.circular(8),
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
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              shrinkWrap: true,
              childAspectRatio: 1.2,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _actionCard(
                  title: 'Messages',
                  icon: AppAssets.icons.messages.svg(),
                  onTap: () {},
                ),
                _actionCard(
                  title: 'Purchases',
                  icon: AppAssets.icons.purchases.svg(),
                  onTap: () {},
                ),
                _actionCard(
                  title: 'Boosts',
                  icon: AppAssets.icons.boosts.svg(),
                  onTap: () {},
                ),
                _actionCard(
                  title: 'Rewards',
                  icon: AppAssets.icons.rewards.svg(),
                  onTap: () {},
                ),
                _actionCard(
                  title: 'Bookmarks',
                  icon: AppAssets.icons.bookmark.svg(),
                  onTap: () {},
                ),
                _actionCard(
                  title: 'Interests',
                  icon: AppAssets.icons.interests.svg(),
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionCard({
    required String title,
    required Widget icon,
    required void Function() onTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xff24262b),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xff111214).withOpacity(0.45),
            radius: 24,
            child: icon,
          ),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
