import 'dart:async';
import 'package:flutter/material.dart';

class TestpsikologScreen extends StatefulWidget {
  const TestpsikologScreen({Key? key}) : super(key: key);

  @override
  State<TestpsikologScreen> createState() => _TestpsikologScreenState();
}

class _TestpsikologScreenState extends State<TestpsikologScreen> {
  // Total waktu dalam detik (2 jam = 7200 detik)
  int remainingSeconds = 7200;
  Timer? _timer;

  final List<Map<String, dynamic>> questions = [
    {
      'question': 'Saat menerima sebuah email, kemungkinan besar saya akan...',

      'options': [
        'Segera membaca dan membalasnya',

        'Menundanya sampai ada waktu luang',

        'Membacanya nanti saja',

        'Langsung menghapusnya',
      ],
    },

    {
      'question': 'Jika ada tugas kelompok, saya biasanya...',

      'options': [
        'Mengambil alih kepemimpinan',

        'Berpartisipasi aktif dalam diskusi',

        'Cenderung diam dan menunggu instruksi',

        'Menyumbangkan ide-ide saja',
      ],
    },

    {
      'question': 'Saat berinteraksi dengan orang lain, saya...',

      'options': [
        'Cenderung memulai pembicaraan',

        'Menunggu dia berbicara terlebih dahulu',

        'Hanya berbicara jika ditanya',

        'Tidak peduli',
      ],
    },

    {
      'question': 'Kalau ada konflik atau masalah, saya...',

      'options': [
        'Mencari solusi secepatnya',

        'Menghindari konfrontasi',

        'Menunggu orang lain menyelesaikannya',

        'Menyalahkan orang lain',
      ],
    },

    {
      'question': 'Saat mengambil sebuah keputusan, saya...',

      'options': [
        'Cenderung terburu-buru',

        'Mempertimbangkan semua pilihan dengan matang',

        'Mengikuti intuisi',

        'Meminta orang lain memutuskan',
      ],
    },

    {
      'question': 'Saat menghadapi sebuah masalah baru, saya...',

      'options': [
        'Langsung cari solusi',

        'Menganalisis situasi secara mendalam',

        'Menyerah begitu saja',

        'Meminta bantuan orang lain',
      ],
    },

    {
      'question': 'Saya lebih suka bekerja...',

      'options': [
        'Sendirian',

        'Dalam tim kecil',

        'Dalam tim besar',

        'Tidak peduli dengan siapa saya bekerja',
      ],
    },

    {
      'question': 'Dalam lingkungan kerja, saya lebih suka...',

      'options': [
        'Pekerjaan yang terstruktur dan teratur',

        'Pekerjaan yang dinamis dan bervariasi',

        'Pekerjaan yang monoton',

        'Pekerjaan yang tidak terstruktur',
      ],
    },

    {
      'question': 'Saat merasa stres, saya cenderung...',

      'options': [
        'Mencari cara untuk mengelola stres',

        'Menyendiri',

        'Makan berlebihan',

        'Menangis',
      ],
    },

    {
      'question': 'Dalam membuat keputusan pribadi, saya...',

      'options': [
        'Meminta saran orang lain',

        'Memutuskan sendiri',

        'Menunda keputusan',

        'Tidak tahu harus berbuat apa',
      ],
    },

    {
      'question': 'Ketika menghadapi situasi baru, saya...',

      'options': [
        'Antusias dan cepat beradaptasi',

        'Cenderung hati-hati dan membutuhkan waktu untuk beradaptasi',

        'Merasa cemas',

        'Menghindari situasi baru',
      ],
    },

    {
      'question': 'Jika ada perubahan rencana, saya...',

      'options': [
        'Menerimanya dengan fleksibel',

        'Merasa frustasi',

        'Menolak perubahan',

        'Tidak peduli',
      ],
    },

    {
      'question': 'Saya lebih suka...',

      'options': [
        'Membaca buku',

        'Menonton film',

        'Mendengarkan musik',

        'Berinteraksi sosial',
      ],
    },

    {
      'question': 'Saat menghadapi sebuah tantangan, saya...',

      'options': [
        'Termotivasi untuk mengatasinya',

        'Merasa terbebani',

        'Menyerah begitu saja',

        'Mengabaikannya',
      ],
    },

    {
      'question': 'Saat diberi kritik, saya...',

      'options': [
        'Menerimanya dengan terbuka',

        'Merasa tersinggung',

        'Menolak kritik',

        'Tidak peduli',
      ],
    },

    {
      'question': 'Saya merasa puas jika...',

      'options': [
        'Mampu mencapai tujuan',

        'Mendapat pujian',

        'Tidak melakukan kesalahan',

        'Menyelesaikan tugas dengan cepat',
      ],
    },

    {
      'question': 'Dalam belajar, saya lebih suka...',

      'options': [
        'Mencari tahu sendiri',

        'Diajari oleh orang lain',

        'Belajar secara mandiri',

        'Belajar bersama teman',
      ],
    },

    {
      'question': 'Saat ada konflik, saya...',

      'options': [
        'Mencari penyelesaian yang adil',

        'Menghindari konflik',

        'Meninggalkan situasi tersebut',

        'Mencari dukungan dari orang lain',
      ],
    },

    {
      'question': 'Saya lebih suka menghabiskan waktu luang dengan...',

      'options': [
        'Aktivitas yang menantang',

        'Bersantai di rumah',

        'Bersosialisasi',

        'Tidur',
      ],
    },

    {
      'question': 'Ketika ada perubahan di tempat kerja, saya...',

      'options': [
        'Menyesuaikan diri dengan cepat',

        'Merasa tidak nyaman',

        'Menolak perubahan',

        'Mengeluh',
      ],
    },

    {
      'question': 'Apakah Anda suka menjadi pusat perhatian?',

      'options': [
        'Ya, sangat suka',

        'Terkadang',

        'Tidak terlalu suka',

        'Tidak suka sama sekali',
      ],
    },

    {
      'question': 'Dalam mengambil keputusan, Anda cenderung...',

      'options': [
        'Analitis dan logis',

        'Emosional',

        'Intuisi',

        'Mengikuti orang lain',
      ],
    },

    {
      'question': 'Saat berhadapan dengan kegagalan, Anda...',

      'options': [
        'Belajar dari kesalahan dan bangkit lagi',

        'Merasa sangat kecewa',

        'Menyalahkan diri sendiri',

        'Menyerah',
      ],
    },

    {
      'question': 'Bagaimana Anda mengatasi tekanan?',

      'options': [
        'Tetap tenang dan fokus',

        'Merasa panik dan cemas',

        'Menghindari situasi yang menekan',

        'Mencari bantuan dari orang lain',
      ],
    },

    {
      'question': 'Ketika Anda merasa tidak termotivasi, Anda...',

      'options': [
        'Mencari inspirasi dan tujuan baru',

        'Menyerah pada perasaan itu',

        'Mengeluh',

        'Tidur panjang',
      ],
    },

    {
      'question':
          'Bagaimana Anda berinteraksi dengan orang yang tidak Anda kenal?',

      'options': [
        'Membuka diri dan mencoba berkenalan',

        'Cenderung pendiam dan menjaga jarak',

        'Merasa canggung',

        'Tidak peduli',
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
                        'psikolog',
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
