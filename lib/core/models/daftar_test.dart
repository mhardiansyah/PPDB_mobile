class SoalTest {
  final String pertanyaan;
  final List<String> opsiJawaban;
  final String jawabanBenar;
  String? kategoriId;

  SoalTest({
    required this.pertanyaan,
    required this.opsiJawaban,
    required this.jawabanBenar,
    this.kategoriId,
  });

  factory SoalTest.fromMap(Map<String, dynamic> map) {
    return SoalTest(
      pertanyaan: map['judul'] ?? '',
      opsiJawaban: List<String>.from(map['jawaban'] ?? []),
      kategoriId: map['kategori_id'] ?? '',
      jawabanBenar:
          map['jawaban_benar'] ??
          map['jawaban benar'] ??
          map['jawaban__benar'] ??
          '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'jawabanBenar': jawabanBenar,
      'kategoriId': kategoriId,
      'pertanyaan': pertanyaan,
      'opsiJawaban': opsiJawaban,
    };
  }
}

class kategorisoalModel {
  final String nama_pelajaran;
  final String deskripsi;
  final String image_url;

  String? userid;
  String? siswaId;

  kategorisoalModel({
    required this.nama_pelajaran,
    this.userid,
    this.deskripsi = '',
    this.image_url = '',
  });

  factory kategorisoalModel.fromJson(Map<String, dynamic> json) {
    return kategorisoalModel(
      deskripsi: (json['deskripsi'] ?? 'tanpa deskripsi') as String,
      image_url: (json['image_url'] ?? '') as String,
      userid: (json['userid'] ?? 'uid') as String,
      nama_pelajaran: (json['nama_pelajaran'] ?? 'tanpa judul') as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userid': userid,
      'deskripsi': deskripsi,
      'image_url': image_url,
      'nama_pelajaran': nama_pelajaran,
    };
  }
}
