import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:popcart/app/service_locator.dart';
import 'package:popcart/core/repository/inventory_repo.dart';
import 'package:popcart/core/widgets/widgets.dart';
import 'package:popcart/features/live/models/products.dart';
import 'package:popcart/features/seller/inventory/product_item.dart';
import 'package:popcart/gen/assets.gen.dart';

class ProductTabView extends StatefulWidget {
  const ProductTabView({required this.type, super.key});

  final String type;

  @override
  State<ProductTabView> createState() => _ProductTabViewState();
}

class _ProductTabViewState extends State<ProductTabView>  {
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
                (element) => element.stockUnit > 4 || element.stockUnit < 1);
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
            onDeleted: _pagingController.refresh,
          );
        },
        firstPageErrorIndicatorBuilder: (context) => emptyState(
            AppAssets.images.box.image(),
            'Looks like an error occurred. Kindly try again!'),
        noItemsFoundIndicatorBuilder: (context) => emptyState(
            AppAssets.images.box.image(),
            'Looks like you haven’t added any products yet. Add products to start '
            'tracking and selling efficiently.'),
      ),
    );
  }
}
