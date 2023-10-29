import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:secure_me/components/drawer.dart';
import 'package:secure_me/pages/profile_page.dart';
import 'package:secure_me/pages/setting_page.dart';
import 'package:secure_me/pages/subscription_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //sign out function
  void signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  //go to profile page
  void goToProfilePage() {
    //pop drawer
    Navigator.pop(context);
    //navigate to profile page
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const ProfilePage()));
  }

  //go to subscription page
  void goToSubscriptionPage() {
    //pop drawer
    Navigator.pop(context);
    //navigate to subscription page
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const MySubscription()));
  }

  //go to setting page
  void goToSettingPage() {
    //pop drawer
    Navigator.pop(context);
    //navigate to setting page
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const SettingPage()));
  }

//get all plans for user
  Stream<List<DocumentSnapshot>> getPlansForUser(String userId) {
    return FirebaseFirestore.instance
        .collection("Subscriptions")
        .doc(userId)
        .collection("Plans")
        .snapshots()
        .map((QuerySnapshot querySnapshot) => querySnapshot.docs);
  }

  Widget planCard(DocumentSnapshot plan) {
    Map<String, dynamic> data = plan.data() as Map<String, dynamic>;

    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text("Package: ${data['Package']}"),
            subtitle: Text("Car Model: ${data['Car Model']}"),
          ),
          ListTile(
            title: Text("Car Reg: ${data['Car Reg']}"),
            subtitle: Text("Car Engine: ${data['Car Engine']}"),
          ),
        ],
      ),
    );
  }

  Widget planList(String userEmail) {
    return StreamBuilder<List<DocumentSnapshot>>(
      stream: getPlansForUser(userEmail),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        } else if (snapshot.hasData) {
          List<Widget> planCards =
              snapshot.data!.map((plan) => planCard(plan)).toList();
          return ListView(
            children: planCards,
          );
        } else {
          return const Text("No plans found.");
        }
      },
    );
  }

  final currentUser = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan[800],
        title: const Text('Secure Me'),
      ),
      drawer: MyDrawer(
        onProfileTap: goToProfilePage,
        onSubscriptionTap: goToSubscriptionPage,
        onSettingTap: goToSettingPage,
        signOut: signOut,
      ),
      body: Column(
        children: [
          Text("Name : ${currentUser.email!}"),
          Expanded(
            child: planList(currentUser.email!),
          ), // Display the user information.)
        ],
      ),
    );
  }
}
