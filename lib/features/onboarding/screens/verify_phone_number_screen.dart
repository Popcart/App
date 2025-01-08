import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:popcart/app/app.module.dart';
import 'package:popcart/core/colors.dart';
import 'package:popcart/core/utils.dart';
import 'package:popcart/core/widgets/bouncing_effect_widget.dart';
import 'package:popcart/core/widgets/buttons.dart';
import 'package:popcart/core/widgets/textfields.dart';
import 'package:popcart/features/onboarding/cubits/cubit/onboarding_cubit.dart';
import 'package:popcart/features/onboarding/screens/enter_phone_number_screen.dart';
import 'package:popcart/l10n/arb/app_localizations.dart';

bool isSeller = false;
bool isBusinessSeller = false;

class VerifyPhoneNumberScreen extends StatefulWidget {
  const VerifyPhoneNumberScreen({super.key});

  @override
  State<VerifyPhoneNumberScreen> createState() =>
      _VerifyPhoneNumberScreenState();
}

class _VerifyPhoneNumberScreenState extends State<VerifyPhoneNumberScreen>
    with TickerProviderStateMixin {
  late Animation<Offset> _firstSlideAnimation;
  late Animation<Offset> _secondSlideAnimation;
  late Animation<Offset> _thirdSlideAnimation;
  late AnimationController _controller;
  late FocusNode _focusNode;
  late TextEditingController _textEditingController;

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
    _textEditingController = TextEditingController();
    _focusNode = FocusNode();
    _controller.forward().then((_) => _focusNode.requestFocus());
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _textEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onProceed() {
    final onboardingCubit = context.read<OnboardingCubit>();
    if (onboardingCubit.userType == UserType.buyer) {
      context.go(AppPath.authorizedUser.auctions.goRoute);
      return;
    }

    if (onboardingCubit.userType != UserType.buyer) {
      if (onboardingCubit.isRegisteredSeller) {
        context.pushNamed(
          AppPath.auth.sellerSignup.businessSignup
              .completeRegisteredBusinessSignup.path,
        );
        return;
      }
      if (!onboardingCubit.isRegisteredSeller) {
        context.pushNamed(
          AppPath.auth.sellerSignup.businessSignup
              .completeIndividualBusinessSignup.path,
        );
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final onboardingCubit = context.watch<OnboardingCubit>();

    return BlocListener<OnboardingCubit, OnboardingState>(
      listener: (context, state) {
        state.whenOrNull(
          verifyOtpFailure: (message) {
            context.showError(message);
            // _onProceed()  ;
          },
          verifyOtpSuccess: _onProceed,
        );
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppBackButton(),
                const SizedBox(height: 32),
                SlideTransition(
                  position: _firstSlideAnimation,
                  child: Text(
                    l10n.input_the_otp_code,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SlideTransition(
                  position: _secondSlideAnimation,
                  child: Text(
                    l10n.otp_code_sub,
                    style: const TextStyle(color: AppColors.white),
                  ),
                ),
                const SizedBox(height: 24),
                SlideTransition(
                  position: _thirdSlideAnimation,
                  child: CustomPinField(
                    focusNode: _focusNode,
                    controller: _textEditingController,
                  ),
                ),
                const Spacer(),
                ListenableBuilder(
                  listenable: _textEditingController,
                  builder: (_, __) {
                    return IgnorePointer(
                      ignoring: _textEditingController.text.length != 4 ||
                          onboardingCubit.state.maybeWhen(
                            orElse: () => false,
                            loading: () => true,
                          ),
                      child: BouncingEffect(
                        onTap: () {
                          onboardingCubit.verifyOtp(
                            otp: _textEditingController.text,
                          );
                        },
                        child: AnimatedOpacity(
                          opacity:
                              _textEditingController.text.length == 4 ? 1 : 0,
                          duration: const Duration(milliseconds: 300),
                          child: CustomElevatedButton(
                            text: l10n.proceed,
                            loading: onboardingCubit.state.maybeWhen(
                              orElse: () => false,
                              loading: () => true,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
