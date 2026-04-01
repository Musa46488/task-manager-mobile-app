import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _isLoading = false;

  Future<void> _loginUser() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnackBar('Please enter both email and password');
      return;
    }

    if (!email.contains('@')) {
      _showSnackBar('Please enter a valid email address');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } catch (e) {
      if (!mounted) return;

      _showSnackBar("Login failed: ${e.toString()}");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
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
          "Login",
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
            SizedBox(
              width: 120,
              height: 48,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _loginUser,
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
                  child: Center(
                    child:
                        _isLoading
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                            : const Text(
                              'Login',
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
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed:
                  _isLoading
                      ? null
                      : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const SignUpPage()),
                        );
                      },
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFFE5EAFC),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Create Account",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: Color(0XFF2E3A59),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
