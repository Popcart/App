import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_validator/form_validator.dart';
import 'package:popcart/core/colors.dart';
import 'package:popcart/core/dropdown_widget.dart';
import 'package:popcart/core/utils.dart';
import 'package:popcart/core/widgets/buttons.dart';
import 'package:popcart/core/widgets/textfields.dart';
import 'package:popcart/core/widgets/widgets.dart';
import 'package:popcart/features/live/models/products.dart';
import 'package:popcart/features/onboarding/models/onboarding_models.dart';
import 'package:popcart/features/seller/cubits/product/product_cubit.dart';
import 'package:popcart/features/seller/inventory/add_product_variant.dart';
import 'package:popcart/features/seller/inventory/product_uploaded.dart';
import 'package:popcart/features/seller/models/variant_model.dart';
import 'package:popcart/gen/assets.gen.dart';
import 'package:popcart/utils/text_styles.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({required this.productModal, super.key});

  final Product productModal;

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final TextEditingController productName = TextEditingController();
  final TextEditingController productDesc = TextEditingController();
  final TextEditingController price = TextEditingController();
  final TextEditingController salesPrice = TextEditingController();
  final TextEditingController discount = TextEditingController();
  TextEditingController stockLevel = TextEditingController();
  final FocusNode focusNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool selling = false;
  ProductCategory? selectedProductCategory;
  List<VariantModel> variants = [];

  @override
  void initState() {
    setProductData();
    context.read<ProductCubit>().getInterests();
    super.initState();
  }

  void setProductData() {
    productName.text = widget.productModal.name;
    productDesc.text = widget.productModal.description;
    price.text = widget.productModal.price.round().toString();
    stockLevel.text = widget.productModal.stockUnit.toString();
    selling = widget.productModal.available;
    variants.addAll(widget.productModal.productVariants);
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
                  title: 'Success',
                  description:
                  'You have successfully edited your product details.',
                ),
              ),
            );
            Navigator.pop(context);
          },
          saveProductFailure: (message) {
            context.showError(message);
          },
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Product'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                              validator: ValidationBuilder().required().build(),
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
                                borderRadius: BorderRadius.circular(19.0)),
                            padding: const EdgeInsets.only(left: 0, right: 50),
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
                                borderRadius: BorderRadius.circular(19.0)),
                            padding: const EdgeInsets.only(left: 0, right: 50),
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
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    hintText: 'Stock level',
                  ),
                  if (variants.isNotEmpty) ...[
                    const SizedBox(
                      height: 17,
                    ),
                    Column(
                      children: [
                        ...List.generate(variants.length, (index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 15.0),
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
                      if (_formKey.currentState!.validate() &&
                          selectedProductCategory != null) {
                        await productCubit.editProduct(
                            productId: widget.productModal.id,
                            productName: productName.text,
                            productDescription: productDesc.text,
                            productPrice: price.text,
                            salesPrice: salesPrice.text,
                            discount: discount.text,
                            status: selling,
                            category: selectedProductCategory!,
                            variants: variants,
                            stockUnit: int.parse(stockLevel.text));
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
