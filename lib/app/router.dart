import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:popcart/app/router_paths.dart';
import 'package:popcart/features/onboarding/screens/business_signup_screen.dart';
import 'package:popcart/features/onboarding/screens/buyer_signup_screen.dart';
import 'package:popcart/features/onboarding/screens/choose_username_screen.dart';
import 'package:popcart/features/onboarding/screens/complete_buyer_registration_screen.dart';
import 'package:popcart/features/onboarding/screens/complete_individual_business_signup_screen.dart';
import 'package:popcart/features/onboarding/screens/complete_registered_business_signup_screen.dart';
import 'package:popcart/features/onboarding/screens/select_seller_type_screen.dart';
// import 'package:popcart/features/onboarding/screens/enter_phone_number_screen.dart';
import 'package:popcart/features/onboarding/screens/select_user_type_screen.dart';
import 'package:popcart/features/onboarding/screens/verify_phone_number_screen.dart';
import 'package:popcart/features/onboarding/screens/video_splash_screen.dart';
import 'package:popcart/gen/assets.gen.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  debugLogDiagnostics: kDebugMode,
  navigatorKey: rootNavigatorKey,
  initialLocation: AppPath.authorizedUser.live.path,
  observers: [
    // FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
  ],
  routes: [
    GoRoute(
      path: AppPath.splash.goRoute,
      // builder: (context, state) => const VideoSplashScreen(),
      pageBuilder: (context, state) => CustomTransitionPage(
        child: const VideoSplashScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
      redirect: (context, state) {
        // if (locator<SharedPrefs>().firstTime ?? true) {
        //   return null;
        // }
        return null;
      },
    ),
    GoRoute(
      path: AppPath.auth.goRoute,
      // builder: (context, state) => const SelectUserTypeScreen(),
      pageBuilder: (context, state) => CustomTransitionPage(
        child: const SelectUserTypeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
      routes: [
        GoRoute(
          path: AppPath.auth.selectSellerType.goRoute,
          name: AppPath.auth.selectSellerType.path,
          // builder: (context, state) => const SelectSellerTypeScreen(),
          pageBuilder: (context, state) => CustomTransitionPage(
            child: const SelectSellerTypeScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
          routes: [
            GoRoute(
              path: AppPath.auth.sellerSignup.businessSignup.goRoute,
              name: AppPath.auth.sellerSignup.businessSignup.path,
              pageBuilder: (context, state) => CustomTransitionPage(
                child: const BusinessSignupScreen(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
              ),
              routes: [
                GoRoute(
                  path: AppPath.auth.sellerSignup.businessSignup
                      .completeRegisteredBusinessSignup.goRoute,
                  name: AppPath.auth.sellerSignup.businessSignup
                      .completeRegisteredBusinessSignup.path,
                  pageBuilder: (context, state) => CustomTransitionPage(
                    child: const CompleteRegisteredBusinessSignupScreen(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                  ),
                ),
                GoRoute(
                  path: AppPath.auth.sellerSignup.businessSignup
                      .completeIndividualBusinessSignup.goRoute,
                  name: AppPath.auth.sellerSignup.businessSignup
                      .completeIndividualBusinessSignup.path,
                  pageBuilder: (context, state) => CustomTransitionPage(
                    child: const CompleteIndividualBusinessSignupScreen(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: AppPath.auth.buyerSignup.goRoute,
          name: AppPath.auth.buyerSignup.path,
          pageBuilder: (context, state) => CustomTransitionPage(
            child: const BuyerSignupScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
          routes: [
            GoRoute(
              path: AppPath.auth.buyerSignup.verifyPhoneNumber.goRoute,
              name: AppPath.auth.buyerSignup.verifyPhoneNumber.path,
              pageBuilder: (context, state) => CustomTransitionPage(
                child: const VerifyPhoneNumberScreen(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
              ),
            ),
            GoRoute(
              path: AppPath.auth.buyerSignup.chooseUsername.goRoute,
              name: AppPath.auth.buyerSignup.chooseUsername.path,
              pageBuilder: (context, state) => CustomTransitionPage(
                child: const ChooseUsernameScreen(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
              ),
            ),
            GoRoute(
              path: AppPath.auth.buyerSignup.completeBuyerSignup.goRoute,
              name: AppPath.auth.buyerSignup.completeBuyerSignup.path,
              pageBuilder: (context, state) => CustomTransitionPage(
                child: const CompleteBuyerRegistrationScreen(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
              ),
            ),
          ],
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
              path: AppPath.authorizedUser.auctions.goRoute,
              builder: (context, state) => const Scaffold(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppPath.authorizedUser.live.goRoute,
              builder: (context, state) => const Scaffold(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppPath.authorizedUser.account.goRoute,
              builder: (context, state) => const Scaffold(),
            ),
          ],
        ),
      ],
    ),
  ],
);

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
    return Scaffold(
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xff111214),
        onTap: onDestinationSelected,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
          color: Colors.white,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 12,
          color: Colors.white,
        ),
        items: [
          BottomNavigationBarItem(
            activeIcon: AppAssets.icons.auctionsSelected.svg(),
            icon: AppAssets.icons.auctionsUnselected.svg(),
            label: 'Auctions',
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
    );
  }
}

class BottomNavWidget extends StatelessWidget {
  const BottomNavWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        // BottomNavigationBarItem(icon: icon)
      ],
    );
  }
}
