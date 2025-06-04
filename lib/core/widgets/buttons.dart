import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:popcart/core/colors.dart';

class CustomElevatedButton extends ElevatedButton {
  CustomElevatedButton({
    required VoidCallback onPressed,
    required String text,
    bool loading = false,
    bool enabled = true,
    bool showIcon = true,
    IconData? icon,
    super.key,
  }) : super(
          onPressed: enabled ? onPressed : null,
          child: loading
              ? const CircularProgressIndicator(
                  color: AppColors.white,
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (showIcon) ...[
                      if (icon != null)
                        Icon(
                          icon,
                          color: enabled
                              ? AppColors.white
                              : AppColors.white.withOpacity(.5),
                        ),
                      Text(
                        text,
                        style: TextStyle(
                          color: enabled
                              ? AppColors.white
                              : AppColors.white.withOpacity(.5),
                        ),
                      ),
                      if (icon == null) ...[
                        const SizedBox(width: 8),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: enabled
                              ? AppColors.white
                              : AppColors.white.withOpacity(.5),
                          size: 16,
                        ),
                      ],
                    ] else ...[
                      Text(
                        text,
                        style: TextStyle(
                          color: enabled
                              ? AppColors.white
                              : AppColors.white.withOpacity(.5),
                        ),
                      ),
                    ]
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
              enabled ? AppColors.orange : AppColors.orange.withOpacity(.5),
            ),
          ),
        );
}

class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key, this.onPressed});
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if(onPressed != null) {
          onPressed!();
        }else {
          Navigator.pop(context);
        }
      },
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.darkGrey,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.arrow_back_ios, color: AppColors.white),
      ),
    );
  }
}
