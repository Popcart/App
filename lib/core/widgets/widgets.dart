import 'package:flutter/material.dart';
import 'package:popcart/core/colors.dart';
import 'package:popcart/core/utils.dart';
import 'package:popcart/features/live/models/products.dart';
import 'package:popcart/gen/assets.gen.dart';
import 'package:popcart/utils/text_styles.dart';

Widget topProductWidget(Product product, int index) {
  return Container(
    decoration: BoxDecoration(color: (index % 2).isEven ? AppColors.brown :
    AppColors.appBackground,
        borderRadius: BorderRadius.circular(16)),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    margin: const EdgeInsets.only(bottom: 10),
    child: Row(
      children: [
        if(product.images.isNotEmpty)ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Image.network(product.images[0], width: 50, height: 40,
              fit: BoxFit.cover),
        ),
        const SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(product.name, style: TextStyles.textTitle),
            Text('${product.stockUnit} sold',
                style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500)),
          ],
        ),
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(product.price.toCurrency(),
                style: TextStyles.titleHeading),
            const SizedBox(height: 4),
            Text('${product.stockUnit} in stock',
                style: TextStyles.body.copyWith(
                  color: product.stockUnit > 4
                      ? AppColors.green
                      : product.stockUnit > 0
                      ? AppColors.amber
                      : AppColors.red,
                )),
          ],
        ),
      ],
    ),
  );
}

Widget inventoryAlertWidget(Product product, int index) {
  return Container(
    decoration: BoxDecoration(color: (index % 2).isEven ? AppColors.brown :
    AppColors.appBackground,
        borderRadius: BorderRadius.circular(16)),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    margin: const EdgeInsets.only(bottom: 10),
    child: Row(
      children: [
        if(product.images.isNotEmpty)ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Image.network(product.images[0], width: 50, height: 40,
              fit: BoxFit.cover),
        ),
        const SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(product.name, style: TextStyles.textTitle),
            Text('Low stock alert',
                style: const TextStyle(
                    color: AppColors.red,
                    fontSize: 12,
                    fontWeight: FontWeight.w500)),
          ],
        ),
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('${product.stockUnit} left',
                style: TextStyles.titleHeading.copyWith(color: AppColors.red)),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                  color: AppColors.black,
                  borderRadius: BorderRadius.all(Radius.circular(3))),
              child: Text('Restock',
                  style: TextStyles.styleW500S12.copyWith(color: AppColors.white)),
            ),
          ],
        ),
      ],
    ),
  );
}