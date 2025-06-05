import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ppdb_be/core/models/daftar_test.dart';

class SoalService {
  final _firestore = FirebaseFirestore.instance;
  final CollectionReference _soal_test = FirebaseFirestore.instance.collection(
    'soal_test',
  );

  Future<List<kategorisoalModel>> fetchKategoriSoal() async {
    try {
      final snapshot = await _firestore.collection('soal_test').get();

      List<kategorisoalModel> kategoriList = [];

      for (var doc in snapshot.docs) {
        final data = doc.data();

        data['nama_pelajaran'] ??= doc.id;

        final kategori = kategorisoalModel.fromJson(data);
        kategoriList.add(kategori);
      }

      return kategoriList;
    } catch (e) {
      print('Error fetching kategori soal: $e');
      return [];
    }
  }

  Future<List<SoalTest>> fetchSoalByKategori(String namaPelajaran) async {
    try {
      final doc =
          await _firestore.collection('soal_test').doc(namaPelajaran).get();

      if (!doc.exists) {
        return [];
      }

      final data = doc.data();
      final List<dynamic> soalArray = data?['soal'] ?? [];

      return soalArray.map((soalMap) {
        return SoalTest.fromMap(soalMap as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print('Error fetching soal: $e');
      return [];
    }
  }
}
