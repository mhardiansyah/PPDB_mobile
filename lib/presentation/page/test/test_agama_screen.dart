import 'dart:async';
import 'package:flutter/material.dart';

class TestDiniahScreen extends StatefulWidget {
  const TestDiniahScreen({Key? key}) : super(key: key);

  @override
  State<TestDiniahScreen> createState() => _TestDiniahScreenState();
}

class _TestDiniahScreenState extends State<TestDiniahScreen> {
  // Total waktu dalam detik (2 jam = 7200 detik)
  int remainingSeconds = 7200;
  Timer? _timer;

  final List<Map<String, dynamic>> questions = [
    {
      'question': ' Rukun Islam yang pertama adalah...',
      'options': ['Syahadat', 'Salat', 'Puasa', 'Haji'],
    },
    {
      'question': ' Kitab suci umat Islam adalah...',
      'options': [
        'Injil',
        'Taurat',
        'Al-Quran',
        'Zabur',
      ], // Disesuaikan urutan jika ada perbedaan
    },
    {
      'question': ' Nabi terakhir dalam Islam adalah...',
      'options': ['Nabi Isa', 'Nabi Musa', 'Nabi Muhammad SAW', 'Nabi Daud'],
    },
    {
      'question': ' Jumlah rakaat shalat Maghrib adalah...',
      'options': ['2 rakaat', '3 rakaat', '4 rakaat', '5 rakaat'],
    },
    {
      'question': ' Rukun Iman ada...',
      'options': ['5', '6', '7', '8'],
    },
    {
      'question': ' Beriman kepada hari kiamat termasuk...',
      'options': ['rukun islam', 'rukun iman', 'sunnah', 'adab'],
    },
    {
      'question': ' Ibadah puasa wajib dikerjakan pada...',
      'options': ['Syawal', 'Rajab', 'Ramadhan', 'Dzulhijjah'],
    },
    {
      'question': ' Nama malaikat yang menyampaikan wahyu adalah...',
      'options': ['israfil', 'malik', 'jibril', 'izrail'],
    },
    {
      'question': ' Lafal syahadat yang benar adalah...',
      'options': [
        'Asyhadu an la ilaha illallah wa asyhadu anna Muhammadan rasulullah',
        'Asyhadu allah',
        'Subhanallah',
        'Alhamdulillah',
      ],
    },
    {
      'question': '. Shalat lima waktu hukumnya adalah...',
      'options': ['Sunnah', 'Makruh', 'Wajib', 'Mubah'],
    },
    {
      'question':
          ' Nabi yang mendapat mukjizat bisa membelah bulan adalah...',
      'options': ['Nabi Isa', 'Nabi Musa', 'Nabi Muhammad', 'Nabi Yusuf'],
    },
    {
      'question': ' Orang yang tidak mau membayar zakat disebut...',
      'options': [
        'Murtad',
        'Musyrik',
        'Kafir',
        'Munafik',
      ], // Pilihan "-" pada gambar tidak relevan
    },
    {
      'question': ' Kitab Injil diturunkan di kota...',
      'options': ['Madinah', 'Mekkah', 'Yerusalem', 'Baitul Maqdis'],
    },
    {
      'question': ' Kitab Injil diturunkan kepada Nabi Isa adalah...',
      'options': ['Zabur', 'Taurat', 'Injil', 'Al-Quran'],
    },
    {
      'question': ' Jumlah rakaat shalat Subuh adalah...',
      'options': ['2 rakaat', '3 rakaat', '4 rakaat', '5 rakaat'],
    },
    {
      'question': 'Nabi yang bisa berbicara sejak bayi adalah...',
      'options': ['Nabi Yusuf', 'Nabi Isa', 'Nabi Musa', 'Nabi Ibrahim'],
    },
    {
      'question': 'Puasa dilakukan sejak...',
      'options': [
        'Terbit matahari hingga terbenam',
        'Terbit fajar hingga terbenam matahari',
        'Terbit fajar hingga terbit matahari',
        'Terbit terbit hingga terbenam matahari',
      ],
    },
    {
      'question': 'Toleransi antar umat beragama disebut...',
      'options': ['Syirik', 'Khilafah', 'Tasawuf', 'Tasamu'],
    },
    {
      'question': 'Salat yang dikerjakan dua kali setahun adalah...',
      'options': [
        'Salat Jumat',
        'Salat Tarawih',
        'Salat Idul Fitri',
        'Salat Tahajud',
      ],
    },
    {
      'question': 'Allah SWT memiliki sifat Maha Melihat, disebut...',
      'options': ['Al-Qawiy', 'Al-Alim', 'Al-Bashir', 'Al-Razzaq'],
    },
    {
      'question': 'Membaca Al-Qur\'an mendapat...',
      'options': ['Pahala', 'Hukuman', 'Dosa', 'Ujian'],
    },
    {
      'question': 'Jumlah juz dalam Al-Qur\'an adalah...',
      'options': ['25', '30', '35', '40'],
    },
    {
      'question': 'Umat Islam menghadap ke arah...',
      'options': ['Barat', 'Selatan', 'Timur', 'Makkah'],
    },
    {
      'question': 'Wajib dikerjakan sebelum...',
      'options': ['Puasa', 'Salat', 'Haji', 'Zakat'],
    },
    {
      'question': 'Orang yang berpuasa tapi tidak shalat...',
      'options': [
        'Diampuni dosanya',
        'Diampuni',
        'Diterima puasanya',
        'Tidak Berdosa',
      ],
    },
  ];

  final Map<int, int> selectedAnswers = {};

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds == 0) {
        timer.cancel();
        // Bisa tambah aksi misalnya submit otomatis atau dialog waktu habis
        // Contoh:
        // showDialog(...) atau langsung pop dan kirim nilai
      } else {
        setState(() {
          remainingSeconds--;
        });
      }
    });
  }

  String formatTime(int seconds) {
    final hours = (seconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$secs';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF444444),
      body: SafeArea(
        child: Center(
          child: Container(
            width: 400,
            margin: const EdgeInsets.symmetric(vertical: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                // Header
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Selamat Mengerjakan',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Agama',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      formatTime(remainingSeconds),
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: questions.length,
                    itemBuilder: (context, index) {
                      final q = questions[index];
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
                            Text(
                              '${index + 1}. ${q['question']}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ...List.generate(q['options'].length, (optIdx) {
                              return RadioListTile<int>(
                                contentPadding: EdgeInsets.zero,
                                title: Text(q['options'][optIdx]),
                                value: optIdx,
                                groupValue: selectedAnswers[index],
                                onChanged: (val) {
                                  setState(() {
                                    selectedAnswers[index] = val!;
                                  });
                                },
                              );
                            }),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      // Aksi saat tombol Next ditekan, misalnya pindah soal atau submit jawaban
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Submit',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
