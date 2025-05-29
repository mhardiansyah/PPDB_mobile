import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ppdb_be/core/models/siswa_model.dart';

class HasilTestService {
  final _hasilTestCollection = FirebaseFirestore.instance.collection(
    'hasil_test',
  );
  final CollectionReference _pendaftaranCollection = FirebaseFirestore.instance
      .collection('pendaftaran');
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> simpanHasilTest({
    required String userId,
    required String namaSiswa,
    required String namaPelajaran,
    required List<Map<String, dynamic>> jawaban,
    required int skor,
  }) async {
    await _hasilTestCollection.add({
      'userId': userId,
      'namaSiswa': namaSiswa,
      'namaPelajaran': namaPelajaran,
      'jawaban': jawaban,
      'skor': skor,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<bool> sudahMengerjakanTes(String userId, String namaPelajaran) async {
    final snapshot =
        await _hasilTestCollection
            .where('userId', isEqualTo: userId)
            .where('namaPelajaran', isEqualTo: namaPelajaran)
            .get();
    print("snapshot.docs.isNotEmpty: ${snapshot.docs.isNotEmpty}");

    return snapshot.docs.isNotEmpty;
  }

  Future<List<String>> getKategoriYangSudahDikerjakan(String userId) async {
    final snapshot =
        await _hasilTestCollection.where('userId', isEqualTo: userId).get();

    return snapshot.docs.map((doc) => doc['namaPelajaran'] as String).toList();
  }

  Future<SiswaModel?> getSinglePendaftaranByUserId(String userId) async {
    try {
      final snapshot =
          await _pendaftaranCollection
              .where("siswa.userid", isEqualTo: userId)
              .limit(1)
              .get();

      if (snapshot.docs.isNotEmpty) {
        final data = snapshot.docs.first.data() as Map<String, dynamic>;
        print("Dokumen pendaftaran lengkap: $data");
        print("Isi field siswa: ${data['siswa']}");
        if (data['siswa'] == null) {
          print("Field 'siswa' kosong atau tidak ada.");
          return null;
        }
        return SiswaModel.fromJson(data['siswa']);
      } else {
        print("Dokumen pendaftaran tidak ditemukan.");
      }
      return null;
    } catch (e) {
      print("Error getSinglePendaftaranByUserId: $e");
      return null;
    }
  }
}
