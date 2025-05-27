import 'package:cloud_firestore/cloud_firestore.dart';

class HasilTestService {
  final _hasilTestCollection = FirebaseFirestore.instance.collection('hasil_test');

  Future<void> simpanHasilTest({
    required String userId,
    required String namaPelajaran,
    required List<Map<String, dynamic>> jawaban,
    required int skor,
  }) async {
    await _hasilTestCollection.add({
      'userId': userId,
      'namaPelajaran': namaPelajaran,
      'jawaban': jawaban,
      'skor': skor,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
