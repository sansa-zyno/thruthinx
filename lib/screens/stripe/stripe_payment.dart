import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:truthinx/utils/ApiKeys.dart';
import 'package:webview_flutter/webview_flutter.dart';
// Import for Android features.
import 'package:webview_flutter_android/webview_flutter_android.dart';

import 'dart:async';

class StripePaymentCheckout extends StatefulWidget {
  final String sessionId;

  StripePaymentCheckout({required this.sessionId});
  @override
  _StripePaymentCheckoutState createState() => _StripePaymentCheckoutState();
}

class _StripePaymentCheckoutState extends State<StripePaymentCheckout> {
  late WebViewController _webViewController;

  String get initialUrl =>
      "data:text/html;base64,${base64Encode(Utf8Encoder().convert(kStripeHTMLPage))}";

  static const String kStripeHTMLPage = '''
  <!DOCTYPE html>
  <html>
  <script src="https://js.stripe.com/v3/"></script>

  <head>
      <title>Stripe Checkout</title>
  </head>

  <body>
      <div style="position: absolute; text-align: center; width:100%; height:100%; top:50%;">
          <p>Loding payment gateway...!</p>
      </div>
  </body>

  </html>
  ''';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    final WebViewController controller = WebViewController();
    // #enddocregion platform_features
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint('WebView is loading (progress : $progress%)');
          },
          onPageStarted: (String url) {
            debugPrint('Page started loading: $url');
          },
          onPageFinished: (String url) {
            debugPrint('Page finished loading: $url');
            if (url == initialUrl) {
              _redirectToStripe(widget.sessionId);
            }
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('''
              Page resource error:
              code: ${error.errorCode}
              description: ${error.description}
              errorType: ${error.errorType}
              isForMainFrame: ${error.isForMainFrame}
          ''');
          },
          onNavigationRequest: (NavigationRequest request) {
            /*if (request.url.startsWith('https://www.youtube.com/')) {
              debugPrint('blocking navigation to ${request.url}');
              return NavigationDecision.prevent;
            }
            debugPrint('allowing navigation to ${request.url}');
            return NavigationDecision.navigate;*/
            if (request.url.startsWith('https://success.com')) {
              print("success");
              Navigator.of(context).pop("success");
              // Navigator.of(context).pop("success");
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => DetailsScreen(widget.doc),
              //   ),
              // );
            } else if (request.url.startsWith('https://cancel.com')) {
              print("Canceled");
              Navigator.of(context).pop('cancel');
            }
            return NavigationDecision.navigate;
          },
          onUrlChange: (UrlChange change) {
            debugPrint('url change to ${change.url}');
          },
        ),
      )
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        },
      )
      ..loadRequest(Uri.parse(initialUrl));

    // #docregion platform_features
    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }
    // #enddocregion platform_features

    _webViewController = controller;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: WebViewWidget(
          controller: _webViewController,
        ),
      ),
    );
  }

  Future<void> _redirectToStripe(String sessionId) async {
    final redirectToCheckoutJs = '''
    var stripe = Stripe(\'$stripeApiKey\');
    
    stripe.redirectToCheckout({
      sessionId: '$sessionId'
    }).then(function (result) {
        result.error.message = 'Error'
    });
    ''';

    return await _webViewController.runJavaScript(redirectToCheckoutJs);
  }
}
