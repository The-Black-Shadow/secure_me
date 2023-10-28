import 'package:cloud_firestore/cloud_firestore.dart';
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
  //all users
  final allUser = FirebaseFirestore.instance.collection('Users');
  //edit field
  Future<void> editField(String field) async {
    String newValue = '';
    //get value
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit $field'),
        backgroundColor: Colors.cyan[200],
        content: TextField(
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Enter new $field',
          ),
          onChanged: (value) {
            newValue = value;
          },
        ),
        actions: [
          //cancel button
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),

          //save button
          TextButton(
            onPressed: () => Navigator.of(context).pop(newValue),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (newValue.isNotEmpty) {
      await allUser.doc(currentUser.email).update({field: newValue});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Page'),
        backgroundColor: Colors.cyan[800],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(currentUser.email)
            .snapshots(),
        builder: (context, snapshot) {
          //get user data
          if (snapshot.hasData) {
            final userData = snapshot.data!.data() as Map<String, dynamic>;
            return ListView(
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
                    text: userData['Name'],
                    onPressed: () => editField('Name')),
                //phone
                MyTextBox(
                    sectionName: 'Phone : ',
                    text: userData['Phone'],
                    onPressed: () => editField('Phone')),
                //address
                MyTextBox(
                    sectionName: 'Address',
                    text: userData['Address'],
                    onPressed: () => editField('Address')),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error${snapshot.error}',
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
