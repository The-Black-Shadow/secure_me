import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:secure_me/components/button.dart';
import 'package:secure_me/components/textfield.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({
    super.key,
    required this.onTap,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  //sign up function
  void signUp() async {
    if (passwordController.text != confirmPasswordController.text) {
      displaymessage("Password does not match");
      return;
    }
    try {
      //create user
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      //after creating user add a new document to firestore
      FirebaseFirestore.instance
          .collection("Users")
          .doc(userCredential.user!.email)
          .set({
        'Name': emailController.text.split('@')[0],
        'Phone': '01xxxxxx',
        'Address': 'Abc, xyz, 123',
      });
    } on FirebaseAuthException catch (e) {
      displaymessage(e.code);
    }
  }

  void displaymessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[200],
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                const SizedBox(height: 50),
                //logo
                const Icon(
                  Icons.security,
                  size: 100,
                  color: Colors.white,
                ),
                const SizedBox(height: 30),
                //welcome text
                const Text("Welcome to Secure Me",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                const SizedBox(height: 30),
                //email textfield
                MyTextfield(
                  controller: emailController,
                  hint: "Email",
                  obscureText: false,
                ),
                const SizedBox(height: 15),
                //password textfield
                MyTextfield(
                  controller: passwordController,
                  hint: "Password",
                  obscureText: true,
                ),
                const SizedBox(height: 15),
                //confirm password textfield
                MyTextfield(
                  controller: confirmPasswordController,
                  hint: "Confirm Password",
                  obscureText: true,
                ),
                const SizedBox(height: 15),
                //login button
                MyButton(
                  onTap: signUp,
                  text: 'Sign Up',
                ),
                const SizedBox(height: 15),
                //register button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?"),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        "Log in now !",
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
