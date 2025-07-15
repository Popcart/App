import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:popcart/core/colors.dart';
import 'package:popcart/core/utils.dart';
import 'package:popcart/features/common/models/order_model.dart';
import 'package:popcart/features/components/network_image.dart';

class SellerOrderItem extends StatelessWidget {

  const SellerOrderItem({required this.order, super.key});
  final Order order;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  height: 80,
                  width: 83,
                  child: NetworkImageWithLoader(
                    order.items[0].meta.image,
                    radius: 5,
                  )),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                text: 'Order ID:',
                                style: TextStyle(color: AppColors.white,
                                  fontSize: 12.sp,),
                                children: [
                                  TextSpan(
                                    text: ' #${order.items[0].id}',
                                    style: TextStyle(
                                      color: AppColors.white,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w700
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 20,),
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: AppColors.orange,
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: Text(order.deliveryStatus),
                          )
                        ],
                      ),
                      const SizedBox(height: 10,),
                      Text(order.items[0].meta.name,  style: TextStyle(
                          color: AppColors.white,
                          fontSize: 12.sp,
                      ),),
                      const SizedBox(height: 10,),
                      Text(order.items[0].meta.price.toCurrency(),
                        style: TextStyle(
                            color: AppColors.white,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700
                        ),),
                    ]),
              ),
            ],
          ),
          const SizedBox(height: 5,),
          const Divider(thickness: 0.5, color: AppColors.dividerColor),
        ],
      ),
    );
  }
}
