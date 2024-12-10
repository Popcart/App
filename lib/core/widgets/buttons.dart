import 'package:flutter/material.dart';
import 'package:popcart/core/colors.dart';

class CustomElevatedButton extends ElevatedButton {
  CustomElevatedButton({
    // required VoidCallback super.onPressed,
    required String text,
    super.key,
  }) : super(
          onPressed: () {},
          child: Text(
            text,
            style: const TextStyle(
              color: AppColors.white,
            ),
          ),
          style: ButtonStyle(
            textStyle: WidgetStateProperty.all<TextStyle>(
              const TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            fixedSize: const WidgetStatePropertyAll(
              Size(double.infinity, 56),
            ),
            minimumSize: const WidgetStatePropertyAll(
              Size(double.infinity, 56),
            ),
            backgroundColor: WidgetStateProperty.all<Color>(
              AppColors.orange,
            ),
          ),
        );
}
