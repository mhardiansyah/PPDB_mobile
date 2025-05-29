import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ppdb_be/core/models/daftar_test.dart';
import 'package:ppdb_be/core/models/siswa_model.dart';
import 'package:ppdb_be/core/router/App_router.dart';

class HasilTestScreen extends StatefulWidget {
  final Map<String, dynamic> extra;

  const HasilTestScreen({super.key, required this.extra, });

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
        title: Text(
          'Hasil Test',
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed:
                      () => context.goNamed(Routes.daftar_test, extra: siswa),
                ),
                SizedBox(width: 10),
                Text(
                  'Skor Anda: $skor  / 100 ',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: soalList.length,
                itemBuilder: (context, index) {
                  final soal = soalList[index];
                  final userAnswer = selectedAnswers[index];
                  final benar =
                      userAnswer != null &&
                      soal.opsiJawaban[userAnswer] == soal.jawabanBenar;

                  return Card(
                    child: ListTile(
                      title: Text('${index + 1}. ${soal.pertanyaan}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Jawaban Anda: ${userAnswer != null ? soal.opsiJawaban[userAnswer] : 'Tidak dijawab'}',
                          ),
                          Text('Jawaban Benar: ${soal.jawabanBenar}'),
                          Text(
                            benar ? '✅ Benar' : '❌ Salah',
                            style: TextStyle(
                              color: benar ? Colors.green : Colors.red,
                            ),
                          ),
                        ],
                      ),
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
