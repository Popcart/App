import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_validator/form_validator.dart';
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

class CompleteBuyerRegistrationScreen extends StatefulWidget {
  const CompleteBuyerRegistrationScreen({super.key});

  @override
  State<CompleteBuyerRegistrationScreen> createState() =>
      _CompleteBuyerRegistrationScreenState();
}

class _CompleteBuyerRegistrationScreenState
    extends State<CompleteBuyerRegistrationScreen>
    with TickerProviderStateMixin {
  late Animation<Offset> _firstSlideAnimation;
  late Animation<Offset> _secondSlideAnimation;
  late Animation<Offset> _thirdSlideAnimation;
  late Animation<Offset> _fourthSlideAnimation;
  late Animation<Offset> _fifthSlideAnimation;
  late AnimationController _controller;
  late FocusNode _focusNode;
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late final GlobalKey<FormState> _formKey;

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
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
        curve: const Interval(0, 0.2, curve: Curves.easeOut),
      ),
    );
    _secondSlideAnimation = Tween<Offset>(
      begin: const Offset(0.4, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.4, curve: Curves.easeOut),
      ),
    );
    _thirdSlideAnimation = Tween<Offset>(
      begin: const Offset(0.4, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.6, curve: Curves.easeOut),
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
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _focusNode = FocusNode();
    _controller.forward().then((_) => _focusNode.requestFocus());
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _focusNode.dispose();
    _formKey.currentState?.dispose();
    super.dispose();
  }

  void _onProceed() {
    if (!_formKey.currentState!.validate()) return;
    context.read<OnboardingCubit>()
      ..firstName = _firstNameController.text
      ..lastName = _lastNameController.text
      ..email = _emailController.text;
    context.pushNamed(AppPath.auth.buyerSignup.chooseUsername.path);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppBackButton(),
                const SizedBox(height: 32),
                SlideTransition(
                  position: _firstSlideAnimation,
                  child: Text(
                    l10n.your_details,
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
                    l10n.your_details_sub,
                    style: const TextStyle(color: AppColors.white),
                  ),
                ),
                const SizedBox(height: 24),
                SlideTransition(
                  position: _thirdSlideAnimation,
                  child: CustomTextFormField(
                    focusNode: _focusNode,
                    controller: _firstNameController,
                    hintText: 'First Name',
                    validator: ValidationBuilder().required().build(),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.words,
                  ),
                ),
                const SizedBox(height: 16),
                SlideTransition(
                  position: _fourthSlideAnimation,
                  child: CustomTextFormField(
                    controller: _lastNameController,
                    hintText: 'Last Name',
                    validator: ValidationBuilder().required().build(),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.words,
                  ),
                ),
                const SizedBox(height: 16),
                SlideTransition(
                  position: _fifthSlideAnimation,
                  child: CustomTextFormField(
                    controller: _emailController,
                    hintText: 'Email',
                    validator: ValidationBuilder()
                        .required()
                        .add(dotValidator)
                        .build(),
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                const Spacer(),
                BouncingEffect(
                  onTap: _onProceed,
                  child: CustomElevatedButton(text: l10n.proceed),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
