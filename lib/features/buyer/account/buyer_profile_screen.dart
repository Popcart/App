import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:popcart/app/app.module.dart';
import 'package:popcart/app/shared_prefs.dart';
import 'package:popcart/core/colors.dart';
import 'package:popcart/core/utils.dart';
import 'package:popcart/core/widgets/widgets.dart';
import 'package:popcart/features/user/cubits/cubit/profile_cubit.dart';
import 'package:popcart/features/wallet/cubit/wallet_cubit.dart';
import 'package:popcart/gen/assets.gen.dart';
import 'package:popcart/route/route_constants.dart';

class BuyerProfileScreen extends StatefulWidget {
  const BuyerProfileScreen({super.key});

  @override
  State<BuyerProfileScreen> createState() => _BuyerProfileScreenState();
}

class _BuyerProfileScreenState extends State<BuyerProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final profileCubit = context.watch<ProfileCubit>();
    final walletCubit = context.watch<WalletCubit>();
    final title = walletCubit.state.maybeWhen(
      loaded: (wallet) => wallet.balance.toCurrency(),
      orElse: () => '....',
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, settingsScreen);
            },
            icon: AppAssets.icons.gear.themedIcon(context),
          ),
        ],
      ),
      body: profileCubit.state.maybeWhen(
        orElse: () => const Center(child: CircularProgressIndicator()),
        loaded: (user) => RefreshIndicator.adaptive(
          onRefresh: () async {
            await context.read<ProfileCubit>().fetchUserProfile();
            await context.read<WalletCubit>().getWalletInfo(
                  userId: locator<SharedPrefs>().userUid,
                );
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            physics: const AlwaysScrollableScrollPhysics(),
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
                          '${user.firstName ?? ''} ${user.lastName ?? ''}',
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
                const SizedBox(height: 16),
                GridView.count(
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
                      title: title,
                      icon: AppAssets.icons.wallet.svg(),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
