import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:ppdb_be/core/models/pembayaran_model.dart';
import 'package:ppdb_be/core/models/siswa_model.dart';
import 'package:ppdb_be/core/router/App_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ppdb_be/service/pembayaran_service.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:uuid/uuid.dart';

class PembayaranScreen extends StatefulWidget {
  final SiswaModel siswa;
  const PembayaranScreen({super.key, required this.siswa});

  @override
  State<PembayaranScreen> createState() => _PembayaranScreenState();
}

class _PembayaranScreenState extends State<PembayaranScreen> {
  final PembayaranService _pembayaranService = PembayaranService();

  PembayaranModel? pembayaran;
  Uint8List? _buktiBayarBytes;
  final ImagePicker _picker = ImagePicker();
  // SiswaModel? siswa;

  @override
  void initState() {
    super.initState();
    SiswaModel siswa = widget.siswa;
    if (siswa != null) {
      print("Siswa ID: ${siswa.id}");
    } else {
      print("Siswa data is null");
    }
  }

  Future<void> _pickImage() async {
  if (kIsWeb) {
    final imageBytes = await ImagePickerWeb.getImageAsBytes();
    if (imageBytes != null) {
      setState(() {
        _buktiBayarBytes = imageBytes;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bukti transfer berhasil dipilih')),
      );
    }
  } else {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _buktiBayarBytes = bytes;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bukti transfer berhasil dipilih')),
      );
    }
  }
}


  Future<void> _submitPembayaran() async {
    final siswaId = widget.siswa.id;
    print("siswaId: $siswaId");

    if (_buktiBayarBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan pilih bukti pembayaran terlebih dahulu.'),
        ),
      );
      return;
    }

    try {
      final buktiPembayaranUrl = await _pembayaranService.uploadBuktiPembayaran(
        _buktiBayarBytes!,
      );

      if (buktiPembayaranUrl == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal upload bukti pembayaran')),
        );
        return;
      }

      await _pembayaranService.tambahPembayaran(
        id: const Uuid().v4(),
        siswaId: siswaId ?? '',
        metodePembayaran: 'Transfer',
        jumlah: 250000,
        buktiBayarBytes: _buktiBayarBytes,
      );


      setState(() {
        pembayaran = PembayaranModel(
          id: const Uuid().v4(),
          siswaId: siswaId ?? '',
          buktiPembayaranUrl: buktiPembayaranUrl,
          tanggalPembayaran: DateTime.now(),
          status: 'sudah bayar',
        );
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pembayaran berhasil ditambahkan')),
      );
      print("Pembayaran sebelum navigasi: $pembayaran");

      context.goNamed(Routes.home);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal tambah pembayaran: $e')));
    }
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF168038),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              onPressed: () {},
              child: const Text(
                "Pembayaran",
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF168038),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Pembayaran uang Test",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  buildRow("Nama", "VALENT PRAKASA ADITYAMOKO"),
                  buildRow("Jurusan", "RPL (Rekayasa Perangkat Lunak)"),
                  buildRow("Nominal Pembayaran", "RP 250.000"),
                  buildRow("No Va", "589678267365"),
                  const SizedBox(height: 24),
                  Center(
                    child: QrImageView(
                      data: "589678267365",
                      size: 150,
                      backgroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 100),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.white),
                          ),
                          onPressed: () => _pickImage(),
                          child: const Text("upload bukti Transfer"),
                        ),
                      ),
                      if (_buktiBayarBytes != null)
                        Column(
                          children: [
                            const SizedBox(height: 20),
                            const Text(
                              'Pratinjau Bukti Pembayaran:',
                              style: TextStyle(color: Colors.white),
                            ),
                            const SizedBox(height: 10),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.memory(
                                _buktiBayarBytes!,
                                width: 100,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                          ),
                          onPressed: () => _submitPembayaran(),
                          child: const Text(
                            "Lanjut ke Tagihan",
                            style: TextStyle(color: Colors.white),
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
      ),
    );
  }

  Widget buildRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text("$title:", style: const TextStyle(color: Colors.white)),
          ),
          Expanded(
            flex: 3,
            child: Text(value, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Color _getStatusPengumumanColor(String? status) {
    switch (status) {
      case 'belum bayar':
        return Colors.orangeAccent;
      case 'verifikasi':
        return Colors.blue;
      case 'sudah bayar':
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
        return 'Belum bayar';
      case 'verifikasi':
        return 'Sedang Diverifikasi';
      case 'sudah bayar':
        return 'Sudah bayar';
      case 'ditolak':
        return 'Ditolak';
      default:
        return 'Belum bayar';
    }
  }
}
