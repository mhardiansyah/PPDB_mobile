import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:ppdb_be/core/models/daftar_test.dart';
import 'package:ppdb_be/core/models/siswa_model.dart';
import 'package:ppdb_be/core/router/App_router.dart';
import 'package:ppdb_be/service/soal_service.dart';
import 'package:ppdb_be/service/hasil_test_service.dart';

class DaftarTestScreen extends StatefulWidget {
  final SiswaModel siswa;
  const DaftarTestScreen({super.key, required this.siswa});

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
  bool showSudahSelesai = false;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    print("User ID: ${user?.uid}");
    print("User ID: ${FirebaseAuth.instance.currentUser?.uid}");

    siswa = widget.siswa;
    if (user != null) {
      userId = user.uid;
      fetchData();
    }
  }

  Future<void> fetchData() async {
    final kategori = await _soalService.fetchKategoriSoal();
    final sudahDikerjakan = await _hasilTestService
        .getKategoriYangSudahDikerjakan(userId!);
    print("List kategori: ${kategori.map((e) => e.nama_pelajaran)}");
    print("Sudah dikerjakan: $sudahDikerjakan");

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
              ? Center(
                child: Lottie.asset(
                  'assets/animations/loadingHome.json',
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              )
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FilterChip(
                          label: const Text("Belum selesai"),
                          selected: !showSudahSelesai,
                          selectedColor: const Color(0xFF278550),
                          checkmarkColor: Colors.white,
                          labelStyle: TextStyle(
                            color:
                                !showSudahSelesai ? Colors.white : Colors.black,
                          ),
                          onSelected: (_) {
                            setState(() {
                              showSudahSelesai = false;
                            });
                          },
                        ),
                        const SizedBox(width: 10),
                        FilterChip(
                          label: const Text("Sudah selesai"),
                          selected: showSudahSelesai,
                          selectedColor: const Color(0xFF278550),
                          checkmarkColor: Colors.white,
                          labelStyle: TextStyle(
                            color:
                                showSudahSelesai ? Colors.white : Colors.black,
                          ),
                          onSelected: (_) {
                            setState(() {
                              showSudahSelesai = true;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    Expanded(
                      child: ListView.builder(
                        itemCount: _kategoriSoalList.length,
                        itemBuilder: (context, index) {
                          final item = _kategoriSoalList[index];
                          print("Deskripsi: ${item.deskripsi}");
                          final sudahDikerjakan = sudahDikerjakanList.contains(
                            item.nama_pelajaran,
                          );

                          if (showSudahSelesai && !sudahDikerjakan)
                            return const SizedBox();
                          if (!showSudahSelesai && sudahDikerjakan)
                            return const SizedBox();

                          return Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.horizontal(
                                    left: Radius.circular(5),
                                    right: Radius.circular(5),
                                  ),
                                  child: Image.network(
                                    item.image_url,
                                    width: 120,
                                    height: 190,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (
                                          context,
                                          error,
                                          stackTrace,
                                        ) => Image.asset(
                                          'assets/images/default_gambar.png',
                                          width: 120,
                                          height: 120,
                                          fit: BoxFit.cover,
                                        ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.nama_pelajaran,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          item.deskripsi,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black87,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),

                                        const SizedBox(height: 12),
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.access_time,
                                                  size: 16,
                                                  color: Colors.grey,
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  "120 Menit",
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(width: 16),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.list_alt,
                                                  size: 16,
                                                  color: Colors.grey,
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  "Jumlah: 25 Soal",
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  sudahDikerjakan
                                                      ? Colors.grey
                                                      : const Color(0xFF278550),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical: 8,
                                                  ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              elevation: 0,
                                            ),
                                            onPressed:
                                                sudahDikerjakan
                                                    ? null
                                                    : () {
                                                      context.goNamed(
                                                        Routes.test_screen,
                                                        extra: {
                                                          'item': item,
                                                          'siswa': siswa,
                                                        },
                                                      );
                                                    },
                                            child: Text(
                                              sudahDikerjakan
                                                  ? "Sudah dikerjakan"
                                                  : "Mulai tes",
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
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
