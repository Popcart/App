import 'package:flutter/material.dart';
import 'package:popcart/gen/assets.gen.dart';
import 'package:popcart/utils/text_styles.dart';

class ProductUploaded extends StatelessWidget {
  const ProductUploaded({required this.title, required this.description, super.key});
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(children: [
        Align(
          child: Image.asset(AppAssets.animations.success.path, width: 100,),
        ),
        const SizedBox(height: 10,),
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
      ]),
    );
  }
}
