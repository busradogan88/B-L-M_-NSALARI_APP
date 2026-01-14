import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'wiews/giris.dart'; // klasör adın gerçekten "wiews" ise doğru

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Teşhis için log
  debugPrint(">>> Firebase init basliyor");

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint(">>> Firebase init bitti");
  } catch (e, s) {
    debugPrint(">>> Firebase init HATA: $e");
    debugPrint(">>> Stack: $s");
  }

  runApp(const MyAnaUygulama());
}

class MyAnaUygulama extends StatelessWidget {
  const MyAnaUygulama({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
