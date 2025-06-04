// ignore_for_file: unused_local_variable

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:ppdb_be/core/models/daftar_test.dart';
import 'package:ppdb_be/core/models/siswa_model.dart';
import 'package:ppdb_be/core/router/App_router.dart';
import 'package:ppdb_be/service/hasil_test_service.dart';
import 'package:ppdb_be/service/soal_service.dart';

class TestScreen extends StatefulWidget {
  final kategorisoalModel kategori;
  final SiswaModel siswa;
  const TestScreen({super.key, required this.kategori, required this.siswa});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  String? userId;
  int remainingSeconds = 7200;
  Timer? _timer;
  List<SoalTest> soalList = [];
  final Map<int, int> selectedAnswers = {};
  bool isLoading = true;
  bool isSubmit = false;

  @override
  void initState() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userId = user.uid;
      print("User ID di initState: $userId");
    }
    super.initState();
    startTimer();
    fetchSoal();
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
      } else {
        setState(() {
          remainingSeconds--;
        });
      }
    });
  }

  void fetchSoal() async {
    final soalService = SoalService();
    final data = await soalService.fetchSoalByKategori(
      widget.kategori.nama_pelajaran,
    );
    print("isi soal data: $data");
    setState(() {
      soalList = data;
      isLoading = false;
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child:
              isLoading
                  ? Center(
                    child: Lottie.asset(
                      'assets/animations/loadingHome.json',
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  )
                  : Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed:
                                () => context.goNamed(
                                  Routes.daftar_test,
                                  extra: widget.siswa,
                                ),
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
                            child: Text(
                              widget.kategori.nama_pelajaran,
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
                          itemCount: soalList.length,
                          itemBuilder: (context, index) {
                            final soal = soalList[index];
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
                                    '${index + 1}. ${soal.pertanyaan}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  ...List.generate(soal.opsiJawaban.length, (
                                    optIdx,
                                  ) {
                                    return RadioListTile<int>(
                                      contentPadding: EdgeInsets.zero,
                                      title: Text(soal.opsiJawaban[optIdx]),
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
                          onPressed:
                              isSubmit
                                  ? null
                                  : () async {
                                    setState(() {
                                      isSubmit = true;
                                    });
                                    int hasilSkor = 0;
                                    List<Map<String, dynamic>> jawabanDetail =
                                        [];

                                    for (int i = 0; i < soalList.length; i++) {
                                      final soal = soalList[i];
                                      final selected = selectedAnswers[i];
                                      final isBenar =
                                          selected != null &&
                                          soal.opsiJawaban[selected] ==
                                              soal.jawabanBenar;

                                      if (isBenar) hasilSkor += 4;

                                      jawabanDetail.add({
                                        'pertanyaan': soal.pertanyaan,
                                        'jawabanUser':
                                            selected != null
                                                ? soal.opsiJawaban[selected]
                                                : 'Kosong',
                                        'jawabanBenar': soal.jawabanBenar,
                                        'benar': isBenar,
                                      });
                                    }

                                    final userId =
                                        FirebaseAuth.instance.currentUser?.uid;

                                    if (userId == null) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Data pendaftaran tidak ditemukan',
                                          ),
                                        ),
                                      );
                                      return;
                                    }

                                    final namaSiswa = widget.siswa.nama;
                                    print("Siswa data: $namaSiswa");
                                    print("Siswa data: ${widget.siswa.nama}");

                                    final hasilService = HasilTestService();
                                    await hasilService.simpanHasilTest(
                                      userId: userId,
                                      namaSiswa: namaSiswa,
                                      namaPelajaran:
                                          widget.kategori.nama_pelajaran,
                                      jawaban: jawabanDetail,
                                      skor: hasilSkor,
                                    );

                                    setState(() {
                                      isSubmit = false;
                                    });

                                    context.goNamed(
                                      Routes.hasil_test,
                                      extra: {
                                        'selectedAnswers': selectedAnswers,
                                        'soalList': soalList,
                                        'skor': hasilSkor,
                                        'siswa': widget.siswa,
                                      },
                                    );
                                  },

                          child:
                              isSubmit
                                  ? CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 4,
                                  )
                                  : Text(
                                    'Submit',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                        ),
                      ),
                    ],
                  ),
        ),
      ),
    );
  }
}
