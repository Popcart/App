import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:popcart/app/service_locator.dart';
import 'package:popcart/core/colors.dart';
import 'package:popcart/core/repository/inventory_repo.dart';
import 'package:popcart/core/utils.dart';
import 'package:popcart/features/live/models/products.dart';
import 'package:popcart/gen/assets.gen.dart';
import 'package:popcart/utils/text_styles.dart';

class ProductTabView extends StatefulWidget {
  final String type;

  const ProductTabView({required this.type});

  @override
  State<ProductTabView> createState() => _ProductTabViewState();
}

class _ProductTabViewState extends State<ProductTabView> {
  final PagingController<int, Product> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener(fetchPage);
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  Future<void> fetchPage(int pageKey) async {
    final items = await locator<InventoryRepo>().getAllProducts(
      page: pageKey,
      limit: 10,
    );
    items.when(
      success: (data) {
        final isLastPage = data?.data?.page == data?.data?.totalPages;
        switch (widget.type) {
          case 'Low stock':
            data?.data?.results.removeWhere(
                (element) => element.stockUnit > 5 || element.stockUnit < 1);
          case 'Out of stock':
            data?.data?.results.removeWhere((element) => element.stockUnit > 0);
          default:
            break;
        }
        final results = data?.data?.results ?? <Product>[];
        if (isLastPage) {
          _pagingController.appendLastPage(results);
        } else {
          _pagingController.appendPage(results, pageKey + 1);
        }
      },
      error: (err) => _pagingController.error = err,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PagedListView<int, Product>(
      pagingController: _pagingController,
      builderDelegate: PagedChildBuilderDelegate<Product>(
        itemBuilder: (context, product, index) {
          return ProductItem(
            product: product,
          );
        },
        firstPageErrorIndicatorBuilder: (context) => emptyState(),
        noItemsFoundIndicatorBuilder: (context) => emptyState(),
      ),
    );
  }

  Widget emptyState() {
    return Column(
      children: [
        const Spacer(),
        AppAssets.images.box.image(),
        const SizedBox(
          height: 10,
        ),
        const Text(
          'Looks like you haven’t added any products yet. Add products to start '
          'tracking and selling efficiently.',
          textAlign: TextAlign.center,
          style: TextStyles.titleHeading,
        ),
        const Spacer(),
      ],
    );
  }
}

class ProductItem extends StatefulWidget {
  final Product product;

  const ProductItem({super.key, required this.product});

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  int _currentPage = 0;
  late final PageController _pageController;

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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
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
          ],
        ),
        const SizedBox(
          height: 5,
        ),
      ],
    );
  }
}
