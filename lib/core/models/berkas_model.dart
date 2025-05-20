class BerkasModel {
  String? id;
  String? siswaId; // Relasi ke SiswaModel

  String? foto3x4Url;
  String? ijazahUrl;
  String? kartuKeluargaUrl;
  String? raporUrl;
  String? suratKeteranganLulusUrl;
  String? aktaKelahiranUrl;

  BerkasModel({
    this.id,
    this.siswaId,
    required this.foto3x4Url,
    required this.ijazahUrl,
    required this.kartuKeluargaUrl,
    required this.raporUrl,
    required this.suratKeteranganLulusUrl,
    required this.aktaKelahiranUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'siswaId': siswaId,
      'foto3x4Url': foto3x4Url,
      'ijazahUrl': ijazahUrl,
      'kartuKeluargaUrl': kartuKeluargaUrl,
      'raporUrl': raporUrl,
      'suratKeteranganLulusUrl': suratKeteranganLulusUrl,
      'aktaKelahiranUrl': aktaKelahiranUrl,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'siswaId': siswaId,
      'foto3x4Url': foto3x4Url,
      'ijazahUrl': ijazahUrl,
      'kartuKeluargaUrl': kartuKeluargaUrl,
      'raporUrl': raporUrl,
      'suratKeteranganLulusUrl': suratKeteranganLulusUrl,
      'aktaKelahiranUrl': aktaKelahiranUrl,
    };
  }

  factory BerkasModel.fromMap(String id, Map<String, dynamic> map) {
    return BerkasModel(
      id: id,
      siswaId: map['siswaId'] ?? '',
      foto3x4Url: map['foto3x4Url'] ?? '',
      ijazahUrl: map['ijazahUrl'] ?? '',
      kartuKeluargaUrl: map['kartuKeluargaUrl'] ?? '',
      raporUrl: map['raporUrl'] ?? '',
      suratKeteranganLulusUrl: map['suratKeteranganLulusUrl'] ?? '',
      aktaKelahiranUrl: map['aktaKelahiranUrl'] ?? '',
    );
  }
  factory BerkasModel.fromJson(String id, Map<String, dynamic> map) {
    return BerkasModel(
      id: id,
      siswaId: map['siswaId'] ?? '',
      foto3x4Url: map['foto3x4Url'] ?? '',
      ijazahUrl: map['ijazahUrl'] ?? '',
      kartuKeluargaUrl: map['kartuKeluargaUrl'] ?? '',
      raporUrl: map['raporUrl'] ?? '',
      suratKeteranganLulusUrl: map['suratKeteranganLulusUrl'] ?? '',
      aktaKelahiranUrl: map['aktaKelahiranUrl'] ?? '',
    );
  }
}
