import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:popcart/app/router_paths.dart';
import 'package:popcart/app/service_locator.dart';
import 'package:popcart/app/shared_prefs.dart';
import 'package:popcart/features/onboarding/screens/enter_phone_number_screen.dart';
import 'package:popcart/features/onboarding/screens/video_splash_screen.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  debugLogDiagnostics: kDebugMode,
  navigatorKey: rootNavigatorKey,
  observers: [
    FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
  ],
  routes: [
    GoRoute(
      path: AppPath.splash.path,
      builder: (context, state) => const VideoSplashScreen(),
      // redirect: (context, state) {
      //   if (locator<SharedPrefs>().firstTime ?? true) {
      //     return null;
      //   }
      //   return AppPath.auth.path;
      // },
    ),
    GoRoute(
      path: AppPath.auth.path,
      builder: (context, state) => const EnterPhoneNumberScreen(),
    ),
  ],
);
