import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'veri_aktar.dart';
import 'package:flutter_application_1/wiews/giris.dart';

// 🔸 Her veri güncellemesinde bu sayıyı +1 arttır (ör: 2 -> 3)
 int DATA_VERSION = 3;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BilimInsanlariApp());
}

class BilimInsanlariApp extends StatelessWidget {
  const BilimInsanlariApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: InitGate(),
    );
  }
}

class InitGate extends StatefulWidget {
  const InitGate({super.key});
  @override
  State<InitGate> createState() => _InitGateState();
}

class _InitGateState extends State<InitGate> {
  late Future<void> _initFuture;
  Object? _lastError;
  bool _isInitializing = false;

  @override
  void initState() {
    super.initState();
    _initFuture = _initApp();
  }

  // 🔹 Firebase ve veri aktarımı arka planda
  Future<void> _initApp() async {
    if (_isInitializing) return;
    _isInitializing = true;

    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }

      // (Opsiyonel) Doğru projeye bağlı mıyız, logla:
      try {
        final opt = DefaultFirebaseOptions.currentPlatform;
        // ignore: avoid_print
        print('FIREBASE projectId=${opt.projectId} appId=${opt.appId}');
      } catch (_) {}

      // Auth dili
      try {
        await FirebaseAuth.instance.setLanguageCode('tr');
      } catch (_) {}

      final prefs = await SharedPreferences.getInstance();

      // (Opsiyonel) Eski anahtarı temizle
      if (prefs.containsKey('veriAktarildi')) {
        await prefs.remove('veriAktarildi');
      }

      // 🔸 Sürüm kontrolü: Yereldeki sürüm < DATA_VERSION ise veriAktar() çalışır
      final localVersion = prefs.getInt('data_version') ?? 0;
      if (localVersion < DATA_VERSION) {
        print(
          '🔁 Veri güncellemesi gerekiyor: local=$localVersion, required=$DATA_VERSION',
        );
        await veriAktar();
        await prefs.setInt('data_version', DATA_VERSION);
        print('✅ Veri güncellemesi tamam: data_version=$DATA_VERSION');
      } else {
        print('ℹ️ Veri güncel: data_version=$localVersion');
      }
    } on FirebaseException catch (e) {
      if (e.code != 'duplicate-app') {
        _lastError = e;
        rethrow;
      }
    } catch (e) {
      _lastError = e;
      rethrow;
    } finally {
      _isInitializing = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    // 🔹 Kullanıcı LoginScreen’i direkt görür; arka planda init devam eder
    return FutureBuilder<void>(
      future: _initFuture,
      builder: (context, snap) {
        if (snap.hasError || _lastError != null) {
          debugPrint("⚠️ Firebase başlatma hatası: $_lastError");
        }
        return const LoginScreen();
      },
    );
  }
}
