import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:popcart/app/service_locator.dart';
import 'package:popcart/core/repository/sellers_repo.dart';
import 'package:popcart/features/live/models/products.dart';
import 'package:popcart/features/onboarding/screens/enter_phone_number_screen.dart';
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppBackButton(),
              const SizedBox(height: 32),
              Expanded(
                child: PagedListView.separated(
                  pagingController: _pagingController,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                  builderDelegate: PagedChildBuilderDelegate<Product>(
                    noItemsFoundIndicatorBuilder: (context) => const Center(
                      child: Text(
                        'No items found',
                        style: TextStyle(fontSize: 24, color: Colors.white),
                      ),
                    ),
                    itemBuilder: (context, item, index) {
                      return ListTile(
                        title: Text(item.name),
                        onTap: () {
                          if (productIds.value.contains(item.id)) {
                            productIds.value.remove(item.id);
                          } else {
                            productIds.value.add(item.id);
                          }
                        },
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
