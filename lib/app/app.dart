import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:popcart/app/router.dart';
import 'package:popcart/core/colors.dart';
import 'package:popcart/features/onboarding/cubits/interest_list/interest_list_cubit.dart';
import 'package:popcart/features/onboarding/cubits/onboarding/onboarding_cubit.dart';
import 'package:popcart/features/user/cubits/cubit/profile_cubit.dart';
import 'package:popcart/l10n/arb/app_localizations.dart';
import 'package:toastification/toastification.dart';

// final contextGlobalKey = GlobalKey();

class PopCart extends StatelessWidget {
  const PopCart({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => OnboardingCubit(),
        ),
        BlocProvider(
          create: (context) => InterestListCubit()..getInterests(),
        ),
        BlocProvider(
          create: (context) => ProfileCubit()..fetchUserProfile(),
        ),
      ],
      child: ToastificationWrapper(
        child: ScreenUtilInit(
          designSize: const Size(393, 852),
          builder: (_, child) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: const TextScaler.linear(0.8)),
            child: MaterialApp.router(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                progressIndicatorTheme: const ProgressIndicatorThemeData(
                  color: AppColors.white,
                ),
                bottomAppBarTheme: const BottomAppBarTheme(
                  color: Color(0xff111214),
                ),
                fontFamily: 'WorkSans',
                textSelectionTheme: const TextSelectionThemeData(
                  cursorColor: AppColors.orange,
                ),
                radioTheme: RadioThemeData(
                  fillColor: WidgetStateProperty.all(AppColors.orange),
                ),
                listTileTheme: const ListTileThemeData(
                  contentPadding: EdgeInsets.zero,
                  titleTextStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  selectedTileColor: AppColors.orange,
                ),
                floatingActionButtonTheme: const FloatingActionButtonThemeData(
                  backgroundColor: AppColors.orange,
                  foregroundColor: Colors.white,
                ),
                scaffoldBackgroundColor: const Color(0xff111214),
                elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    fixedSize: const Size(double.infinity, 56),
                  ),
                ),
                appBarTheme: const AppBarTheme(
                  centerTitle: false,
                  surfaceTintColor: Colors.white,
                  backgroundColor: Colors.white,
                  elevation: 0.1,
                  shadowColor: Color(0xff091824),
                  titleTextStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 21,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              routerConfig: router,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
            ),
          ),
        ),
      ),
    );
  }
}
