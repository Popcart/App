import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:popcart/app/router_paths.dart';
import 'package:popcart/app/service_locator.dart';
import 'package:popcart/app/shared_prefs.dart';
import 'package:popcart/app/theme.dart';
import 'package:popcart/app/theme_cubit.dart';
import 'package:popcart/core/widgets/widgets.dart';
import 'package:popcart/features/buyer/account/buyer_profile_screen.dart';
import 'package:popcart/features/buyer/account/buyer_setings_screen.dart';
import 'package:popcart/features/buyer/explore/explore_screen.dart';
import 'package:popcart/features/buyer/explore/search_screen.dart';
import 'package:popcart/features/buyer/live/buyer_live_screen_nav.dart';
import 'package:popcart/features/buyer/live/buyer_livestream_screen.dart';
import 'package:popcart/features/live/models/products.dart';
import 'package:popcart/features/onboarding/screens/business_details_screen.dart';
import 'package:popcart/features/onboarding/screens/login_screen.dart';
import 'package:popcart/features/onboarding/screens/select_interests_screen.dart';
import 'package:popcart/features/onboarding/screens/select_user_type_screen.dart';
import 'package:popcart/features/onboarding/screens/sign_up_screen.dart';
import 'package:popcart/features/onboarding/screens/verify_otp_screen.dart';
import 'package:popcart/features/onboarding/screens/video_splash_screen.dart';
import 'package:popcart/features/product/product_screen.dart';
import 'package:popcart/features/seller/account/seller_profile_screen.dart';
import 'package:popcart/features/seller/account/seller_setings_screen.dart';
import 'package:popcart/features/seller/analytics/analytics_screen.dart';
import 'package:popcart/features/seller/analytics/inventory_product_screen.dart';
import 'package:popcart/features/seller/analytics/top_product_screen.dart';
import 'package:popcart/features/seller/inventory/add_product_screen.dart';
import 'package:popcart/features/seller/inventory/edit_product_screen.dart';
import 'package:popcart/features/seller/inventory/inventory_screen.dart';
import 'package:popcart/features/seller/live/seller_live_nav.dart';
import 'package:popcart/features/seller/live/seller_livestream_screen.dart';
import 'package:popcart/features/seller/orders/orders_screen.dart';
import 'package:popcart/features/user/cubits/cubit/profile_cubit.dart';
import 'package:popcart/features/user/models/user_model.dart';
import 'package:popcart/gen/assets.gen.dart';
import 'package:popcart/l10n/arb/app_localizations.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  debugLogDiagnostics: kDebugMode,
  navigatorKey: rootNavigatorKey,
  initialLocation: AppPath.splash.path,
  routes: [
    GoRoute(
      path: AppPath.splash.goRoute,
      builder: (context, state) => const VideoSplashScreen(),
      redirect: (context, state) {
        if (!locator<SharedPrefs>().loggedIn) return null;
        return AppPath.authorizedUser.path;
      },
    ),
    GoRoute(
      path: AppPath.authorizedUser.path,
      builder: (context, state) {
        final profileState = context.watch<ProfileCubit>().state;

        return profileState.maybeWhen(
          loaded: (user) => MainShell(userType: user.userType),
          orElse: () => const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
        );
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
    GoRoute(
      path: AppPath.authorizedUser.productPage.goRoute,
      name: AppPath.authorizedUser.productPage.path,
      pageBuilder: (context, state) => CustomTransitionPage(
        child: ProductScreen(
          productId: state.extra! as String,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    ),
  ],
);

List<StatefulShellBranch> getBranches(UserType userType) {
  if (userType == UserType.buyer) {
    return [
      StatefulShellBranch(
        routes: [
          GoRoute(
              path: AppPath.authorizedUser.buyer.liveTab.goRoute,
              builder: (context, state) => const BuyerLiveScreenNav(),
          ),
        ],
      ),
      StatefulShellBranch(
        routes: [
          GoRoute(
              path: AppPath.authorizedUser.buyer.exploreTab.goRoute,
              name: AppPath.authorizedUser.buyer.exploreTab.path,
              pageBuilder: (context, state) => CustomTransitionPage(
                    child: const ExploreScreen(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                  ),
              routes: [
                GoRoute(
                  path: AppPath.authorizedUser.buyer.exploreTab.search.goRoute,
                  name: AppPath.authorizedUser.buyer.exploreTab.search.path,
                  pageBuilder: (context, state) => CustomTransitionPage(
                    child: const SearchScreen(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                  ),
                ),
                GoRoute(
                  path: AppPath.authorizedUser.productPage.path,
                  builder: (context, state) => const ExploreScreen(),
                  routes: [
                    GoRoute(
                      path: AppPath.authorizedUser.productPage.goRoute,
                      name: AppPath.authorizedUser.productPage.path,
                      pageBuilder: (context, state) => CustomTransitionPage(
                        child: ProductScreen(
                          productId: state.extra! as String,
                        ),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          return FadeTransition(
                              opacity: animation, child: child);
                        },
                      ),
                    ),
                  ],
                ),
              ]),
        ],
      ),
      StatefulShellBranch(
        routes: [
          GoRoute(
              path: AppPath.authorizedUser.buyer.accountTab.goRoute,
              builder: (context, state) => const BuyerProfileScreen(),
              routes: [
                GoRoute(
                  path: AppPath
                      .authorizedUser.buyer.accountTab.settings.goRoute,
                  name: AppPath.authorizedUser.buyer.accountTab.settings.path,
                  pageBuilder: (context, state) => CustomTransitionPage(
                    child: const BuyerSetingsScreen(),
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
              ]),
        ],
      ),
    ];
  } else {
    return [
      StatefulShellBranch(
        routes: [
          GoRoute(
              path: AppPath.authorizedUser.seller.analytics.goRoute,
              builder: (context, state) => const AnalyticsScreen(),
              routes: [
                GoRoute(
                  path: AppPath
                      .authorizedUser.seller.analytics.topProduct.goRoute,
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
                  path: AppPath
                      .authorizedUser.seller.analytics.inventoryProduct.goRoute,
                  name: AppPath
                      .authorizedUser.seller.analytics.inventoryProduct.path,
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
              ]),
        ],
      ),
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: AppPath.authorizedUser.seller.orders.goRoute,
            builder: (context, state) => const OrdersScreen(),
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
                  path: AppPath
                      .authorizedUser.seller.inventory.addProduct.goRoute,
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
                GoRoute(
                    path: AppPath
                        .authorizedUser.seller.inventory.editProduct.goRoute,
                    name: AppPath
                        .authorizedUser.seller.inventory.editProduct.path,
                    pageBuilder: (context, state) {
                      final product = state.extra! as Product;
                      return CustomTransitionPage(
                        child: EditProductScreen(productModal: product),
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
                      );
                    }),
              ]),
        ],
      ),
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: AppPath.authorizedUser.seller.live.goRoute,
            builder: (context, state) => const SellerLiveNav(),
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
              GoRoute(
                path: AppPath.authorizedUser.seller.live.goLive.goRoute,
                name: AppPath.authorizedUser.seller.live.goLive.path,
                pageBuilder: (context, state) => CustomTransitionPage(
                  child: SellerLivestreamScreen(
                    channelName: state.uri.queryParameters['channelName'] ?? '',
                    token: state.uri.queryParameters['token'] ?? '',
                  ),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                ),
              ),
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
              path: AppPath.authorizedUser.seller.account.goRoute,
              builder: (context, state) => const SellerProfileScreen(),
              routes: [
                GoRoute(
                  path: AppPath.authorizedUser.seller.account.settings.goRoute,
                  name: AppPath.authorizedUser.seller.account.settings.path,
                  pageBuilder: (context, state) => CustomTransitionPage(
                    child: const SellerSetingsScreen(),
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
              ]),
        ],
      ),
    ];
  }
}

class MainShell extends StatelessWidget {
  const MainShell({required this.userType, super.key});

  final UserType userType;

  @override
  Widget build(BuildContext context) {
    final shellRouter = GoRouter(
      initialLocation: userType == UserType.seller
          ? AppPath.authorizedUser.seller.analytics.path
          : AppPath.authorizedUser.buyer.exploreTab.path,
      routes: [
        StatefulShellRoute.indexedStack(
          builder: (context, state, navShell) =>
              ScaffoldWithNestedNavigation(navigationShell: navShell),
          branches: getBranches(userType),
        ),
      ],
    );

    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: darkTheme,
          darkTheme: darkTheme,
          themeMode: themeMode,
          routerConfig: shellRouter,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        );
      },
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
        body: body,
        bottomNavigationBar: profileCubit.state.whenOrNull(
          loaded: (user) => switch (user.userType) {
            UserType.buyer => BottomNavigationBar(
                currentIndex: selectedIndex,
                onTap: onDestinationSelected,
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
            UserType.seller => BottomNavigationBar(
                currentIndex: selectedIndex,
                onTap: onDestinationSelected,
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
              )
          },
        ),
      ),
    );
  }
}
