import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_validator/form_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:popcart/app/app.module.dart';
import 'package:popcart/core/colors.dart';
import 'package:popcart/core/utils.dart';
import 'package:popcart/core/widgets/buttons.dart';
import 'package:popcart/core/widgets/textfields.dart';
import 'package:popcart/features/onboarding/cubits/onboarding/onboarding_cubit.dart';
import 'package:popcart/l10n/arb/app_localizations.dart';

class BusinessDetailsScreen extends StatefulWidget {
  const BusinessDetailsScreen({super.key});

  @override
  State<BusinessDetailsScreen> createState() => _BusinessDetailsScreenState();
}

class _BusinessDetailsScreenState extends State<BusinessDetailsScreen>
    with SingleTickerProviderStateMixin {
  late final TextEditingController _businessNameController;
  late final TextEditingController _rcNumberController;
  late final TextEditingController _businessOwnerBvnController;
  late final TextEditingController _businessAddressController;
  late final TextEditingController _utilityBillDocumentController;
  late final TextEditingController _idDocumentController;
  late final GlobalKey<FormState> _formKey;
  File? _idDocument;
  File? _utilityBillDocument;
  late final FocusNode _bvnFocusNode;
  late AnimationController _controller;
  late Animation<Offset> _firstSlideAnimation;
  late Animation<Offset> _secondSlideAnimation;
  late Animation<Offset> _thirdSlideAnimation;
  late Animation<Offset> _fourthSlideAnimation;
  late Animation<Offset> _fifthSlideAnimation;
  late Animation<Offset> _sixthSlideAnimation;
  late Animation<Offset> _seventhSlideAnimation;
  late Animation<Offset> _eightSlideAnimation;

  Future<void> selectUtiltyBillDocument() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
    );
    if (result != null) {
      setState(() {
        _utilityBillDocument = File(result.files.single.path!);
        _utilityBillDocumentController.text =
            _utilityBillDocument!.path.split('/').last;
      });
    }
  }

  Future<void> selectIdDocument() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
    );
    if (result != null) {
      setState(() {
        _idDocument = File(result.files.single.path!);
        _idDocumentController.text = _idDocument!.path.split('/').last;
      });
    }
  }

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    final onboardingCubit = context.read<OnboardingCubit>();
    _businessNameController = TextEditingController(text: onboardingCubit.businessName);
    _rcNumberController = TextEditingController();
    _businessOwnerBvnController = TextEditingController();
    _businessAddressController = TextEditingController();

    _businessNameController.addListener(_onFieldsChanged);
    _rcNumberController.addListener(_onFieldsChanged);
    _businessOwnerBvnController.addListener(_onFieldsChanged);
    _businessAddressController.addListener(_onFieldsChanged);

    _utilityBillDocumentController = TextEditingController();
    _idDocumentController = TextEditingController();
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
    _sixthSlideAnimation = Tween<Offset>(
      begin: const Offset(0.4, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.6, curve: Curves.easeOut),
      ),
    );
    _seventhSlideAnimation = Tween<Offset>(
      begin: const Offset(0.4, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.6, curve: Curves.easeOut),
      ),
    );
    _eightSlideAnimation = Tween<Offset>(
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
  void dispose() {
    _controller.dispose();
    _businessNameController.dispose();
    _rcNumberController.dispose();
    _businessOwnerBvnController.dispose();
    _businessAddressController.dispose();
    _utilityBillDocumentController.dispose();
    _idDocumentController.dispose();
    _bvnFocusNode.dispose();
    _formKey.currentState?.dispose();
    super.dispose();
  }

  bool get _areAllFieldsFilledRegistered =>
      _businessNameController.text.isNotEmpty &&
      _rcNumberController.text.isNotEmpty &&
      _businessOwnerBvnController.text.isNotEmpty &&
      _businessAddressController.text.isNotEmpty &&
      _utilityBillDocument != null &&
      _idDocument != null;

  bool get _areAllFieldsFilled =>
      _businessOwnerBvnController.text.isNotEmpty &&
      _utilityBillDocument != null &&
      _idDocument != null;

  void _onFieldsChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final onboardingCubit = context.watch<OnboardingCubit>();
    return BlocListener<OnboardingCubit, OnboardingState>(
      listener: (context, state) {
        state.whenOrNull(
          onboardingFailure: (message) => context.showError(message),
          onboardingSuccess: () => context.go(AppPath.authorizedUser.seller.analytics.path),
          submitRegisteredBusinessInformationSuccess: () {
            context.go(AppPath.authorizedUser.seller.analytics.path);
          },
        );
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
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
                    if (onboardingCubit.isRegisteredSeller) ...[
                      SlideTransition(
                        position: _thirdSlideAnimation,
                        child: CustomTextFormField(
                          controller: _businessNameController,
                          validator: ValidationBuilder().required().build(),
                          hintText: 'Business Name',
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SlideTransition(
                        position: _fourthSlideAnimation,
                        child: CustomTextFormField(
                          focusNode: _bvnFocusNode,
                          validator: ValidationBuilder().required().build(),
                          controller: _rcNumberController,
                          hintText: 'RC Number',
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    SlideTransition(
                      position: _fifthSlideAnimation,
                      child: CustomTextFormField(
                        controller: _businessOwnerBvnController,
                        focusNode: !onboardingCubit.isRegisteredSeller ?
                        _bvnFocusNode : null,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: ValidationBuilder()
                            .required()
                            .maxLength(11)
                            .build(),
                        hintText: 'Business Owner BVN',
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    if (onboardingCubit.isRegisteredSeller) ...[
                      const SizedBox(height: 16),
                      SlideTransition(
                        position: _sixthSlideAnimation,
                        child: CustomTextFormField(
                          controller: _businessAddressController,
                          validator: ValidationBuilder().required().build(),
                          hintText: 'Business Address',
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    SlideTransition(
                      position: _seventhSlideAnimation,
                      child: CustomFileField(
                        hintText: 'ID Document',
                        onFileSelected: (file) {
                          setState(() {
                            _idDocument = file;
                            if (file != null) {
                              _idDocumentController.text =
                                  file.path.split('/').last;
                            } else {
                              _idDocumentController.clear();
                            }
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    SlideTransition(
                      position: _eightSlideAnimation,
                      child: CustomFileField(
                        hintText: 'Utility Bill Document',
                        onFileSelected: (file) {
                          setState(() {
                            _utilityBillDocument = file;
                            if (file != null) {
                              _utilityBillDocumentController.text =
                                  file.path.split('/').last;
                            } else {
                              _utilityBillDocumentController.clear();
                            }
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    CustomElevatedButton(
                      text: l10n.next,
                      loading: onboardingCubit.state.maybeWhen(
                        orElse: () => false,
                        loading: () => true,
                      ),
                      enabled: onboardingCubit.isRegisteredSeller ?
                      _areAllFieldsFilledRegistered :_areAllFieldsFilled,
                      onPressed: () {
                        onboardingCubit.submitRegisteredBusinessInformation(
                          businessName: _businessNameController.text,
                          rcNumber: _rcNumberController.text,
                          businessOwnerBvn: _businessOwnerBvnController.text,
                          businessAddress: _businessAddressController.text,
                          utilityBillDocument: _utilityBillDocument!,
                          idDocument: _idDocument!,
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
