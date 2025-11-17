import 'package:flutter/material.dart';
import 'oyun_bio_harita_sayfasi.dart';
import 'kayitsayfasi.dart';
import 'sifremi_unuttum.dart'; // 🔹 yeni dosya eklendi
import 'package:flutter_application_1/service/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // 🔹 Arka plan gradyan (mor tonları)
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF7F00FF), Color(0xFFE100FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              padding: const EdgeInsets.all(25.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo veya ikon
                  Image.asset(
                    'assets/images/science.png',
                    width: 120,
                    height: 120,
                  ),
                  const SizedBox(height: 20),

                  const Text(
                    "Giriş Yap",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6A0DAD),
                    ),
                  ),
                  const SizedBox(height: 25),

                  // E-posta alanı
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      prefixIcon:
                          const Icon(Icons.email, color: Colors.deepPurple),
                      hintText: "E-posta adresinizi girin",
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Şifre alanı
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon:
                          const Icon(Icons.lock, color: Colors.deepPurple),
                      hintText: "Şifrenizi girin",
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // 🔹 Şifremi Unuttum Butonu (artık ayrı sayfaya yönlendiriyor)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SifremiUnuttum(),
                          ),
                        );
                      },
                      child: const Text(
                        "Şifremi Unuttum",
                        style: TextStyle(
                          color: Color(0xFF6A0DAD),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Giriş Yap butonu (mor gradyan)
                  Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
                      ),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                      ),
                      onPressed: () async {
                        setState(() => isLoading = true);
                        try {
                          await Auth().signIn(
                            email: _emailController.text.trim(),
                            password: _passwordController.text.trim(),
                          );

                          if (!mounted) return;
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const OyunBioHaritaSayfasi(title: "Harita"),
                            ),
                          );
                        } on FirebaseAuthException catch (e) {
                          String mesaj;
                          if (e.code == 'user-not-found') {
                            mesaj = 'Kullanıcı bulunamadı.';
                          } else if (e.code == 'wrong-password') {
                            mesaj = 'Hatalı şifre.';
                          } else if (e.code == 'invalid-email') {
                            mesaj = 'Geçersiz e-posta formatı.';
                          } else {
                            mesaj = e.message ?? 'Giriş hatası: ${e.code}';
                          }

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(mesaj)),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Beklenmeyen hata: $e")),
                          );
                        } finally {
                          setState(() => isLoading = false);
                        }
                      },
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Giriş Yap",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // 🔹 Kayıt Ol bağlantısı
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const Kayitsayfasi(title: "Kayıt Sayfası"),
                        ),
                      );
                    },
                    child: const Text(
                      "Hesabın yok mu? Kayıt ol",
                      style: TextStyle(
                        color: Color(0xFF6A0DAD),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
