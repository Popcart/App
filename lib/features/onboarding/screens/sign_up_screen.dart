import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_validator/form_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:popcart/app/router_paths.dart';
import 'package:popcart/core/colors.dart';
import 'package:popcart/core/utils.dart';
import 'package:popcart/core/widgets/buttons.dart';
import 'package:popcart/core/widgets/textfields.dart';
import 'package:popcart/features/onboarding/cubits/onboarding/onboarding_cubit.dart';
import 'package:popcart/features/user/models/user_model.dart';
import 'package:popcart/gen/assets.gen.dart';
import 'package:popcart/l10n/arb/app_localizations.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _animation;
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _businessNameController = TextEditingController();
  final _phoneNumber = TextEditingController(text: '+234');

  bool isBusinessRegistered = false;
  Timer? _debounce;

  bool isUsernameAvailable = false;
  bool isEmailAvailable = false;
  String usernameAvailability = '';
  String emailAvailability = '';

  void onChangedHandler(String value, String field) {
    _formKey.currentState!.validate();
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (value.isNotEmpty) {
        if (field == 'email') {
          setState(() {
            emailAvailability = '';
          });
          checkEmailAvailability(value);
        } else if (field == 'username') {
          setState(() {
            usernameAvailability = '';
          });
          checkUsernameAvailability(value);
        }
      }
    });
  }

  Future<void> checkEmailAvailability(String email) async {
    await context.read<OnboardingCubit>().verifyEmail(email);
  }

  Future<void> checkUsernameAvailability(String username) async {
    await context.read<OnboardingCubit>().verifyUsername(username);
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animation = Tween<Offset>(
      begin: const Offset(0.4, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _businessNameController.dispose();
    _phoneNumber.dispose();
    super.dispose();
  }

  void _onProceed() {
    if (!_formKey.currentState!.validate() ||
        !isUsernameAvailable ||
        !isEmailAvailable) return;
    context.read<OnboardingCubit>()
      ..isLoggingIn = false
      ..email = _emailController.text
      ..username = _usernameController.text
      ..firstName = _firstNameController.text
      ..lastName = _lastNameController.text
      ..businessName = _businessNameController.text
      ..phoneNumber = _phoneNumber.text
      ..isRegisteredSeller = isBusinessRegistered
      ..registerUser();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cubit = context.watch<OnboardingCubit>();

    return Scaffold(
      body: SafeArea(
        child: BlocListener<OnboardingCubit, OnboardingState>(
          listener: (context, state) {
            state.whenOrNull(
              onboardingFailure: (msg) => context.showError(msg),
              onboardingSuccess: () {
                context.pushNamed(AppPath.auth.otp.path);
              },
              verifyEmailSuccess: () => setState(() {
                isEmailAvailable = true;
                emailAvailability = 'Email is available';
              }),
              verifyEmailFailure: (msg) => setState(() {
                isEmailAvailable = false;
                emailAvailability = msg;
              }),
              verifyUsernameSuccess: () => setState(() {
                isUsernameAvailable = true;
                usernameAvailability = 'Username is available';
              }),
              verifyUsernameFailure: (msg) => setState(() {
                isUsernameAvailable = false;
                usernameAvailability = msg;
              }),
            );
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppBackButton(),
                  const SizedBox(height: 32),
                  SlideTransition(
                    position: _animation,
                    child: const Text(
                      'Sign up for free',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SlideTransition(
                    position: _animation,
                    child: Text(
                      l10n.your_details_sub,
                      style: const TextStyle(color: AppColors.white),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SlideTransition(
                    position: _animation,
                    child: const Text(
                      'Email Address',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SlideTransition(
                    position: _animation,
                    child: CustomTextFormField(
                      controller: _emailController,
                      hintText: 'Email Address',
                      validator: ValidationBuilder()
                          .required()
                          .add(dotValidator)
                          .build(),
                      textInputAction: TextInputAction.next,
                      prefixIcon: AppAssets.icons.mail.svg(),
                      onChanged: (value) => onChangedHandler(value, 'email'),
                    ),
                  ),
                  if (emailAvailability.isNotEmpty) ...{
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      emailAvailability,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color:
                            isEmailAvailable ? AppColors.green : AppColors.red,
                      ),
                    ),
                  },
                  const SizedBox(height: 16),
                  SlideTransition(
                    position: _animation,
                    child: const Text(
                      'Username',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SlideTransition(
                    position: _animation,
                    child: CustomTextFormField(
                      controller: _usernameController,
                      hintText: 'Username',
                      validator: ValidationBuilder().required().build(),
                      textInputAction: TextInputAction.next,
                      prefixIcon: AppAssets.icons.mail.svg(),
                      onChanged: (value) => onChangedHandler(value, 'username'),
                    ),
                  ),
                  if (usernameAvailability.isNotEmpty) ...{
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      usernameAvailability,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: isUsernameAvailable
                            ? AppColors.green
                            : AppColors.red,
                      ),
                    ),
                  },
                  const SizedBox(height: 16),
                  ..._buildField('Last Name', AppAssets.icons.name.svg(),
                      _lastNameController),
                  ..._buildField('First Name', AppAssets.icons.name.svg(),
                      _firstNameController),
                  if (cubit.userType == UserType.seller) ...{
                    ..._buildField(
                        'Business Name',
                        AppAssets.icons.business.svg(),
                        _businessNameController),
                    const Text(
                      'Is your business registered?',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.white,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        children: [
                          Flexible(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: AppColors.darkGrey,
                                  borderRadius: BorderRadius.circular(19.0)),
                              padding:
                                  const EdgeInsets.only(left: 0, right: 50),
                              child: Row(
                                children: [
                                  Radio<bool>(
                                    value: true,
                                    groupValue: isBusinessRegistered,
                                    onChanged: (value) {
                                      setState(
                                          () => isBusinessRegistered = value!);
                                    },
                                  ),
                                  const Text('Yes',
                                      style: TextStyle(color: AppColors.white)),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Flexible(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: AppColors.darkGrey,
                                  borderRadius: BorderRadius.circular(19.0)),
                              padding:
                                  const EdgeInsets.only(left: 0, right: 50),
                              child: Row(
                                children: [
                                  Radio<bool>(
                                    value: false,
                                    groupValue: isBusinessRegistered,
                                    onChanged: (value) {
                                      setState(
                                          () => isBusinessRegistered = value!);
                                    },
                                  ),
                                  const Text('No',
                                      style: TextStyle(color: AppColors.white)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  },
                  ..._buildField('Phone number', AppAssets.icons.phone.svg(),
                      _phoneNumber),
                  const SizedBox(height: 24),
                  CustomElevatedButton(
                    text: l10n.next,
                    loading: cubit.state.maybeWhen(
                      loading: () => true,
                      orElse: () => false,
                    ),
                    onPressed: _onProceed,
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: 'Already have an account? ',
                        style: const TextStyle(color: AppColors.white),
                        children: [
                          TextSpan(
                            text: 'Sign in',
                            style: const TextStyle(
                              color: AppColors.orange,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                context.pushReplacement(AppPath.auth.path);
                              },
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildField(
    String label,
    Widget prefixIcon,
    TextEditingController controller, {
    String? Function(String?)? validator,
  }) {
    return [
      SlideTransition(
        position: _animation,
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.white,
          ),
        ),
      ),
      const SizedBox(height: 8),
      SlideTransition(
        position: _animation,
        child: CustomTextFormField(
          controller: controller,
          hintText: label,
          validator: validator ?? ValidationBuilder().required().build(),
          textInputAction: TextInputAction.next,
          prefixIcon: prefixIcon,
        ),
      ),
      const SizedBox(height: 16),
    ];
  }
}
