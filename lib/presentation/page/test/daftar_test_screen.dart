import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ppdb_be/core/models/daftar_test.dart';
import 'package:ppdb_be/core/models/siswa_model.dart';
import 'package:ppdb_be/core/router/App_router.dart';
import 'package:ppdb_be/service/soal_service.dart';
import 'package:ppdb_be/service/hasil_test_service.dart';

class DaftarTestScreen extends StatefulWidget {
  const DaftarTestScreen({super.key});

  @override
  State<DaftarTestScreen> createState() => _DaftarTestScreenState();
}

class _DaftarTestScreenState extends State<DaftarTestScreen> {
  final SoalService _soalService = SoalService();
  final HasilTestService _hasilTestService = HasilTestService();

  List<kategorisoalModel> _kategoriSoalList = [];
  List<String> sudahDikerjakanList = [];
  bool _isLoading = true;
  String? userId;
  SiswaModel? siswa;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userId = user.uid;
      fetchData();
    }
  }

  Future<void> fetchData() async {
    final kategori = await _soalService.fetchKategoriSoal();
    final sudahDikerjakan = await _hasilTestService
        .getKategoriYangSudahDikerjakan(userId!);

    setState(() {
      _kategoriSoalList = kategori;
      sudahDikerjakanList = sudahDikerjakan;
      _isLoading = false;
    });
  }

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
        leading: BackButton(
          color: Colors.white,
          onPressed: () {
            context.goNamed(Routes.home);
          },
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView.builder(
                  itemCount: _kategoriSoalList.length,
                  itemBuilder: (context, index) {
                    final item = _kategoriSoalList[index];
                    final sudahDikerjakan = sudahDikerjakanList.contains(
                      item.nama_pelajaran,
                    );

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
                            child: Image.network(
                              item.image_url,
                              width: double.infinity,
                              height: 130,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (context, error, stackTrace) => Image.asset(
                                    'assets/images/default_gambar.png',
                                    width: double.infinity,
                                    height: 130,
                                    fit: BoxFit.cover,
                                  ),
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
                                  item.nama_pelajaran,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item.deskripsi,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: const [
                                        Icon(Icons.access_time, size: 16),
                                        SizedBox(width: 4),
                                        Text(
                                          "2 Jam",
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            sudahDikerjakan
                                                ? Colors.grey
                                                : const Color(0xFF278550),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 8,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                      // onPressed:
                                      //     (sudahDikerjakan || siswa == null)
                                      //         ? null
                                      //         : () {
                                      //           print(
                                      //             "Navigating with siswa: $siswa",
                                      //           );
                                      //           context.goNamed(
                                      //             Routes.test_screen,
                                      //             extra: {
                                      //               'item': item,
                                      //               'siswa': siswa,
                                      //             },
                                      //           );
                                      //         },
                                      onPressed: () {
                                        context.goNamed(Routes.test_screen, extra: item);
                                      },

                                      child: Text(
                                        sudahDikerjakan
                                            ? "Sudah dikerjakan"
                                            : "Mulai tes",
                                        style: const TextStyle(
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
