import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:popcart/core/colors.dart';
import 'package:popcart/core/utils.dart';
import 'package:popcart/features/live/models/products.dart';
import 'package:popcart/features/seller/models/variant_model.dart';
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
            const Text('Low stock alert',
                style: TextStyle(
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

Widget variantItem(
    {required VariantModel variant,
      required BuildContext context,
      required VoidCallback callback}) {
  return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.25,
        children: [
          SlidableAction(
            onPressed: (context) => callback(),
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete_outline,
            label: 'Delete',
          ),
        ],
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.textFieldFillColor,
          borderRadius: BorderRadius.circular(16),
        ),
        // margin: const EdgeInsets.only(bottom: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(variant.variant, style: TextStyles.body),
            const SizedBox(height: 4),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: List.generate(
                variant.options.length,
                    (index) {
                  return Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppColors.black,
                      borderRadius: BorderRadius.all(Radius.circular(3)),
                    ),
                    child: Text(
                      variant.options[index],
                      style: TextStyles.caption,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ));
}

class CustomTabBar extends StatelessWidget {

  const CustomTabBar({
    required this.selectedIndex,
    required this.tabs,
    required this.onTap,
  });
  final int selectedIndex;
  final List<String> tabs;
  final Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.tabContainerColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final isSelected = index == selectedIndex;
          return Expanded(
            child: InkWell(
              onTap: () => onTap(index),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: index == selectedIndex
                      ? AppColors.tabSelectedContainerColor
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: index == selectedIndex
                        ? AppColors.tabSelectedBorderColor
                        : Colors.transparent,
                    width: 5,
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: Center(
                  child: Text(
                    tabs[index],
                    style: TextStyle(
                      color: isSelected
                          ? AppColors.white
                          : AppColors.tabUnSelectedTextColor,
                      fontWeight:
                      isSelected ? FontWeight.w700 : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

Widget emptyState(Widget icon, String label) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Spacer(),
      Center(child: icon),
      const SizedBox(
        height: 10,
      ),
      Center(
        child: Text(label,
          textAlign: TextAlign.center,
          style: TextStyles.titleHeading,
        ),
      ),
      const Spacer(),
    ],
  );
}

extension SvgThemed on SvgGenImage {
  Widget themedIcon(BuildContext context, {bool override = false}) {
    final iconColor = Theme.of(context).iconTheme.color;
    return svg(
      colorFilter: override
          ? null
          : ColorFilter.mode(iconColor ?? Colors.white, BlendMode.srcIn),
    );
  }

}