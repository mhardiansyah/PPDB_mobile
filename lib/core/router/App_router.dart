import 'package:go_router/go_router.dart';
import 'package:ppdb_be/core/models/daftar_test.dart';
import 'package:ppdb_be/core/models/pembayaran_model.dart';
import 'package:ppdb_be/core/models/siswa_model.dart';
import 'package:ppdb_be/presentation/page/Form_screen.dart';
import 'package:ppdb_be/presentation/page/Pembayaran_screen.dart';
import 'package:ppdb_be/presentation/page/Splash_screen.dart';
import 'package:ppdb_be/presentation/page/edit_files_screen.dart';
import 'package:ppdb_be/presentation/page/form_files_screen.dart';
import 'package:ppdb_be/presentation/page/Home_screen.dart';
import 'package:ppdb_be/presentation/page/Login_screen.dart';
import 'package:ppdb_be/presentation/page/Register_screen.dart';
import 'package:ppdb_be/presentation/page/edit_berkas_screen.dart';
import 'package:ppdb_be/presentation/page/test/daftar_test_screen.dart';
import 'package:ppdb_be/presentation/page/test/hasil_test_screen.dart';
import 'package:ppdb_be/presentation/page/test/test_diniah_screen.dart';
import 'package:ppdb_be/presentation/page/test/test_screen.dart';

part 'Route_name.dart';

final appRoute = [
  GoRoute(
    path: '/home',
    name: Routes.home,
    builder: (context, state) {
      final pembayaran = state.extra as PembayaranModel?;
      return HomeScreen(pembayaran: pembayaran);
    },
  ),
  GoRoute(
    path: '/splash',
    name: Routes.splash,
    builder: (context, state) => const SplashScreen(),
  ),
  GoRoute(
    path: '/login',
    name: Routes.login,
    builder: (context, state) => const LoginScreen(),
  ),
  GoRoute(
    path: '/register',
    name: Routes.register,
    builder: (context, state) => const RegisterScreen(),
  ),
  GoRoute(
    path: '/form',
    name: Routes.form,
    builder: (context, state) => const FormScreen(),
  ),
  GoRoute(
    path: '/lihatform',
    name: Routes.lihatform,
    builder: (context, state) {
      final siswadata = state.extra as SiswaModel;
      return EditBerkasScreen(siswadata: siswadata);
    },
  ),
  GoRoute(
    path: '/formFiles',
    name: Routes.formFiles,
    builder: (context, state) {
      final siswa = state.extra as SiswaModel;
      return FormFilesScreen(siswa: siswa);
    },
  ),
  GoRoute(
    path: '/editfiles',
    name: Routes.lihatfiles,
    builder: (context, state) {
      final siswafiles = state.extra as SiswaModel;
      return EditFilesScreen(siswa: siswafiles);
    },
  ),
  GoRoute(
    path: '/daftar_test',
    name: Routes.daftar_test,
    builder: (context, state) => const DaftarTestScreen(),
  ),
  GoRoute(
    path: '/test_diniah',
    name: Routes.test_diniah,
    builder: (context, state) {
      final kategori = state.extra as kategorisoalModel;
      return TestDiniahScreen(kategori: kategori);
    },
  ),
  GoRoute(
    path: '/test_screen',
    name: Routes.test_screen,
    builder: (context, state) {
      final kategori = state.extra as kategorisoalModel;
      return TestScreen(kategori: kategori);
    },
  ),
  GoRoute(
    name: Routes.hasil_test,
    path: '/hasil-test',
    builder: (context, state) {
      final extra = state.extra as Map<String, dynamic>;
      return HasilTestScreen(extra: extra);
    },
  ),

  GoRoute(
    name: Routes.pembayaran,
    path: '/pembayaran',
    builder: (context, state) {
      final siswa = state.extra as SiswaModel;
      return PembayaranScreen(siswa: siswa);
    },
  ),
  // GoRoute(
  //     path: '/pembayaran',
  //     name: Routes.pembayaran,
  //     builder: (context, state) => const PembayaranScreen(),
  //   ),
];
