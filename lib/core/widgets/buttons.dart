import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:popcart/core/colors.dart';

class CustomElevatedButton extends ElevatedButton {
  CustomElevatedButton({
    required VoidCallback onPressed,
    required String text,
    bool loading = false,
    bool enabled = true,
    super.key,
  }) : super(
    onPressed: enabled ? onPressed : null,
          child: loading
              ? const CircularProgressIndicator(color: AppColors.white,)
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      text,
                      style: TextStyle(
                        color: enabled ? AppColors.white : AppColors.white
                            .withOpacity(.5),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: enabled ? AppColors.white : AppColors.white
                          .withOpacity(.5),
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
              enabled? AppColors.orange : AppColors.orange.withOpacity(.5),
            ),
          ),
        );
}
