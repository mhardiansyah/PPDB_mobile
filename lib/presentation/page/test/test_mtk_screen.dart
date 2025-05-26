import 'dart:async';
import 'package:flutter/material.dart';

class TestMtkScreen extends StatefulWidget {
  const TestMtkScreen({Key? key}) : super(key: key);

  @override
  State<TestMtkScreen> createState() => _TestMtkScreenState();
}

class _TestMtkScreenState extends State<TestMtkScreen> {
  // Total waktu dalam detik (2 jam = 7200 detik)
  int remainingSeconds = 7200;
  Timer? _timer;

  final List<Map<String, dynamic>> questions = [
    {
      'question': 'Hasil dari 8 + 13 adalah...',
      'options': ['18', '20', '21', '15'],
    },
    {
      'question': 'Kelompok prima terkecil adalah...',
      'options': ['0', '1', '2', '4'],
    },
    {
      'question': 'FPB dari 12 dan 18 adalah...',
      'options': ['2', '4', '6', '12'],
    },
    {
      'question': 'KPK dari 4 dan 6 adalah...',
      'options': ['18', '12', '36', '24'],
    },
    {
      'question': '6 + 6 = ...',
      'options': ['6', '8', '5', '7'],
    },
    {
      'question': '0,25 jika diubah ke bentuk pecahan adalah...',
      'options': ['1/2', '1/4', '1/8', '2/5'],
    },
    {
      'question': 'Akar kuadrat dari 81 adalah...',
      'options': ['7', '8', '9', '5'],
    },
    {
      'question': '2 x 9 = ...',
      'options': ['8', '16', '18', '12'],
    },
    {
      'question': 'Hasil dari 10% dari 200 adalah...',
      'options': ['20', '30', '40', '50'],
    },
    {
      'question': 'Hasil dari 10% dari 200 ...',
      'options': ['10 ', '20', '30', '40'],
    },
    {
      'question': ' Hasil dari 13 + 7 adalah...',
      'options': ['14', '17', '20', '19'],
    },
    {
      'question': ' Pecahan 2 mewakili dari 3 = 1 adalah...',
      'options': ['1/7', '2/3', '1/3', '3/8'],
    },
    {
      'question': ' 2,5 + 3,5 = ...',
      'options': ['5', '6', '6,5', '7'],
    },
    {
      'question': ' 6 + 6 : 2 = ...',
      'options': ['3', '6', '9', '12'],
    },
    {
      'question': ' 0,06 dalam bentuk persen adalah...',
      'options': ['0,06%', '6%', '0,6%', '70,5%'],
    },
    {
      'question':
          ' Sebuah segitiga mempunyai alas 40 cm dan tinggi 6 cm. Luasnya adalah...',
      'options': ['60 cm²', '120 cm²', '240 cm²', '600 cm²'],
    },
    {
      'question':
          ' Jika sebuah persegi panjang panjangnya 10 cm dan lebarnya 4 cm, maka luasnya adalah...',
      'options': ['40 cm²', '14 cm²', '24 cm²', '50 cm²'],
    },
    {
      'question': ' 3 jam berapa menit = ...',
      'options': ['90', '100', '120', '180'],
    },
    {
      'question': ' Hasil dari 5² adalah...',
      'options': ['7', '8', '10', '25'],
    },
    {
      'question': ' Hasil dari 10% dari 200 ...',
      'options': ['10', '20', '30', '40'],
    },
    {
      'question':
          ' Keliling segitiga dengan panjang sisi 5 cm, 6 cm, dan 7 cm adalah...',
      'options': ['18 cm', '17 cm', '19 cm', '16 cm'],
    },
    {
      'question': ' Volume kubus dengan sisi 3 cm adalah...',
      'options': ['6 cm³', '18 cm³', '9 cm³', '27 cm³'],
    },
    {
      'question':
          ' Jika suhu di kulkas -5°C lalu naik 3°C, maka suhunya sekarang...',
      'options': ['-8°C', '-2°C', '-10°C', '0°C'],
    },
    {
      'question': ' 100 : (5 × 2) = ...',
      'options': ['10', '100', '5', '15'],
    },
    {
      'question': ' Volume kubus dengan sisi 3 cm adalah...',
      'options': ['6 cm³', '18 cm³', '9 cm³', '27 cm³'],
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
                        'matematika',
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
