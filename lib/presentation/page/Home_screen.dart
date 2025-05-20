import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ppdb_be/core/models/siswa_model.dart';
import 'package:ppdb_be/core/router/App_router.dart';
import 'package:ppdb_be/service/Pendaftaran_service.dart';
import 'package:ppdb_be/service/auth_service.dart';
import 'package:ppdb_be/widgets/SiswaCard.dart';
import 'package:ppdb_be/widgets/berkas.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  String? userId;
  void initState() {
    super.initState();
    User user = FirebaseAuth.instance.currentUser!;
    print("ID USER IS : ${user.uid}");
    if (user != null) {
      setState(() {
        userId = user.uid;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF278550),
        elevation: 0,
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.asset('assets/icons/logo.png', width: 35),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SMK MADINATUL QURAN',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Kab. Bogor',
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            FutureBuilder(
              future: FirebaseAuth.instance.authStateChanges().first,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final User user = snapshot.data!;
                  return UserAccountsDrawerHeader(
                    decoration: BoxDecoration(color: Colors.green[700]),
                    accountName: Text(user.displayName ?? 'User'),
                    accountEmail: Text(user.email ?? 'email'),
                    currentAccountPicture: CircleAvatar(
                      backgroundImage: NetworkImage(
                        user.photoURL ?? 'assets/icons/logo.png',
                      ),
                    ),
                  );
                } else {
                  return UserAccountsDrawerHeader(
                    accountName: Text('User'),
                    accountEmail: Text('email'),
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Beranda'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Pengaturan'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Keluar'),
              onTap: () {
                AuthService().logout(context);
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/bgHome.png',
              width: MediaQuery.of(context).size.width * 1.5,
              fit: BoxFit.cover,
              height: double.infinity,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              right: 50,
              left: 50,
              top: 40,
              bottom: 18,
            ),
            child:
                userId == null
                    ? const Center(child: CircularProgressIndicator())
                    : StreamBuilder<List<SiswaModel>>(
                      stream: PendaftaranService().getPendaftaranByUserId(
                        userId!,
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }

                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Center(
                            child: Text("Belum ada data pendaftaran."),
                          );
                        }

                        final siswaList = snapshot.data!;
                        print('siswaList: $siswaList');

                        return ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: siswaList.length,
                          itemBuilder: (context, index) {
                            final siswa = siswaList[index];
                            print('status: ${siswa.status}');
                            return buildSiswaContainer(siswa);
                          },
                        );
                      },
                    ),
          ),
        ],
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () {
          context.goNamed(Routes.form);
        },
        style: ElevatedButton.styleFrom(
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
          maximumSize: Size(182, 79),
          backgroundColor: Color(0xFF278550),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          "Daftarkan Anak Anda",
          style: TextStyle(fontSize: 13, color: Colors.white),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'list'),
          BottomNavigationBarItem(
            icon: Icon(Icons.drafts_outlined),
            label: 'drafts',
          ),
        ],
      ),
    );
  }

  Widget buildSiswaContainer(SiswaModel siswa) {
    return Container(
      margin: const EdgeInsets.only(bottom: 40),
      width: 375,
      height: 151,
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Berkas Diupload',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 19),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Status'),
                Row(
                  children: [
                    const Icon(
                      Icons.crisis_alert_outlined,
                      color: Colors.green,
                    ),
                    const SizedBox(width: 4),
                    Text(siswa.status ?? "-"),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 19),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Berkas berhasil dilihat',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow,
                    foregroundColor: Colors.black,
                  ),
                  child: const Text('Lihat Berkas'),
                ),
                const SizedBox(width: 19),
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Berkas berhasil dihapus',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Hapus Berkas'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
