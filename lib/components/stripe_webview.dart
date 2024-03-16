import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class StripeCheckoutWebView extends StatelessWidget {
  final String url;

  const StripeCheckoutWebView({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stripe Checkout'),
      ),
      body: WebView(
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
        navigationDelegate: (NavigationRequest request) {
          // Check if the payment was successful
          if (request.url.startsWith('your_success_url')) {
            // If payment was successful, return 'success' as the result
            Navigator.pop(context, 'success');
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    );
  }
}
