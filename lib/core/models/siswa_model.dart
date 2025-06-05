
class SiswaModel {
  String? id;
  String? userid;
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
  String provinsi;
  String domisili;
  String kecamatan;
  String golonganDarah;
  String jenisKelamin;
  String status;

  SiswaModel({
    this.id,
    required this.userid,
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
    required this.provinsi,
    required this.domisili,
    required this.kecamatan,
    required this.golonganDarah,
    required this.jenisKelamin,
    this.status = 'pending',
  });


  Map<String, dynamic> toJson() => {
    'id': id,
    'userid': userid,
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
    'provinsi': provinsi,
    'domisili': domisili,
    'kecamatan': kecamatan,
    'golonganDarah': golonganDarah,
    'jenisKelamin': jenisKelamin,
    'status': status,
  };

  factory SiswaModel.fromJson(Map<String, dynamic> json) => SiswaModel(
    id: json['id'],
    userid: json['userid'],
    nama: json['nama'],
    jurusan: json['jurusan'],
    asalSekolah: json['asalSekolah'],
    nisn: json['nisn'],
    namaIbu: json['namaIbu'],
    namaAyah: json['namaAyah'],
    pekerjaanIbu: json['pekerjaanIbu'],
    pekerjaanAyah: json['pekerjaanAyah'],
    noTelpOrtu: json['noTelpOrtu'],
    alamat: json['alamat'],
    provinsi: json['provinsi'],
    domisili: json['domisili'],
    kecamatan: json['kecamatan'],
    golonganDarah: json['golonganDarah'],
    jenisKelamin: json['jenisKelamin'],
    status: json['status'] ?? 'pending',
  );
}
