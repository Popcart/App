import 'package:flutter/material.dart';
import 'package:popcart/features/buyer/account/buyer_profile_screen.dart';
import 'package:popcart/features/buyer/account/buyer_setings_screen.dart';
import 'package:popcart/features/buyer/buyer_home.dart';
import 'package:popcart/features/buyer/cart/delivery_address.dart';
import 'package:popcart/features/buyer/cart/payment_screen.dart';
import 'package:popcart/features/buyer/explore/search_screen.dart';
import 'package:popcart/features/live/models/products.dart';
import 'package:popcart/features/onboarding/screens/business_details_screen.dart';
import 'package:popcart/features/onboarding/screens/login_screen.dart';
import 'package:popcart/features/onboarding/screens/select_interests_screen.dart';
import 'package:popcart/features/onboarding/screens/select_user_type_screen.dart';
import 'package:popcart/features/onboarding/screens/sign_up_screen.dart';
import 'package:popcart/features/onboarding/screens/splash_screen.dart';
import 'package:popcart/features/onboarding/screens/verify_otp_screen.dart';
import 'package:popcart/features/onboarding/screens/video_splash_screen.dart';
import 'package:popcart/features/common/screen/product_screen.dart';
import 'package:popcart/features/seller/account/create_pop.dart';
import 'package:popcart/features/seller/account/profile_posts.dart';
import 'package:popcart/features/seller/account/select_video.dart';
import 'package:popcart/features/seller/account/seller_setings_screen.dart';
import 'package:popcart/features/seller/analytics/inventory_product_screen.dart';
import 'package:popcart/features/seller/analytics/top_product_screen.dart';
import 'package:popcart/features/seller/inventory/add_product_screen.dart';
import 'package:popcart/features/seller/inventory/edit_product_screen.dart';
import 'package:popcart/features/seller/live/seller_livestream_screen.dart';
import 'package:popcart/features/seller/models/video_post_response.dart';
import 'package:popcart/features/seller/seller_home.dart';
import 'package:popcart/route/route_constants.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case splashRoute:
      return MaterialPageRoute(
        builder: (context) => const SplashScreen(),
      );
    case onboardingScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const VideoSplashScreen(),
      );
    case loginScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      );
    case otpScreen:
      return MaterialPageRoute(
        builder: (context) => const VerifyOtpScreen(),
      );
    case interestScreen:
      return MaterialPageRoute(
        builder: (context) => const SelectInterestsScreen(),
      );
    case selectAccountTypeScreen:
      return MaterialPageRoute(
        builder: (context) => const SelectUserTypeScreen(),
      );
    case signUp:
      return MaterialPageRoute(
        builder: (context) => const SignUpScreen(),
      );
    case businessDetails:
      return MaterialPageRoute(
        builder: (context) => const BusinessDetailsScreen(),
      );

    case sellerHome:
      return MaterialPageRoute(
        builder: (context) => const SellerHome(),
        settings: const RouteSettings(name: sellerHome),
      );

    case sellerSettings:
      return MaterialPageRoute(
          builder: (context) => const SellerSetingsScreen());

  //Buyer screens
    case buyerHome:
      return MaterialPageRoute(
        builder: (context) => const BuyerHome(),
        settings: const RouteSettings(name: buyerHome),
      );
    case searchScreen:
      return MaterialPageRoute(
        builder: (context) => const SearchScreen(),
      );
    case settingsScreen:
      return MaterialPageRoute(
        builder: (context) => const BuyerSetingsScreen(),
      );
    case profileScreen:
      return MaterialPageRoute(
        builder: (context) => const BuyerProfileScreen(),
      );
    case topProductScreen:
      return MaterialPageRoute(
        builder: (context) => const TopProductScreen(),
      );
    case inventoryScreen:
      return MaterialPageRoute(
        builder: (context) => const InventoryProductScreen(),
      );
    case editProductScreen:
      return MaterialPageRoute(builder: (context) {
        final product = settings.arguments! as Product;
        return EditProductScreen(productModal: product);
      });
    case addProductScreen:
      return MaterialPageRoute(
        builder: (context) => const AddProductScreen(),
      );
    case deliveryAddress:
      return MaterialPageRoute(
        builder: (context) => const DeliveryAddress(),
      );
    case paymentScreen:
      return MaterialPageRoute(
        builder: (context) {
          final deliveryAddress = settings.arguments! as Map<String, dynamic>;
          return PaymentScreen(address: deliveryAddress,);
        },
      );
    case productScreen:
      return MaterialPageRoute(
        builder: (context) {
          final productId = settings.arguments! as String;
          return ProductScreen(productId: productId);
        },
      );
    case sellerLiveStream:
      return MaterialPageRoute(
        builder: (context) {
          final map = settings.arguments! as Map<String, String?>;
          return SellerLivestreamScreen(
            channelName: map['channelName']!,
            token: map['token']!,
          );
        },
      );
    case selectVideo:
      return MaterialPageRoute(
        builder: (context) {
          return const SelectVideo();
        },
      );

    case createPopPlay:
      return MaterialPageRoute(
        builder: (context) {
          final map = settings.arguments! as Map<String, String?>;
          return CreatePopScreen(
            artifact: map['artifact']!,
            thumbnail: map['thumbnail']!,
          );
        },
      );

    case popPlayScreen:
      return MaterialPageRoute(
        builder: (context) {
          final map = settings.arguments! as Map<String, dynamic>;
          final posts = map['posts'] as List<VideoPost>;
          final index = map['index'] as int;
          return ProfilePosts(
            posts: posts,
            index: index,
          );
        },
      );

    default:
      return MaterialPageRoute(
        // Make a screen for undefine
        builder: (context) => const VideoSplashScreen(),
      );
  }
}
