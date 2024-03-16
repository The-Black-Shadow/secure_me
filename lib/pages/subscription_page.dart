import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:secure_me/components/stripe_webview.dart';

class SubscriptionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subscription Packages'),
      ),
      body: SubscriptionPackages(),
    );
  }
}

class SubscriptionPackages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('SubscriptionPackages')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

        return ListView.builder(
          itemCount: documents.length,
          itemBuilder: (BuildContext context, int index) {
            final Map<String, dynamic> data =
                documents[index].data() as Map<String, dynamic>;

            TextEditingController brandController = TextEditingController();
            TextEditingController modelController = TextEditingController();
            TextEditingController regController = TextEditingController();
            TextEditingController engineController = TextEditingController();

            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(data['packageName'] ?? 'Package Name',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(data['packageDetails'] ?? 'Package Details'),
                  trailing: Text(
                    data['packagePrice'] != null
                        ? '\$${data['packagePrice']}'
                        : 'Price',
                    style: const TextStyle(
                        fontSize: 26), // Adjust the font size here
                  ),
                  onTap: () => _purchasePackage(context, data, brandController,
                      modelController, regController, engineController),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _purchasePackage(
      BuildContext context,
      Map<String, dynamic> data,
      TextEditingController brandController,
      TextEditingController modelController,
      TextEditingController regController,
      TextEditingController engineController) async {
    final currentUser = FirebaseAuth.instance.currentUser;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Purchase ${data['packageName']}'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),
              TextField(
                controller: brandController,
                decoration: const InputDecoration(
                  labelText: 'Car Brand',
                  border: OutlineInputBorder(),
                  hintText: 'Enter car brand',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: modelController,
                decoration: const InputDecoration(
                  labelText: 'Car Model',
                  border: OutlineInputBorder(),
                  hintText: 'Enter car model',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: regController,
                decoration: const InputDecoration(
                  labelText: 'Car Register',
                  border: OutlineInputBorder(),
                  hintText: 'Enter car register',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: engineController,
                decoration: const InputDecoration(
                  labelText: 'Car Engine',
                  border: OutlineInputBorder(),
                  hintText: 'Enter car engine',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              String brand = brandController.text.trim();
              String model = modelController.text.trim();
              String engine = engineController.text.trim();

              if (brand.isNotEmpty && model.isNotEmpty && engine.isNotEmpty) {
                _stripeCheckout(context, data, brandController, modelController,
                    regController, engineController);
              } else {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Error'),
                    content: const Text('Please fill all fields.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              }
            },
            child: const Text('Purchase'),
          ),
        ],
      ),
    );
  }

  Future<void> _stripeCheckout(
      BuildContext context,
      Map<String, dynamic> data,
      TextEditingController brandController,
      TextEditingController modelController,
      TextEditingController regController,
      TextEditingController engineController) async {
    // Example Stripe checkout URL
    final stripeCheckoutUrl = 'https://buy.stripe.com/test_7sI7sw0Uxdvq8w0eUV';

    try {
      // Launch Stripe checkout web view
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StripeCheckoutWebView(url: stripeCheckoutUrl),
        ),
      );

      // Check if payment was successful
      if (result == 'success') {
        print('Payment Successssssssssss');
        // If payment was successful, handle the purchase
        _handlePurchase(context, data, brandController, modelController,
            regController, engineController);
      }
    } catch (e) {
      print('Error launching Stripe checkout: $e');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text(
              'An error occurred during checkout. Please try again later.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void _handlePurchase(
      BuildContext context,
      Map<String, dynamic> data,
      TextEditingController brandController,
      TextEditingController modelController,
      TextEditingController regController,
      TextEditingController engineController) async {
    String brand = brandController.text.trim();
    String model = modelController.text.trim();
    String reg = regController.text.trim();
    String engine = engineController.text.trim();

    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      // Calculate expiration date (1 year validity)
      DateTime currentDate = DateTime.now();
      DateTime expirationDate = currentDate.add(Duration(days: 365));

      await FirebaseFirestore.instance
          .collection('Subscriptions')
          .doc(currentUser!.email)
          .collection('Plans')
          .add({
        'Package': data['packageName'],
        'Car Brand': brand,
        'Car Model': model,
        'Car Reg': reg,
        'Car Engine': engine,
        'Expiration Date': expirationDate,
      });

      brandController.clear();
      modelController.clear();
      regController.clear();
      engineController.clear();

      Navigator.pop(context);
    } catch (e) {
      print('Error adding data: $e');
    }
  }
}

//==========
