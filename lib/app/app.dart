import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:popcart/app/router.dart';
import 'package:popcart/l10n/arb/app_localizations.dart';
import 'package:toastification/toastification.dart';

// final contextGlobalKey = GlobalKey();

class PopCart extends StatelessWidget {
  const PopCart({super.key});

  // final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: ScreenUtilInit(
        designSize: const Size(393, 852),
        builder: (_, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: const TextScaler.linear(0.8)),
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              fontFamily: 'WorkSans',
              scaffoldBackgroundColor: Colors.white,
              textSelectionTheme: const TextSelectionThemeData(
                  // cursorColor: greenPrimaryColor,
                  ),
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
    );
  }
}
