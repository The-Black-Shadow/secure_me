import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MySubscription extends StatefulWidget {
  const MySubscription({super.key});

  @override
  State<MySubscription> createState() => _MySubscriptionState();
}

class _MySubscriptionState extends State<MySubscription> {
  final brandController = TextEditingController();
  final regController = TextEditingController();
  final engineController = TextEditingController();
  String? planName;
  String? planPrice;
  final currentUser = FirebaseAuth.instance.currentUser!;

  Future addPlan(planName, planPrice) async {
    addUserData(planName, brandController.text, regController.text,
        engineController.text);
  }

  Future addUserData(
    String name,
    String carModel,
    String regNo,
    String carEngine,
  ) async {
    await FirebaseFirestore.instance
        .collection("Subscriptions")
        .doc(currentUser.email)
        .collection('Plans')
        .add({
      'Package': name,
      'Car Model': carModel,
      'Car Reg': regNo,
      'Car Engine': carEngine,
    });
  }

  void buyPlan(String planNamee, String price) {
    planPrice = price;
    planName = planNamee;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('You have selected $planName'),
        backgroundColor: Colors.cyan[200],
        content: SizedBox(
          height: 400,
          width: 300,
          child: Column(
            children: [
              const Text(
                'Enter Your Car Brand Name : ',
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                controller: brandController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Car Brand Name',
                ),
              ),
              const SizedBox(height: 10.0),
              //Car registration number
              const Text(
                'Enter Car Registration Number : ',
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                controller: regController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Car Registration Details',
                ),
              ),
              const SizedBox(height: 10.0),
              //Car engine number
              const Text(
                'Enter Car Engine Number : ',
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                controller: engineController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Car Engine Number',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => {
              addPlan(planName, planPrice),
              Navigator.pop(context),
            },
            child: const Text('Purchase'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan[300],
      appBar: AppBar(
        title: const Text('Subscription'),
        backgroundColor: Colors.cyan[800],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //Basic Plan
            Container(
              margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 40.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Colors.cyan[200],
                border: Border.all(color: Colors.grey),
              ),
              padding: const EdgeInsets.all(10.0),
              child: ExpansionTile(
                title: const Text('Basic Plan'),
                children: [
                  Card(
                    shadowColor: Colors.grey,
                    child: Container(
                      margin: const EdgeInsets.all(5.0),
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment
                            .start, // Set this property to start from the left
                        children: [
                          const Text(
                            'Plan includes :',
                            style: TextStyle(
                              fontSize: 20.0,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          const Text('1. 1 GB Storage'),
                          const Text('2. 1 User'),
                          const Text('3. 1 Device'),
                          const Text('4. 1 Year'),
                          const Text('5. 1 Car'),
                          const Text('6. 1 Driver'),
                          const Text('7. 1 Location'),
                          const Text('8. 1 Emergency Contact'),
                          ElevatedButton(
                            onPressed: () => buyPlan('Basic Plan', '\$50'),
                            child: const Text('\$50 Purchase'),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            //Standard Plan
            Container(
              margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 40.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Colors.cyan[200],
                border: Border.all(color: Colors.grey),
              ),
              padding: const EdgeInsets.all(10.0),
              child: ExpansionTile(
                title: const Text('Standard Plan'),
                children: [
                  Card(
                    shadowColor: Colors.grey,
                    child: Container(
                      margin: const EdgeInsets.all(5.0),
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment
                            .start, // Set this property to start from the left
                        children: [
                          const Text(
                            'Plan includes :',
                            style: TextStyle(
                              fontSize: 20.0,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          const Text('1. 1 GB Storage'),
                          const Text('2. 1 User'),
                          const Text('3. 1 Device'),
                          const Text('4. 1 Year'),
                          const Text('5. 1 Car'),
                          const Text('6. 1 Driver'),
                          const Text('7. 1 Location'),
                          const Text('8. 1 Emergency Contact'),
                          ElevatedButton(
                            onPressed: () => buyPlan('Standard Plan', '\$75'),
                            child: const Text('\$75 Purchase'),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            //Premium Plan
            Container(
              margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 40.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Colors.cyan[200],
                border: Border.all(color: Colors.grey),
              ),
              padding: const EdgeInsets.all(10.0),
              child: ExpansionTile(
                title: const Text('Premium Plan'),
                children: [
                  Card(
                    shadowColor: Colors.grey,
                    child: Container(
                      margin: const EdgeInsets.all(5.0),
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment
                            .start, // Set this property to start from the left
                        children: [
                          const Text(
                            'Plan includes :',
                            style: TextStyle(
                              fontSize: 20.0,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          const Text('1. 1 GB Storage'),
                          const Text('2. 1 User'),
                          const Text('3. 1 Device'),
                          const Text('4. 1 Year'),
                          const Text('5. 1 Car'),
                          const Text('6. 1 Driver'),
                          const Text('7. 1 Location'),
                          const Text('8. 1 Emergency Contact'),
                          ElevatedButton(
                            onPressed: () => buyPlan('Premium Plan', '\$120'),
                            child: const Text('\$120 Purchase'),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
