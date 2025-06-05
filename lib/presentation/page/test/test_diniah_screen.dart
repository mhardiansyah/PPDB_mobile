import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ppdb_be/core/models/daftar_test.dart';
import 'package:ppdb_be/core/router/App_router.dart';
import 'package:ppdb_be/service/soal_service.dart';

class TestDiniahScreen extends StatefulWidget {
  final kategorisoalModel kategori;
  const TestDiniahScreen({super.key, required this.kategori});

  @override
  State<TestDiniahScreen> createState() => _TestDiniahScreenState();
}

class _TestDiniahScreenState extends State<TestDiniahScreen> {
  int remainingSeconds = 7200;
  Timer? _timer;
  List<SoalTest> soalList = [];
  final Map<int, int> selectedAnswers = {};
  bool isLoading = true;

  @override
  void initState() {
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
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed:
                                () => context.goNamed(Routes.daftar_test),
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
                          onPressed: () {
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
    );
  }
}
