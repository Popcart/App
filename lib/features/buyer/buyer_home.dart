import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:popcart/app/service_locator.dart';
import 'package:popcart/app/shared_prefs.dart';
import 'package:popcart/core/widgets/widgets.dart';
import 'package:popcart/features/buyer/account/buyer_profile_screen.dart';
import 'package:popcart/features/buyer/explore/explore_screen.dart';
import 'package:popcart/features/buyer/live/buyer_live_screen_nav.dart';
import 'package:popcart/features/user/cubits/cubit/profile_cubit.dart';
import 'package:popcart/features/wallet/cubit/wallet_cubit.dart';
import 'package:popcart/gen/assets.gen.dart';

class BuyerHome extends StatefulWidget {
  const BuyerHome({super.key});

  @override
  State<BuyerHome> createState() => _BuyerHomeState();
}

ValueNotifier<int> currentIndex = ValueNotifier(1);

class _BuyerHomeState extends State<BuyerHome> {
  final List<Widget> _pages = const [
    BuyerLiveScreenNav(),
    ExploreScreen(),
    BuyerProfileScreen(),
  ];

  SvgPicture svgIcon(String src, {Color? color}) {
    return SvgPicture.asset(
      src,
      height: 24,
    );
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  Future<void> loadData() async {
    await context.read<ProfileCubit>().fetchUserProfile();
    await context
        .read<WalletCubit>()
        .getWalletInfo(userId: locator<SharedPrefs>().userUid);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: currentIndex,
      builder: (context, index, _) {
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) async {
            if (didPop) return;

            if (currentIndex.value == 1) {
              await SystemNavigator.pop();
              return;
            } else {
              currentIndex.value = 1;
              return;
            }
          },
          child: Scaffold(
            body: _pages[index],
            bottomNavigationBar: Container(
              padding: const EdgeInsets.only(top: 2),
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.white
                  : const Color(0xFF101015),
              child: BottomNavigationBar(
                currentIndex: index,
                onTap: (newIndex) => currentIndex.value = newIndex,
                backgroundColor:
                    Theme.of(context).brightness == Brightness.light
                        ? Colors.white
                        : const Color(0xFF101015),
                type: BottomNavigationBarType.fixed,
                items: [
                  BottomNavigationBarItem(
                    activeIcon:
                        AppAssets.icons.liveSelected.themedIcon(context),
                    icon: AppAssets.icons.liveUnselected.themedIcon(context),
                    label: 'Live',
                  ),
                  BottomNavigationBarItem(
                    activeIcon:
                        AppAssets.icons.auctionsSelected.themedIcon(context),
                    icon:
                        AppAssets.icons.auctionsUnselected.themedIcon(context),
                    label: 'Explore',
                  ),
                  BottomNavigationBarItem(
                    activeIcon:
                        AppAssets.icons.profileSelected.themedIcon(context),
                    icon: AppAssets.icons.profileUnselected.themedIcon(context),
                    label: 'Account',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
