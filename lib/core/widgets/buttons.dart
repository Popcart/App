import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:popcart/core/colors.dart';

class CustomElevatedButton extends ElevatedButton {
  CustomElevatedButton({
    // required VoidCallback super.onPressed,
    required String text,
    bool loading = false,
    super.key,
  }) : super(
          onPressed: () {},
          child: loading
              ? const CupertinoActivityIndicator()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      text,
                      style: const TextStyle(
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.white,
                      size: 16,
                    ),
                  ],
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
