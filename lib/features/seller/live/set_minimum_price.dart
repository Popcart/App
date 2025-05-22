import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_validator/form_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:popcart/app/service_locator.dart';
import 'package:popcart/core/colors.dart';
import 'package:popcart/core/repository/inventory_repo.dart';
import 'package:popcart/core/widgets/buttons.dart';
import 'package:popcart/core/widgets/textfields.dart';
import 'package:popcart/core/widgets/widgets.dart';
import 'package:popcart/features/live/models/products.dart';
import 'package:popcart/gen/assets.gen.dart';
import 'package:popcart/utils/text_styles.dart';

class SetMinimumPrice extends StatefulWidget {
  const SetMinimumPrice({super.key, required this.products});

  final List<Product> products;

  @override
  State<SetMinimumPrice> createState() => _SetMinimumPriceState();
}

class _SetMinimumPriceState extends State<SetMinimumPrice> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  context.pop();
                },
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: AppColors.white,
                ),
              ),
              const Text('Set minimum price', style: TextStyles.titleHeading),
              const SizedBox(),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  textAlign: TextAlign.center,
                  'Product',
                  style: TextStyles.subheadingBlackOnWhite,
                ),
                Text(
                  textAlign: TextAlign.center,
                  'Price',
                  style: TextStyles.subheadingBlackOnWhite,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView.builder(
                  itemCount: widget.products.length,
                  itemBuilder: (context, itemIndex) {
                    return EditPriceProductItem(
                      product: widget.products[itemIndex],
                    );
                  }),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomElevatedButton(
              showIcon: false,
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {}
                },
                text: 'Go live'),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}

class EditPriceProductItem extends StatefulWidget {
  const EditPriceProductItem(
      {required this.product, this.isSelected = false, super.key});

  final Product product;
  final bool isSelected;

  @override
  State<EditPriceProductItem> createState() => _EditPriceProductItemState();
}

class _EditPriceProductItemState extends State<EditPriceProductItem> {
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(thickness: 0.5, color: AppColors.dividerColor),
        const SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Stack(
                  children: [
                    SizedBox(
                        height: 70,
                        width: 100,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            widget.product.images[0],
                            fit: BoxFit.cover,
                          ),
                        )),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      left: 0,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: const BoxDecoration(
                          color: AppColors.darkGrey,
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(12),
                              bottomLeft: Radius.circular(12)),
                        ),
                        child: Text(
                          textAlign: TextAlign.center,
                          widget.product.category.name,
                          style: TextStyles.caption,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
            const Spacer(),
            Flexible(
              child: CustomTextFormField(
                validator: ValidationBuilder().required().build(),
                controller: textEditingController,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                hintText: 'minimum price',
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
      ],
    );
  }
}
