import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:popcart/app/router_paths.dart';
import 'package:popcart/core/colors.dart';
import 'package:popcart/core/utils.dart';
import 'package:popcart/features/live/models/products.dart';
import 'package:popcart/features/seller/cubits/product/product_cubit.dart';
import 'package:popcart/gen/assets.gen.dart';
import 'package:popcart/utils/text_styles.dart';

class ProductItem extends StatefulWidget {
  const ProductItem(
      {required this.product, required this.onDeleted, super.key});

  final Product product;
  final VoidCallback onDeleted;

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  int _currentPage = 0;
  late final PageController _pageController;
  bool _isDeleting = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(thickness: 0.5, color: AppColors.dividerColor),
        const SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                SizedBox(
                  height: 70,
                  width: 100,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: widget.product.images.length,
                    onPageChanged: (i) => setState(() => _currentPage = i),
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(widget.product.images[index],
                            fit: BoxFit.cover),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:
                      List.generate(widget.product.images.length, (index) {
                    final isActive = index == _currentPage;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: isActive ? 6 : 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: isActive
                            ? AppColors.white
                            : AppColors.tabContainerColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }),
                )
              ],
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.product.name, style: TextStyles.textTitle),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.all(4),
                  margin: const EdgeInsets.only(right: 4),
                  decoration: const BoxDecoration(
                      color: AppColors.containerBlue,
                      borderRadius: BorderRadius.all(Radius.circular(3))),
                  child: Text(widget.product.category.name,
                      style: TextStyles.styleW500S12),
                ),
              ],
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(widget.product.price.toCurrency(),
                    style: TextStyles.titleHeading),
                const SizedBox(height: 4),
                Text('${widget.product.stockUnit} in stock',
                    style: TextStyles.body.copyWith(
                      color: widget.product.stockUnit > 4
                          ? AppColors.green
                          : widget.product.stockUnit > 0
                              ? AppColors.amber
                              : AppColors.red,
                    )),
              ],
            ),
            const SizedBox(
              width: 10,
            ),
            if (_isDeleting)
              const Padding(
                padding: EdgeInsets.all(10),
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: AppColors.white,
                  ),
                ),
              )
            else
              PopupMenuButton<String>(
                color: AppColors.popUpMenuBg,
                icon: AppAssets.icons.menu.svg(),
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                onSelected: (value) async {
                  if (value == 'delete') {
                    await _deleteProduct();
                  } else if (value == 'edit') {
                    await context.pushNamed(
                      AppPath.authorizedUser.seller.inventory.editProduct.path,
                      extra: widget.product,
                    );
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Edit',
                          style: TextStyle(
                              color: AppColors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 17),
                        ),
                        const SizedBox(
                          width: 110,
                        ),
                        AppAssets.icons.edit.svg()
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Delete',
                          style: TextStyle(
                              color: AppColors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 17),
                        ),
                        const SizedBox(
                          width: 110,
                        ),
                        AppAssets.icons.deleteProduct.svg()
                      ],
                    ),
                  ),
                ],
              )
          ],
        ),
        const SizedBox(
          height: 5,
        ),
      ],
    );
  }

  Future<void> _deleteProduct() async {
    setState(() => _isDeleting = true);

    final productCubit = context.read<ProductCubit>();
    final result =
        await productCubit.deleteProduct(productId: widget.product.id);

    await result.when(
      success: (message) async {
        widget.onDeleted();
        await context
            .showSuccess(message?.message ?? 'Product deleted successfully');
      },
      error: (e) async {
        await context.showError(e.message ?? 'An error occurred');
      },
    );

    setState(() => _isDeleting = false);
  }
}

// await showDialog<bool>(
//   context: context,
//   builder: (context) => AlertDialog(
//     title: const Text('Confirm Delete'),
//     content: const Text(
//         'Are you sure you want to delete this product?'),
//     actions: [
//       TextButton(
//         onPressed: () => Navigator.pop(context),
//         child: const Text('Cancel'),
//       ),
//       TextButton(
//         onPressed: () async {
//           Navigator.pop(context);
//           final response = await locator<InventoryRepo>()
//               .deleteProduct(productId: widget.product.id);
//         },
//         child: const Text('Delete',
//             style: TextStyle(color: Colors.red)),
//       ),
//     ],
//   ),
// );
