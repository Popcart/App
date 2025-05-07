import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:popcart/core/colors.dart';

class CustomDropDownWidget<T> extends StatefulWidget {
  final String title;
  final T? value;
  final List<T> items;
  final String Function(T) itemLabel;
  final ValueChanged<T> onChanged;

  const CustomDropDownWidget({
    super.key,
    required this.title,
    required this.value,
    required this.items,
    required this.itemLabel,
    required this.onChanged,
  });

  @override
  State<CustomDropDownWidget<T>> createState() =>
      _CustomDropDownWidgetState<T>();
}

class _CustomDropDownWidgetState<T> extends State<CustomDropDownWidget<T>> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2<T>(
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.textFieldFillColor,
        contentPadding: const EdgeInsets.symmetric(vertical: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(19),
          borderSide: const BorderSide(color: AppColors.boxGrey),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(19)),
          borderSide: BorderSide(color: AppColors.boxGrey),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(19)),
          borderSide: BorderSide(color: AppColors.boxGrey),
        ),
      ),
      isExpanded: true,
      value: widget.value,
      hint: Text(
        widget.title,
        style: const TextStyle(fontSize: 16, color: AppColors.black),
      ),
      items: widget.items
          .map((item) => DropdownMenuItem<T>(
                value: item,
                child: Text(
                  widget.itemLabel(item),
                  style: const TextStyle(fontSize: 16, color: AppColors.white),
                ),
              ))
          .toList(),
      validator: (value) => value == null ? 'Required' : null,
      onChanged: (newValue) {
        widget.onChanged(newValue as T);
      },
    );
  }
}
