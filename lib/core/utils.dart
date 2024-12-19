import 'package:flutter/cupertino.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:popcart/gen/assets.gen.dart';
import 'package:toastification/toastification.dart';

String? dotValidator(String? value) {
  if (value != null && !value.contains('.') && !value.contains('@')) {
    return 'Invalid email address';
  }
  // check if theres a . after the @
  if (value != null && value.contains('@')) {
    final split = value.split('@');
    if (split[1].contains('.')) {
      return null;
    }
    return 'Invalid email address';
  }
  // check if theres any character after the last .
  if (value != null && value.contains('.')) {
    final split = value.split('.');
    if (split[split.length - 1].isEmpty) {
      return 'Invalid email address';
    }
  }
  return null;
}

extension BuildContextExtension on BuildContext {
  Future<void> showError(String error) async {
    await Haptics.vibrate(HapticsType.error);
    toastification.show(
      alignment: Alignment.topCenter,
      type: ToastificationType.error,
      style: ToastificationStyle.flat,
      autoCloseDuration: const Duration(seconds: 5),
      showProgressBar: false,
      borderSide: const BorderSide(color: Color(0xfffda29b)),
      backgroundColor: const Color(0xfffffbfa),
      icon: AppAssets.icons.errorIcon.svg(),
      title: const Text(
        'Error',
        style: TextStyle(
          color: Color(0xffb42318),
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      description: Text(
        error,
        style: const TextStyle(
          color: Color(0xffb42318),
          fontSize: 14,
        ),
      ),
    );
  }

  Future<void> showSuccess(String message) async {
    await Haptics.vibrate(HapticsType.success);
    toastification.show(
      alignment: Alignment.topCenter,
      type: ToastificationType.success,
      style: ToastificationStyle.flat,
      autoCloseDuration: const Duration(seconds: 5),
      showProgressBar: false,
      borderSide: const BorderSide(color: Color(0xff6ce9a6)),
      backgroundColor: const Color(0xfff6fef9),
      icon: AppAssets.icons.checkicon.svg(),
      title: const Text(
        'Success',
        style: TextStyle(
          color: Color(0xff027a48),
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      description: Text(
        message,
        style: const TextStyle(
          color: Color(0xff027a48),
          fontSize: 14,
        ),
      ),
    );
  }
}
