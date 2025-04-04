import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:popcart/app/app.module.dart';
import 'package:popcart/core/colors.dart';
import 'package:popcart/core/widgets/animated_widgets.dart';
import 'package:popcart/core/widgets/buttons.dart';
import 'package:popcart/features/onboarding/cubits/onboarding/onboarding_cubit.dart';
import 'package:popcart/features/onboarding/screens/enter_phone_number_screen.dart';
import 'package:popcart/gen/assets.gen.dart';
import 'package:popcart/l10n/arb/app_localizations.dart';

class SelectSellerTypeScreen extends StatefulHookWidget {
  const SelectSellerTypeScreen({super.key});

  @override
  State<SelectSellerTypeScreen> createState() => _SelectSellerTypeScreenState();
}

class _SelectSellerTypeScreenState extends State<SelectSellerTypeScreen>
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
    final onboardingCubit = context.watch<OnboardingCubit>();
    final l10n = AppLocalizations.of(context);
    final isRegistered = useState<bool?>(null);
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
                          l10n.are_you_a_registered_business,
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
                        isRegistered.value = true;
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
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 36,
                            ),
                            child: Row(
                              children: [
                                Radio<bool?>.adaptive(
                                  value: true,
                                  groupValue: isRegistered.value,
                                  onChanged: (onChanged) {
                                    isRegistered.value = onChanged;
                                  },
                                ),
                                const SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      l10n.yes,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
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
                        isRegistered.value = false;
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
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 36,
                            ),
                            child: Row(
                              children: [
                                Radio<bool?>.adaptive(
                                  value: false,
                                  groupValue: isRegistered.value,
                                  onChanged: (onChanged) {
                                    isRegistered.value = onChanged;
                                  },
                                ),
                                const SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      l10n.no,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
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
                    IgnorePointer(
                      ignoring: isRegistered.value == null,
                      child: AnimatedOpacity(
                        opacity: isRegistered.value == null ? 0 : 1,
                        duration: const Duration(milliseconds: 300),
                        child: BouncingEffect(
                          onTap: () {
                            if (isRegistered.value!) {
                              onboardingCubit.isRegisteredSeller = true;
                            } else {
                              onboardingCubit.isRegisteredSeller = false;
                            }
                            context.pushNamed(
                              AppPath
                                  .auth.signup.path,
                            );
                          },
                          child: CustomElevatedButton(
                            text: l10n.next,
                          ),
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
