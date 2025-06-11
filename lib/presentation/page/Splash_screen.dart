import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:ppdb_be/core/router/App_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  cekData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      context.goNamed(Routes.home);
    } else {
      context.goNamed(Routes.login);
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      context.goNamed(Routes.login);
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/BgSplash.png',
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width * 1.5,
              height: double.infinity,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 100),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/icons/logoBaru.png', width: 200),
                  const SizedBox(height: 60),
                  Lottie.asset(
                    'assets/animations/splash.json',
                    width: 250,
                    height: 250,
                    repeat: true,
                  ),
                ],
              ),
            ),
          ),
          // Center(
          //   child: Lottie.asset(
          //     'animations/splash.json',
          //     width: 250,
          //     height: 250,
          //     repeat: true,
          //   ),
          // ),
        ],
      ),
    );
  }
}
