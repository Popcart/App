import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class CompleteIndividualBusinessSignupScreen extends StatefulWidget {
  const CompleteIndividualBusinessSignupScreen({super.key});

  @override
  State<CompleteIndividualBusinessSignupScreen> createState() =>
      _CompleteIndividualBusinessSignupScreenState();
}

class _CompleteIndividualBusinessSignupScreenState
    extends State<CompleteIndividualBusinessSignupScreen>
    with SingleTickerProviderStateMixin {
  late final TextEditingController _bvnController;
  late final TextEditingController _businessNameController;
  late final FocusNode _bvnFocusNode;
  late AnimationController _controller;
  late Animation<Offset> _firstSlideAnimation;
  late Animation<Offset> _secondSlideAnimation;
  late Animation<Offset> _thirdSlideAnimation;
  late Animation<Offset> _fourthSlideAnimation;
  late Animation<Offset> _fifthSlideAnimation;
  @override
  void initState() {
    _bvnController = TextEditingController();
    _businessNameController = TextEditingController();

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
    _fourthSlideAnimation = Tween<Offset>(
      begin: const Offset(0.4, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.6, curve: Curves.easeOut),
      ),
    );
    _fifthSlideAnimation = Tween<Offset>(
      begin: const Offset(0.4, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.6, curve: Curves.easeOut),
      ),
    );
    _bvnFocusNode = FocusNode();
    _controller.forward().then((_) => _bvnFocusNode.requestFocus());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final onbaordingCubit = context.watch<OnboardingCubit>();
    return BlocListener<OnboardingCubit, OnboardingState>(
      listener: (context, state) {
        state.whenOrNull(
          onboardingFailure: (message) => context.showError(message),
          onboardingSuccess: () => context.go(AppPath.authorizedUser.live.path),
          submitRegisteredBusinessInformationSuccess: () {
            context.go(AppPath.authorizedUser.live.path);
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
                    l10n.business_details,
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
                    l10n.business_details_sub,
                    style: const TextStyle(color: AppColors.white),
                  ),
                ),
                const SizedBox(height: 24),
                SlideTransition(
                  position: _thirdSlideAnimation,
                  child: CustomTextFormField(
                    focusNode: _bvnFocusNode,
                    controller: _bvnController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(11),
                    ],
                    hintText: 'BVN',
                  ),
                ),
                const SizedBox(height: 16),
                SlideTransition(
                  position: _fourthSlideAnimation,
                  child: CustomTextFormField(
                    controller: _businessNameController,
                    hintText: 'Business Name(Optional)',
                  ),
                ),
                const SizedBox(height: 16),
                SlideTransition(
                  position: _fifthSlideAnimation,
                  child: CustomTextFormField(
                    hintText: 'Business Email(Optional)',
                  ),
                ),
                const Spacer(),
                ListenableBuilder(
                  listenable: _bvnController,
                  builder: (context, child) {
                    if (_bvnController.text.length == 11) {
                      return BouncingEffect(
                        onTap: () {
                          context
                              .read<OnboardingCubit>()
                              .submitIndividualBusinessInformation(
                                bvn: _bvnController.text,
                                businessName: _businessNameController.text,
                                // businessEmail: _
                              );
                        },
                        child: CustomElevatedButton(
                          text: l10n.next,
                          loading: onbaordingCubit.state.maybeWhen(
                            loading: () => true,
                            orElse: () => false,
                          ),
                        ),
                      );
                    }
                    return const SizedBox();
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
