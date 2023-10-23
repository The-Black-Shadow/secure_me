import 'package:flutter/material.dart';
import 'package:secure_me/components/button.dart';
import 'package:secure_me/components/textfield.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({
    super.key,
    required this.onTap,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[200],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              const SizedBox(height: 150),
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
              const SizedBox(height: 50),
              //email textfield
              MyTextfield(
                controller: emailController,
                hint: "Email",
                obscureText: false,
              ),
              const SizedBox(height: 20),
              //password textfield
              MyTextfield(
                controller: passwordController,
                hint: "Password",
                obscureText: true,
              ),
              const SizedBox(height: 20),
              //login button
              MyButton(onTap: () {}, text: 'Log In'),
              const SizedBox(height: 20),
              //register button
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text(
                      "Register now !",
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
    );
  }
}
