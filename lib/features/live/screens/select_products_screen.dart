import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:popcart/app/service_locator.dart';
import 'package:popcart/core/repository/sellers_repo.dart';
import 'package:popcart/core/widgets/buttons.dart';
import 'package:popcart/features/live/models/products.dart';
import 'package:popcart/features/onboarding/screens/app_back_button.dart';
import 'package:popcart/features/user/cubits/cubit/profile_cubit.dart';

class SelectProductsScreen extends StatefulHookWidget {
  const SelectProductsScreen({super.key});

  @override
  State<SelectProductsScreen> createState() => _SelectProductsScreenState();
}

class _SelectProductsScreenState extends State<SelectProductsScreen> {
  late final PagingController<int, Product> _pagingController;

  @override
  void initState() {
    super.initState();
    _pagingController = PagingController<int, Product>(firstPageKey: 1)
      ..addPageRequestListener(fetchProducts);
  }

  Future<void> fetchProducts(int pageKey) async {
    final sellersRepo = locator<SellersRepo>();
    final userId = context.read<ProfileCubit>().state.maybeWhen(
          orElse: () => '',
          loaded: (user) => user.id,
        );
    final newItems = await sellersRepo.getProducts(
      userId: userId,
      page: pageKey,
      limit: 10,
    );
    newItems.when(
      success: (data) {
        final isLastPage = data?.data?.page == data?.data?.totalPages;
        if (isLastPage) {
          _pagingController.appendLastPage(data?.data?.results ?? <Product>[]);
        } else {
          final nextPageKey = pageKey + 1;
          _pagingController.appendPage(
            data?.data?.results ?? <Product>[],
            nextPageKey,
          );
        }
      },
      error: (error) {
        _pagingController.error = error;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final productIds = useState<List<String>>([]);
    return Scaffold(
      bottomNavigationBar: productIds.value.isEmpty
          ? null
          : BottomAppBar(
              child: CustomElevatedButton(
                text: 'Select ${productIds.value.length} Products'
                    .replaceAll('1 Products', '1 Product'), onPressed: () {
                context.pop(productIds.value);
              },
              ),
            ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppBackButton(),
              const SizedBox(height: 32),
              Expanded(
                child: PagedGridView(
                  pagingController: _pagingController,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  builderDelegate: PagedChildBuilderDelegate<Product>(
                    noItemsFoundIndicatorBuilder: (context) => const Center(
                      child: Text(
                        'No items found',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                    itemBuilder: (context, item, index) {
                      return GestureDetector(
                        onTap: () {
                          if (productIds.value.contains(item.id)) {
                            productIds.value = productIds.value
                                .where((element) => element != item.id)
                                .toList();
                          } else {
                            productIds.value = [...productIds.value, item.id];
                          }
                        },
                        child: Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: ExtendedImage.network(
                                    item.images.first,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: 140,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  item.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: CircleAvatar(
                                backgroundColor:
                                    productIds.value.contains(item.id)
                                        ? Colors.green
                                        : Colors.white,
                                child: Icon(
                                  productIds.value.contains(item.id)
                                      ? Icons.check
                                      : Icons.add,
                                  color: productIds.value.contains(item.id)
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
