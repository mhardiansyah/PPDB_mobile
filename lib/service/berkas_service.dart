// // ignore_for_fil_build_context_synchronously, avoid_print

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:ppdb_be/core/models/berkas_model.dart';
// import 'package:ppdb_be/core/models/siswa_model.dart';
// import 'package:ppdb_be/core/router/App_router.dart';

// class BerkasService {
//   final CollectionReference _berkasColection = FirebaseFirestore.instance
//       .collection('berkas');
//   final CollectionReference _siswaCollection = FirebaseFirestore.instance
//       .collection('berkas');

//   Future addBerkas(BerkasModel berkasitems, BuildContext context) async {
//     try {
//       print('jalan cuyy');
//       DocumentReference docref = await _berkasColection.add(
//         berkasitems.toJson(),
//       );
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Data Berhasil Ditambahkan')));
//       context.goNamed(Routes.home);
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('data gagal ditambahkan')));
//       print('gagal cuyy: $e');
//     }
//   }

//   //   Future addSiswa(SiswaModel siswaItems, BuildContext context) async {
//   //     try {
//   //       print('jalan cuyy');
//   //       await _siswaCollection.add(siswaItems.toJson());
//   //       ScaffoldMessenger.of(context).showSnackBar(
//   //         SnackBar(content: Text('Data Siswa Berhasil Ditambahkan')),
//   //       );
//   //       context.goNamed(Routes.home);
//   //     } catch (e) {
//   //       ScaffoldMessenger.of(
//   //         context,
//   //       ).showSnackBar(SnackBar(content: Text('Data Siswa Gagal Ditambahkan')));
//   //       print('gagal cuyy: $e');
//   //     }

//   //     Stream<List<BerkasModel>> getberkas() {
//   //       return _berkasColection.snapshots().map((event) {
//   //         return event.docs
//   //             .map((e) => BerkasModel.fromJson(e.data() as Map<String, dynamic>))
//   //             .toList();
//   //       });
//   //     }

//   //     Future<List<SiswaModel>> getAllSiswa() async {
//   //       final snapshot =
//   //           await FirebaseFirestore.instance.collection('siswa').get();

//   //       return snapshot.docs.map((doc) {
//   //         final data = doc.data();
//   //         final siswa = SiswaModel.fromJson(data);
//   //         siswa.userId = doc.data()['user_id'];
//   //         return siswa;
//   //       }).toList();
//   //     }
//   //   }
//   // }

//   Future<List<BerkasModel>> getAllBerkas() async {
//     final snapshot =
//         await FirebaseFirestore.instance.collection('berkas').get();

//     return snapshot.docs
//         .map((doc) => BerkasModel.fromJson(doc.data.asMap()))
//         .toList();
//   }
// }
