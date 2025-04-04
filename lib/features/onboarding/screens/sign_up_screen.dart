import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_validator/form_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:popcart/app/router_paths.dart';
import 'package:popcart/core/colors.dart';
import 'package:popcart/core/utils.dart';
import 'package:popcart/core/widgets/animated_widgets.dart';
import 'package:popcart/core/widgets/buttons.dart';
import 'package:popcart/core/widgets/textfields.dart';
import 'package:popcart/features/onboarding/cubits/onboarding/onboarding_cubit.dart';
import 'package:popcart/features/onboarding/screens/enter_phone_number_screen.dart';
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
  final _phoneNumber = TextEditingController();

  bool isBusinessRegistered = true;

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
    if (!_formKey.currentState!.validate()) return;
    context.read<OnboardingCubit>()
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
              onboardingSuccess: () =>
                  context.pushNamed(AppPath.auth.otp.path),
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
                      "Sign up for free",
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
                  ..._buildField("Email Address", AppAssets.icons.mail.svg(),_emailController,
                      validator: ValidationBuilder().required().add(
                          dotValidator).build()),
                  ..._buildField("Username", AppAssets.icons.username.svg(),_usernameController),
                  ..._buildField("Last Name",AppAssets.icons.name.svg(), _lastNameController),
                  ..._buildField("First Name", AppAssets.icons.name.svg(),_firstNameController),
                  if(cubit.userType == UserType.seller)...{
                    ..._buildField("Business Name", AppAssets.icons.business.svg(),_businessNameController),
                    const SizedBox(height: 2),
                    const Text(
                      "Is your business registered?",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                color: AppColors.darkGrey,
                                borderRadius: BorderRadius.circular(19.0)
                            ),
                            padding: EdgeInsets.only(left: 0, right: 50),
                            child: Row(
                              children: [
                                Radio<bool>(
                                  value: true,
                                  groupValue: isBusinessRegistered,
                                  onChanged: (value) {
                                    setState(() => isBusinessRegistered = value!);
                                  },
                                ),
                                const Text("Yes",
                                    style: TextStyle(color: AppColors.white)),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 20,),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                color: AppColors.darkGrey,
                                borderRadius: BorderRadius.circular(19.0)
                            ),
                            padding: EdgeInsets.only(left: 0, right: 50),
                            child: Row(
                              children: [
                                Radio<bool>(
                                  value: false,
                                  groupValue: isBusinessRegistered,
                                  onChanged: (value) {
                                    setState(() => isBusinessRegistered = value!);
                                  },
                                ),
                                const Text(
                                    "No", style: TextStyle(color: AppColors.white)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  },
                  ..._buildField("Phone number", AppAssets.icons.phone.svg(), _phoneNumber),
                  const SizedBox(height: 24),
                  BouncingEffect(
                    onTap: _onProceed,
                    child: CustomElevatedButton(
                      text: l10n.next,
                      loading: cubit.state.maybeWhen(
                        loading: () => true,
                        orElse: () => false,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: "Already have an account? ",
                        style: const TextStyle(color: AppColors.white),
                        children: [
                          TextSpan(
                            text: "Sign in",
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

  List<Widget> _buildField(String label,
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

