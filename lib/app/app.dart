import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:popcart/app/router.dart';
import 'package:popcart/app/theme.dart';
import 'package:popcart/app/theme_cubit.dart';
import 'package:popcart/features/live/cubits/active_livestream/active_livestreams_cubit.dart';
import 'package:popcart/features/live/cubits/open_livestream/open_livestream_cubit.dart';
import 'package:popcart/features/onboarding/cubits/interest_list/interest_list_cubit.dart';
import 'package:popcart/features/onboarding/cubits/onboarding/onboarding_cubit.dart';
import 'package:popcart/features/seller/cubits/product/product_cubit.dart';
import 'package:popcart/features/user/cubits/cubit/profile_cubit.dart';
import 'package:popcart/l10n/arb/app_localizations.dart';
import 'package:toastification/toastification.dart';

class PopCart extends StatelessWidget {
  const PopCart({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ThemeCubit(),
        ),
        BlocProvider(
          create: (context) => OnboardingCubit(),
        ),
        BlocProvider(
          create: (context) => InterestCubit()..getInterests(),
        ),
        BlocProvider(
          create: (context) => ProfileCubit()..fetchUserProfile(),
        ),
        BlocProvider(
          create: (context) => ProductCubit()..getInterests(),
        ),
        BlocProvider(
          create: (context) => OpenLivestreamCubit(),
        ),
        BlocProvider(
          create: (context) => ActiveLivestreamsCubit()..getActiveLivestreams(),
        ),
        BlocProvider(
          create: (context) => ScheduledLivestreamsCubit()..getScheduledLivestreams(),
        ),
      ],
      child: ToastificationWrapper(
        child: ScreenUtilInit(
          designSize: const Size(393, 852),
          builder: (_, child) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: const TextScaler.linear(0.8)),
            child: BlocBuilder<ThemeCubit, ThemeMode>(
              builder: (context, themeMode) {
                return MaterialApp.router(
                  debugShowCheckedModeBanner: false,
                  theme: darkTheme,
                  darkTheme: darkTheme,
                  themeMode: themeMode,
                  routerConfig: router,
                  localizationsDelegates:
                      AppLocalizations.localizationsDelegates,
                  supportedLocales: AppLocalizations.supportedLocales,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
