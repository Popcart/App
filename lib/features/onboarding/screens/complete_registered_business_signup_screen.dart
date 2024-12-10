import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:popcart/core/colors.dart';
import 'package:popcart/core/widgets/textfields.dart';
import 'package:popcart/features/onboarding/screens/enter_phone_number_screen.dart';
import 'package:popcart/l10n/arb/app_localizations.dart';

class CompleteRegisteredBusinessSignupScreen extends StatefulWidget {
  const CompleteRegisteredBusinessSignupScreen({super.key});

  @override
  State<CompleteRegisteredBusinessSignupScreen> createState() =>
      _CompleteRegisteredBusinessSignupScreenState();
}

class _CompleteRegisteredBusinessSignupScreenState
    extends State<CompleteRegisteredBusinessSignupScreen>
    with SingleTickerProviderStateMixin {
  late final TextEditingController _businessNameController;
  late final TextEditingController _rcNumberController;
  late final TextEditingController _businessOwnerBvnController;
  late final TextEditingController _businessAddressController;
  late final TextEditingController _utilityBillDocumentController;
  late final TextEditingController _idDocumentController;
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
    _businessNameController = TextEditingController();
    _rcNumberController = TextEditingController();
    _businessOwnerBvnController = TextEditingController();
    _businessAddressController = TextEditingController();
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
                  controller: _businessNameController,
                  keyboardType: TextInputType.number,
                  hintText: 'Business Name',
                ),
              ),
              const SizedBox(height: 16),
              SlideTransition(
                position: _fourthSlideAnimation,
                child: CustomTextFormField(
                  controller: _rcNumberController,
                  hintText: 'RC Number',
                ),
              ),
              const SizedBox(height: 16),
              SlideTransition(
                position: _fifthSlideAnimation,
                child: CustomTextFormField(
                  controller: _businessOwnerBvnController,
                  hintText: 'Business Owner BVN',
                ),
              ),
              const SizedBox(height: 16),
              SlideTransition(
                position: _sixthSlideAnimation,
                child: CustomTextFormField(
                  controller: _businessAddressController,
                  hintText: 'Business Address',
                ),
              ),
              const SizedBox(height: 16),
              SlideTransition(
                position: _seventhSlideAnimation,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: selectIdDocument,
                  child: CustomTextFormField(
                    controller: _idDocumentController,
                    hintText: 'ID Document',
                    enabled: false,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SlideTransition(
                position: _eightSlideAnimation,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: selectUtiltyBillDocument,
                  child: CustomTextFormField(
                    controller: _utilityBillDocumentController,
                    enabled: false,
                    hintText: 'Utility Bill Document',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
