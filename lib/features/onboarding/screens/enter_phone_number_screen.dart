import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:popcart/core/colors.dart';
import 'package:popcart/core/widgets/bouncing_effect_widget.dart';
import 'package:popcart/core/widgets/textfields.dart';
import 'package:popcart/l10n/arb/app_localizations.dart';

class EnterPhoneNumberScreen extends StatefulWidget {
  const EnterPhoneNumberScreen({super.key});

  @override
  State<EnterPhoneNumberScreen> createState() => _EnterPhoneNumberScreenState();
}

class _EnterPhoneNumberScreenState extends State<EnterPhoneNumberScreen>
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
            ],
          ),
        ),
      ),
    );
  }
}

class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BouncingEffect(
      onTap: () {
        context.pop();
      },
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.darkGrey,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: IconButton(
            visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
            icon: const Icon(Icons.arrow_back_ios, color: AppColors.white),
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}
