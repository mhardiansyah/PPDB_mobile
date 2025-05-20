import 'package:go_router/go_router.dart';
import 'package:ppdb_be/core/models/siswa_model.dart';
import 'package:ppdb_be/presentation/Form_screen.dart';
import 'package:ppdb_be/presentation/form_files_screen.dart';
import 'package:ppdb_be/presentation/page/Home_screen.dart';
import 'package:ppdb_be/presentation/page/Login_screen.dart';
import 'package:ppdb_be/presentation/page/Register_screen.dart';
import 'package:ppdb_be/presentation/page/edit_berkas_screen.dart';

part 'Route_name.dart';

final appRoute = [
  GoRoute(
    path: '/home',
    name: Routes.home,
    builder: (context, state) => const HomeScreen(),
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
    path: '/editberkas',
    name: Routes.editberkas,
    builder: (context, state) => const EditBerkasScreen(),
  ),
  GoRoute(
    path: '/formFiles',
    name: Routes.formFiles,
    builder: (context, state) {
      final siswa = state.extra as SiswaModel;
      return FormFilesScreen(siswa: siswa);
    },
  ),
];
