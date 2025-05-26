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
  final CollectionReference _pendaftaranCollection = FirebaseFirestore.instance
      .collection('pendaftaran');

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
    } catch (e) {
      print('Gagal menambahkan pendaftaran: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal menambahkan data')));
    }
  }

  // Future editPendaftaran(BerkasModel berkasItems, BuildContext context) async {
  //   try {
  //     final docRef = FirebaseFirestore.instance
  //         .collection('pendaftaran')
  //         .doc(berkasItems.id);
  //     await docRef.set({
  //       'foto3x4Url': berkasItems.foto3x4Url,
  //       'ijazahUrl': berkasItems.ijazahUrl,
  //       'kartuKeluargaUrl': berkasItems.kartuKeluargaUrl,
  //       'raporUrl': berkasItems.raporUrl,
  //       'suratKeteranganLulusUrl': berkasItems.suratKeteranganLulusUrl,
  //       'aktaKelahiranUrl': berkasItems.aktaKelahiranUrl,
  //       'updatedAt': DateTime.now(),
  //     }, SetOptions(merge: true));
  //   } catch (e) {
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(SnackBar(content: Text('Gagal mengedit data: $e')));
  //   }
  // }


Future updateBerkasBySiswaId(String siswaId, Map<String, dynamic> dataBerkas) async {
  final _pendaftaranCollection = FirebaseFirestore.instance.collection('pendaftaran');

  try {
    // Query dokumen berdasarkan berkas.siswaId
    final querySnapshot = await _pendaftaranCollection
        .where('berkas.siswaId', isEqualTo: siswaId)
        .limit(1)
        .get();

    if (querySnapshot.docs.isEmpty) {
      print('Dokumen dengan siswaId $siswaId tidak ditemukan.');
      return;
    }

    // Ambil ID dokumen
    final docId = querySnapshot.docs.first.id;

    // Update field berkas
    await _pendaftaranCollection.doc(docId).update({
      'berkas.foto3x4Url': dataBerkas['foto3x4Url'],
      'berkas.ijazahUrl': dataBerkas['ijazahUrl'],
      'berkas.kartuKeluargaUrl': dataBerkas['kartuKeluargaUrl'],
      'berkas.raporUrl': dataBerkas['raporUrl'],
      'berkas.suratKeteranganLulusUrl': dataBerkas['suratKeteranganLulusUrl'],
      'berkas.aktaKelahiranUrl': dataBerkas['aktaKelahiranUrl'],
    });

    print('Update berkas berhasil untuk siswaId $siswaId');
  } catch (e) {
    print('Gagal update berkas: $e');
    rethrow;
  }
}



  Future addSiswa(SiswaModel siswa) async {
    final prefs = await SharedPreferences.getInstance();
    final siswaJson = jsonEncode(siswa.toJson());
    await prefs.setString('siswa', siswaJson);
    print('Siswa data saved: $siswaJson');
  }

  Stream<List<SiswaModel>> getPendaftaranByUserId(String userId) {
    return FirebaseFirestore.instance
        .collection('pendaftaran')
        .where("siswa.userid", isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            return SiswaModel.fromJson(data['siswa']);
          }).toList();
        });
  }
}
