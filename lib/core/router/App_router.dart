import 'package:go_router/go_router.dart';
import 'package:ppdb_be/core/models/siswa_model.dart';
import 'package:ppdb_be/presentation/page/Form_screen.dart';
import 'package:ppdb_be/presentation/page/Splash_screen.dart';
import 'package:ppdb_be/presentation/page/edit_files_screen.dart';
import 'package:ppdb_be/presentation/page/form_files_screen.dart';
import 'package:ppdb_be/presentation/page/Home_screen.dart';
import 'package:ppdb_be/presentation/page/Login_screen.dart';
import 'package:ppdb_be/presentation/page/Register_screen.dart';
import 'package:ppdb_be/presentation/page/edit_berkas_screen.dart';
import 'package:ppdb_be/presentation/page/test/daftar_test_screen.dart';

part 'Route_name.dart';

final appRoute = [
  GoRoute(
    path: '/home',
    name: Routes.home,
    builder: (context, state) => const HomeScreen(),
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
];
