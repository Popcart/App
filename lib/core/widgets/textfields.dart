import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_validator/form_validator.dart';
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
    super.validator,
    super.textInputAction,
    super.textCapitalization,
    super.inputFormatters,
  }) : super(
          onTapOutside: kDebugMode
              ? (_) => FocusScope.of(rootNavigatorKey.currentContext!).unfocus()
              : null,
          style: const TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
          cursorHeight: 20,
          decoration: InputDecoration(
            hintText: hintText ?? '',
            hintStyle: TextStyle(color: AppColors.white.withValues(alpha: 0.2)),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100),
              borderSide: const BorderSide(color: AppColors.white),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100),
              borderSide: const BorderSide(color: Color(0xff50535B)),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100),
              borderSide: const BorderSide(color: Color(0xff50535B)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100),
              borderSide: const BorderSide(color: AppColors.orange),
            ),
          ),
        );
}

class CustomPinField extends Pinput {
  CustomPinField({
    super.key,
    super.focusNode,
    super.controller,
  }) : super(
          length: 5,
          onTapOutside: kDebugMode
              ? (_) => FocusScope.of(rootNavigatorKey.currentContext!).unfocus()
              : null,
          closeKeyboardWhenCompleted: false,
          defaultPinTheme: PinTheme(
            width: 56,
            height: 56,
            textStyle: const TextStyle(
              color: AppColors.white,
              fontWeight: FontWeight.w700,
              fontSize: 45,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xff50535B)),
              borderRadius: BorderRadius.circular(100),
            ),
          ),
          pinAnimationType: PinAnimationType.slide,
          focusedPinTheme: PinTheme(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.orange),
              borderRadius: BorderRadius.circular(100),
            ),
            textStyle: const TextStyle(
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

class CustomFileField extends HookWidget {
  const CustomFileField({
    required this.onFileSelected,
    required this.hintText,
    super.key,
  });

  final ValueChanged<File?> onFileSelected;
  final String hintText;
  @override
  Widget build(BuildContext context) {
    final file = useState<File?>(null);
    final idController = useTextEditingController();
    final selectFile = useCallback(() async {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
      );
      if (result != null) {
        file.value = File(result.files.single.path!);
        onFileSelected(file.value);
        idController.text = file.value!.path.split('/').last;
      }
    });
    return file.value == null
        ? GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: selectFile,
            child: CustomTextFormField(
              controller: idController,
              hintText: hintText,
              validator: ValidationBuilder().required().build(),
              enabled: false,
            ),
          )
        : Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.darkGrey,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    file.value!.path.split('/').last,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: () {
                    file.value = null;
                    onFileSelected(null);
                    idController.clear();
                  },
                  child: const Icon(
                    Icons.cancel,
                    color: AppColors.orange,
                  ),
                ),
              ],
            ),
          );
  }
}
