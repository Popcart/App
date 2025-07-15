import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:popcart/app/service_locator.dart';
import 'package:popcart/core/colors.dart';
import 'package:popcart/core/repository/order_repo.dart';
import 'package:popcart/core/widgets/widgets.dart';
import 'package:popcart/features/common/models/order_model.dart';
import 'package:popcart/features/common/widget/order_item.dart';
import 'package:popcart/gen/assets.gen.dart';
import 'package:popcart/utils/text_styles.dart';

class BuyersOrdersTabView extends StatefulWidget {
  const BuyersOrdersTabView({required this.type, super.key});

  final String type;

  @override
  State<BuyersOrdersTabView> createState() => _BuyersOrdersTabViewState();
}

class _BuyersOrdersTabViewState extends State<BuyersOrdersTabView> {
  final PagingController<int, TransactionList> _pagingController =
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
    final items = await locator<OrderRepo>().getBuyerOrders(
      page: pageKey,
      limit: 10, status: widget.type.toLowerCase(),
    );
    items.when(
      success: (data) {
        // final isLastPage = data?.data?.page == data?.data?.totalPages;
        final results = data?.data ?? <TransactionList>[];
        // if (isLastPage) {
        //   _pagingController.appendLastPage(results);
        // } else {
          _pagingController.appendPage(results, pageKey + 1);
        // }
      },
      error: (err) => _pagingController.error = err,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PagedListView<int, TransactionList>(
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate<TransactionList>(
              itemBuilder: (context, order, index) {
                return OrderItem(
                  transactionList: order,
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
