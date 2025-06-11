import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:intl/intl.dart';
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

extension StringExtension on String {
  String addQueryParameters(Map<String, dynamic> params) {
    if (params.isEmpty) {
      return this;
    }

    final buffer = StringBuffer(this);

    if (!contains('?')) {
      buffer.write('?');
    } else {
      if (!endsWith('&')) {
        buffer.write('&');
      }
    }

    params.forEach((key, value) {
      buffer.write('$key=$value&');
    });

    final result = buffer.toString();
    return result.substring(0, result.length - 1);
  }
}

class PhonePrefixFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    const prefix = '+234';

    // If the new value doesn't start with the prefix, restore it
    if (!newValue.text.startsWith(prefix)) {
      // If user is trying to delete the prefix
      // keep the prefix and what was after it
      if (oldValue.text.startsWith(prefix) &&
          newValue.text.length < prefix.length) {
        return oldValue.copyWith(
          text: prefix,
          selection: const TextSelection.collapsed(offset: prefix.length),
        );
      }

      // Otherwise, ensure the prefix is always there
      var newText = prefix;
      if (newValue.text.isNotEmpty) {
        // If they're typing elsewhere, try to preserve what they typed
        if (!oldValue.text.startsWith(prefix)) {
          newText += newValue.text;
        } else if (newValue.text.length >= oldValue.text.length) {
          // They're adding text
          newText += newValue.text.substring(newValue.text.length - 1);
        }
      }

      return TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length),
      );
    }

    return newValue;
  }
}

extension NumberExtension on num {
  String toCurrency() {
    return NumberFormat.currency(locale: 'en_NG', symbol: '₦').format(this);
  }
}

const String kJoinNotification = 'JoinNotification';
const String kLeaveNotification = 'LeaveNotification';
const String kPlainText = 'PlainText';
const String kViewerCountUpdate = 'ViewerCountUpdate';
