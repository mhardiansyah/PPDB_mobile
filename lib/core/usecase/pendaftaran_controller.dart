import 'dart:convert';

import 'package:ppdb_be/core/models/siswa_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<SiswaModel?> getDataSiswaFromSharedPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  final siswaString = prefs.getString('siswaData');

  if (siswaString != null) {
    final Map<String, dynamic> siswaMap = jsonDecode(siswaString);
    return SiswaModel.fromJson(siswaMap);
  }

  return null;
}