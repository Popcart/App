import 'dart:math';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:popcart/app/service_locator.dart';
import 'package:popcart/core/colors.dart';
import 'package:popcart/core/repository/products_repo.dart';
import 'package:popcart/core/repository/sellers_repo.dart';
import 'package:popcart/core/utils.dart';
import 'package:popcart/core/widgets/buttons.dart';
import 'package:popcart/features/components/network_image.dart';
import 'package:popcart/features/live/models/products.dart';
import 'package:popcart/gen/assets.gen.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProductScreen extends HookWidget {
  const ProductScreen({super.key, required this.productId});

  final String productId;

  @override
  Widget build(BuildContext context) {
    final product = useState<Product>(Product.empty());
    final fetchProduct = useCallback(() async {
      final response =
          await locator<ProductsRepo>().getProductDetails(productId: productId);
      response.when(
        success: (data) {
          product.value = data?.data ?? Product.empty();
        },
        error: (error) {},
      );
    });
    useEffect(
      () {
        fetchProduct();
        return null;
      },
      [],
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const AppBackButton(),
        title: const Text(
          'Product',
          style: TextStyle(color: AppColors.white, fontSize: 20),
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Skeletonizer(
            enabled: product.value == Product.empty(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                    height: 270,
                    child: product.value.images.isNotEmpty ? NetworkImageWithLoader(
                      product.value.images.first,
                    ) : const Center(child: CupertinoActivityIndicator())),
                const SizedBox(height: 8),
                Text(
                  product.value.brand,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  product.value.name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  product.value.price.toCurrency(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                CustomElevatedButton(
                  text: 'Buy now',
                  showIcon: false,
                  onPressed: () async {},
                ),
                const SizedBox(height: 20),
                const Text(
                  'Details',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: AppColors.boxGrey,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(children: [
                    GestureDetector(
                      onTap: () {},
                      child: Row(
                        children: [
                          SizedBox(
                              width: 20,
                              height: 20,
                              child: AppAssets.icons.infoWhite.svg()),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text(
                            'Description',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                                color: AppColors.white),
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.chevron_right,
                            color: AppColors.white,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {},
                      child: Row(
                        children: [
                          SizedBox(
                              width: 20,
                              height: 20,
                              child: AppAssets.icons.condition.svg()),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text(
                            'Condition',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: AppColors.white),
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.chevron_right,
                            color: AppColors.white,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {},
                      child: Row(
                        children: [
                          SizedBox(
                              width: 20,
                              height: 20,
                              child: AppAssets.icons.policy.svg()),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text(
                            'Return Policy',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: AppColors.white),
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.chevron_right,
                            color: AppColors.white,
                          ),
                        ],
                      ),
                    ),
                  ]),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Seller',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: AppColors.boxGrey,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(children: [
                    ListTile(
                      leading: ClipOval(
                          child: Image.network(
                        'https://thrustapi.pythonanywhere.com/media/product_images/1000035278.jpg',
                        width: 32,
                        height: 32,
                        fit: BoxFit.cover,
                      )),
                      visualDensity: const VisualDensity(vertical: -4),
                      title: Text(product.value.seller.username),
                      subtitle: Row(
                        children: [
                          AppAssets.icons.star.svg(),
                          const SizedBox(
                            width: 5,
                          ),
                          RichText(
                            text: const TextSpan(
                              text: '4.9',
                              style: TextStyle(color: AppColors.white),
                              children: [
                                TextSpan(
                                  text: ' • ',
                                  style: TextStyle(
                                    color: AppColors.white,
                                  ),
                                ),
                                TextSpan(
                                  text: '122 ',
                                  style: TextStyle(
                                    color: AppColors.white,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Reviews',
                                  style: TextStyle(
                                    color: AppColors.textGrey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        // handle orders tap
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: CustomElevatedButton(
                                showIcon: false,
                                usePrimaryColor: false,
                                onPressed: () {},
                                text: 'Message')),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: CustomElevatedButton(
                                showIcon: false,
                                onPressed: () {},
                                text: 'View store')),
                      ],
                    )
                  ]),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
