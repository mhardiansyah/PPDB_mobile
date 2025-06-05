import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ppdb_be/core/models/siswa_model.dart';
import 'package:ppdb_be/core/router/App_router.dart';
import 'package:ppdb_be/service/Pendaftaran_service.dart';
import 'package:uuid/uuid.dart';

class EditBerkasScreen extends StatefulWidget {
  final SiswaModel? siswadata;
  const EditBerkasScreen({super.key, this.siswadata});

  @override
  State<EditBerkasScreen> createState() => _EditBerkasScreenState();
}

class _EditBerkasScreenState extends State<EditBerkasScreen> {
  final _formKey = GlobalKey<FormState>();
  String? selectedJurusan;
  final List<String> jurusanList = [
    'REKAYASA PERANGKAT LUNAK',
    'TEKNIK KOMPUTER DAN JARINGAN',
  ];

  String? selectedJenisKelamin;

  final List<String> jenisKelaminList = ['Laki-laki', 'Perempuan'];

  // Controllers
  final TextEditingController namaSiswaController = TextEditingController();
  final TextEditingController asalSekolahController = TextEditingController();
  final TextEditingController nisnController = TextEditingController();
  final TextEditingController namaIbuController = TextEditingController();
  final TextEditingController namaAyahController = TextEditingController();
  final TextEditingController pekerjaanIbuController = TextEditingController();
  final TextEditingController pekerjaanAyahController = TextEditingController();
  final TextEditingController noTelpController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController golDarahController = TextEditingController();
  // final TextEditingController jenisKelaminController = TextEditingController();
  final TextEditingController provinsiController = TextEditingController();
  final TextEditingController domisiliController = TextEditingController();
  final TextEditingController kecamatanController = TextEditingController();
  String? userId;

  getData() {
    setState(() {
      namaSiswaController.text = widget.siswadata!.nama;
      selectedJurusan = widget.siswadata!.jurusan;
      asalSekolahController.text = widget.siswadata!.asalSekolah;
      nisnController.text = widget.siswadata!.nisn;
      namaIbuController.text = widget.siswadata!.namaIbu;
      namaAyahController.text = widget.siswadata!.namaAyah;
      pekerjaanIbuController.text = widget.siswadata!.pekerjaanIbu;
      pekerjaanAyahController.text = widget.siswadata!.pekerjaanAyah;
      noTelpController.text = widget.siswadata!.noTelpOrtu;
      alamatController.text = widget.siswadata!.alamat;
      golDarahController.text = widget.siswadata!.golonganDarah;
      selectedJenisKelamin = widget.siswadata!.jenisKelamin;
      provinsiController.text = widget.siswadata!.provinsi;
      domisiliController.text = widget.siswadata!.domisili;
      kecamatanController.text = widget.siswadata!.kecamatan;
    });
  }

  @override
  initState() {
    getData();
    User user = FirebaseAuth.instance.currentUser!;
    print("ID USER IS : ${user.uid}");
    setState(() {
      userId = user.uid;
    });
      super.initState();
  }

  @override
  void dispose() {
    namaSiswaController.dispose();
    asalSekolahController.dispose();
    nisnController.dispose();
    namaIbuController.dispose();
    namaAyahController.dispose();
    pekerjaanIbuController.dispose();
    pekerjaanAyahController.dispose();
    noTelpController.dispose();
    alamatController.dispose();
    provinsiController.dispose();
    domisiliController.dispose();
    kecamatanController.dispose();
    golDarahController.dispose();
    // jenisKelaminController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(String label, String hint) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: const Text(
          "FORM PENDAFTARAN SISWA",
          style: TextStyle(fontSize: 16, color: Colors.white),
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: namaSiswaController,
                  decoration: _inputDecoration("Nama Siswa", "Michael"),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedJurusan,
                  decoration: _inputDecoration(
                    "Pilih Jurusan",
                    "Pilih salah satu",
                  ),
                  items:
                      jurusanList
                          .map(
                            (jurusan) => DropdownMenuItem(
                              value: jurusan,
                              child: Text(jurusan),
                            ),
                          )
                          .toList(),
                  onChanged: (value) => setState(() => selectedJurusan = value),
                  validator:
                      (value) => value == null ? 'Jurusan harus dipilih' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: asalSekolahController,
                  decoration: _inputDecoration("Asal Sekolah", "SMKN 1 Kediri"),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: nisnController,
                  decoration: _inputDecoration("NISN", "0292122133"),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: namaIbuController,
                        decoration: _inputDecoration("Nama Ibu", "Mita"),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: namaAyahController,
                        decoration: _inputDecoration("Nama Ayah", "Jackson"),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: pekerjaanIbuController,
                        decoration: _inputDecoration(
                          "Pekerjaan Ibu",
                          "Juru Masak",
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: pekerjaanAyahController,
                        decoration: _inputDecoration(
                          "Pekerjaan Ayah",
                          "Programmer",
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: noTelpController,
                  decoration: _inputDecoration(
                    "No. Telpon Orang Tua",
                    "085134223134",
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: alamatController,
                  decoration: _inputDecoration(
                    "Alamat rumah",
                    "Kediri, Pare...",
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: provinsiController,
                        decoration: _inputDecoration("Provinsi", "Jawa barat"),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: domisiliController,
                        decoration: _inputDecoration("Domisili", "kab.bandung"),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: kecamatanController,
                  decoration: _inputDecoration("Kecamatan", "ciwidey"),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: golDarahController,
                        decoration: _inputDecoration("Golongan Darah", "AB+"),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: selectedJenisKelamin,
                        decoration: _inputDecoration(
                          "Pilih Jenis Kelamin",
                          "Pilih salah satu",
                        ),
                        items:
                            jenisKelaminList
                                .map(
                                  (jenisKelamin) => DropdownMenuItem(
                                    value: jenisKelamin,
                                    child: Text(jenisKelamin),
                                  ),
                                )
                                .toList(),
                        onChanged:
                            (value) =>
                                setState(() => selectedJenisKelamin = value),
                        validator:
                            (value) =>
                                value == null
                                    ? 'Jenis kelamin harus dipilih'
                                    : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final siswa = SiswaModel(
                        id: const Uuid().v4(),
                        userid: userId,
                        nama: namaSiswaController.text,
                        jurusan: selectedJurusan ?? '',
                        asalSekolah: asalSekolahController.text,
                        nisn: nisnController.text,
                        namaIbu: namaIbuController.text,
                        namaAyah: namaAyahController.text,
                        pekerjaanIbu: pekerjaanIbuController.text,
                        pekerjaanAyah: pekerjaanAyahController.text,
                        noTelpOrtu: noTelpController.text,
                        alamat: alamatController.text,
                        provinsi: provinsiController.text,
                        domisili: domisiliController.text,
                        kecamatan: kecamatanController.text,
                        golonganDarah: golDarahController.text,
                        // jenisKelamin: jenisKelaminController.text,
                        jenisKelamin: selectedJenisKelamin ?? '',
                      );

                      await PendaftaranService().addSiswa(siswa);

                      context.goNamed(Routes.formFiles, extra: siswa);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Selanjutnya",
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
