import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ppdb_be/core/models/daftar_test.dart';
import 'package:ppdb_be/core/models/siswa_model.dart';
import 'package:ppdb_be/core/router/App_router.dart';

class HasilTestScreen extends StatefulWidget {
  final Map<String, dynamic> extra;

  const HasilTestScreen({super.key, required this.extra});

  @override
  State<HasilTestScreen> createState() => _HasilTestScreenState();
}

class _HasilTestScreenState extends State<HasilTestScreen> {
  @override
  Widget build(BuildContext context) {
    final selectedAnswers = widget.extra['selectedAnswers'] as Map<int, int>;
    final soalList = widget.extra['soalList'] as List<SoalTest>;
    final skor = widget.extra['skor'] as int;
    final siswa = widget.extra['siswa'] as SiswaModel;

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
            context.goNamed(Routes.daftar_test, extra: siswa);
          },
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Center(
              child: Column(
                children: [
                  Text(
                    'Selamat Anda Telah Mengerjakan Tes',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Skor Anda: $skor / 100',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // List of Questions
            Expanded(
              child: ListView.builder(
                itemCount: soalList.length,
                itemBuilder: (context, index) {
                  final soal = soalList[index];
                  final userAnswer = selectedAnswers[index];
                  final benar =
                      userAnswer != null &&
                      soal.opsiJawaban[userAnswer] == soal.jawabanBenar;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Question Text
                        Text(
                          '${index + 1}. ${soal.pertanyaan}',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 8),
                        // Options
                        ...List.generate(soal.opsiJawaban.length, (optIdx) {
                          final isCorrect =
                              soal.opsiJawaban[optIdx] == soal.jawabanBenar;
                          final isSelected = userAnswer == optIdx;

                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color:
                                  isSelected
                                      ? (isCorrect
                                          ? Colors.green.shade100
                                          : Colors.red.shade100)
                                      : null,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color:
                                    isCorrect
                                        ? Colors.green
                                        : Colors.grey.shade300,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  isCorrect
                                      ? Icons.check_circle
                                      : (isSelected
                                          ? Icons.cancel
                                          : Icons.circle_outlined),
                                  color: isCorrect ? Colors.green : Colors.red,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    soal.opsiJawaban[optIdx],
                                    style: TextStyle(
                                      color:
                                          isCorrect
                                              ? Colors.green
                                              : Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
