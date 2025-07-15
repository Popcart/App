import 'package:flutter/material.dart';
import 'package:popcart/core/widgets/buttons.dart';
import 'package:popcart/gen/assets.gen.dart';
import 'package:popcart/utils/text_styles.dart';

class ProductUploaded extends StatelessWidget {
  const ProductUploaded({
    required this.title,
    required this.description,
    this.onButtonPressed,
    this.showButton = false,
    super.key,
  });

  final String title;
  final String description;
  final VoidCallback? onButtonPressed;
  final bool showButton;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(children: [
        Align(
          child: Image.asset(AppAssets.animations.success.path, width: 100),
        ),
        const SizedBox(height: 10),
        Align(
          child: Text(title,
              textAlign: TextAlign.center, style: TextStyles.heading),
        ),
        const SizedBox(height: 16),
        Text(
          description,
          textAlign: TextAlign.center,
          style: TextStyles.textTitle,
        ),
        if (showButton) ...[
          const SizedBox(height: 20),
          CustomElevatedButton(
            onPressed: ()=> onButtonPressed!(),
            text: 'Track order',
            showIcon: false,
          ),
        ]
      ]),
    );
  }
}
