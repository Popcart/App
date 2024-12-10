import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:popcart/app/router.dart';
import 'package:popcart/core/colors.dart';

class CustomTextFormField extends TextFormField {
  CustomTextFormField({
    super.key,
    super.autofocus,
    super.focusNode,
    super.controller,
    super.keyboardType,
    String? hintText,
    super.enabled,
  }) : super(
          onTapOutside: kDebugMode
              ? (_) => FocusScope.of(rootNavigatorKey.currentContext!).unfocus()
              : null,
          style: const TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.w700,
            fontSize: 30,
          ),
          decoration: InputDecoration.collapsed(
            hintText: hintText ?? '',
            hintStyle: TextStyle(color: AppColors.white.withOpacity(0.2)),
          ),
        );
}

class CustomPinField extends Pinput {
  CustomPinField({
    super.key,
    super.focusNode,
    super.controller,
  }) : super(
          length: 6,
          onTapOutside: kDebugMode
              ? (_) => FocusScope.of(rootNavigatorKey.currentContext!).unfocus()
              : null,
          closeKeyboardWhenCompleted: false,
          defaultPinTheme: const PinTheme(
            width: 56,
            height: 56,
            textStyle: TextStyle(
              color: AppColors.white,
              fontWeight: FontWeight.w700,
              fontSize: 45,
            ),
          ),
          pinAnimationType: PinAnimationType.slide,
          focusedPinTheme: const PinTheme(
            width: 56,
            height: 56,
            textStyle: TextStyle(
              color: AppColors.white,
              fontWeight: FontWeight.w700,
              fontSize: 45,
            ),
          ),
          cursor: const SizedBox(
            height: 20,
            child: VerticalDivider(
              width: 1,
              color: AppColors.white,
            ),
          ),
        );
}
