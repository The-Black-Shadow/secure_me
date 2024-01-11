import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:secure_me/components/drawer.dart';
import 'package:secure_me/components/pdf_generation.dart';
import 'package:secure_me/pages/profile_page.dart';
import 'package:secure_me/pages/setting_page.dart';
import 'package:secure_me/pages/stylecard.dart';
import 'package:secure_me/pages/subscription_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userName = "";
  String userAddress = "";
  String phone = "";
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
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SubscriptionPage()));
  }

  //go to setting page
  void goToSettingPage() {
    //pop drawer
    Navigator.pop(context);
    //navigate to setting page
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const SettingPage()));
  }

  //get user information
  Future<void> fetchUserData() async {
    String userEmail = FirebaseAuth.instance.currentUser!.email!;

    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userEmail)
          .get();

      if (userSnapshot.exists) {
        Map<String, dynamic> userData =
            userSnapshot.data() as Map<String, dynamic>;
        setState(() {
          userName = userData['Name'];
          userAddress = userData['Address'];
          phone = userData['Phone'];
        });
      } else {
        print('Document does not exist for the logged-in user.');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
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

    DateTime expirationDate = data['Expiration Date']?.toDate();
    String formattedExpirationDate = expirationDate != null
        ? DateFormat.yMMMMd().format(expirationDate)
        : 'N/A';

    int validityDays = expirationDate != null
        ? expirationDate.difference(DateTime.now()).inDays
        : 0;

    return Card(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Text("Package: ${data['Package']}"),
                  subtitle: Text("Car Model: ${data['Car Model']}"),
                ),
                ListTile(
                  title: Text("Car Reg: ${data['Car Reg']}"),
                  subtitle: Text("Car Engine: ${data['Car Engine']}"),
                ),
                ListTile(
                  title: Text("Expiration Date: $formattedExpirationDate"),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                const Text(
                  'Validity:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '$validityDays days',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    // Request permissions
                    var status = await Permission.storage.request();

                    if (status == PermissionStatus.granted) {
                      // Functionality for printing
                      Map<String, dynamic> packageInfo = {
                        'Package': data['Package'],
                        'Car Model': data['Car Model'],
                        'Car Reg': data['Car Reg'],
                        'Car Engine': data['Car Engine'],
                        // Add other necessary package information
                      };
                      try {
                        // Generate PDF
                        String pdfPath = await generatePdf(packageInfo);

                        // Open the generated PDF file
                        OpenFile.open(pdfPath);
                      } catch (e) {
                        print('Error generating or opening PDF: $e');
                      }
                    } else {
                      print('Permission denied');
                    }
                  },
                  child: const Text('Print'),
                ),
              ],
            ),
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

// Refresh user data when pulled down
  Future<void> _refreshData() async {
    await fetchUserData(); // Refresh user data when pulled down
    // Add any other refresh logic here
    setState(() {});
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
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              StyledCard(
                userName: userName,
                userEmail: FirebaseAuth.instance.currentUser!.email!,
                userAddress: userAddress,
                phone: phone,
              ),
              const SizedBox(height: 16), // Add some space between widgets
              const Text('Your Plans',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  )),
              const SizedBox(height: 16), // Add some space between widgets
              StreamBuilder<List<DocumentSnapshot>>(
                stream:
                    getPlansForUser(FirebaseAuth.instance.currentUser!.email!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  } else if (snapshot.hasData) {
                    List<Widget> planCards =
                        snapshot.data!.map((plan) => planCard(plan)).toList();
                    return Column(
                      children: planCards,
                    );
                  } else {
                    return const Text("No plans found.");
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
