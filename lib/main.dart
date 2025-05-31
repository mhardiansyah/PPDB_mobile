import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ppdb_be/core/router/App_router.dart';
import 'package:ppdb_be/firebase_options.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Handle background messages here
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

void setupFCM() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission();
  print('Izin notifikasi: ${settings.authorizationStatus}');

  String? token = await messaging.getToken();
  print('Token FCM: $token');

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Notifikasi saat app dibuka: ${message.notification?.title}');
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('User klik notifikasi: ${message.notification?.body}');
    final tipe = message.data['tipe'];
    if (tipe == 'Pengumuman_lolos') {
      navigatorKey.currentContext?.goNamed(Routes.home); // ✅ navigasi
    }
  });
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future main() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  setupFCM();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final GoRouter customRouter = GoRouter(
            initialLocation: snapshot.data != null ? '/home' : '/splash',
            routes: appRoute,
            navigatorKey: navigatorKey,
          );
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            routerConfig: customRouter,
          );
        } else {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(color: Colors.green),
              ),
            ),
          );
        }
      },
    );
  }
}
