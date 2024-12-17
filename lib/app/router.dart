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

final rootNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  debugLogDiagnostics: kDebugMode,
  navigatorKey: rootNavigatorKey,
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
  ],
);
