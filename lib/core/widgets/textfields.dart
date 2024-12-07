import 'package:flutter/material.dart';
import 'package:popcart/app/router.dart';
import 'package:popcart/core/colors.dart';

class CustomTextFormField extends TextFormField {
  CustomTextFormField({
    super.key,
    super.autofocus,
    super.focusNode,
    super.controller,
    super.keyboardType,
  }) : super(
          onTapOutside: (_) =>
              FocusScope.of(rootNavigatorKey.currentContext!).unfocus(),
          style: const TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.w700,
            fontSize: 30,
          ),
          decoration: const InputDecoration.collapsed(hintText: ''),
        );
}
