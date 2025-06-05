import 'package:flutter/material.dart';

class Berkas extends StatelessWidget {
  const Berkas({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 375,
      height: 151,
      decoration: BoxDecoration(
        color: Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Berkas Di upload'),
            SizedBox(height: 19),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Status'),
                Row(
                  children: [
                    Icon(Icons.crisis_alert_outlined, color: Colors.green),
                    Text('Di cek oleh panitia'),
                  ],
                ),
              ],
            ),
            SizedBox(height: 19),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Berkas berhasil dihapus')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: Text('Hapus Berkas'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
