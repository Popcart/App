import 'package:flutter/material.dart';
import 'package:popcart/gen/assets.gen.dart';
import 'package:popcart/utils/text_styles.dart';

class ProductUploaded extends StatefulWidget {
  const ProductUploaded({super.key});

  @override
  State<ProductUploaded> createState() => _ProductUploadedState();
}

class _ProductUploadedState extends State<ProductUploaded> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Align(
          child: Image.asset(AppAssets.animations.success.path, width: 100,),
        ),
        const SizedBox(height: 10,),
        const Align(
          child: Text('Product Added Successfully!',
              textAlign: TextAlign.center, style: TextStyles.heading),
        ),
        const SizedBox(height: 16),
        const Text(
          'Your new item is now live in your inventory. Ready to manage, edit, or start selling?',
          textAlign: TextAlign.center,
          style: TextStyles.textTitle,
        ),
      ]),
    );
  }
}
