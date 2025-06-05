import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:ppdb_be/core/router/App_router.dart';

class SuccessUploadDialog extends StatelessWidget {
  final String schoolName;

  const SuccessUploadDialog({super.key, required this.schoolName});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset(
            'assets/animations/popup.json',
            width: 250,
            height: 250,
            repeat: false,
          ),
          const SizedBox(height: 16),
          Text(
            "Berhasil Mengirim Berkas",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 25),
          Text(
            "Berkas kamu telah terkirim ke $schoolName",
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF7A7A7A),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 25),
          SizedBox(
            width: 172,
            child: ElevatedButton(
              onPressed: () => context.goNamed(Routes.home),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF226D3D),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Kembali Ke Home",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
