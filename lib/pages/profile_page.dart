import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:secure_me/components/text_box.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  //current user
  final currentUser = FirebaseAuth.instance.currentUser!;
  //edit field
  Future<void> editField(String field) async {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Page'),
        backgroundColor: Colors.cyan[800],
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          //profile pic
          const Icon(
            Icons.person,
            size: 100,
          ),
          const SizedBox(height: 10),
          Text(
            'Email : ${currentUser.email!}',
            style: const TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),

          //user details
          const SizedBox(height: 50),
          const Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              'User Details',
              style: TextStyle(fontSize: 15),
              textAlign: TextAlign.left,
            ),
          ),
          const SizedBox(height: 10),
          //name
          MyTextBox(
              sectionName: 'Name : ',
              text: 'Mehedi Hasan',
              onPressed: () => editField('username')),
          //phone
          MyTextBox(
              sectionName: 'Phone : ',
              text: '01700000000',
              onPressed: () => editField('phone')),
          //address
          MyTextBox(
              sectionName: 'Address',
              text: 'Khulna, BD',
              onPressed: () => editField('address')),
        ],
      ),
    );
  }
}
