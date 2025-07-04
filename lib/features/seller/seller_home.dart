import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:popcart/app/app.module.dart';
import 'package:popcart/app/shared_prefs.dart';
import 'package:popcart/core/widgets/widgets.dart';
import 'package:popcart/features/seller/account/seller_profile_screen.dart';
import 'package:popcart/features/seller/analytics/analytics_screen.dart';
import 'package:popcart/features/seller/inventory/inventory_screen.dart';
import 'package:popcart/features/seller/live/seller_live_nav.dart';
import 'package:popcart/features/seller/orders/orders_screen.dart';
import 'package:popcart/features/user/cubits/cubit/profile_cubit.dart';
import 'package:popcart/features/wallet/cubit/wallet_cubit.dart';
import 'package:popcart/gen/assets.gen.dart';

class SellerHome extends StatefulWidget {
  const SellerHome({super.key});

  @override
  State<SellerHome> createState() => _SellerHomeState();
}

ValueNotifier<int> sellerCurrentIndex = ValueNotifier(0);

class _SellerHomeState extends State<SellerHome>{
  final List<Widget> _pages = const [
    AnalyticsScreen(),
    OrdersScreen(),
    InventoryScreen(),
    SellerLiveNav(),
    SellerProfileScreen(),
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
    await context.read<WalletCubit>().getWalletInfo(userId: locator<SharedPrefs>().userUid);
  }
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: sellerCurrentIndex,
      builder: (context, index, _) {
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) async {
            if (didPop) return;

            if (sellerCurrentIndex.value == 0) {
              await SystemNavigator.pop();
              return;
            } else {
              sellerCurrentIndex.value = 0;
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
                onTap: (newIndex) => sellerCurrentIndex.value = newIndex,
                backgroundColor: Theme.of(context).brightness == Brightness.light
                    ? Colors.white
                    : const Color(0xFF101015),
                type: BottomNavigationBarType.fixed,
                items: [
                  BottomNavigationBarItem(
                    activeIcon:
                    AppAssets.icons.analyticSelected.themedIcon(context),
                    icon:
                    AppAssets.icons.analyticUnselected.themedIcon(context),
                    label: 'Analytics',
                  ),
                  BottomNavigationBarItem(
                    activeIcon:
                    AppAssets.icons.orderSelected.themedIcon(context),
                    icon: AppAssets.icons.orderUnselected.themedIcon(context),
                    label: 'Orders',
                  ),
                  BottomNavigationBarItem(
                    activeIcon:
                    AppAssets.icons.auctionsSelected.themedIcon(context),
                    icon:
                    AppAssets.icons.auctionsUnselected.themedIcon(context),
                    label: 'Inventory',
                  ),
                  BottomNavigationBarItem(
                    activeIcon:
                    AppAssets.icons.liveSelected.themedIcon(context),
                    icon: AppAssets.icons.liveUnselected.themedIcon(context),
                    label: 'Live',
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
