import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:popcart/app/router_paths.dart';
import 'package:popcart/app/service_locator.dart';
import 'package:popcart/app/shared_prefs.dart';
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
import 'package:popcart/features/onboarding/screens/business_signup_screen.dart';
import 'package:popcart/features/onboarding/screens/buyer_signup_screen.dart';
import 'package:popcart/features/onboarding/screens/choose_username_screen.dart';
import 'package:popcart/features/onboarding/screens/complete_buyer_registration_screen.dart';
import 'package:popcart/features/onboarding/screens/complete_individual_business_signup_screen.dart';
import 'package:popcart/features/onboarding/screens/complete_registered_business_signup_screen.dart';
import 'package:popcart/features/onboarding/screens/login_screen.dart';
import 'package:popcart/features/onboarding/screens/select_interests_screen.dart';
import 'package:popcart/features/onboarding/screens/select_seller_type_screen.dart';
// import 'package:popcart/features/onboarding/screens/enter_phone_number_screen.dart';
import 'package:popcart/features/onboarding/screens/select_user_type_screen.dart';
import 'package:popcart/features/onboarding/screens/verify_phone_number_screen.dart';
import 'package:popcart/features/onboarding/screens/video_splash_screen.dart';
import 'package:popcart/features/user/cubits/cubit/profile_cubit.dart';
import 'package:popcart/features/user/models/user_model.dart';
import 'package:popcart/gen/assets.gen.dart';
import 'package:webview_flutter/webview_flutter.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  debugLogDiagnostics: kDebugMode,
  navigatorKey: rootNavigatorKey,
  initialLocation: AppPath.splash.path,
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
        if (locator<SharedPrefs>().loggedIn) {
          return AppPath.authorizedUser.live.path;
        }
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
              path: AppPath.auth.login.goRoute,
              name: AppPath.auth.login.path,
              pageBuilder: (context, state) => CustomTransitionPage(
                child: const LoginScreen(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
              ),
            ),
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
            GoRoute(
              path: AppPath.auth.buyerSignup.selectInterests.goRoute,
              name: AppPath.auth.buyerSignup.selectInterests.path,
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
              builder: (context, state) => const LiveScreen(),
              routes: [
                GoRoute(
                  path: AppPath.authorizedUser.live.scheduleSession.goRoute,
                  name: AppPath.authorizedUser.live.scheduleSession.path,
                  pageBuilder: (context, state) => CustomTransitionPage(
                    child: const ScheduleSessionScreen(),
                    // implement a slide up transition
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
                  path: AppPath.authorizedUser.live.selectProducts.goRoute,
                  name: AppPath.authorizedUser.live.selectProducts.path,
                  pageBuilder: (context, state) => CustomTransitionPage(
                    child: const SelectProductsScreen(),
                    // implement a slide up transition
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                  ),
                ),
                GoRoute(
                  path: AppPath.authorizedUser.live.sellerLivestream.goRoute,
                  name: AppPath.authorizedUser.live.sellerLivestream.path,
                  parentNavigatorKey: rootNavigatorKey,
                  pageBuilder: (context, state) => CustomTransitionPage(
                    child: SellerLivestreamScreen(
                      channelName:
                          state.uri.queryParameters['channelName'] ?? '',
                      token: state.uri.queryParameters['token'] ?? '',
                    ),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                  ),
                ),
                GoRoute(
                  path: AppPath.authorizedUser.live.buyerLivestream.goRoute,
                  name: AppPath.authorizedUser.live.buyerLivestream.path,
                  parentNavigatorKey: rootNavigatorKey,
                  pageBuilder: (context, state) => CustomTransitionPage(
                    child: BuyerLivestreamScreen(
                      liveStream: state.extra! as LiveStream,
                      token: state.uri.queryParameters['token'] ?? '',
                    ),
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
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppPath.authorizedUser.account.goRoute,
              builder: (context, state) => const AccountWebview(),
            ),
            GoRoute(
              path: AppPath.authorizedUser.account.settings.goRoute,
              builder: (context, state) => const BuyerSetingsScreen(),
            ),
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
    return Scaffold(
      body: body,
      bottomNavigationBar: profileCubit.state.whenOrNull(
        loaded: (user) => switch (user.userType) {
          UserType.seller => null,
          UserType.buyer => BottomNavigationBar(
              currentIndex: selectedIndex,
              backgroundColor: const Color(0xff111214),
              onTap: onDestinationSelected,
              selectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
              showUnselectedLabels: false,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white,
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 12,
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
            )
        },
      ),
    );
  }
}
