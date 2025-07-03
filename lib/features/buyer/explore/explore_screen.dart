import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:popcart/app/service_locator.dart';
import 'package:popcart/app/shared_prefs.dart';
import 'package:popcart/core/colors.dart';
import 'package:popcart/core/repository/products_repo.dart';
import 'package:popcart/core/repository/sellers_repo.dart';
import 'package:popcart/core/utils.dart';
import 'package:popcart/features/buyer/explore/watch_screen.dart';
import 'package:popcart/features/buyer/explore/widget/interest_filter.dart';
import 'package:popcart/features/buyer/explore/widget/live_pop_up.dart';
import 'package:popcart/features/buyer/explore/widget/product_search.dart';
import 'package:popcart/features/buyer/live/buyer_livestream_screen.dart';
import 'package:popcart/features/components/network_image.dart';
import 'package:popcart/features/live/cubits/active_livestream/active_livestreams_cubit.dart';
import 'package:popcart/features/live/cubits/open_livestream/open_livestream_cubit.dart';
import 'package:popcart/features/live/models/products.dart';
import 'package:popcart/features/onboarding/cubits/interest_list/interest_list_cubit.dart';
import 'package:popcart/features/onboarding/models/onboarding_models.dart';
import 'package:popcart/features/user/models/user_model.dart';
import 'package:popcart/gen/assets.gen.dart';
import 'package:popcart/route/route_constants.dart';

class ExploreScreen extends StatefulHookWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  List<Product> topProducts = [];
  List<Product> inventoryProducts = [];
  List<UserModel> sellers = [];
  final ValueNotifier<int> selectedTab = ValueNotifier<int>(1);
  final ValueNotifier<List<ProductCategory>> selectedInterests =
      ValueNotifier([]);

  @override
  void initState() {
    super.initState();
    context.read<ActiveLivestreamsCubit>().getActiveLivestreams();
    context.read<ScheduledLivestreamsCubit>().getScheduledLivestreams();
    fetchTopProducts();
  }

  Future<void> fetchTopProducts() async {
    try {
      final results = await Future.wait([
        locator<ProductsRepo>().getProducts(page: 1, limit: 20),
        locator<ProductsRepo>().getProducts(page: 1, limit: 20),
        locator<SellersRepo>().getSellers(page: 1, limit: 20),
      ]);

      final topProductsResponse = results[0];
      final inventoryProductsResponse = results[1];
      final sellersResponse = results[2];
      // Handle top products response
      topProductsResponse.maybeWhen(
        success: (data) {
          final productResult = data?.data?.results ?? <Product>[];
          topProducts.addAll(productResult as List<Product>);
        },
        orElse: () {
          // Handle other cases if necessary
        },
      );

      // Handle inventory products response
      inventoryProductsResponse.maybeWhen(
        success: (data) {
          final results = data?.data?.results ?? <Product>[];
          inventoryProducts.addAll(results as List<Product>);
        },
        orElse: () {
          // Handle other cases if necessary
        },
      );

      // Handle inventory products response
      sellersResponse.maybeWhen(
        success: (data) {
          final results = data?.data?.results ?? <UserModel>[];
          sellers.addAll(results as List<UserModel>);
        },
        orElse: () {
          // Handle other cases if necessary
        },
      );
      if (mounted) setState(() {});
    } catch (e, stackTrace) {
      print(stackTrace);
    }
  }

  Future<void> _openImagePicker(BuildContext context) async {
    final picker = ImagePicker();

    await showModalBottomSheet<void>(
      context: context,
      builder: (_) => Container(
        height: MediaQuery.of(context).size.height * 0.2,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: AppAssets.icons.homeCamera.svg(),
              title: const Text('Take Photo'),
              onTap: () async {
                Navigator.pop(context);
                final image =
                    await picker.pickImage(source: ImageSource.camera);
                if (image != null) {
                  await _useImage(XFile(image.path));
                }
              },
            ),
            ListTile(
              leading: AppAssets.icons.addIcon.svg(),
              title: const Text('Choose from Gallery'),
              onTap: () async {
                Navigator.pop(context);
                final image =
                    await picker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  await _useImage(XFile(image.path));
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _useImage(XFile image) async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (_) => Container(
        height: MediaQuery.of(context).size.height * 0.5,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: ProductSearch(
          file: image,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeLivestreamsCubit = context.watch<ActiveLivestreamsCubit>();
    final scheduledLiveStreams = context.watch<ScheduledLivestreamsCubit>();
    final interestListCubit = context.watch<InterestCubit>();
    return ValueListenableBuilder<int>(
        valueListenable: selectedTab,
        builder: (context, value, _) {
          return CupertinoPageScaffold(
              backgroundColor: Colors.transparent,
              navigationBar: CupertinoNavigationBar(
                  enableBackgroundFilterBlur: value == 1,
                  backgroundColor: Colors.transparent,
                  border: null,
                  leading: ValueListenableBuilder<int>(
                    valueListenable: selectedTab,
                    builder: (context, value, _) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                        ),
                        child: CustomSlidingSegmentedControl<int>(
                          initialValue: value,
                          innerPadding: const EdgeInsets.all(4),
                          children: {
                            1: Text(
                              'Explore',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: value == 1
                                    ? AppColors.black
                                    : AppColors.tabSelectedContainerColor,
                              ),
                            ),
                            2: Text(
                              'Watch',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: value == 2
                                    ? AppColors.black
                                    : AppColors.tabSelectedContainerColor,
                              ),
                            ),
                          },
                          decoration: BoxDecoration(
                            color: AppColors.tabContainerColor,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          thumbDecoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInToLinear,
                          onValueChanged: (v) async {
                            await Future<void>.delayed(
                                const Duration(milliseconds: 300));
                            selectedTab.value = v;
                          },
                        ),
                      );
                    },
                  ),
                  trailing: ConstrainedBox(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (value == 1)
                          GestureDetector(
                              onTap: () {
                                _openImagePicker(context);
                              },
                              child: AppAssets.icons.homeCamera.svg()),
                        const SizedBox(
                          width: 10,
                        ),
                        ValueListenableBuilder<List<ProductCategory>>(
                            valueListenable: selectedInterests,
                            builder: (context, selected, _) {
                              return GestureDetector(
                                  onTap: () async {
                                    final selected = await showModalBottomSheet<
                                        List<ProductCategory>>(
                                      context: context,
                                      builder: (_) => Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.5,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(16),
                                            topRight: Radius.circular(16),
                                          ),
                                        ),
                                        child: const InterestFilter(),
                                      ),
                                    );

                                    if (selected != null) {
                                      selectedInterests.value = selected;
                                    }
                                  },
                                  child: selected.isEmpty
                                      ? AppAssets.icons.homeMenu.svg()
                                      : AppAssets.icons.filterSelected.svg());
                            }),
                        const SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                            onTap: () {
                              selectedTab.value = 1;
                              Navigator.pushNamed(context, searchScreen);
                            },
                            child: AppAssets.icons.homeSearch.svg()),
                      ],
                    ),
                  )),
              child: value == 1
                  ? RefreshIndicator.adaptive(
                      displacement: 120,
                      onRefresh: () async {
                        await context
                            .read<ActiveLivestreamsCubit>()
                            .getActiveLivestreams();
                        await context
                            .read<ScheduledLivestreamsCubit>()
                            .getScheduledLivestreams();
                        await fetchTopProducts();
                      },
                      child: SafeArea(
                        top: false,
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 100,
                                ),
                                ValueListenableBuilder<List<ProductCategory>>(
                                  valueListenable: selectedInterests,
                                  builder: (context, selected, _) {
                                    return Visibility(
                                      visible: selected.isNotEmpty,
                                      child: SizedBox(
                                        height: 40,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          physics:
                                              const ClampingScrollPhysics(),
                                          itemCount:
                                              interestListCubit.state.maybeWhen(
                                            orElse: () => 0,
                                            loaded: (interests) =>
                                                interests.length,
                                          ),
                                          itemBuilder: (context, index) {
                                            final interest = interestListCubit
                                                .state
                                                .maybeWhen(
                                              orElse: ProductCategory.init,
                                              loaded: (interests) =>
                                                  interests[index],
                                            );

                                            final isSelected =
                                                selected.contains(interest);

                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 8),
                                              child: Chip(
                                                label: Text(
                                                  interest.name,
                                                  style: TextStyle(
                                                    color: isSelected
                                                        ? Colors.white
                                                        : const Color(
                                                            0xff676C75),
                                                    fontWeight: isSelected
                                                        ? FontWeight.w500
                                                        : FontWeight.normal,
                                                  ),
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(80),
                                                ),
                                                backgroundColor: isSelected
                                                    ? const Color(0xff676C75)
                                                    : const Color(0xff111214),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
                                  width: double.infinity,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xff24262B),
                                      borderRadius: BorderRadius.circular(8),
                                      image: DecorationImage(
                                        image: AssetImage(
                                          AppAssets.images.girl.path,
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    child: Stack(children: [
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        left: 0,
                                        child: Container(
                                          height: 200,
                                          decoration: const BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  Colors.transparent,
                                                  Colors.black,
                                                ],
                                                stops: [0.0, 1.0],
                                              ),
                                              borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(8),
                                                bottomRight: Radius.circular(8),
                                              )),
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.all(24),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Spacer(),
                                            Text(
                                              'JOGGERS',
                                              style: TextStyle(
                                                fontSize: 28,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              '''Discover trending vintage styles from iconic brands like Levi's, Carhartt, Diesel & more.''',
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ]),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                if (activeLivestreamsCubit.state.maybeWhen(
                                        orElse: () => 0,
                                        success: (liveStreams) =>
                                            liveStreams.length) >
                                    0) ...{
                                  const Text(
                                    'Live now',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                  SizedBox(
                                    height: 300,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      itemCount: activeLivestreamsCubit.state
                                          .maybeWhen(
                                        orElse: () => 4,
                                        success: (liveStreams) =>
                                            liveStreams.length,
                                      ),
                                      itemBuilder: (context, index) {
                                        return LiveStreamExplore(
                                            liveStream: activeLivestreamsCubit
                                                .state
                                                .maybeWhen(
                                          orElse: LiveStream.empty,
                                          success: (liveStreams) =>
                                              liveStreams[index],
                                        ));
                                      },
                                    ),
                                  ),
                                },
                                const SizedBox(height: 24),
                                const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Stores',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      'See all',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 14),
                                SizedBox(
                                  height: 120,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemCount: sellers.length,
                                    itemBuilder: (context, index) {
                                      return StoresCard(
                                        userModel: sellers[index],
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(height: 24),
                                if (scheduledLiveStreams.state.maybeWhen(
                                        orElse: () => 0,
                                        success: (liveStreams) =>
                                            liveStreams.length) >
                                    0) ...{
                                  const Text(
                                    'Upcoming Live',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                  SizedBox(
                                    height: 300,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      itemCount:
                                          scheduledLiveStreams.state.maybeWhen(
                                        orElse: () => 4,
                                        success: (liveStreams) =>
                                            liveStreams.length,
                                      ),
                                      itemBuilder: (context, index) {
                                        return LiveStreamExplore(
                                            liveStream: scheduledLiveStreams
                                                .state
                                                .maybeWhen(
                                          orElse: LiveStream.empty,
                                          success: (liveStreams) =>
                                              liveStreams[index],
                                        ));
                                      },
                                    ),
                                  ),
                                },
                                const SizedBox(height: 24),
                                const Text(
                                  'Top Products',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 14),
                                SizedBox(
                                  height: 100,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemCount: topProducts.length,
                                    itemBuilder: (context, index) {
                                      final item = topProducts[index];
                                      return TopProducts(product: item);
                                    },
                                  ),
                                ),
                                const SizedBox(height: 24),
                                const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Products handpicked for you',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      'See all',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 14),
                                SizedBox(
                                  height: 250,
                                  child: GridView.builder(
                                    scrollDirection: Axis.horizontal,
                                    physics: const BouncingScrollPhysics(),
                                    gridDelegate:
                                        const SliverGridDelegateWithMaxCrossAxisExtent(
                                      maxCrossAxisExtent: 200,
                                      mainAxisSpacing: 16,
                                      crossAxisSpacing: 16,
                                      childAspectRatio: 1,
                                    ),
                                    itemCount: inventoryProducts.length,
                                    itemBuilder: (_, index) =>
                                        HandPickedProduct(
                                      product: inventoryProducts[index],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  : const WatchScreen());
        });
  }
}

class LiveStreamExplore extends StatelessWidget {
  const LiveStreamExplore({required this.liveStream, super.key});

  final LiveStream liveStream;

  @override
  Widget build(BuildContext context) {
    final openLivestreamCubit = context.read<OpenLivestreamCubit>();
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        try {
          final token = await openLivestreamCubit.generateAgoraToken(
            channelName: liveStream.id,
            agoraRole: 2,
            uid: 0,
          );

          if (token == null) {
            if (context.mounted) {
              await context.showError('Failed to generate token');
            }
            return;
          }

          if (!context.mounted) return;

          await Navigator.push<BuyerLivestreamScreen>(
            context,
            MaterialPageRoute<BuyerLivestreamScreen>(
              builder: (_) => BuyerLivestreamScreen(
                liveStream: liveStream,
                token: token,
              ),
            ),
          );
        } catch (e) {
          await context.showError('Cannot join live at the moment');
        }
      },
      child: Container(
          width: 270,
          height: 300,
          margin: const EdgeInsets.only(right: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: liveStream.thumbnail != null
                ? DecorationImage(
                    image: NetworkImage(liveStream.thumbnail!),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: Stack(
            children: [
              if (liveStream.thumbnail == null)
                userThumbnail(liveStream.user.username)
              else
                const SizedBox.shrink(),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black54,
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black87,
                    ],
                    stops: [0.0, 0.3, 0.7, 1.0],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xff4B4444).withOpacity(0.5),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.remove_red_eye_outlined,
                            color: Colors.white,
                            size: 12,
                          ),
                          SizedBox(width: 4),
                          Text(
                            '100',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xffcc0000),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: const Text(
                        'Live',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(),
                    Row(
                      children: [
                        const CircleAvatar(radius: 12),
                        const SizedBox(width: 12),
                        Text(
                          liveStream.user.username,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      liveStream.title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}

class StoresCard extends StatefulWidget {
  final UserModel userModel;

  const StoresCard({super.key, required this.userModel});

  @override
  State<StoresCard> createState() => _StoresCardState();
}

class _StoresCardState extends State<StoresCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.boxGrey,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          const NetworkImageWithLoader(''),
          const SizedBox(height: 8),
          Text(
            widget.userModel.businessProfile.businessName,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.orange,
              borderRadius: BorderRadius.circular(100),
            ),
            child: const Text(
              'Follow',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class HandPickedProduct extends StatefulWidget {
  const HandPickedProduct({super.key, required this.product});

  final Product product;

  @override
  State<HandPickedProduct> createState() => _HandPickedProductState();
}

class _HandPickedProductState extends State<HandPickedProduct> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          productScreen,
          arguments: widget.product.id,
        );
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        width: 100,
        height: 100,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        decoration: BoxDecoration(
          color: AppColors.boxGrey,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipOval(
              child: widget.product.images.isNotEmpty
                  ? Image.network(
                      widget.product.images[0],
                      width: 55,
                      height: 55,
                      fit: BoxFit.cover,
                    )
                  : const Icon(Icons.image_not_supported),
            ),
            const SizedBox(height: 8),
            Flexible(
              child: Text(
                widget.product.name,
                overflow: TextOverflow.clip,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TopProducts extends StatefulWidget {
  const TopProducts({super.key, required this.product});

  final Product product;

  @override
  State<TopProducts> createState() => _TopProductsState();
}

class _TopProductsState extends State<TopProducts> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: 100,
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            productScreen,
            arguments: widget.product.id,
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.product.images.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.network(widget.product.images[0],
                    width: 80, height: 55, fit: BoxFit.cover),
              ),
            const SizedBox(height: 8),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Text(
                  widget.product.name,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
