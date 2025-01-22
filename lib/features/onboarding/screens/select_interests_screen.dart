import 'package:flutter/material.dart';
import 'package:popcart/features/onboarding/screens/enter_phone_number_screen.dart';

class SelectInterestsScreen extends StatelessWidget {
  const SelectInterestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppBackButton(),
              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
