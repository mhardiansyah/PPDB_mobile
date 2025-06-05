import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:ppdb_be/core/models/berkas_model.dart';
import 'package:ppdb_be/core/models/siswa_model.dart';
import 'package:ppdb_be/core/router/App_router.dart';
import 'package:ppdb_be/service/Pendaftaran_service.dart';
import 'package:ppdb_be/service/upload_service.dart';
import 'package:ppdb_be/utils/image_picker_mobile.dart';
import 'package:ppdb_be/utils/image_picker_mobile.dart';
import 'package:ppdb_be/utils/image_picker_web.dart';
import 'package:ppdb_be/widgets/notif_failed.dart';
import 'package:ppdb_be/widgets/notif_succes.dart';
import 'package:ppdb_be/utils/image_picker_web.dart'
    if (dart.library.io) 'package:ppdb_be/utils/image_picker_mobile.dart';

class FormFilesScreen extends StatefulWidget {
  final SiswaModel siswa;
  const FormFilesScreen({super.key, required this.siswa});

  @override
  State<FormFilesScreen> createState() => _FormFilesScreenState();
}

class _FormFilesScreenState extends State<FormFilesScreen> {
  final _formKey = GlobalKey<FormState>();
  List<Uint8List?> selectedFiles = List.filled(6, null);
  List<String?> uploadedUrls = List.filled(6, null);
  bool isLoading = false;

  Future pilihGambar(int index) async {
    Uint8List? image;
    if (kIsWeb) {
    } else {
      image = await pickImageMobile();
    }

    if (image != null) {
      setState(() {
        selectedFiles[index] = image;
      });
    }
  }

  Future _kirimBerkas() async {
    setState(() => isLoading = true);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          content: Lottie.asset(
            'assets/animations/loadingPasir.json',
            width: 200,
            height: 200,
            repeat: true,
          ),
        );
      },
    );

    for (int i = 0; i < selectedFiles.length; i++) {
      if (selectedFiles[i] != null) {
        try {
          final url = await UploadService().uploadImage(selectedFiles[i]!);
          uploadedUrls[i] = url;
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Gagal upload berkas ke-${i + 1}: $e")),
          );
          showDialog(context: context, builder: (context) => NotifFailed());
          setState(() => isLoading = false);
          return;
        }
      }
    }

    final berkas = BerkasModel(
      siswaId: widget.siswa.id.toString(),
      foto3x4Url: uploadedUrls[0],
      ijazahUrl: uploadedUrls[1],
      kartuKeluargaUrl: uploadedUrls[2],
      raporUrl: uploadedUrls[3],
      suratKeteranganLulusUrl: uploadedUrls[4],
      aktaKelahiranUrl: uploadedUrls[5],
    );

    await PendaftaranService().addPendaftaran(
      siswa: widget.siswa,
      berkas: berkas,
      context: context,
    );

    setState(() {
      isLoading = false;
      selectedFiles = List.filled(6, null);
      uploadedUrls = List.filled(6, null);
      widget.siswa.status = 'sedang diproses';
    });
    showDialog(
      context: context,
      builder:
          (context) => SuccessUploadDialog(schoolName: "SMK MADINATULQURAN"),
    );
  }

  @override
  Widget build(BuildContext context) {
    final fileLabels = [
      "Upload Foto 3x4",
      "Upload Ijazah Sekolah",
      "Upload Kartu Keluarga",
      "Upload Raport",
      "Upload Surat Keterangan Lulus",
      "Upload Akta Kelahiran",
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF226D3D),
        title: const Text(
          "ISI BERKAS DATA DIRI SISWA",
          style: TextStyle(fontSize: 16, color: Color(0xFFFFFFFF)),
        ),
        centerTitle: true,
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
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                for (int i = 0; i < 6; i++) ...[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(fileLabels[i]),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => pilihGambar(i),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      foregroundColor: Colors.black,
                      minimumSize: const Size(double.infinity, 50),
                      elevation: 0,
                    ),
                    child: const Text("Upload File"),
                  ),
                  if (selectedFiles[i] != null) ...[
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Image.memory(
                        selectedFiles[i]!,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                ],
                ElevatedButton(
                  onPressed: isLoading ? null : _kirimBerkas,

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF226D3D),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child:
                      isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                            "Kirim Berkas",
                            style: TextStyle(fontSize: 16, color: Colors.white),
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