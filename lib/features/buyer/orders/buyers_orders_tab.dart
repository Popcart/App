import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:popcart/app/service_locator.dart';
import 'package:popcart/core/colors.dart';
import 'package:popcart/core/repository/order_repo.dart';
import 'package:popcart/core/widgets/widgets.dart';
import 'package:popcart/features/live/models/products.dart';
import 'package:popcart/features/seller/inventory/product_item.dart';
import 'package:popcart/gen/assets.gen.dart';
import 'package:popcart/utils/text_styles.dart';

class BuyersOrdersTabView extends StatefulWidget {
  const BuyersOrdersTabView({required this.type, super.key});

  final String type;

  @override
  State<BuyersOrdersTabView> createState() => _BuyersOrdersTabViewState();
}

class _BuyersOrdersTabViewState extends State<BuyersOrdersTabView> {
  final PagingController<int, Product> _pagingController =
      PagingController(firstPageKey: 1);
  String filterBy = 'Recents';
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
    final items = await locator<OrderRepo>().getOrders(
      page: pageKey,
      limit: 10, status: widget.type.toLowerCase(),
    );
    items.when(
      success: (data) {
        final isLastPage = data?.data?.page == data?.data?.totalPages;
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
    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            await showSortModal(
              context: context,
              selected: filterBy,
              onChanged: (val) => setState(() => filterBy = val),
            );

          },
          child: Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  'Sort by: ',
                  style: TextStyles.titleHeading,
                ),
                Text(
                  filterBy,
                  style: TextStyles.titleHeading,
                ),
                const SizedBox(
                  width: 5,
                ),
                const Icon(Icons.keyboard_arrow_down)
              ],
            ),
          ),
        ),
        SizedBox(height: 20,),
        Expanded(
          child: PagedListView<int, Product>(
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate<Product>(
              itemBuilder: (context, product, index) {
                return ProductItem(
                  product: product,
                  onDeleted: _pagingController.refresh,
                );
              },
              firstPageErrorIndicatorBuilder: (context) => emptyState(
                  AppAssets.images.bag.image(),
                  'Looks like an error occurred. Kindly try again!'),
              noItemsFoundIndicatorBuilder: (context) => emptyState(
                  AppAssets.images.bag.image(),
                  'You haven’t received any orders from this buyer. '
                      'Once they make a purchase, their orders will '
                      'appear here.'),
            ),
          ),
        ),
      ],
    );
  }


  Future<void> showSortModal({
    required BuildContext context,
    required String selected,
    required void Function(String value) onChanged,
  }) {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: ['Recent', 'Oldest', 'Earliest'].map((value) {
              return InkWell(
                onTap: () {
                  onChanged(value);
                  Navigator.pop(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      value[0].toUpperCase() + value.substring(1),
                      style: TextStyles.titleHeading,
                    ),
                    RadioTheme(
                      data: RadioThemeData(
                        fillColor: WidgetStateProperty.resolveWith<Color>((states) {
                          if (states.contains(WidgetState.selected)) {
                            return Colors.orange;
                          }
                          return Colors.white;
                        }),
                        overlayColor: MaterialStateProperty.all(Colors.transparent),
                        visualDensity: VisualDensity.compact,
                      ),
                      child: Radio<String>(
                        value: value,
                        groupValue: selected,
                        activeColor: AppColors.white,
                        onChanged: (_) {
                          onChanged(value);
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
