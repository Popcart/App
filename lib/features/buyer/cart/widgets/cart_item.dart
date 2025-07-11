import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:popcart/core/colors.dart';
import 'package:popcart/core/utils.dart';
import 'package:popcart/features/buyer/cart/cubit/cart_cubit.dart';
import 'package:popcart/features/components/network_image.dart';
import 'package:popcart/features/live/models/cart_item_model.dart';
import 'package:popcart/gen/assets.gen.dart';
import 'package:popcart/route/route_constants.dart';
import 'package:popcart/utils/text_styles.dart';

class CartItem extends StatefulWidget {
  const CartItem({super.key, required this.cartItem});

  final CartItemModel cartItem;

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  ValueNotifier<int> quantity = ValueNotifier(1);

  @override
  void initState() {
    quantity.value = widget.cartItem.quantity;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.pushNamed(
          context,
          productScreen,
          arguments: widget.cartItem.productId,
        );
      },
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(
              height: 70,
              width: 80,
              child: NetworkImageWithLoader(
                widget.cartItem.meta.image,
                radius: 12,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.cartItem.meta.name,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.body,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      widget.cartItem.meta.price.toCurrency(),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles.titleHeading,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  color: AppColors.textFieldFillColor),
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 7),
              child: Row(
                children: [
                  ValueListenableBuilder(
                    valueListenable: quantity,
                    builder: (BuildContext context, int value, Widget? child) {
                      if (value > 1) {
                        return InkWell(
                            onTap: () async {
                              quantity.value--;
                              await context.read<CartCubit>().updateCartItem(
                                  widget.cartItem.copyWith(quantity: quantity.value));
                            },
                            child: AppAssets.icons.minus.svg());
                      } else {
                        return InkWell(
                            onTap: () async {
                              await context
                                  .read<CartCubit>()
                                  .deleteCartItem(widget.cartItem);
                            },
                            child: AppAssets.icons.deleteCart.svg());
                      }
                    },
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  ValueListenableBuilder(
                    valueListenable: quantity,
                    builder: (BuildContext context, int value, Widget? child) {
                      return Text(
                        value.toString(),
                        style: TextStyles.textTitle,
                      );
                    },
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  InkWell(
                      onTap: () async {
                        quantity.value++;
                        await context.read<CartCubit>().updateCartItem(
                            widget.cartItem.copyWith(quantity: quantity.value));
                      },
                      child: AppAssets.icons.add.svg())
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
