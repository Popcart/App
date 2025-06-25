import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:popcart/app/service_locator.dart';
import 'package:popcart/app/shared_prefs.dart';
import 'package:popcart/core/colors.dart';
import 'package:popcart/gen/assets.gen.dart';
import 'package:popcart/route/route_constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () async {
      final isLoggedIn = locator.get<SharedPrefs>().loggedIn;
      if (isLoggedIn) {
        final token = locator.get<SharedPrefs>().accessToken ?? '';
        if (token.isNotEmpty) {
          locator.get<SharedPrefs>().accessToken = token;
        }
        final isBuyer = locator.get<SharedPrefs>().isBuyer;
        if(isBuyer) {
          await Navigator.pushNamedAndRemoveUntil(
            Get.context!,
            buyerHome,
                (route) => false,
          );
        }else{
          await Navigator.pushNamedAndRemoveUntil(
            Get.context!,
            sellerHome,
                (route) => false,
          );
        }
      }else{
        await Navigator.pushNamedAndRemoveUntil(
          Get.context!,
          onboardingScreenRoute,
              (route) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.appBackground,
        body: Center(
            child: Image.asset(
              AppAssets.images.appLogo.path,
              width: 50,
              height: 50,
            )));
  }
}
