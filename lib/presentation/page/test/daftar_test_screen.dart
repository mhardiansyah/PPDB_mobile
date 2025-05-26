import 'package:flutter/material.dart';
import 'test_mtk_screen.dart';
import 'test_agama_screen.dart'; // Import screen agama
import 'test_psikolog_screen.dart';
import 'test_inggris_screen.dart';

class DaftarTestScreen extends StatefulWidget {
  const DaftarTestScreen({super.key});

  @override
  State<DaftarTestScreen> createState() => _DaftarTestScreenState();
}

class _DaftarTestScreenState extends State<DaftarTestScreen> {
  final List<Map<String, String>> testList = [
    {
      "title": "Agama",
      "description": "Latihan Soal Rukun Iman dan Rukun Islam",
      "image": "assets/images/agama.png",
    },
    {
      "title": "matematika",
      "description": "Materi Dasar Komputer dan Internet",
      "image": "assets/images/mtk.png",
    },
    {
      "title": "bahasa inggris",
      "description": "Pengetahuan Inggris",
      "image": "assets/images/inggris.png",
    },
    {
      "title": "psikolog",
      "description": "Latihan Mengenal Diri Sendiri",
      "image": "assets/images/logika.png",
    },
  ];

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
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: testList.length,
          itemBuilder: (context, index) {
            final item = testList[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: Image.asset(
                      item["image"]!,
                      width: double.infinity,
                      height: 130,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item["title"]!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item["description"]!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: const [
                                Icon(Icons.access_time, size: 16),
                                SizedBox(width: 4),
                                Text("2 Jam", style: TextStyle(fontSize: 12)),
                              ],
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF278550),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 8,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                if (item["title"] == "Agama") {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => const TestDiniahScreen(),
                                    ),
                                  );
                                } else if (item["title"] == "matematika") {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => const TestMtkScreen(),
                                    ),
                                  );
                                } else if (item["title"] == "psikolog") {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => TestpsikologScreen(),
                                    ),
                                  );
                                } else if (item["title"] == "bahasa inggris") {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => TestInggrisScreen(),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Halaman tes belum tersedia',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: const Text(
                                "Mulai tes",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
