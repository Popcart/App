import 'package:flutter/material.dart';
import 'package:popcart/core/colors.dart';
import 'package:popcart/gen/assets.gen.dart';

Widget TopProductWidget() {
  return Container(
    decoration: const BoxDecoration(color: AppColors.grey50),
    margin: const EdgeInsets.only(bottom: 10),
    child: Row(
      children: [
        SizedBox(
            width: 50, height: 40, child: AppAssets.images.buyer.image()),
        const SizedBox(
          width: 10,
        ),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Premium Headphones',
                style: TextStyle(
                    color: AppColors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500)),
            Text('123 sold',
                style: TextStyle(
                    color: AppColors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500)),
          ],
        ),
        const Spacer(),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('₦350k',
                style: TextStyle(
                    color: AppColors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500)),
            Text('42 in stock',
                style: TextStyle(
                    color: AppColors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500)),
          ],
        ),
      ],
    ),
  );
}