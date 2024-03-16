import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class StripeCheckoutWebView extends StatefulWidget {
  final String url;

  const StripeCheckoutWebView({super.key, required this.url});

  @override
  _StripeCheckoutWebViewState createState() => _StripeCheckoutWebViewState();
}

class _StripeCheckoutWebViewState extends State<StripeCheckoutWebView> {
  late WebViewController _controller;
  bool _paymentSuccessful = false;

  @override
  void initState() {
    super.initState();
    // Start listening for URL changes
    _listenForUrlChanges();
  }

  void _listenForUrlChanges() {
    // Set up a timer to periodically check the current URL
    Timer.periodic(const Duration(seconds: 2), (timer) async {
      final currentUrl = await _controller.currentUrl();
      print('Current URL: $currentUrl');

      // Check if the current URL is not null and matches the success URL
      if (currentUrl != null &&
          currentUrl.contains('https://buy.stripe.com/c/pay/')) {
        // Stop the timer
        timer.cancel();
        // Set the payment successful flag
        setState(() {
          _paymentSuccessful = true;
        });
        // Show success message
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Payment successful')),
        // );
        // Pop the screen
        await Future.delayed(const Duration(seconds: 4));
        Navigator.pop(context, 'success');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stripe Checkout'),
      ),
      body: WebView(
        initialUrl: widget.url,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController controller) {
          _controller = controller;
        },
      ),
    );
  }
}
