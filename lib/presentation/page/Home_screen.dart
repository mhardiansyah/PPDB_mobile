import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:ppdb_be/core/models/pembayaran_model.dart';
import 'package:ppdb_be/core/models/siswa_model.dart';
import 'package:ppdb_be/core/router/App_router.dart';
import 'package:ppdb_be/service/Pendaftaran_service.dart';
import 'package:ppdb_be/service/auth_service.dart';
import 'package:ppdb_be/service/pembayaran_service.dart';
import 'package:ppdb_be/service/pembayaran_uang_masuk_service.dart';
import 'package:ppdb_be/widgets/SiswaCard.dart';
import 'package:ppdb_be/widgets/berkas.dart';
import 'package:ppdb_be/widgets/notif_failed.dart';
import 'package:ppdb_be/widgets/notif_succes.dart';
import 'package:qr_flutter/qr_flutter.dart';

class HomeScreen extends StatefulWidget {
  // final PembayaranModel? pembayaran;
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  String? userId;
  bool isSudahDaftar = false;
  bool isSudahcomplete = false;
  bool isSudahbayar = false;
  bool isSudahbayarUangMasuk = false;
  bool isSudahTest = false;
  bool isDiterima = false;
  bool isDitolak = false;
  bool showPembayaranQr = false;
  SiswaModel? siswa;
  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userId = user.uid;
      cekPendaftaran(user.uid);
      cekberkas(user.uid);
      ceksudahTest(user.uid);
      cekDiterima(user.uid);
      cekIsDitolak(user.uid);
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

    if (firstData.isNotEmpty) {
      final siswaId = firstData[0].id;
      cekPembayaran(siswaId!);
      cekPembayaranUangMasuk(siswaId);
    }
  }

  void cekberkas(String uid) async {
    final stream = PendaftaranService().getBerkasByUserId(uid);
    final firstData = await stream.first;

    if (mounted) {
      if (firstData.isNotEmpty) {
        final berkas = firstData[0];
        setState(() {
          isSudahcomplete =
              berkas.foto3x4Url != null &&
              berkas.foto3x4Url!.isNotEmpty &&
              berkas.ijazahUrl != null &&
              berkas.ijazahUrl!.isNotEmpty &&
              berkas.kartuKeluargaUrl != null &&
              berkas.kartuKeluargaUrl!.isNotEmpty &&
              berkas.raporUrl != null &&
              berkas.raporUrl!.isNotEmpty &&
              berkas.suratKeteranganLulusUrl != null &&
              berkas.suratKeteranganLulusUrl!.isNotEmpty &&
              berkas.aktaKelahiranUrl != null &&
              berkas.aktaKelahiranUrl!.isNotEmpty;
        });
      } else {
        setState(() {
          isSudahcomplete = false;
        });
      }
    }
  }

  void cekPembayaran(String siswaId) async {
    final stream = PembayaranService().getPembayaranBySiswaId(siswaId);
    final firstData = await stream.first;
    if (mounted) {
      setState(() {
        isSudahbayar = firstData?.status == 'sudah bayar';
      });
    }
  }

  void cekPembayaranUangMasuk(String siswaId) async {
    final stream = PembayaranUangMasukService().getPembayaranBySiswaId(siswaId);
    final firstData = await stream.first;
    if (mounted) {
      setState(() {
        isSudahbayarUangMasuk = firstData?.status == 'sudah bayar uang masuk';
      });
    } else {
      setState(() {
        isSudahbayarUangMasuk = false;
      });
    }
  }

  void ceksudahTest(String userId) async {
    final hasilTest =
        await FirebaseFirestore.instance
            .collection('hasil_test')
            .where('userId', isEqualTo: userId)
            .get();

    if (mounted) {
      setState(() {
        isSudahTest = hasilTest.docs.length >= 4;
      });
    }
  }

  void cekDiterima(String userId) async {
    final stream = PendaftaranService().getPendaftaranByUserId(userId);
    stream.listen((siswaList) {
      if (mounted) {
        setState(() {
          if (siswaList.isNotEmpty) {
            final siswa = siswaList.first;
            isDiterima = siswa.status == 'accepted';
            isDitolak = siswa.status == 'ditolak';
          } else {
            isDiterima = false;
            isDitolak = false;
          }
        });
      }
    });
  }

  void cekIsDitolak(String userId) async {
    final stream = PendaftaranService().getPendaftaranByUserId(userId);
    stream.listen((siswaList) {
      if (mounted) {
        setState(() {
          isDitolak =
              siswaList.isNotEmpty && siswaList.first.status == 'ditolak';
        });
      }
    });
  }

  void tampilkanQRPembayaran() {
    setState(() {
      showPembayaranQr = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
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
              SizedBox(width: screenWidth * 0.02),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SMK KREATIF NUSANTARA',
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Kab. Bogor',
                    style: TextStyle(
                      fontSize: screenWidth * 0.03,
                      color: Colors.white,
                    ),
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
                      backgroundImage:
                          user.photoURL != null
                              ? NetworkImage(user.photoURL!)
                              : Image.asset('assets/icons/logoBaru.png').image,
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
            // ListTile(
            //   leading: const Icon(Icons.text_snippet_outlined),
            //   title: const Text('Test'),
            //   onTap: () {
            //     if (siswa == null) {
            //       context.goNamed(Routes.notFound);
            //     } else {
            //       context.goNamed(Routes.daftar_test, extra: siswa);
            //     }
            //   },
            // ),
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
              ? Center(
                child: Lottie.asset(
                  'assets/animations/loadingData.json',
                  width: 100,
                  height: 100,
                  repeat: true,
                ),
              )
              : SingleChildScrollView(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        'assets/images/bgHome.png',
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width * 1.5,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 10,
                      ),
                      child: Column(
                        children: [
                          Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                buildWelcomeHeader(
                                  FirebaseAuth
                                          .instance
                                          .currentUser
                                          ?.displayName ??
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
                                          child: Lottie.asset(
                                            'assets/animations/loadingData.json',
                                            width: 100,
                                            height: 100,
                                            repeat: true,
                                          ),
                                        );
                                      }

                                      if (!snapshot.hasData ||
                                          snapshot.data!.isEmpty) {
                                        return const Center(
                                          child: Text(
                                            "kamu belum mendaftar di PPDB ini",
                                          ),
                                        );
                                      }

                                      final siswaList = snapshot.data!;
                                      return Column(
                                        children:
                                            siswaList
                                                .map(
                                                  (siswa) =>
                                                      buildSiswaContainer(
                                                        siswa,
                                                      ),
                                                )
                                                .toList(),
                                      );
                                    },
                                  ),
                                ),
                                Center(
                                  child:
                                      isSudahcomplete
                                          ? Container(
                                            width: 194,
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 24,
                                              vertical: 8,
                                            ),
                                            margin: EdgeInsets.only(top: 40),
                                            decoration: BoxDecoration(
                                              color: Color(0xFF1B884B),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                color: Color(0xFFFFFFFF),
                                                width: 2,
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                "Pengumuman",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                          )
                                          : null,
                                ),

                                const SizedBox(height: 20),
                                Center(
                                  child:
                                      isSudahcomplete
                                          ? buildPengumumanContainer(context)
                                          : null,
                                ),
                                const SizedBox(height: 20),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 10,
                                  ),

                                  height: 300,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF278550),
                                    border: Border.all(color: Colors.white),
                                    borderRadius: BorderRadius.circular(12),
                                  ),

                                  child: Column(
                                    children: [
                                      Center(
                                        child: Text(
                                          "Fasilitas",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      GridView.count(
                                        crossAxisCount: 3,
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        mainAxisSpacing: 8,
                                        crossAxisSpacing: 4,

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
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
      case 'complete':
        return Colors.orangeAccent;
      case 'verifikasi':
        return Colors.blue;
      case 'accepted':
        return Colors.green;
      case 'ditolak':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String? status) {
    switch (status) {
      case 'pending':
        return 'Pending';
      case 'complete':
        return 'berkas diterima';
      case 'verifikasi':
        return 'Sedang Diverifikasi';
      case 'accepted':
        return 'Diterima';
      case 'ditolak':
        return 'Ditolak';
      default:
        return 'Belum lengkap';
    }
  }

  Color _getStatusPengumumanColor(String? status) {
    switch (status) {
      case 'belum bayar':
        return Colors.orangeAccent;
      case 'verifikasi':
        return Colors.blue;
      case 'sudah bayar':
        return Colors.greenAccent;
      case 'diterima':
        return Colors.green;
      case 'ditolak':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusPengumumanText(String? status) {
    switch (status) {
      case 'belum bayar':
        return 'belum bayar';
      case 'verifikasi':
        return 'Sedang Diverifikasi';
      case 'sudah bayar':
        return 'sudah bayar';
      case 'diterima':
        return 'Diterima';
      case 'ditolak':
        return 'Ditolak';
      default:
        return 'Belum bayar';
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

  Widget buildPengumumanContainer(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return StreamBuilder<List<SiswaModel>>(
          stream: PendaftaranService().getPendaftaranByUserId(userId!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator.adaptive(
                  backgroundColor: Colors.green,
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(Colors.green),
                ),
              );
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("Data siswa tidak tersedia"));
            }

            final siswaList = snapshot.data!;
            final siswa = siswaList.first;

            String pesan1;
            String pesan2;
            String pesan3;
            String pesan4;
            Color warnabtn;

            if (isSudahbayarUangMasuk) {
              pesan1 =
                  'Selamat, Anda sudah membayar uang masuk. Siswa dengan nama: ${siswa.nama} telah diterima di SMK KREATIF NUSANTARA.';
              pesan2 =
                  'Terima kasih telah mengikuti PPDB SMK KREATIF NUSANTARA.';
              pesan3 = '';
              pesan4 = 'DONE';
              warnabtn = Color(0xFF278550);
            } else if (isDiterima) {
              pesan1 =
                  'Berdasarkan hasil pemeriksaan Test, calon santri atas nama ${siswa.nama} dinyatakan';
              pesan2 = 'Lulus';
              pesan3 = 'Silahkan untuk melanjutkan pembayaran uang masuk.';
              pesan4 = 'Silahkan lanjutkan pembayaran';
              warnabtn = Color(0xFFFCAA09);
            } else if (isDitolak) {
              pesan1 =
                  'Berdasarkan hasil pemeriksaan Test, calon santri atas nama ${siswa.nama} dinyatakan';
              pesan2 = 'Tidak Lulus';
              pesan3 = 'Silahkan untuk coba lagi di tahun depan.';
              pesan4 = '';
              warnabtn = Color(0xFFFCAA09);
            } else if (!isSudahbayar) {
              pesan1 =
                  'Berdasarkan hasil pemeriksaan berkas, calon santri atas nama ${siswa.nama} dinyatakan lolos seleksi administrasi.';
              pesan2 =
                  'Selanjutnya, mohon untuk segera melakukan pembayaran uang tes sebagai syarat mengikuti tahap berikutnya dalam proses PPDB Tahun Pelajaran 2024/2025.';
              pesan3 = 'Pembayaran';
              pesan4 = '';
              warnabtn = Color(0xFFFCAA09);
            } else if (isSudahbayar && !isSudahTest) {
              pesan1 =
                  'Terima kasih, kami telah menerima pembayaran uang tes Anda.';
              pesan2 =
                  'Selanjutnya, calon santri dijadwalkan untuk mengikuti tahap ujian seleksi masuk SMK KREATIF NUSANTARA Tahun Pelajaran 2024/2025.';
              pesan3 = 'Mulai test';
              pesan4 = '';
              warnabtn = Color(0xFFFCAA09);
            } else if (isSudahbayar && isSudahTest) {
              pesan1 =
                  'Silahkan tunggu untuk informasi lebih lanjut tentang hasil ujian seleksi masuk SMK KREATIF NUSANTARA Tahun Pelajaran 2024/2025.';
              pesan2 = 'Selamat menjadi siswa baru di SMK KREATIF NUSANTARA';
              pesan3 = 'Done';
              pesan4 = '';
              warnabtn = Color(0xFF278550);
            } else {
              pesan1 = 'Status pendaftaran tidak diketahui.';
              pesan2 = '';
              pesan3 = '';
              pesan4 = '';
              warnabtn = Colors.grey;
            }

            return StreamBuilder<PembayaranModel?>(
              stream: PembayaranService().getPembayaranBySiswaId(siswa.id!),
              builder: (context, pembayaranSnapshot) {
                if (pembayaranSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator.adaptive());
                }

                final pembayaran = pembayaranSnapshot.data;
                print("Status Pembayaran: ${pembayaran?.status}");
                print("User ID: $userId");
                print("Show Pembayaran: ${showPembayaranQr}");
                print("Show Pembayaran Uang masuk: ${isSudahbayarUangMasuk}");
                return Container(
                  width: 416,
                  margin: EdgeInsets.only(bottom: 20),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Color(0xFF278550),
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Pengumuman PPDB SMK KREATIF NUSANTARA Tahun Pelajaran\n 2024/2025',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 40),

                      if (isDiterima) ...[
                        Text(
                          pesan1,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),

                        SizedBox(height: 20),
                        Center(
                          child: Text(
                            pesan2,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              color: Color(0xFFFCAA09),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          pesan3,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 80),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed:
                                  isSudahbayarUangMasuk
                                      ? null
                                      : () {
                                        if (isDiterima) {
                                          context.goNamed(
                                            Routes.pembayaran,
                                            extra: siswa,
                                          );
                                        } else if (!isSudahbayar) {
                                          context.goNamed(
                                            Routes.pembayaran,
                                            extra: siswa,
                                          );
                                        } else if (isSudahbayar &&
                                            !isSudahTest) {
                                          context.goNamed(
                                            Routes.daftar_test,
                                            extra: siswa,
                                          );
                                        } else if (isSudahbayar &&
                                            isSudahTest) {
                                          null;
                                          print("ada masalah");
                                        }
                                      },

                              style: ElevatedButton.styleFrom(
                                backgroundColor: warnabtn,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                pesan4,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ] else if (isDitolak) ...[
                        Text(
                          pesan1,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),

                        SizedBox(height: 20),
                        Center(
                          child: Text(
                            pesan2,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              color: Color(0xFFFCAA09),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          pesan3,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 80),
                      ] else if (isSudahbayarUangMasuk) ...[
                        Text(
                          pesan1,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),

                        SizedBox(height: 20),
                        Center(
                          child: Text(
                            pesan2,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              color: Color(0xFFFCAA09),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          pesan3,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 80),
                      ] else ...[
                        Text(
                          pesan1,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),

                        SizedBox(height: 80),
                        Text(
                          pesan2,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                        SizedBox(height: 80),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _getStatusPengumumanColor(
                                  pembayaran?.status,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'Status: ${_getStatusPengumumanText(pembayaran?.status)}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                if (!isSudahbayar) {
                                  context.goNamed(
                                    Routes.pembayaran,
                                    extra: siswa,
                                  );
                                } else if (isSudahbayar && !isSudahTest) {
                                  context.goNamed(
                                    Routes.daftar_test,
                                    extra: siswa,
                                  );
                                } else if (isSudahbayar && isSudahTest) {
                                  null;
                                }
                              },

                              style: ElevatedButton.styleFrom(
                                backgroundColor: warnabtn,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                pesan3,
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
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget buildSiswaContainer(SiswaModel siswa) {
    return Container(
      width: 416,
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF278550),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "DATA SISWA",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildDetailWithIcon(Icons.person, "Nama", siswa.nama ?? "-"),
          _buildDetailWithIcon(Icons.school, "Jurusan", siswa.jurusan ?? "-"),
          _buildDetailWithIcon(
            Icons.business,
            "Asal Sekolah",
            siswa.asalSekolah ?? "-",
          ),
          _buildDetailWithIcon(
            Icons.male,
            "Jenis Kelamin",
            siswa.jenisKelamin ?? "-",
          ),
          _buildDetailWithIcon(Icons.home, "Domisili", siswa.domisili ?? "-"),
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
                onPressed:
                    isSudahcomplete
                        ? null
                        : () {
                          context.goNamed(Routes.lihatfiles, extra: siswa);
                        },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isSudahcomplete ? Color(0xFF278550) : Color(0xFFFCAA09),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  isSudahcomplete ? "Sudah Complete" : "Belum upload berkas",
                  style: TextStyle(
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
      width: 120,
      child: Container(
        padding: EdgeInsets.only(top: 10, bottom: 6, left: 8, right: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xFF278550)),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Image.asset(imagePath, height: 48, fit: BoxFit.contain),
            const SizedBox(height: 7),
            Text(
              title,
              style: TextStyle(fontSize: 9, color: Colors.indigo[900]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailWithIcon(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 8),
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
