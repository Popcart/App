import 'package:flutter/material.dart';
import 'package:popcart/core/colors.dart';
import 'package:popcart/core/widgets/bouncing_effect_widget.dart';
import 'package:popcart/core/widgets/buttons.dart';
import 'package:popcart/core/widgets/textfields.dart';
import 'package:popcart/features/onboarding/screens/enter_phone_number_screen.dart';
import 'package:popcart/l10n/arb/app_localizations.dart';

class BusinessSignupScreen extends StatefulWidget {
  const BusinessSignupScreen({super.key});

  @override
  State<BusinessSignupScreen> createState() => _BusinessSignupScreenState();
}

class _BusinessSignupScreenState extends State<BusinessSignupScreen>
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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
                ),
              ),
              const SizedBox(height: 16),
              SlideTransition(
                position: _fourthSlideAnimation,
                child: CustomTextFormField(
                  controller: _lastNameController,
                  hintText: 'Last Name',
                ),
              ),
              const SizedBox(height: 16),
              SlideTransition(
                position: _fifthSlideAnimation,
                child: CustomTextFormField(
                  controller: _emailController,
                  hintText: 'Email',
                ),
              ),
              const Spacer(),
              BouncingEffect(
                onTap: () {},
                child: CustomElevatedButton(text: l10n.next),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
