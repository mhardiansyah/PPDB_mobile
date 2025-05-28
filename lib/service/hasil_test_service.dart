import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ppdb_be/core/models/siswa_model.dart';

class HasilTestService {
  final _hasilTestCollection = FirebaseFirestore.instance.collection(
    'hasil_test',
  );
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> simpanHasilTest({
    required String userId,
    // required String namaSiswa,
    required String namaPelajaran,
    required List<Map<String, dynamic>> jawaban,
    required int skor,
  }) async {
    await _hasilTestCollection.add({
      'userId': userId,
      // 'namaSiswa': namaSiswa,
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

    return snapshot.docs.isNotEmpty;
  }

  Future<List<String>> getKategoriYangSudahDikerjakan(String userId) async {
    final snapshot =
        await _hasilTestCollection.where('userId', isEqualTo: userId).get();

    return snapshot.docs.map((doc) => doc['namaPelajaran'] as String).toList();
  }

  Future<SiswaModel?> getSiswaByUid(String uid) async {
    try {
      final querySnapshot = await _firestore
          .collection('pendaftaran')
          .where('uid', isEqualTo: uid)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final data = querySnapshot.docs.first.data();
        return SiswaModel.fromJson(data);
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting siswa by UID: $e');
      return null;
    }
  }
}
