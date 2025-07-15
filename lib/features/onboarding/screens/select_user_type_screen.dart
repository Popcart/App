import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:popcart/core/colors.dart';
import 'package:popcart/core/widgets/buttons.dart';
import 'package:popcart/features/onboarding/cubits/onboarding/onboarding_cubit.dart';
import 'package:popcart/features/common/models/user_model.dart';
import 'package:popcart/gen/assets.gen.dart';
import 'package:popcart/l10n/arb/app_localizations.dart';
import 'package:popcart/route/route_constants.dart';

class SelectUserTypeScreen extends StatefulHookWidget {
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
    final isBuyer = useState<bool?>(null);
    return Scaffold(
      body: Stack(
        children: [
          // Positioned.fill(child: AppAssets.images.authBg.image()),
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
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              isBuyer.value = true;
                              onboardingCubit.userType = UserType.buyer;
                            },
                            child: FadeTransition(
                              opacity: _controller,
                              child: SlideTransition(
                                position: _secondSlideAnimation,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xff24262b),
                                    border: Border.all(color: isBuyer.value ==
                                        null || isBuyer.value == false ?
                                    const Color(0xff24262b) : AppColors.orange),
                                    borderRadius:
                                    const BorderRadius.all(Radius.circular(24)),
                                  ),
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 64,
                                        height: 64,
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(20),
                                          ),
                                          image: DecorationImage(
                                            image: AppAssets.images.buyer.provider(),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        l10n.buyer,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        textAlign: TextAlign.center,
                                        // l10n.buyer_sub,
                                        "Find and purchase\nproducts",
                                        style: const TextStyle(
                                          color: AppColors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              isBuyer.value = false;
                              onboardingCubit.userType = UserType.seller;
                            },
                            child: FadeTransition(
                              opacity: _controller,
                              child: SlideTransition(
                                position: _thirdSlideAnimation,
                                child: Container(
                                  decoration:  BoxDecoration(
                                    color: const Color(0xff24262b),
                                    border: Border.all(color: isBuyer.value == null || isBuyer.value == true ?
                                    const Color(0xff24262b) : AppColors.orange),
                                    borderRadius:
                                    const BorderRadius.all(Radius.circular(24)),
                                  ),
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 64,
                                        height: 64,
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(20),
                                          ),
                                          image: DecorationImage(
                                            image: AppAssets.images.seller
                                                .provider(),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        l10n.seller,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        // l10n.seller_sub,
                                        "List and sell your\nproducts with ease",
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: AppColors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    IgnorePointer(
                      ignoring: isBuyer.value == null,
                      child: AnimatedOpacity(
                        opacity: isBuyer.value == null ? 0 : 1,
                        duration: const Duration(milliseconds: 300),
                        child: CustomElevatedButton(
                          text: l10n.next, onPressed: () {
                          Navigator.pushNamed(context, signUp);
                        },
                        ),
                      ),
                    ),
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
