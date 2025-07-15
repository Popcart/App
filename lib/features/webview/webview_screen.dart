import 'package:flutter/material.dart';
import 'package:popcart/gen/assets.gen.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({
    super.key,
    required this.txnRef,
    required this.amount,
    required this.paymentLink,
  });

  final String txnRef;
  final String paymentLink;
  final dynamic amount;

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late WebViewController _controller;

  late final PlatformWebViewControllerCreationParams params;

  @override
  void initState() {
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
    // final htmlForm = '''
    // <html>
    //   <body onload="document.forms[0].submit()">
    //     <form method="post" action="https://newwebpay.interswitchng.com/collections/w/pay">
    //       <input name="merchant_code" value="MX119938" />
    //       <input name="pay_item_id" value="3588562" />
    //       <input name="site_redirect_url" value="https://newwebpay.interswitchng.com/collections/w/pay" />
    //       <input name="txn_ref" value="${widget.txnRef}" />
    //       <input name="amount" value="${widget.amount}" />
    //       <input name="currency" value="Naira" />
    //       <input type="submit" value="Pay Now" />
    //     </form>
    //   </body>
    // </html>
    // ''';

    // final controller = WebViewController()
    //   ..loadHtmlString(htmlForm)
    //   ..setNavigationDelegate(
    //     NavigationDelegate(
    //       onProgress: (int progress) {},
    //       onPageStarted: (String url) async {},
    //       onPageFinished: (String url) {},
    //       onHttpError: (HttpResponseError error) {},
    //       onWebResourceError: (WebResourceError error) {},
    //       onNavigationRequest: (NavigationRequest request) {
    //         print(request.url);
    //         return NavigationDecision.navigate;
    //       },
    //     ),
    //   )
    //   ..setJavaScriptMode(JavaScriptMode.unrestricted);

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
