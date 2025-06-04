import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ppdb_be/core/router/App_router.dart';
import 'package:ppdb_be/service/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool _obscureText = true;

  void togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf2f2f2),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              'assets/images/Head.png',
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),

                  TextField(
                    controller: email,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Password Field
                  TextField(
                    controller: password,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      labelText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: togglePasswordVisibility,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Login Button
                  ElevatedButton(
                    onPressed: () {
                      AuthService().login(context, email.text, password.text);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: Center(
                        child: Text(
                          'Login',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      context.goNamed(Routes.register);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: Center(
                        child: Text(
                          'Register',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Divider with text
                  Row(
                    children: [
                      Expanded(
                        child: Divider(color: Colors.grey, thickness: 1),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'Or login with',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      Expanded(
                        child: Divider(color: Colors.grey, thickness: 1),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Google Sign-In Button
                  ElevatedButton(
                    onPressed: () {
                      AuthService().sign_with_google(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: Colors.black),
                      ),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/icons/google.png', // Ganti dengan path ikon Google Anda
                            height: 24,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Continue with Google',
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
