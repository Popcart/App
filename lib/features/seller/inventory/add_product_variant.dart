import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:popcart/core/colors.dart';
import 'package:popcart/core/widgets/buttons.dart';
import 'package:popcart/core/widgets/textfields.dart';
import 'package:popcart/features/seller/models/variant_model.dart';
import 'package:popcart/gen/assets.gen.dart';
import 'package:popcart/utils/text_styles.dart';

class AddProductVariant extends StatefulWidget {
  const AddProductVariant({super.key});

  @override
  State<AddProductVariant> createState() => _AddProductVariantState();
}

class _AddProductVariantState extends State<AddProductVariant> {
  TextEditingController variantType = TextEditingController();
  final List<TextEditingController> _controllers = [TextEditingController()];
  final List<FocusNode> _focusNodes = [FocusNode()];

  void _addField() {
    setState(() {
      _controllers.add(TextEditingController());
      _focusNodes.add(FocusNode());
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes.last.requestFocus();
    });
  }

  List<String> _getValues() {
    return _controllers.map((c) => c.text).toList();
  }

  @override
  void dispose() {
    variantType.dispose();
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Align(
              child: Text('Add Product Variant',
                  textAlign: TextAlign.center, style: TextStyles.heading),
            ),
            const SizedBox(height: 16),
            const Text(
              'Variant type',
              style: TextStyles.textTitle,
            ),
            const SizedBox(
              height: 10,
            ),
            CustomTextFormField(
              validator: ValidationBuilder().required().build(),
              controller: variantType,
              hintText: 'Variant',
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(
              height: 20,
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                ...List.generate(_controllers.length, (index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Option',
                            style: TextStyles.textTitle,
                          ),
                          const SizedBox(width: 20),
                          if (index != 0)
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _controllers.removeAt(index);
                                });
                              },
                              child: AppAssets.icons.delete.svg(width: 10),
                            ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      SizedBox(
                        width: 100,
                        child: CustomTextFormField(
                          validator: ValidationBuilder().required().build(),
                          controller: _controllers[index],
                          hintText: '',
                          focusNode: _focusNodes[index],
                        ),
                      ),
                    ],
                  );
                }),
                InkWell(
                  onTap: _addField,
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add, color: AppColors.orange),
                      SizedBox(width: 10),
                      Text(
                        'Add option',
                        style: TextStyles.textTitle,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            CustomElevatedButton(
              text: 'Save',
              onPressed: () {
                if (variantType.text.isEmpty ||
                    _getValues().any((element) => element.isEmpty)) {
                  return;
                }
                Navigator.pop(
                    context,
                    VariantModel(
                        variant: variantType.text,
                        options: _getValues(),));
              },
            )
          ],
        ),
      ),
    );
  }
}
