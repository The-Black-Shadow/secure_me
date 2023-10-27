import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:secure_me/components/drawer.dart';
import 'package:secure_me/pages/profile_page.dart';
import 'package:secure_me/pages/setting_page.dart';

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

  //go to setting page
  void goToSettingPage() {
    //pop drawer
    Navigator.pop(context);
    //navigate to setting page
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const SettingPage()));
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
        onSettingTap: goToSettingPage,
        signOut: signOut,
      ),
      body: Column(
        children: [
          Text("Name : ${currentUser.email!}"),
        ],
      ),
    );
  }
}
