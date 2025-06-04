import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:ppdb_be/core/router/App_router.dart';

class NotfoundScreen extends StatelessWidget {
  const NotfoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF278550),
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.asset('assets/icons/logoBaru.png', width: 35),
              ),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SMK KREATIF NUSANTARA',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Kab. Bogor',
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
        leading: BackButton(
          color: Colors.white,
          onPressed: () {
            context.goNamed(Routes.home);
          },
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Center(
          child: Column(
            children: [
              Lottie.asset(
                'assets/animations/notFound.json',
                width: 200,
                height: 200,
                repeat: true,
              ),
              const SizedBox(height: 20),
              Text(
                "Oop periksa jaringan atau data halaman tidak di temukan",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
