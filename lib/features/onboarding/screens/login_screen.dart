import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:popcart/app/router_paths.dart';
import 'package:popcart/core/colors.dart';
import 'package:popcart/core/utils.dart';
import 'package:popcart/core/widgets/animated_widgets.dart';
import 'package:popcart/core/widgets/buttons.dart';
import 'package:popcart/core/widgets/textfields.dart';
import 'package:popcart/features/onboarding/cubits/onboarding/onboarding_cubit.dart';
import 'package:popcart/features/onboarding/screens/enter_phone_number_screen.dart';
import 'package:popcart/l10n/arb/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _firstSlideAnimation;
  late Animation<Offset> _secondSlideAnimation;
  late Animation<Offset> _thirdSlideAnimation;
  late FocusNode _focusNode;
  late TextEditingController _textEditingController;

  @override
  void initState() {
    _textEditingController = TextEditingController(text: '+234');
    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    _firstSlideAnimation = Tween<Offset>(
      begin: const Offset(0.3, 0), // Slide in from right
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      ),
    );

    _secondSlideAnimation = Tween<Offset>(
      begin: const Offset(0.3, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      ),
    );

    _thirdSlideAnimation = Tween<Offset>(
      begin: const Offset(0.3, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      ),
    );
    _focusNode = FocusNode();
    _controller.forward().then((_) => _focusNode.requestFocus());
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _controller.dispose();
    _focusNode.dispose();

    super.dispose();
  }

  void sendOtp() {
    context.read<OnboardingCubit>()
      ..phoneNumber = _textEditingController.text
      ..sendOtp();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final onboardingCubit = context.watch<OnboardingCubit>();

    return BlocListener<OnboardingCubit, OnboardingState>(
      listener: (context, state) {
        state.whenOrNull(
          sendOtpSuccess: () => context.pushNamed(
            AppPath.auth.otp.path,
          ),
          sendOtpFailure: (message) => context.showError(message),
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
                    l10n.enter_your_phone_number,
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
                    l10n.enter_your_phone_number_sub,
                    style: const TextStyle(color: AppColors.white),
                  ),
                ),
                const SizedBox(height: 24),
                SlideTransition(
                  position: _thirdSlideAnimation,
                  child: CustomTextFormField(
                    focusNode: _focusNode,
                    controller: _textEditingController,
                    keyboardType: TextInputType.phone,
                  ),
                ),
                const SizedBox(height: 24),
                ListenableBuilder(
                  listenable: _textEditingController,
                  builder: (_, __) {
                    return IgnorePointer(
                      ignoring: _textEditingController.text.length != 14 ||
                          onboardingCubit.state.maybeWhen(
                            orElse: () => false,
                            loading: () => true,
                          ),
                      child: BouncingEffect(
                        onTap: sendOtp,
                        child: AnimatedOpacity(
                          opacity:
                              _textEditingController.text.length == 14 ? 1 : 0,
                          duration: const Duration(milliseconds: 300),
                          child: CustomElevatedButton(
                            text: "Sign in",
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
                const SizedBox(height: 24),
                SlideTransition(
                  position: _secondSlideAnimation,
                  child: Center(
                    child: RichText(
                        text: TextSpan(
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Colors.white),
                            children: [
                          const TextSpan(
                            text: "Don't have an account? ",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Colors.white),
                          ),
                          TextSpan(
                            text: "Sign up",
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                context.pushNamed(
                                  AppPath.auth.accountType.path,
                                );
                              },
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                decoration: TextDecoration.underline,
                                color: AppColors.orange,),
                          )
                        ])),
                  ),
                ),
                const SizedBox(height: 14),
                SlideTransition(
                  position: _secondSlideAnimation,
                  child: const Center(
                    child: Text(
                      'Forgot Password',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                          color: AppColors.orange,),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
