import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:popcart/app/service_locator.dart';
import 'package:popcart/core/colors.dart';
import 'package:popcart/core/repository/inventory_repo.dart';
import 'package:popcart/core/widgets/buttons.dart';
import 'package:popcart/core/widgets/widgets.dart';
import 'package:popcart/features/live/models/products.dart';
import 'package:popcart/features/seller/live/set_minimum_price.dart';
import 'package:popcart/gen/assets.gen.dart';
import 'package:popcart/utils/text_styles.dart';

class ChooseProduct extends StatefulWidget {
  const ChooseProduct(
      {super.key, required this.roomName, required this.thumbnail, this.scheduledDate});

  final String roomName;
  final XFile thumbnail;
  final String? scheduledDate;

  @override
  State<ChooseProduct> createState() => _ChooseProductState();
}

class _ChooseProductState extends State<ChooseProduct> {
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

  List<Product> _products = [];

  Future<void> fetchPage(int pageKey) async {
    final items = await locator<InventoryRepo>().getAllProducts(
      page: pageKey,
      limit: 10,
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
        setState(() {});
      },
      error: (err) => _pagingController.error = err,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: AppColors.white,
              ),
            ),
            const Text('Choose Product', style: TextStyles.titleHeading),
            const SizedBox(),
          ],
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: PagedListView<int, Product>(
              pagingController: _pagingController,
              builderDelegate: PagedChildBuilderDelegate<Product>(
                itemBuilder: (context, product, index) {
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      if (_products.contains(product)) {
                        _products.remove(product);
                      } else {
                        _products.add(product);
                      }
                      setState(() {});
                    },
                    child: ChooseProductItem(
                      product: product,
                      isSelected: _products.contains(product),
                    ),
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
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Visibility(
          visible: (_pagingController.itemList?.isNotEmpty ?? false) &&
              _products.isNotEmpty,
          child: CustomElevatedButton(
              showIcon: false,
              onPressed: () async {
                await showModalBottomSheet<void>(
                    context: context,
                    builder: (context) {
                      return SetMinimumPrice(
                        products: _products,
                        scheduledDate: widget.scheduledDate,
                        roomName: widget.roomName, thumbnail: widget.thumbnail,
                      );
                    });
              },
              text: 'Proceed'),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}

class ChooseProductItem extends StatefulWidget {
  const ChooseProductItem(
      {required this.product, this.isSelected = false, super.key});

  final Product product;
  final bool isSelected;

  @override
  State<ChooseProductItem> createState() => _ChooseProductItemState();
}

class _ChooseProductItemState extends State<ChooseProductItem> {
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
          children: [
            Column(
              children: [
                SizedBox(
                  height: 70,
                  width: 100,
                  child: Stack(children: [
                    PageView.builder(
                      controller: _pageController,
                      itemCount: widget.product.images.length,
                      onPageChanged: (i) => setState(() => _currentPage = i),
                      itemBuilder: (context, index) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            widget.product.images[index],
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
                    Positioned(
                        top: 5,
                        right: 5,
                        child: widget.isSelected
                            ? AppAssets.icons.selected.svg()
                            : AppAssets.icons.unselected.svg())
                  ]),
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
                const Text('Min. Price', style: TextStyles.titleHeading),
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
