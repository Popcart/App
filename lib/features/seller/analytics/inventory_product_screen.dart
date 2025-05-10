import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:popcart/app/service_locator.dart';
import 'package:popcart/core/repository/inventory_repo.dart';
import 'package:popcart/core/widgets/widgets.dart';
import 'package:popcart/features/live/models/products.dart';

class InventoryProductScreen extends StatefulWidget {
  const InventoryProductScreen({super.key});

  @override
  State<InventoryProductScreen> createState() => _InventoryProductScreenState();
}

class _InventoryProductScreenState extends State<InventoryProductScreen> {
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
    final items = await
    locator<InventoryRepo>().getAllProducts(
      page: pageKey,
      limit: 10,
    );
    items.when(
      success: (data) {
        final isLastPage = data?.data?.page == data?.data?.totalPages;
        data?.data?.results.removeWhere(
                (element) => element.stockUnit > 5);
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory Alerts'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: PagedListView<int, Product>(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<Product>(
            itemBuilder: (context, product, index) {
              return inventoryAlertWidget(
                product, index
              );
            },
            // firstPageErrorIndicatorBuilder: (context) => emptyState(),
            // noItemsFoundIndicatorBuilder: (context) => emptyState(),
          ),
        ),
      ),
    );
  }
}
