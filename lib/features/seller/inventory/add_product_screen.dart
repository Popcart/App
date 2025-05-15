import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:form_validator/form_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:popcart/app/router_paths.dart';
import 'package:popcart/core/colors.dart';
import 'package:popcart/core/dropdown_widget.dart';
import 'package:popcart/core/utils.dart';
import 'package:popcart/core/widgets/buttons.dart';
import 'package:popcart/core/widgets/textfields.dart';
import 'package:popcart/core/widgets/widgets.dart';
import 'package:popcart/features/onboarding/models/onboarding_models.dart';
import 'package:popcart/features/seller/cubits/product/product_cubit.dart';
import 'package:popcart/features/seller/inventory/add_product_variant.dart';
import 'package:popcart/features/seller/inventory/product_uploaded.dart';
import 'package:popcart/features/seller/models/variant_model.dart';
import 'package:popcart/gen/assets.gen.dart';
import 'package:popcart/utils/text_styles.dart';
import 'package:reorderables/reorderables.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController productName = TextEditingController();
  final TextEditingController productDesc = TextEditingController();
  final TextEditingController price = TextEditingController();
  final TextEditingController salesPrice = TextEditingController();
  final TextEditingController discount = TextEditingController();
  TextEditingController stockLevel = TextEditingController();
  final FocusNode focusNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool selling = false;
  int step = 1;
  final ImagePicker _picker = ImagePicker();
  final List<XFile> _images = [];
  late ProductCategory selectedProductCategory;
  List<VariantModel> variants = [];

  Future<void> pickImages() async {
    final picked = await _picker.pickMultiImage();
    if (picked.isNotEmpty) {
      setState(() => _images.addAll(picked));
    }
  }

  @override
  void initState() {
    context.read<ProductCubit>().getInterests();
    super.initState();
  }

  void removeImage(int index) {
    setState(() => _images.removeAt(index));
  }

  void reorderImages(int oldIndex, int newIndex) {
    setState(() {
      final item = _images.removeAt(oldIndex);
      _images.insert(newIndex, item);
    });
  }

  @override
  void dispose() {
    stockLevel.dispose();
    productName.dispose();
    productDesc.dispose();
    price.dispose();
    salesPrice.dispose();
    discount.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productCubit = context.watch<ProductCubit>();
    return BlocListener<ProductCubit, AddProductState>(
      listener: (context, state) {
        state.whenOrNull(
          loading: () {},
          loaded: (product) {
            selectedProductCategory = product[0];
          },
          error: (message) {
            context.showError(message);
          },
          saveProduct: () async {
              await showModalBottomSheet<void>(
                context: context,
                builder: (_) => Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: const ProductUploaded(
                    title: 'Product Added Successfully!',
                    description:
                        'Your new item is now live in your inventory. Ready to manage, edit, or start selling!',
                  ),
                ),
              );
            context.push(AppPath.authorizedUser.seller.inventory.path);
          },
          saveProductFailure: (message) {
            context.showError(message);
          },
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Product'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: LinearProgressIndicator(
                          value: _images.isNotEmpty ? 1.0 : 0.5,
                          backgroundColor: AppColors.white,
                          color: AppColors.white,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                              AppColors.orange),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: LinearProgressIndicator(
                          value: step == 2 ? 1.0 : 0.0,
                          backgroundColor: AppColors.white,
                          color: AppColors.white,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                              AppColors.orange),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Step ${_images.isEmpty ? 1 : 2} of 2',
                      textAlign: TextAlign.center,
                      style: TextStyles.caption,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (step == 1) ...{
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: pickImages,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image:
                                AssetImage(AppAssets.images.dottedLines.path),
                            fit: BoxFit.fill,
                          ),
                        ),
                        child: Column(
                          children: [
                            AppAssets.images.addImage.image(),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              'Upload up to 10 images of your product',
                              textAlign: TextAlign.center,
                              style: TextStyles.titleHeading,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              'PNG or JPG (Max: 800px by 1200px)',
                              textAlign: TextAlign.center,
                              style: TextStyles.caption,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 21,
                    ),
                    if (_images.isNotEmpty) ...{
                      Container(
                        decoration: const BoxDecoration(
                            color: AppColors.infoContainerColor,
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Row(
                          children: [
                            AppAssets.icons.info.svg(),
                            const SizedBox(
                              width: 20,
                            ),
                            Flexible(
                              child: Text(
                                'Tap on images to edit them, or press, hold and move for reordering',
                                textAlign: TextAlign.start,
                                style: TextStyles.caption
                                    .copyWith(color: AppColors.orange),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ReorderableWrap(
                        spacing: 8,
                        runSpacing: 8,
                        maxMainAxisCount: 3,
                        onReorder: reorderImages,
                        children: List.generate(_images.length, (index) {
                          final width =
                              (MediaQuery.of(context).size.width - 32) / 4;
                          return Stack(
                            key: ValueKey(_images[index].path),
                            clipBehavior: Clip.none,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  File(_images[index].path),
                                  width: width,
                                  height: width,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: -10,
                                right: -10,
                                child: GestureDetector(
                                    onTap: () => removeImage(index),
                                    child: AppAssets.icons.cancel.svg()),
                              ),
                            ],
                          );
                        }),
                      ),
                      const SizedBox(
                        height: 21,
                      ),
                      CustomElevatedButton(
                        text: 'Next',
                        enabled: _images.isNotEmpty,
                        onPressed: () {
                          setState(() {
                            step = 2;
                          });
                        },
                      )
                    },
                  } else ...{
                    const Text(
                      'Product name',
                      style: TextStyles.textTitle,
                    ),
                    const SizedBox(height: 10),
                    CustomTextFormField(
                      focusNode: focusNode,
                      validator: ValidationBuilder().required().build(),
                      controller: productName,
                      hintText: 'Product name',
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Product categories',
                      style: TextStyles.textTitle,
                    ),
                    const SizedBox(height: 11),
                    CustomDropDownWidget<ProductCategory>(
                      title: 'Select Product Category',
                      items: productCubit.interestsList,
                      itemLabel: (item) => item.name,
                      onChanged: (selectedItem) {
                        selectedProductCategory = selectedItem;
                      },
                      value: selectedProductCategory,
                    ),
                    const SizedBox(height: 21),
                    const Text(
                      'Product description',
                      style: TextStyles.textTitle,
                    ),
                    const SizedBox(height: 12),
                    CustomTextFormField(
                      validator: ValidationBuilder().required().build(),
                      controller: productDesc,
                      hintText: 'Product description',
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(
                      height: 19,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Price',
                                style: TextStyles.textTitle,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              CustomTextFormField(
                                validator:
                                    ValidationBuilder().required().build(),
                                controller: price,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                hintText: 'Amount',
                                textInputAction: TextInputAction.next,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Sales Price',
                                style: TextStyles.textTitle,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              CustomTextFormField(
                                controller: salesPrice,
                                hintText: 'Amount',
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                textInputAction: TextInputAction.next,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Discount',
                                style: TextStyles.textTitle,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              CustomTextFormField(
                                controller: discount,
                                hintText: 'Amount',
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                textInputAction: TextInputAction.next,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    const Text('Status', style: TextStyles.textTitle),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        children: [
                          Flexible(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: AppColors.darkGrey,
                                  borderRadius: BorderRadius.circular(19)),
                              padding:
                                  const EdgeInsets.only(left: 0, right: 50),
                              child: Row(
                                children: [
                                  Radio<bool>(
                                    value: true,
                                    groupValue: selling,
                                    onChanged: (value) {
                                      setState(() => selling = value!);
                                    },
                                  ),
                                  const Text('Selling',
                                      style: TextStyle(color: AppColors.white)),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Flexible(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: AppColors.darkGrey,
                                  borderRadius: BorderRadius.circular(19)),
                              padding:
                                  const EdgeInsets.only(left: 0, right: 50),
                              child: Row(
                                children: [
                                  Radio<bool>(
                                    value: false,
                                    groupValue: selling,
                                    onChanged: (value) {
                                      setState(() => selling = value!);
                                    },
                                  ),
                                  const Text('Not Selling',
                                      style: TextStyle(color: AppColors.white)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Stock level',
                      style: TextStyles.textTitle,
                    ),
                    const SizedBox(
                      height: 13,
                    ),
                    CustomTextFormField(
                      validator: ValidationBuilder().required().build(),
                      controller: stockLevel,
                      hintText: 'Stock level',
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                    if (variants.isNotEmpty) ...[
                      const SizedBox(
                        height: 17,
                      ),
                      Column(
                        children: [
                          ...List.generate(variants.length, (index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: variantItem(
                                variant: variants[index],
                                context: context,
                                callback: () {
                                  variants.removeAt(index);
                                  setState(() {});
                                },
                              ),
                            );
                          }),
                        ],
                      ),
                    ],
                    const SizedBox(
                      height: 15,
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () async {
                        final variant =
                            await showModalBottomSheet<VariantModel>(
                          context: context,
                          isScrollControlled: true,
                          builder: (_) => Container(
                            height: MediaQuery.of(context).size.height * 0.5,
                            decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                              ),
                            ),
                            child: const AddProductVariant(),
                          ),
                        );
                        if (variant != null) {
                          setState(() {
                            variants.add(variant);
                          });
                        }
                      },
                      child: Row(
                        children: [
                          AppAssets.icons.addIcon.svg(),
                          const SizedBox(
                            width: 20,
                          ),
                          const Text('Add Product variant',
                              style: TextStyles.textTitle),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    CustomElevatedButton(
                      text: 'Save',
                      showIcon: false,
                      loading: productCubit.state.maybeWhen(
                        orElse: () => false,
                        loading: () => true,
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await productCubit.addProduct(
                              productName: productName.text,
                              productDescription: productDesc.text,
                              productPrice: price.text,
                              salesPrice: salesPrice.text,
                              discount: discount.text,
                              status: selling,
                              images: _images,
                              category: selectedProductCategory,
                              variants: variants,
                              stockUnit: int.parse(stockLevel.text));
                        }
                      },
                    )
                  },
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
