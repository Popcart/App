import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:popcart/app/router_paths.dart';
import 'package:popcart/app/service_locator.dart';
import 'package:popcart/app/shared_prefs.dart';
import 'package:popcart/core/colors.dart';
import 'package:popcart/core/utils.dart';
import 'package:popcart/env/env.dart';
import 'package:popcart/features/live/models/products.dart';
import 'package:popcart/features/live/screens/buyer_livestream_screen.dart';
import 'package:popcart/features/live/screens/buyer_profile_screen.dart';
import 'package:popcart/features/live/screens/buyer_setings_screen.dart';
import 'package:popcart/features/live/screens/live_screen.dart';
import 'package:popcart/features/live/screens/schedule_session_screen.dart';
import 'package:popcart/features/live/screens/select_products_screen.dart';
import 'package:popcart/features/live/screens/seller_livestream_screen.dart';
import 'package:popcart/features/onboarding/screens/business_details_screen.dart';
import 'package:popcart/features/onboarding/screens/select_interests_screen.dart';
import 'package:popcart/features/onboarding/screens/sign_up_screen.dart';
import 'package:popcart/features/onboarding/screens/login_screen.dart';
import 'package:popcart/features/onboarding/screens/select_user_type_screen.dart';
import 'package:popcart/features/onboarding/screens/verify_otp_screen.dart';
import 'package:popcart/features/onboarding/screens/video_splash_screen.dart';
import 'package:popcart/features/seller/analytics/analytics_screen.dart';
import 'package:popcart/features/seller/analytics/inventory_product_screen.dart';
import 'package:popcart/features/seller/analytics/top_product_screen.dart';
import 'package:popcart/features/seller/inventory/add_product_screen.dart';
import 'package:popcart/features/seller/inventory/inventory_screen.dart';
import 'package:popcart/features/user/cubits/cubit/profile_cubit.dart';
import 'package:popcart/features/user/models/user_model.dart';
import 'package:popcart/gen/assets.gen.dart';
import 'package:webview_flutter/webview_flutter.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  debugLogDiagnostics: kDebugMode,
  navigatorKey: rootNavigatorKey,
  initialLocation: AppPath.splash.path,
  routes: [
    GoRoute(
      path: AppPath.splash.goRoute,
      pageBuilder: (context, state) => CustomTransitionPage(
        child: const VideoSplashScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
      redirect: (context, state) {
        if (locator<SharedPrefs>().loggedIn) {
          final profileCubit = context.read<ProfileCubit>();
          final user = profileCubit.state.maybeWhen(
            loaded: (user) => user,
            orElse: () => null,
          );

          if (user != null) {
            return switch (user.userType) {
              UserType.seller => AppPath.authorizedUser.seller.analytics.path,
              UserType.buyer => AppPath.authorizedUser.buyer.path,
            };
          }
          return AppPath.authorizedUser.seller.analytics.path;
        }
        return null;
      },
    ),
    GoRoute(
      path: AppPath.auth.goRoute,
      pageBuilder: (context, state) => CustomTransitionPage(
        child: const LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
      routes: [
        GoRoute(
          path: AppPath.auth.otp.goRoute,
          name: AppPath.auth.otp.path,
          pageBuilder: (context, state) => CustomTransitionPage(
            child: const VerifyOtpScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        ),
        GoRoute(
          path: AppPath.auth.accountType.goRoute,
          name: AppPath.auth.accountType.path,
          pageBuilder: (context, state) => CustomTransitionPage(
            child: const SelectUserTypeScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        ),
        GoRoute(
          path: AppPath.auth.signup.goRoute,
          name: AppPath.auth.signup.path,
          pageBuilder: (context, state) => CustomTransitionPage(
            child: const SignUpScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        ),
        GoRoute(
          path: AppPath.auth.businessDetails.goRoute,
          name: AppPath.auth.businessDetails.path,
          pageBuilder: (context, state) => CustomTransitionPage(
            child: const BusinessDetailsScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        ),
        GoRoute(
          path: AppPath.auth.interestScreen.goRoute,
          name: AppPath.auth.interestScreen.path,
          pageBuilder: (context, state) => CustomTransitionPage(
            child: const SelectInterestsScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        ),
      ],
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          ScaffoldWithNestedNavigation(
        navigationShell: navigationShell,
      ),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppPath.authorizedUser.seller.analytics.goRoute,
              builder: (context, state) => const AnalyticsScreen(),
                routes: [
                  GoRoute(
                    path: AppPath.authorizedUser.seller.analytics.topProduct.goRoute,
                    name: AppPath.authorizedUser.seller.analytics.topProduct.path,
                    pageBuilder: (context, state) => CustomTransitionPage(
                      child: const TopProductScreen(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        const begin = Offset(0, 1);
                        const end = Offset.zero;
                        const curve = Curves.ease;
                        final tween = Tween(begin: begin, end: end)
                            .chain(CurveTween(curve: curve));
                        final offsetAnimation = animation.drive(tween);
                        return SlideTransition(
                          position: offsetAnimation,
                          child: child,
                        );
                      },
                    ),
                  ),
                  GoRoute(
                    path: AppPath.authorizedUser.seller.analytics.inventoryProduct.goRoute,
                    name: AppPath.authorizedUser.seller.analytics.inventoryProduct.path,
                    pageBuilder: (context, state) => CustomTransitionPage(
                      child: const InventoryProductScreen(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        const begin = Offset(0, 1);
                        const end = Offset.zero;
                        const curve = Curves.ease;
                        final tween = Tween(begin: begin, end: end)
                            .chain(CurveTween(curve: curve));
                        final offsetAnimation = animation.drive(tween);
                        return SlideTransition(
                          position: offsetAnimation,
                          child: child,
                        );
                      },
                    ),
                  ),
                ]
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppPath.authorizedUser.seller.orders.goRoute,
              builder: (context, state) => const Scaffold(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppPath.authorizedUser.seller.inventory.goRoute,
              builder: (context, state) => const InventoryScreen(),
              routes: [
                GoRoute(
                  path: AppPath.authorizedUser.seller.inventory.addProduct.goRoute,
                  name: AppPath.authorizedUser.seller.inventory.addProduct.path,
                  pageBuilder: (context, state) => CustomTransitionPage(
                    child: const AddProductScreen(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      const begin = Offset(0, 1);
                      const end = Offset.zero;
                      const curve = Curves.ease;
                      final tween = Tween(begin: begin, end: end)
                          .chain(CurveTween(curve: curve));
                      final offsetAnimation = animation.drive(tween);
                      return SlideTransition(
                        position: offsetAnimation,
                        child: child,
                      );
                    },
                  ),
                ),
              ]
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppPath.authorizedUser.seller.live.goRoute,
              builder: (context, state) => const SizedBox(),
              routes: [
                // GoRoute(
                //   path: AppPath.authorizedUser.live.scheduleSession.goRoute,
                //   name: AppPath.authorizedUser.live.scheduleSession.path,
                //   pageBuilder: (context, state) => CustomTransitionPage(
                //     child: const ScheduleSessionScreen(),
                //     // implement a slide up transition
                //     transitionsBuilder:
                //         (context, animation, secondaryAnimation, child) {
                //       const begin = Offset(0, 1);
                //       const end = Offset.zero;
                //       const curve = Curves.ease;
                //       final tween = Tween(begin: begin, end: end)
                //           .chain(CurveTween(curve: curve));
                //       final offsetAnimation = animation.drive(tween);
                //       return SlideTransition(
                //         position: offsetAnimation,
                //         child: child,
                //       );
                //     },
                //   ),
                // ),
                // GoRoute(
                //   path: AppPath.authorizedUser.live.selectProducts.goRoute,
                //   name: AppPath.authorizedUser.live.selectProducts.path,
                //   pageBuilder: (context, state) => CustomTransitionPage(
                //     child: const SelectProductsScreen(),
                //     // implement a slide up transition
                //     transitionsBuilder:
                //         (context, animation, secondaryAnimation, child) {
                //       return FadeTransition(opacity: animation, child: child);
                //     },
                //   ),
                // ),
                // GoRoute(
                //   path: AppPath.authorizedUser.live.sellerLivestream.goRoute,
                //   name: AppPath.authorizedUser.live.sellerLivestream.path,
                //   parentNavigatorKey: rootNavigatorKey,
                //   pageBuilder: (context, state) => CustomTransitionPage(
                //     child: SellerLivestreamScreen(
                //       channelName:
                //           state.uri.queryParameters['channelName'] ?? '',
                //       token: state.uri.queryParameters['token'] ?? '',
                //     ),
                //     transitionsBuilder:
                //         (context, animation, secondaryAnimation, child) {
                //       return FadeTransition(opacity: animation, child: child);
                //     },
                //   ),
                // ),
                // GoRoute(
                //   path: AppPath.authorizedUser.live.buyerLivestream.goRoute,
                //   name: AppPath.authorizedUser.live.buyerLivestream.path,
                //   parentNavigatorKey: rootNavigatorKey,
                //   pageBuilder: (context, state) => CustomTransitionPage(
                //     child: BuyerLivestreamScreen(
                //       liveStream: state.extra! as LiveStream,
                //       token: state.uri.queryParameters['token'] ?? '',
                //     ),
                //     transitionsBuilder:
                //         (context, animation, secondaryAnimation, child) {
                //       return FadeTransition(opacity: animation, child: child);
                //     },
                //   ),
                // ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
                path: AppPath.authorizedUser.seller.sellerAccount.goRoute,
                builder: (context, state) => const AccountWebview(),
                routes: []),
          ],
        ),
      ],
    ),
  ],
);

class AccountWebview extends StatefulWidget {
  const AccountWebview({
    super.key,
  });

  @override
  State<AccountWebview> createState() => _AccountWebviewState();
}

class _AccountWebviewState extends State<AccountWebview> {
  late final WebViewController controller;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    final url = Env().sellerDashboardUrl.addQueryParameters({
      'state': 'app',
      'accessToken': locator<SharedPrefs>().accessToken,
    });
    log(url, name: 'AccountWebview');
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xff111214))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() {
              loading = true;
            });
          },
          onPageFinished: (url) {
            setState(() {
              loading = false;
            });
          },
        ),
      )
      ..loadRequest(
        Uri.parse(
          Env().sellerDashboardUrl.addQueryParameters({
            'state': 'app',
            'accessToken': locator<SharedPrefs>().accessToken,
          }),
        ),
      )
      ..enableZoom(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            return state.maybeWhen(
              orElse: CupertinoActivityIndicator.new,
              loaded: (user) => switch (user.userType) {
                UserType.seller => loading
                    ? const Center(
                        child: CupertinoActivityIndicator(color: Colors.white),
                      )
                    : WebViewWidget(
                        controller: controller,
                      ),
                UserType.buyer => const BuyerProfileScreen(),
              },
            );
          },
        ),
      ),
    );
  }
}

class ScaffoldWithNestedNavigation extends StatelessWidget {
  const ScaffoldWithNestedNavigation({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  void _goBranch(int index) => navigationShell.goBranch(
        index,
        initialLocation: index == navigationShell.currentIndex,
      );

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithNavigationBar(
      body: navigationShell,
      selectedIndex: navigationShell.currentIndex,
      onDestinationSelected: _goBranch,
    );
  }
}

class ScaffoldWithNavigationBar extends StatelessWidget {
  const ScaffoldWithNavigationBar({
    required this.body,
    required this.selectedIndex,
    required this.onDestinationSelected,
    super.key,
  });

  final Widget body;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    final profileCubit = context.watch<ProfileCubit>();
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: SafeArea(child: body),
        bottomNavigationBar: profileCubit.state.whenOrNull(
          loaded: (user) => switch (user.userType) {
            UserType.seller => null,
            UserType.buyer => Theme(
                data: Theme.of(context).copyWith(
                  canvasColor: AppColors.appBackground,
                ),
                child: BottomNavigationBar(
                  currentIndex: selectedIndex,
                  onTap: onDestinationSelected,
                  selectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                  selectedItemColor: Colors.white,
                  unselectedItemColor: Colors.white,
                  showUnselectedLabels: false,
                  unselectedLabelStyle: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: Colors.white),
                  items: [
                    BottomNavigationBarItem(
                      activeIcon: AppAssets.icons.analyticSelected.svg(),
                      icon: AppAssets.icons.analyticUnselected.svg(),
                      label: 'Analytics',
                    ),
                    BottomNavigationBarItem(
                      activeIcon: AppAssets.icons.orderSelected.svg(),
                      icon: AppAssets.icons.orderUnselected.svg(),
                      label: 'Orders',
                    ),
                    BottomNavigationBarItem(
                      activeIcon: AppAssets.icons.auctionsSelected.svg(),
                      icon: AppAssets.icons.auctionsUnselected.svg(),
                      label: 'Inventory',
                    ),
                    BottomNavigationBarItem(
                      activeIcon: AppAssets.icons.liveSelected.svg(),
                      icon: AppAssets.icons.liveUnselected.svg(),
                      label: 'Live',
                    ),
                    BottomNavigationBarItem(
                      activeIcon: AppAssets.icons.profileSelected.svg(),
                      icon: AppAssets.icons.profileUnselected.svg(),
                      label: 'Account',
                    ),
                  ],
                ),
              )
          },
        ),
      ),
    );
  }
}
