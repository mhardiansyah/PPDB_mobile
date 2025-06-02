import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:ppdb_be/core/models/pembayaran_model.dart';

class PembayaranUangMasukService {
  final _pembayaranCollection = FirebaseFirestore.instance.collection(
    'pembayaran_uang_masuk_siswa',
  );

  Future<String?> uploadBuktiPembayaran(Uint8List imageBytes) async {
    try {
      Uri url = Uri.parse(
        'https://api.cloudinary.com/v1_1/dulun20eo/image/upload',
      );

      var request =
          http.MultipartRequest('POST', url)
            ..fields['upload_preset'] = 'simple_app_preset'
            ..files.add(
              http.MultipartFile.fromBytes(
                'file',
                imageBytes,
                filename: 'bukti.jpg',
              ),
            );

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var jsonResult = jsonDecode(responseData);
        return jsonResult['secure_url'];
      } else {
        print('Upload gagal: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Exception saat upload: $e');
      return null;
    }
  }

  Future tambahPembayaran({
    String? id,
    required String siswaId,
    required String metodePembayaran,
    required int jumlah,
    Uint8List? buktiBayarBytes,
  }) async {
    try {
      String? buktiPembayaranUrl;

      if (buktiBayarBytes != null) {
        buktiPembayaranUrl = await uploadBuktiPembayaran(buktiBayarBytes);
      }

      final pembayaran = PembayaranModel(
        id: id,
        siswaId: siswaId,
        buktiPembayaranUrl: buktiPembayaranUrl,
        tanggalPembayaran: DateTime.now(),
        status: 'sudah bayar',
      );

      await _pembayaranCollection.add(pembayaran.toJson());
      print(
        "Pembayaran berhasil ditambahkan ke koleksi pembayaran_uang_masuk_siswa",
      );
    } catch (e) {
      print("Error tambah pembayaran: $e");
    }
  }

  Stream<PembayaranModel?> getPembayaranBySiswaId(String siswaId) {
    print(
      "Mencari pembayaran untuk siswaId: $siswaId di koleksi pembayaran_uang_masuk_siswa",
    );

    return _pembayaranCollection
        .where('siswaId', isEqualTo: siswaId)
        .snapshots()
        .map((snapshot) {
          print("Jumlah dokumen ditemukan: ${snapshot.docs.length}");
          if (snapshot.docs.isNotEmpty) {
            final data = snapshot.docs.first.data();
            print("Data dokumen: $data");
            return PembayaranModel.fromJson(data);
          } else {
            return null;
          }
        });
  }
}
