import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:popcart/core/colors.dart';
import 'package:popcart/core/utils.dart';
import 'package:popcart/core/widgets/widgets.dart';
import 'package:popcart/features/buyer/cart/cubit/cart_cubit.dart';
import 'package:popcart/features/buyer/cart/widgets/cart_item.dart';
import 'package:popcart/features/live/models/cart_item_model.dart';
import 'package:popcart/features/seller/orders/orders_tab.dart';
import 'package:popcart/gen/assets.gen.dart';
import 'package:popcart/route/route_constants.dart';
import 'package:popcart/utils/text_styles.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<CartItemModel> carts = [];

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        automaticallyImplyLeading: false,
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
            orElse: () {},
          );
        },
        builder: (context, state) {
          final isLoading =
              state.maybeWhen(loading: () => true, orElse: () => false);
          return !isLoading
              ? carts.isNotEmpty
                  ? RefreshIndicator.adaptive(
                    onRefresh: ()=> context.read<CartCubit>().getCart(),
                    child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, deliveryAddress);
                              },
                              child: Row(
                                children: [
                                  AppAssets.icons.delivery.svg(),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  const Text(
                                    'Add delivery address',
                                    style: TextStyles.titleHeading,
                                  ),
                                  const Spacer(),
                                  const Icon(Icons.keyboard_arrow_right_rounded)
                                ],
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
                            height: 10,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: ListView.separated(
                                shrinkWrap: true,
                                itemCount: carts.length,
                                itemBuilder: (context, index) {
                                  return CartItem(cartItem: carts[index]);
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return const Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Divider(
                                      thickness: 0.5,
                                      color: AppColors.textFieldFillColor,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
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
}
