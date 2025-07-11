import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_validator/form_validator.dart';
import 'package:popcart/core/colors.dart';
import 'package:popcart/core/utils.dart';
import 'package:popcart/core/widgets/buttons.dart';
import 'package:popcart/core/widgets/textfields.dart';
import 'package:popcart/features/buyer/cart/widgets/location_bottomsheet.dart';
import 'package:popcart/features/seller/cubits/product/product_cubit.dart';
import 'package:popcart/utils/text_styles.dart';

class DeliveryAddress extends StatefulWidget {
  const DeliveryAddress({super.key});

  @override
  State<DeliveryAddress> createState() => _DeliveryAddressState();
}

class _DeliveryAddressState extends State<DeliveryAddress> {
  final TextEditingController addressCtrl = TextEditingController();
  final TextEditingController phoneNumber = TextEditingController();
  final TextEditingController lga = TextEditingController();
  final TextEditingController landmark = TextEditingController();
  final TextEditingController state = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  @override
  void dispose() {
    lga.dispose();
    addressCtrl.dispose();
    landmark.dispose();
    state.dispose();
    phoneNumber.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productCubit = context.watch<ProductCubit>();
    return BlocListener<ProductCubit, AddProductState>(
      listener: (context, state) {
        state.whenOrNull(
          loading: () {},
          loaded: (product) {},
          error: (message) {
            context.showError(message);
          },
          saveProduct: () async {},
          saveProductFailure: (message) {
            context.showError(message);
          },
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Delivery Address'),
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
                    'Address',
                    style: TextStyles.textTitle,
                  ),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () async {
                      final address = await showModalBottomSheet<String>(
                        context: context,
                        isScrollControlled: true,
                        builder: (_) => Container(
                          height: MediaQuery.of(context).size.height * .7,
                          decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                          ),
                          child: const LocationBottomsheet(),
                        ),
                      );
                      if(address != null){
                        setState(() {
                          addressCtrl.text = address;
                        });
                      }
                    },
                    child: CustomTextFormField(
                      validator: ValidationBuilder().required().build(),
                      controller: addressCtrl,
                      hintText: 'Address',
                      suffixIcon: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: AppColors.white,
                      ),
                      enabled: false,
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  const SizedBox(
                    height: 19,
                  ),
                  const Text(
                    'Landmark',
                    style: TextStyles.textTitle,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextFormField(
                    validator: ValidationBuilder().required().build(),
                    controller: landmark,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    hintText: 'Closest landmark to your address',
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  const Text(
                    'Phone Number',
                    style: TextStyles.textTitle,
                  ),
                  const SizedBox(
                    height: 13,
                  ),
                  CustomTextFormField(
                    validator: ValidationBuilder().required().build(),
                    controller: phoneNumber,
                    hintText: 'Phone number',
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                  const SizedBox(height: 20),
                  CustomElevatedButton(
                    text: 'Add delivery address',
                    showIcon: false,
                    loading: false,
                    onPressed: () async {},
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
