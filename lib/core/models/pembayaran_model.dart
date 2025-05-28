import 'package:cloud_firestore/cloud_firestore.dart';

class PembayaranModel {
  String? id;
  String? siswaId;
  String? buktiPembayaranUrl;
  DateTime tanggalPembayaran;
  String? status;

  PembayaranModel({
    this.id,
    this.siswaId,
    required this.buktiPembayaranUrl,
    required this.tanggalPembayaran,
    this.status = 'sudah bayar',
  });

  factory PembayaranModel.fromJson(Map<String, dynamic> json) {
    return PembayaranModel(
      id: json['id'],
      siswaId: json['siswaId'] ?? '',
      buktiPembayaranUrl: json['buktiPembayaranUrl'],
      tanggalPembayaran: (json['tanggalPembayaran'] as Timestamp).toDate(),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'siswaId': siswaId,
      'buktiPembayaranUrl': buktiPembayaranUrl,
      'tanggalPembayaran': tanggalPembayaran,
      'status': status,
    };
  }
}
