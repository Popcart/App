import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:popcart/core/colors.dart';
import 'package:popcart/core/utils.dart';
import 'package:popcart/core/widgets/buttons.dart';
import 'package:popcart/core/widgets/widgets.dart';
import 'package:popcart/features/buyer/buyer_home.dart';
import 'package:popcart/features/buyer/cart/cubit/cart_cubit.dart';
import 'package:popcart/features/components/network_image.dart';
import 'package:popcart/features/live/models/cart_item_model.dart';
import 'package:popcart/features/seller/inventory/product_uploaded.dart';
import 'package:popcart/features/seller/live/set_minimum_price.dart';
import 'package:popcart/features/wallet/cubit/wallet_cubit.dart';
import 'package:popcart/gen/assets.gen.dart';
import 'package:popcart/route/route_constants.dart';
import 'package:popcart/utils/text_styles.dart';

enum PaymentOption { wallet, paystack, interswitch }

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key, required this.address});

  final Map<String, dynamic>? address;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  List<CartItemModel> carts = [];
  PaymentOption selectedOption = PaymentOption.wallet;
  TextEditingController amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getCartItems();
  }

  Future<void> getCartItems() async {
    await context.read<CartCubit>().getCart();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final walletCubit = context.watch<WalletCubit>();
    final title = walletCubit.state.maybeWhen(
      loaded: (wallet) => wallet.balance.toCurrency(),
      orElse: () => '0',
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: BlocConsumer<CartCubit, CartState>(
        listener: (context, state) {
          state.maybeWhen(
            getCartSuccess: (items) {
              carts = items;
              setState(() {});
            },
            getCartError: (error) {
              context.showError(error);
            },
            orderProcessed: () async {
              await showModalBottomSheet<void>(
                context: context,
                isDismissible: false,
                enableDrag: false,
                builder: (_) => Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: ProductUploaded(
                      title: 'Order Confirmed',
                      description:
                          'Thank you for your purchase. We’re getting it ready '
                          'and will notify you once it’s on the way!',
                      showButton: true,
                      onButtonPressed: () {
                        currentIndex.value = 2;
                        Navigator.of(context).popUntil(
                            (route) => route.settings.name == buyerHome);
                      }),
                ),
              );
            },
            processingOrderError: (error) {
              context.showError(error);
            },
            orElse: () {},
          );
        },
        builder: (context, state) {
          final isLoading =
              state.maybeWhen(loading: () => true, orElse: () => false);
          return !isLoading
              ? carts.isNotEmpty
                  ? SingleChildScrollView(
                      child: RefreshIndicator.adaptive(
                        onRefresh: () => context.read<CartCubit>().getCart(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                'Payment Method',
                                style: TextStyles.titleHeading,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                children: PaymentOption.values.map((option) {
                                  return Theme(
                                    data: theme.copyWith(
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                    ),
                                    child: RadioListTile<PaymentOption>(
                                      title: Text(option.name),
                                      subtitle: option == PaymentOption.wallet
                                          ? Text(
                                              'Available balance: '
                                              '$title',
                                              style: TextStyles.body,
                                            )
                                          : null,
                                      secondary: option == PaymentOption.wallet
                                          ? AppAssets.icons.paymentWallet.svg()
                                          : option == PaymentOption.paystack
                                              ? AppAssets.icons.paymentPaystack
                                                  .svg()
                                              : AppAssets
                                                  .icons.paymentInterswitch
                                                  .svg(),
                                      value: option,
                                      groupValue: selectedOption,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedOption = value!;
                                        });
                                      },
                                      controlAffinity:
                                          ListTileControlAffinity.trailing,
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Divider(
                              thickness: 6,
                              color: AppColors.textFieldFillColor,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                children: [
                                  const Expanded(
                                    child: Text(
                                      'My Cart',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyles.titleHeading,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      'View',
                                      style: TextStyle(
                                        color: AppColors.orange,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: SizedBox(
                                height: 80,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: carts.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 20),
                                      child: SizedBox(
                                        height: 60,
                                        width: 80,
                                        child: NetworkImageWithLoader(
                                          carts[index].meta.image,
                                          radius: 12,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Divider(
                              thickness: 6,
                              color: AppColors.textFieldFillColor,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                'Order Summary',
                                style: TextStyles.titleHeading,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                children: [
                                  detail('${carts.length} items',
                                      calculateCartTotal(carts).toCurrency()),
                                  detail('Delivery Fee', 0.toCurrency()),
                                  detail('Estimated taxes and fees',
                                      0.toCurrency()),
                                  detail('Sub total', 0.toCurrency()),
                                ],
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Divider(
                                thickness: 0.5,
                                color: AppColors.textFieldFillColor,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: detail('Total to pay',
                                  calculateCartTotal(carts).toCurrency()),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: CustomElevatedButton(
                                  loading: context
                                      .watch<CartCubit>()
                                      .state
                                      .maybeWhen(
                                        orElse: () => false,
                                        processingOrder: () => true,
                                      ),
                                  onPressed: () async {
                                    if (selectedOption.name == 'wallet') {
                                      final amount = double.parse(
                                        title
                                            .replaceAll('₦', '')
                                            .replaceAll(',', ''),
                                      );
                                      if (amount < calculateCartTotal(carts)) {
                                        await context.showError('Insufficient funds');
                                        // await showModalBottomSheet<void>(
                                        //     context: context,
                                        //     builder: (context) {
                                        //       return Padding(
                                        //         padding: const EdgeInsets.all(20),
                                        //         child: Column(
                                        //           children: [
                                        //             SizedBox(height: 20,),
                                        //             const Text('Insufficient Funds'),
                                        //             SizedBox(height: 20,),
                                        //             const Text('Kindly Top - up your wallet to pay'),
                                        //             SizedBox(height: 20,),
                                        //             TextField(
                                        //               controller: amountController,
                                        //               decoration: const InputDecoration(
                                        //                 hintText: 'Amount',
                                        //                 hintStyle:
                                        //                 TextStyle(color: Color(0xffD7D8D9), fontSize: 16),
                                        //                 fillColor: Color(0xff24262B),
                                        //                 filled: true,
                                        //                 border: OutlineInputBorder(
                                        //                   borderRadius: BorderRadius.all(Radius.circular(8)),
                                        //                   borderSide: BorderSide.none,
                                        //                 ),
                                        //               ),
                                        //             ),
                                        //             SizedBox(height: 20,),
                                        //             CustomElevatedButton(onPressed: (){}, text: 'Confirm Amount', showIcon: false,)
                                        //           ],
                                        //         ),
                                        //       );
                                        //     });
                                        return;
                                      }
                                    }
                                    await context.read<CartCubit>().processPayment({
                                      'deliveryAddress':
                                          widget.address!['address'],
                                      'landmark': widget.address!['landmark'],
                                      'recipientPhone':
                                          widget.address!['phoneNumber'],
                                      'fulfilledBy': 'popcart',
                                      'amount': calculateCartTotal(carts),
                                      'cart':
                                          carts.map((e) => e.toJson()).toList(),
                                      'paymentOption': selectedOption.name,
                                    });
                                  },
                                  showIcon: false,
                                  text: 'Pay for order'),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    )
                  : Expanded(
                      child: emptyState(
                          SizedBox(
                              width: 100,
                              child: AppAssets.images.designerBag.image()),
                          'You cart is empty'),
                    )
              : const Center(
                  child: CircularProgressIndicator(),
                );
        },
      ),
    );
  }

  Widget detail(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyles.titleHeading,
          ),
          Text(
            value,
            style: TextStyles.titleHeading,
          ),
        ],
      ),
    );
  }
}
