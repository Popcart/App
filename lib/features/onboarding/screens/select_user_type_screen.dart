import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:popcart/app/app.module.dart';
import 'package:popcart/core/colors.dart';
import 'package:popcart/features/onboarding/cubits/onboarding/onboarding_cubit.dart';
import 'package:popcart/features/onboarding/screens/enter_phone_number_screen.dart';
import 'package:popcart/features/user/models/user_model.dart';
import 'package:popcart/gen/assets.gen.dart';
import 'package:popcart/l10n/arb/app_localizations.dart';

class SelectUserTypeScreen extends StatefulWidget {
  const SelectUserTypeScreen({super.key});

  @override
  State<SelectUserTypeScreen> createState() => _SelectUserTypeScreenState();
}

class _SelectUserTypeScreenState extends State<SelectUserTypeScreen>
    with TickerProviderStateMixin {
  late Animation<Offset> _firstSlideAnimation;
  late Animation<Offset> _secondSlideAnimation;
  late Animation<Offset> _thirdSlideAnimation;
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    // Staggered slide animations
    _firstSlideAnimation = Tween<Offset>(
      begin: const Offset(0.4, 0), // Starts off-screen to the right
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.4, curve: Curves.easeOut),
      ),
    );
    _secondSlideAnimation = Tween<Offset>(
      begin: const Offset(0.4, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.6, curve: Curves.easeOut),
      ),
    );
    _thirdSlideAnimation = Tween<Offset>(
      begin: const Offset(0.4, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 1, curve: Curves.easeOut),
      ),
    );
    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final onboardingCubit = context.watch<OnboardingCubit>();
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: AppAssets.images.authBg.image()),
          Positioned.fill(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AppBackButton(),
                    const SizedBox(height: 32),
                    FadeTransition(
                      opacity: _controller,
                      child: SlideTransition(
                        position: _firstSlideAnimation,
                        child: Text(
                          l10n.select_your_account_type,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 64),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        onboardingCubit.userType = UserType.buyer;
                        context.pushNamed(
                          AppPath.auth.buyerSignup.completeBuyerSignup.path,
                        );
                      },
                      child: FadeTransition(
                        opacity: _controller,
                        child: SlideTransition(
                          position: _secondSlideAnimation,
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Color(0xff24262b),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(24)),
                            ),
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                Container(
                                  width: 64,
                                  height: 64,
                                  decoration: BoxDecoration(
                                    color: const Color(0xfff97316),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                    image: DecorationImage(
                                      image: AppAssets.images.buyer.provider(),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      l10n.buyer,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      l10n.buyer_sub,
                                      style: const TextStyle(
                                        color: AppColors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                  color: AppColors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        onboardingCubit.userType = UserType.seller;
                        context.pushNamed(AppPath.auth.selectSellerType.path);
                      },
                      child: FadeTransition(
                        opacity: _controller,
                        child: SlideTransition(
                          position: _thirdSlideAnimation,
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Color(0xff24262b),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(24)),
                            ),
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                Container(
                                  width: 64,
                                  height: 64,
                                  decoration: BoxDecoration(
                                    color: const Color(0xfff97316),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                    image: DecorationImage(
                                      image: AppAssets.images.seller.provider(),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      l10n.seller,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      l10n.seller_sub,
                                      style: const TextStyle(
                                        color: AppColors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                  color: AppColors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          context.pushNamed(
                            AppPath.auth.login.path,
                          );
                        },
                        child: Text.rich(
                          TextSpan(
                            text: l10n.already_have_an_account,
                            style: const TextStyle(
                              color: AppColors.orange,
                              fontWeight: FontWeight.w600,
                            ),
                            children: [
                              const TextSpan(
                                text: ' ',
                              ),
                              TextSpan(
                                text: l10n.sign_in,
                                style: const TextStyle(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
