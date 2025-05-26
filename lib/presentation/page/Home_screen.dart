import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:ppdb_be/core/models/siswa_model.dart';
import 'package:ppdb_be/core/router/App_router.dart';
import 'package:ppdb_be/service/Pendaftaran_service.dart';
import 'package:ppdb_be/service/auth_service.dart';
import 'package:ppdb_be/widgets/SiswaCard.dart';
import 'package:ppdb_be/widgets/berkas.dart';
import 'package:ppdb_be/widgets/notif_failed.dart';
import 'package:ppdb_be/widgets/notif_succes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  String? userId;
  bool isSudahDaftar = false;
  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userId = user.uid;
      cekPendaftaran(user.uid);
    }
  }

  void cekPendaftaran(String uid) async {
    final stream = PendaftaranService().getPendaftaranByUserId(uid);
    final firstData = await stream.first;
    if (mounted) {
      setState(() {
        isSudahDaftar = firstData.isNotEmpty;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF278550),
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
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
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            FutureBuilder(
              future: FirebaseAuth.instance.authStateChanges().first,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final User user = snapshot.data!;
                  return UserAccountsDrawerHeader(
                    decoration: BoxDecoration(color: Colors.green[700]),
                    accountName: Text(user.displayName ?? 'User'),
                    accountEmail: Text(user.email ?? 'email'),
                    currentAccountPicture: CircleAvatar(
                      backgroundImage: NetworkImage(
                        user.photoURL ?? 'assets/icons/logoBaru.png',
                      ),
                    ),
                  );
                } else {
                  return UserAccountsDrawerHeader(
                    accountName: Text('User'),
                    accountEmail: Text('email'),
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Beranda'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Pengaturan'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.text_snippet_outlined),
              title: const Text('Test'),
              onTap: () {
                context.goNamed(Routes.daftar_test);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Keluar'),
              onTap: () {
                AuthService().logout(context);
              },
            ),
          ],
        ),
      ),
      body:
          userId == null
              ? Center(child: CircularProgressIndicator(color: Colors.green))
              : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 10,
                  ),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.asset(
                          'assets/images/bgHome.png',
                          fit: BoxFit.cover,
                          width: MediaQuery.of(context).size.width * 1.5,
                          height: double.infinity,
                        ),
                      ),
                      Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildWelcomeHeader(
                              FirebaseAuth.instance.currentUser?.displayName ??
                                  'User',
                            ),

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20.0,
                                vertical: 10,
                              ),
                              child: Text(
                                'Selamat Datang di PPDB Online',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                              ),
                              child: StreamBuilder<List<SiswaModel>>(
                                stream: PendaftaranService()
                                    .getPendaftaranByUserId(userId!),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                      child: CircularProgressIndicator.adaptive(
                                        backgroundColor: Colors.green,
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation(
                                          Colors.green,
                                        ),
                                      ),
                                    );
                                  }

                                  if (!snapshot.hasData ||
                                      snapshot.data!.isEmpty) {
                                    return const Center(
                                      child: Text(
                                        "Belum ada data pendaftaran.",
                                      ),
                                    );
                                  }

                                  final siswaList = snapshot.data!;
                                  return Column(
                                    children:
                                        siswaList
                                            .map(
                                              (siswa) =>
                                                  buildSiswaContainer(siswa),
                                            )
                                            .toList(),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 80),
                            Center(
                              child: Container(
                                width: 194,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Color(0xFF1B884B), // Hijau
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text(
                                    "Program",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            GridView.count(
                              crossAxisCount: 3,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,

                              children: [
                                buildFeatureCard(
                                  "Ekstrakurikuler Menarik & Beragam",
                                  "assets/icons/eskul.png",
                                ),
                                buildFeatureCard(
                                  "Pesantren Berbasis IT",
                                  "assets/icons/it.png",
                                ),
                                buildFeatureCard(
                                  "Program Keahlian Sesuai Kebutuhan Industri",
                                  "assets/icons/program.png",
                                ),
                                buildFeatureCard(
                                  "Sertifikat Kompetensi",
                                  "assets/icons/sertifikat.png",
                                ),
                                buildFeatureCard(
                                  "Lingkungan asri",
                                  "assets/icons/asri.png",
                                ),
                                buildFeatureCard(
                                  "Dibimbing oleh Tenaga Pengajar Berpengalaman",
                                  "assets/icons/pengajar.png",
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),

                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  context.goNamed(Routes.daftar_test);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(
                                    0xFFFFA500,
                                  ), // Warna oranye
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  "Ikuti Test",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

      floatingActionButton:
          isSudahDaftar
              ? null
              : ElevatedButton(
                onPressed: () {
                  context.goNamed(Routes.form);
                },
                style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                  maximumSize: Size(182, 79),
                  backgroundColor: Color(0xFF278550),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  "Daftarkan Anak Anda",
                  style: TextStyle(fontSize: 13, color: Colors.white),
                ),
              ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'verifikasi':
        return Colors.blue;
      case 'diterima':
        return Colors.green;
      case 'ditolak':
        return Colors.red;
      default:
        return Colors.grey; // fallback jika null atau status tak dikenal
    }
  }

  String _getStatusText(String? status) {
    switch (status) {
      case 'pending':
        return 'Pending';
      case 'verifikasi':
        return 'Sedang Diverifikasi';
      case 'diterima':
        return 'Diterima';
      case 'ditolak':
        return 'Ditolak';
      default:
        return 'Belum lengkap';
    }
  }

  Widget buildWelcomeHeader(String namaSiswa) {
    return Container(
      width: 397,
      height: 193,
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFF278550), width: 2),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/bgbanner.png',
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width * 1.5,
              height: double.infinity,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo Kiri
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selamat Datang,',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    namaSiswa,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                ],
              ),

              const Spacer(),

              // Foto Siswa Kanan
            ],
          ),
        ],
      ),
    );
  }

  Widget buildSiswaContainer(SiswaModel siswa) {
    return Container(
      width: 392,
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF278550), // warna hijau branding
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "DATA ANAK",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 10),
          _buildDetail("Nama", siswa.nama ?? "-"),
          _buildDetail("Jurusan", siswa.jurusan ?? "-"),
          _buildDetail("Asal Sekolah", siswa.asalSekolah ?? "-"),
          _buildDetail("Jenis Kelamin", siswa.jenisKelamin ?? "-"),
          _buildDetail("Domisili", siswa.domisili ?? "-"),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text("Status: ", style: TextStyle(color: Colors.white)),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(siswa.status),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _getStatusText(siswa.status),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  context.goNamed(Routes.lihatfiles, extra: siswa);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFCAA09),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  "Belum upload Berkas",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildFeatureCard(String title, String imagePath) {
    return SizedBox(
      width: 100,
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Image.asset(imagePath, height: 48, fit: BoxFit.contain),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(fontSize: 12, color: Colors.indigo[900]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetail(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text("$title:", style: TextStyle(color: Colors.white)),
          ),
          Expanded(
            flex: 5,
            child: Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
