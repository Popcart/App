import 'package:flutter/material.dart';
import 'package:popcart/gen/assets.gen.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({
    super.key,
    required this.paymentLink,
  });

  final String paymentLink;

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late WebViewController _controller;

  late final PlatformWebViewControllerCreationParams params;

  @override
  void initState() {
    print("Payment link: ${widget.paymentLink}");
    params = const PlatformWebViewControllerCreationParams();
    _controller = WebViewController.fromPlatformCreationParams(
      params,
      onPermissionRequest: (WebViewPermissionRequest request) {
        request.grant();
      },
    )
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) async {},
          onPageFinished: (String url) {},
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            print(request.url);
            if (request.url.contains('payment-successful')) {
              Future.delayed(const Duration(seconds: 2), () {
                if(mounted) {
                  Navigator.pop(context, true);
                }
              });
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentLink));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: AppAssets.images.appLogo.image(),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              Navigator.pop(context, false);
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
