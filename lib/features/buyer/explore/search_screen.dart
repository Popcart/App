import 'package:flutter/material.dart';
import 'package:popcart/app/service_locator.dart';
import 'package:popcart/core/colors.dart';
import 'package:popcart/core/repository/products_repo.dart';
import 'package:popcart/core/widgets/buttons.dart';
import 'package:popcart/features/components/network_image.dart';
import 'package:popcart/features/live/models/products.dart';
import 'package:popcart/features/common/models/user_model.dart';
import 'package:popcart/gen/assets.gen.dart';
import 'package:popcart/route/route_constants.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  FocusNode focusNode = FocusNode();
  List<Product> products = [];
  List<UserModel> stores = [];
  bool isSearching = false;

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 500), () {
      focusNode.requestFocus();
    });
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          focusNode: focusNode,
          controller: searchController,
          onSubmitted: (value) async {
            if (value.isNotEmpty) {
              setState(() {
                products.clear();
                stores.clear();
                isSearching = true;
              });
              final result = await locator<ProductsRepo>()
                  .searchProduct(
                  page: 1, limit: 20, productName: value);
              result.maybeWhen(
                success: (data) {
                  products.addAll(data?.data?.products ?? []);
                  stores.addAll(data?.data?.sellers ?? []);
                  if (mounted) {
                    setState(() {
                      isSearching = false;
                    });
                  }
                },
                orElse: () {
                  setState(() {
                    isSearching = false;
                  });
                },
              );
            }
          },
          decoration: InputDecoration(
            hintText: 'Search popcart',
            hintStyle: const TextStyle(
                color: Color(0xffD7D8D9), fontSize: 16),
            prefixIcon: Padding(
              padding: const EdgeInsets.all(12),
              child: AppAssets.icons.search.svg(),
            ),
            fillColor: const Color(0xff24262B),
            filled: true,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        centerTitle: false,
        leading: const AppBackButton(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (products.isEmpty && stores.isEmpty && !isSearching)
                SizedBox(
                  height: MediaQuery.of(context).size.height -
                      kToolbarHeight -
                      MediaQuery.of(context).padding.top,
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Looking for something?',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'Try searching for products or sellers',
                          style: TextStyle(
                            color: AppColors.grey,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (isSearching)
                SizedBox(
                  height: MediaQuery.of(context).size.height -
                      kToolbarHeight -
                      MediaQuery.of(context).padding.top,
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 50),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              if (products.isNotEmpty) ...[
                const Text(
                  'Products',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return ListTile(
                      leading: SizedBox(
                        width: 42,
                        height: 42,
                        child: NetworkImageWithLoader(
                          product.images[0],
                          radius: 12,
                        ),
                      ),
                      title: Text(product.name),
                      trailing: const Icon(
                        Icons.keyboard_arrow_right_rounded,
                        color: AppColors.white,
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, productScreen,
                            arguments: product.id);
                      },
                    );
                  },
                ),
              ],
              const SizedBox(height: 20),
              if (stores.isNotEmpty) ...[
                const Text(
                  'Stores',
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                ListView.builder(
                  itemCount: stores.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final store = stores[index];
                    return ListTile(
                      leading: SizedBox(
                        width: 42,
                        height: 42,
                        child: NetworkImageWithLoader(
                          store.username,
                          radius: 100,
                        ),
                      ),
                      title: Text(
                        store.businessProfile.businessName,
                        textAlign: TextAlign.start,
                      ),
                      trailing: const Icon(
                        Icons.keyboard_arrow_right_rounded,
                        color: AppColors.white,
                      ),
                      onTap: () {},
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
