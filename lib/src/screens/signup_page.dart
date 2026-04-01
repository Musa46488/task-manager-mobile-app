import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> _signUpUser() async {
    final firstName = firstNameController.text.trim();
    final lastName = lastNameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (firstName.isEmpty ||
        lastName.isEmpty ||
        email.isEmpty ||
        password.isEmpty) {
      _showSnackBar("Please fill all fields.");
      return;
    }

    if (!email.contains('@')) {
      _showSnackBar("Please enter a valid email address.");
      return;
    }
    if (password.length < 6) {
      _showSnackBar("Password must be at least 6 characters.");
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      final uid = userCredential.user?.uid;
      if (uid == null) {
        _showSnackBar("Sign up failed: UID not found.");
        return;
      }

      await FirebaseFirestore.instance.collection('User Data').doc(uid).set({
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'createdAt': Timestamp.now(),
      });

      if (!mounted) return;

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      _showSnackBar(
        "Sign up failed: ${e is FirebaseAuthException ? e.message : e.toString()}",
      );
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF2F5FF),
        title: const Text(
          "Sign Up",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 24,
            color: Color(0XFF2E3A59),
          ),
        ),
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0XFF2E3A59)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: firstNameController,
              decoration: const InputDecoration(
                labelText: "First Name",
                labelStyle: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                  color: Color(0XFF2E3A59),
                ),
              ),
            ),
            TextField(
              controller: lastNameController,
              decoration: const InputDecoration(
                labelText: "Last Name",
                labelStyle: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                  color: Color(0XFF2E3A59),
                ),
              ),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Email",
                labelStyle: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                  color: Color(0XFF2E3A59),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: "Password",
                labelStyle: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                  color: Color(0XFF2E3A59),
                ),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signUpUser,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: const StadiumBorder(),
              ),
              child: Ink(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF9C2CF3), Color(0xFF3A49F9)],
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                ),
                child: Container(
                  constraints: const BoxConstraints(
                    maxWidth: 120,
                    minHeight: 48,
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
