import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ppdb_be/core/models/siswa_model.dart';

class SiswaCard extends StatelessWidget {
  final SiswaModel siswa;

  const SiswaCard({Key? key, required this.siswa}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Ambil status dari model
    final status = siswa.status;

    // Tentukan warna atau ikon berdasarkan status
    Color statusColor;
    Icon statusIcon;
    String statusText;

    switch (status) {
      case 'diterima':
        statusColor = Colors.green;
        statusIcon = const Icon(Icons.check_circle, color: Colors.green);
        statusText = 'Diterima';
        break;
      case 'di cek oleh panitia':
        statusColor = Colors.orange;
        statusIcon = const Icon(Icons.timelapse, color: Colors.orange);
        statusText = 'Di cek oleh panitia';
        break;
      case 'pending':
      default:
        statusColor = Colors.grey;
        statusIcon = const Icon(Icons.info_outline, color: Colors.grey);
        statusText = 'Menunggu';
        break;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor),
      ),
      child: Row(
        children: [
          statusIcon,
          const SizedBox(width: 8),
          Text(
            statusText,
            style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
