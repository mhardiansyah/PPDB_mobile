class PendaftaranModel {
  String? id;
  String nama;
  String jurusan;
  String asalSekolah;
  String nisn;
  String namaIbu;
  String namaAyah;
  String pekerjaanIbu;
  String pekerjaanAyah;
  String noTelpOrtu;
  String alamat;
  String golonganDarah;
  String jenisKelamin;

  // URL berkas yang diupload
  String foto3x4Url;
  String ijazahUrl;
  String kartuKeluargaUrl;
  String raporUrl;
  String suratKeteranganLulusUrl;
  String aktaKelahiranUrl;

  String status; 

  PendaftaranModel({
    this.id,
    required this.nama,
    required this.jurusan,
    required this.asalSekolah,
    required this.nisn,
    required this.namaIbu,
    required this.namaAyah,
    required this.pekerjaanIbu,
    required this.pekerjaanAyah,
    required this.noTelpOrtu,
    required this.alamat,
    required this.golonganDarah,
    required this.jenisKelamin,
    required this.foto3x4Url,
    required this.ijazahUrl,
    required this.kartuKeluargaUrl,
    required this.raporUrl,
    required this.suratKeteranganLulusUrl,
    required this.aktaKelahiranUrl,
    this.status = 'pending',
  });

  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'jurusan': jurusan,
      'asalSekolah': asalSekolah,
      'nisn': nisn,
      'namaIbu': namaIbu,
      'namaAyah': namaAyah,
      'pekerjaanIbu': pekerjaanIbu,
      'pekerjaanAyah': pekerjaanAyah,
      'noTelpOrtu': noTelpOrtu,
      'alamat': alamat,
      'golonganDarah': golonganDarah,
      'jenisKelamin': jenisKelamin,
      'foto3x4Url': foto3x4Url,
      'ijazahUrl': ijazahUrl,
      'kartuKeluargaUrl': kartuKeluargaUrl,
      'raporUrl': raporUrl,
      'suratKeteranganLulusUrl': suratKeteranganLulusUrl,
      'aktaKelahiranUrl': aktaKelahiranUrl,
      'status': status,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
      'jurusan': jurusan,
      'asalSekolah': asalSekolah,
      'nisn': nisn,
      'namaIbu': namaIbu,
      'namaAyah': namaAyah,
      'pekerjaanIbu': pekerjaanIbu,
      'pekerjaanAyah': pekerjaanAyah,
      'noTelpOrtu': noTelpOrtu,
      'alamat': alamat,
      'golonganDarah': golonganDarah,
      'jenisKelamin': jenisKelamin,
      'foto3x4Url': foto3x4Url,
      'ijazahUrl': ijazahUrl,
      'kartuKeluargaUrl': kartuKeluargaUrl,
      'raporUrl': raporUrl,
      'suratKeteranganLulusUrl': suratKeteranganLulusUrl,
      'aktaKelahiranUrl': aktaKelahiranUrl,
      'status': status,
    };
  }

  factory PendaftaranModel.fromMap(String id, Map<String, dynamic> map) {
    return PendaftaranModel(
      id: id,
      nama: map['nama'] ?? '',
      jurusan: map['jurusan'] ?? '',
      asalSekolah: map['asalSekolah'] ?? '',
      nisn: map['nisn'] ?? '',
      namaIbu: map['namaIbu'] ?? '',
      namaAyah: map['namaAyah'] ?? '',
      pekerjaanIbu: map['pekerjaanIbu'] ?? '',
      pekerjaanAyah: map['pekerjaanAyah'] ?? '',
      noTelpOrtu: map['noTelpOrtu'] ?? '',
      alamat: map['alamat'] ?? '',
      golonganDarah: map['golonganDarah'] ?? '',
      jenisKelamin: map['jenisKelamin'] ?? '',
      foto3x4Url: map['foto3x4Url'] ?? '',
      ijazahUrl: map['ijazahUrl'] ?? '',
      kartuKeluargaUrl: map['kartuKeluargaUrl'] ?? '',
      raporUrl: map['raporUrl'] ?? '',
      suratKeteranganLulusUrl: map['suratKeteranganLulusUrl'] ?? '',
      aktaKelahiranUrl: map['aktaKelahiranUrl'] ?? '',
      status: map['status'] ?? 'pending',
    );
  }
}
