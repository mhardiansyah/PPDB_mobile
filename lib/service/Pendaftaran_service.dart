import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ppdb_be/core/models/berkas_model.dart';
import 'package:ppdb_be/core/models/berkas_model.dart';
import 'package:ppdb_be/core/models/pendaftaran.dart';
import 'package:ppdb_be/core/models/siswa_model.dart';
import 'package:ppdb_be/core/router/App_router.dart';
import 'package:ppdb_be/widgets/notif_succes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PendaftaranService {
  // final CollectionReference _pendaftaranColection = FirebaseFirestore.instance
  //     .collection('berkas');
  final CollectionReference _pendaftaranCollection = FirebaseFirestore.instance
      .collection('pendaftaran');
  // final CollectionReference , {required BerkasModel berkas}_collection =
  // FirebaseFirestore.instance.collection('pendaftaran');

  Future addPendaftaran({
    required SiswaModel siswa,
    required BerkasModel berkas,
    required BuildContext context,
  }) async {
    try {
      final docfref = await _pendaftaranCollection.add({
        'siswa': siswa.toJson(),
        'berkas': berkas.toJson(),
      });

      final genaretId = docfref.id;

      SuccessUploadWidget(key: const Key('success'));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pendaftaran berhasil ditambahkan')),
      );
      context.goNamed(Routes.home); // pastikan nama rute sesuai
    } catch (e) {
      print('Gagal menambahkan pendaftaran: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal menambahkan data')));
    }
  }

  // Future addPendaftaran(
  //   PendaftaranModel pendaftaranitems,
  //   BuildContext context,
  // ) async {
  //   try {
  //     print('jalan cuyy');
  //     DocumentReference docref = await _pendaftaranColection.add(
  //       pendaftaranitems.toJson(),
  //     );
  //     context.goNamed(Routes.home);
  //   } catch (e) {
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(SnackBar(content: Text('data gagal ditambahkan')));
  //     print('gagal cuyy: $e');
  //   }
  // }

  Future addSiswa(SiswaModel siswa) async {
    final prefs = await SharedPreferences.getInstance();
    final siswaJson = jsonEncode(siswa.toJson());
    await prefs.setString('siswa', siswaJson);
    print('Siswa data saved: $siswaJson');
  }

  //  Future addSiswaBerkas(
  //   SiswaModel siswa,
  //   BerkasModel berkas,
  //   BuildContext context,
  // ) async {
  //   try {
  //     // Gabungkan data ke dalam satu Map
  //     final Map<String, dynamic> dataGabungan = {
  //       'siswa': siswa.toJson(),
  //       'berkas': berkas.toJson(),
  //       'createdAt': Timestamp.now(),
  //     };

  //     await _collection.add(dataGabungan);
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Data berhasil ditambahkan")),
  //     );

  //     Navigator.pop(context); // atau redirect sesuai kebutuhan
  //   } catch (e) {
  //     print('Gagal menambahkan data: $e');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Gagal menambahkan data")),
  //     );
  //   }
  // }

  // Stream<List<SiswaModel>> getPendaftaran() {
  // return _pendaftaranCollection.snapshots().map((event) {
  //   return event.docs.map((e) {
  //     final data = e.data() as Map<String, dynamic>;
  //     final siswaMap = data['siswa'] as Map<String, dynamic>;
  //     return SiswaModel.fromJson(siswaMap);
  //   }).toList();
  // });

  Stream<SiswaModel?> getPendaftaranByUserId(String userId) {
    return FirebaseFirestore.instance
        .collection('pendaftaran')
        .where("siswa.userid", isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
          if (snapshot.docs.isNotEmpty) {
            final data = snapshot.docs.first.data();
            return SiswaModel.fromJson(data['siswa']);
          }
          return null;
        });
  }
  
}
