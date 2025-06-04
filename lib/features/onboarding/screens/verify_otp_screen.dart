import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:popcart/app/app.module.dart';
import 'package:popcart/core/colors.dart';
import 'package:popcart/core/utils.dart';
import 'package:popcart/core/widgets/buttons.dart';
import 'package:popcart/core/widgets/textfields.dart';
import 'package:popcart/features/onboarding/cubits/onboarding/onboarding_cubit.dart';
import 'package:popcart/features/user/models/user_model.dart';
import 'package:popcart/l10n/arb/app_localizations.dart';
import 'package:timer_count_down/timer_count_down.dart';

class VerifyOtpScreen extends StatefulHookWidget {
  const VerifyOtpScreen({super.key});

  @override
  State<VerifyOtpScreen> createState() => _VerifyPhoneNumberScreenState();
}

class _VerifyPhoneNumberScreenState extends State<VerifyOtpScreen>
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

  void handleResendOTP() {
    context.read<OnboardingCubit>().sendOtp(isResendingOtp: true);
  }

  void _onProceed() {
    final onboardingCubit = context.read<OnboardingCubit>();
    if (onboardingCubit.isLoggingIn) {
      context.push(AppPath.authorizedUser.path);
    } else {
      if (onboardingCubit.userType == UserType.buyer) {
        context.pushNamed(AppPath.auth.interestScreen.path);
      } else {
        context.pushNamed(AppPath.auth.businessDetails.path);
      }
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final onboardingCubit = context.watch<OnboardingCubit>();
    final otpSent = useState(false);

    useEffect(
      () {
        // Initialize by simulating an OTP sent when screen loads
        otpSent.value = true;
        return null;
      },
      const [],
    );
    return BlocListener<OnboardingCubit, OnboardingState>(
      listener: (context, state) {
        state.whenOrNull(
          verifyOtpFailure: (message) {
            context.showError(message);
          },
          verifyOtpSuccess: _onProceed,
          resendOtpSuccess: () {
            otpSent.value = true;
          },
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
                    'We just sent the verification code to your email address '
                    '${onboardingCubit.email}',
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
                SizedBox(
                  height: 20,
                ),
                if (otpSent.value)
                  OTPCountdownTimer(
                    onResendPressed: handleResendOTP,
                  ),
                const Spacer(),
                ListenableBuilder(
                  listenable: _textEditingController,
                  builder: (_, __) {
                    return IgnorePointer(
                      ignoring: _textEditingController.text.length != 5 ||
                          onboardingCubit.state.maybeWhen(
                            orElse: () => false,
                            loading: () => true,
                          ),
                      child: AnimatedOpacity(
                        opacity:
                            _textEditingController.text.length == 5 ? 1 : 0,
                        duration: const Duration(milliseconds: 300),
                        child: CustomElevatedButton(
                          text: l10n.next,
                          loading: onboardingCubit.state.maybeWhen(
                            orElse: () => false,
                            loading: () => true,
                          ),
                          onPressed: () {
                            onboardingCubit.verifyOtp(
                              otp: _textEditingController.text,
                            );
                          },
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

class OTPCountdownTimer extends HookWidget {
  const OTPCountdownTimer({
    required this.onResendPressed,
    super.key,
    this.timerDuration = 120, // 2 minutes in seconds
  });

  final void Function() onResendPressed;
  final int timerDuration;

  @override
  Widget build(BuildContext context) {
    final isTimerRunning = useState(true);
    final countdownKey = useState(UniqueKey());
    void restartTimer() {
      isTimerRunning.value = true;
      countdownKey.value = UniqueKey();
      onResendPressed();
    }

    return isTimerRunning.value
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Resend OTP in ',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 14,
                ),
              ),
              Countdown(
                key: countdownKey.value,
                seconds: timerDuration,
                build: (BuildContext context, double time) {
                  final minutes = (time ~/ 60).toString().padLeft(2, '0');
                  final seconds =
                      (time % 60).floor().toString().padLeft(2, '0');
                  return Text(
                    '$minutes:$seconds',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  );
                },
                onFinished: () {
                  isTimerRunning.value = false;
                },
              ),
            ],
          )
        : TextButton(
            onPressed: restartTimer,
            child: const Text(
              'Resend OTP',
              style: TextStyle(
                color: AppColors.orange,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          );
  }
}
