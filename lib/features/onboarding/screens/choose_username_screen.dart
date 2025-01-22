import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:popcart/app/router_paths.dart';
import 'package:popcart/core/colors.dart';
import 'package:popcart/core/widgets/bouncing_effect_widget.dart';
import 'package:popcart/core/widgets/buttons.dart';
import 'package:popcart/core/widgets/textfields.dart';
import 'package:popcart/features/onboarding/cubits/onboarding/onboarding_cubit.dart';
import 'package:popcart/features/onboarding/screens/enter_phone_number_screen.dart';
import 'package:popcart/l10n/arb/app_localizations.dart';

class ChooseUsernameScreen extends StatefulWidget {
  const ChooseUsernameScreen({super.key});

  @override
  State<ChooseUsernameScreen> createState() => _ChooseUsernameScreenState();
}

class _ChooseUsernameScreenState extends State<ChooseUsernameScreen>
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final onboardingCubit = context.watch<OnboardingCubit>();
    return Scaffold(
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
                  l10n.choose_a_username,
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
                  l10n.choose_a_username_sub,
                  style: const TextStyle(color: AppColors.white),
                ),
              ),
              const SizedBox(height: 24),
              SlideTransition(
                position: _thirdSlideAnimation,
                child: CustomTextFormField(
                  focusNode: _focusNode,
                  controller: _textEditingController,
                ),
              ),
              const Spacer(),
              ListenableBuilder(
                listenable: _textEditingController,
                builder: (_, __) {
                  return IgnorePointer(
                    ignoring: _textEditingController.text.length < 2,
                    child: BouncingEffect(
                      onTap: () {
                        onboardingCubit.username = _textEditingController.text;
                        context.pushNamed(AppPath.auth.buyerSignup.path);
                      },
                      child: AnimatedOpacity(
                        opacity:
                            _textEditingController.text.length >= 2 ? 1 : 0,
                        duration: const Duration(milliseconds: 300),
                        child: CustomElevatedButton(text: l10n.proceed),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
