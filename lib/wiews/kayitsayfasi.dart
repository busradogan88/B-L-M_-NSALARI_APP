import 'package:flutter/material.dart';
import 'package:flutter_application_1/service/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Kayitsayfasi extends StatelessWidget {
  final String title;
  const Kayitsayfasi({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _sifreController = TextEditingController();

    return Scaffold(
      // Arka planı mor tonlarında gradyan yapıyoruz
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF7F00FF), // mor
              Color(0xFFE100FF), // açık mor/pembe
            ],
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
                  // Başlık
                  const Text(
                    "Kayıt Ol",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6A0DAD),
                    ),
                  ),
                  const SizedBox(height: 25),

                  // E-posta
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.email, color: Colors.deepPurple),
                      hintText: "E-posta adresinizi girin",
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Şifre
                  TextField(
                    controller: _sifreController,
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock, color: Colors.deepPurple),
                      hintText: "Şifre oluşturun",
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Kayıt Ol butonu (gradientli)
                  Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF8E2DE2),
                          Color(0xFF4A00E0),
                        ],
                      ),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                      ),
                      onPressed: () async {
                        String email = _emailController.text.trim();
                        String password = _sifreController.text.trim();

                        if (email.isEmpty || password.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Lütfen e-posta ve şifre girin"),
                            ),
                          );
                          return;
                        }

                        try {
                          await Auth().createUser(
                              email: email, password: password);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Kayıt başarılı!")),
                          );
                          Navigator.pop(context);
                        } on FirebaseAuthException catch (e) {
                          String mesaj;
                          if (e.code == 'email-already-in-use') {
                            mesaj = 'Bu e-posta zaten kayıtlı.';
                          } else if (e.code == 'invalid-email') {
                            mesaj = 'Geçersiz e-posta formatı.';
                          } else if (e.code == 'weak-password') {
                            mesaj = 'Şifre çok zayıf.';
                          } else {
                            mesaj = e.message ?? 'Kayıt başarısız: ${e.code}';
                          }
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text(mesaj)));
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Beklenmeyen hata: $e")),
                          );
                        }
                      },
                      child: const Text(
                        "Kayıt Ol",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Geri dön butonu
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "Zaten hesabın var mı? Giriş yap",
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
