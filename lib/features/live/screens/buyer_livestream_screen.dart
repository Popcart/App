import 'dart:developer';
import 'dart:math' hide log;

// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:keyboard_attachable/keyboard_attachable.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:popcart/app/service_locator.dart';
import 'package:popcart/core/repository/sellers_repo.dart';
import 'package:popcart/core/utils.dart';
import 'package:popcart/env/env.dart';
import 'package:popcart/features/live/cubits/active_livestream/active_livestreams_cubit.dart';
import 'package:popcart/features/live/models/products.dart';
import 'package:popcart/features/onboarding/screens/enter_phone_number_screen.dart';
import 'package:popcart/gen/assets.gen.dart';
import 'package:skeletonizer/skeletonizer.dart';

class BuyerLivestreamScreen extends StatefulWidget {
  const BuyerLivestreamScreen({
    required this.liveStream,
    required this.token,
    super.key,
  });

  final LiveStream liveStream;
  final String token;
  @override
  State<BuyerLivestreamScreen> createState() => _BuyerLivestreamScreenState();
}

class _BuyerLivestreamScreenState extends State<BuyerLivestreamScreen> {
  // late RtcEngine _engine;
  bool _localUserJoined = false;
  int userJoined = 0;

  @override
  void initState() {
    super.initState();
    // initAgora();
  }

  @override
  void dispose() {
    // _engine
    //   ..leaveChannel()
    //   ..release();
    super.dispose();
  }

  @override
  void deactivate() {
    context.read<ActiveLivestreamsCubit>().getActiveLivestreams();
    super.deactivate();
  }

  void closeLivestream() {
    showCupertinoDialog<void>(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: const Text('Livestream Ended'),
        content: const Text('The seller has ended the livestream'),
        actions: [
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () {
              context.pop(true);
            },
          ),
        ],
      ),
    ).then((_) {
      if (mounted) {
        context.pop();
      }
    });
  }

  // Future<void> initAgora() async {
  //   try {
  //     await [Permission.camera, Permission.microphone].request();
  //     // Create RTC Engine
  //     _engine = createAgoraRtcEngine();
  //     await _engine.initialize(
  //       RtcEngineContext(
  //         appId: Env().agoraAppId,
  //         channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
  //       ),
  //     );
  //     // Set up event handlers
  //     _engine.registerEventHandler(
  //       RtcEngineEventHandler(
  //         onUserOffline: (connection, remoteUid, reason) {
  //           log(
  //             connection.toJson().toString(),
  //             name: 'AGORA onUserOffline connection',
  //           );
  //           log(remoteUid.toString(), name: 'AGORA onUserOffline remoteUid');
  //           log(reason.toString(), name: 'AGORA onUserOffline reason');
  //           if (remoteUid.toString() == widget.liveStream.agoraId) {
  //             closeLivestream();
  //           }
  //         },
  //         onJoinChannelSuccess: (connection, elapsed) {
  //           log(
  //             connection.toJson().toString(),
  //             name: 'AGORA onJoinChannelSuccess connection',
  //           );
  //           log(elapsed.toString(), name: 'AGORA onJoinChannelSuccess elapsed');
  //           setState(() {
  //             _localUserJoined = true;
  //           });
  //         },
  //         onError: (err, msg) async {
  //           log(err.toString(), name: 'AGORA onError err');
  //           log(msg, name: 'AGORA onError msg');
  //           await context.showError(msg);
  //           if (mounted) {
  //             context.pop();
  //           }
  //         },
  //       ),
  //     );
  //     await _engine.setClientRole(role: ClientRoleType.clientRoleAudience);
  //     await _engine.joinChannel(
  //       token: widget.token,
  //       channelId: widget.liveStream.id,
  //       uid: 1,
  //       options: const ChannelMediaOptions(
  //         publishMicrophoneTrack: false,
  //         publishCameraTrack: false,
  //         autoSubscribeAudio: true,
  //         autoSubscribeVideo: true,
  //         clientRoleType: ClientRoleType.clientRoleAudience,
  //       ),
  //     );
  //     // await _engine.enableAudio();
  //     // await _engine.enableVideo();
  //     await _engine.startPreview();
  //   } catch (e) {
  //     log(e.toString(), name: 'Agora Error');
  //   }
  // }

  Future<void> showProductModal() async {
    final product = await showModalBottomSheet<Product>(
      context: context,
      isScrollControlled: true,
      builder: (_) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: ProductModal(
          sellerId: widget.liveStream.user.id,
          products: widget.liveStream.products,
        ),
      ),
    );

    if (product != null) {
      // print(product);
      // context.go('/product/${product.id}');
    }
  }

  @override
  Widget build(BuildContext context) {
    log(widget.liveStream.products.toString());
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: _renderVideo(),
          ),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AppBackButton(),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 12,
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.liveStream.user.username,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            const Text(
                              '0 followers',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xfff97316),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Follow',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xff4B4444)
                                    .withOpacity(0.5),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.remove_red_eye_outlined,
                                    color: Colors.white,
                                    size: 12,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    userJoined.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
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
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SafeArea(
                maintainBottomViewPadding: true,
                child: FooterLayout(
                  footer: KeyboardAttachable(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Flexible(
                            flex: 5,
                            child: chatBox(),
                          ),
                          const SizedBox(width: 16),
                          Flexible(
                            child: GestureDetector(
                              onTap: showProductModal,
                              behavior: HitTestBehavior.opaque,
                              child: Container(
                                width: 56,
                                height: 56,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(
                                    color: Colors.white,
                                  ),
                                ),
                                child: AppAssets.icons.storefront.svg(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  TextField chatBox() {
    return TextField(
      onTapOutside: (event) => FocusScope.of(context).unfocus(),
      decoration: const InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(100),
          ),
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(100),
          ),
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _renderVideo() {
    // if (widget.isBroadcaster) {
    // return _localUserJoined
    //     ? AgoraVideoView(
    //         controller: VideoViewController(
    //           rtcEngine: _engine,
    //           canvas: VideoCanvas(
    //             renderMode: RenderModeType.renderModeHidden,
    //             uid: int.tryParse(widget.liveStream.agoraId) ?? 0,
    //           ),
    //         ),
    //       )
    //     :
    return const CupertinoActivityIndicator();
  }
}

class ProductModal extends HookWidget {
  const ProductModal({
    required this.products,
    required this.sellerId,
    super.key,
  });

  final List<String> products;
  final String sellerId;

  @override
  Widget build(BuildContext context) {
    final selectedSegment = useState(0);
    final pageController = usePageController();
    return Column(
      children: [
        const Text(
          'Products',
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          // height: 40,
          child: CupertinoSegmentedControl<int>(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: const {
              0: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'In this room',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              1: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Store',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            },
            onValueChanged: (int value) {
              selectedSegment.value = value;
              pageController.animateToPage(
                value,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            groupValue: selectedSegment.value, // Current selected value
            borderColor: const Color(0xFF393C43),
            selectedColor: const Color(0xFF676C75), // Selected segment color
            unselectedColor:
                const Color(0xFF393C43), // Unselected segment color
          ),
        ),

        const SizedBox(height: 16),
        Expanded(
          child: PageView(
            controller: pageController,
            onPageChanged: (int page) {
              selectedSegment.value = page;
            },
            children: [
              GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) => SingleProductWidget(
                  id: products[index],
                ),
              ),
              AllSellerProducts(id: sellerId),
            ],
          ),
        ),
        // Spacer(),
      ],
    );
  }
}

class AllSellerProducts extends StatefulWidget {
  const AllSellerProducts({
    required this.id,
    super.key,
  });

  final String id;

  @override
  State<AllSellerProducts> createState() => _AllSellerProductsState();
}

class _AllSellerProductsState extends State<AllSellerProducts> {
  late final PagingController<int, Product> _pagingController;

  @override
  void initState() {
    super.initState();
    _pagingController = PagingController(firstPageKey: 1);
    _pagingController.addPageRequestListener(fetchPage);
  }

  Future<void> fetchPage(int pageKey) async {
    final items = await locator<SellersRepo>().getProducts(
      userId: widget.id,
      page: pageKey,
      limit: 10,
    );
    items.when(
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
    return PagedGridView(
      pagingController: _pagingController,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      builderDelegate: PagedChildBuilderDelegate<Product>(
        itemBuilder: (context, item, index) => GestureDetector(
          onTap: () {
            context.pop(item);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: ExtendedImage.network(
                  item.images.first,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 120,
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
              // const SizedBox(height: 8),
              Text(
                item.price.toCurrency(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        noItemsFoundIndicatorBuilder: (context) => const Center(
          child: Text(
            'No items found',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}

class SingleProductWidget extends HookWidget {
  const SingleProductWidget({
    required this.id,
    super.key,
  });

  final String id;

  @override
  Widget build(BuildContext context) {
    final product = useState<Product>(Product.empty());
    final fetchProduct = useCallback(() async {
      final response = await locator<SellersRepo>().getProduct(productId: id);
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
    return GestureDetector(
      onTap: () {
        context.pop(product.value);
      },
      child: Skeletonizer(
        enabled: product.value == Product.empty(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: ExtendedImage.network(
                product.value.images.isEmpty
                    ? Random.secure().toString()
                    : product.value.images.first,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 120,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              product.value.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            // const SizedBox(height: 8),
            Text(
              product.value.price.toCurrency(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
