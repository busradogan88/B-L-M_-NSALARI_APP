import 'package:flutter/material.dart';
import 'package:flutter_application_1/wiews/kategori.dart';
import 'package:flutter_application_1/wiews/oyun.dart';
import 'package:flutter_application_1/wiews/harita.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OyunBioHaritaSayfasi extends StatelessWidget {
  final String title;
  const OyunBioHaritaSayfasi({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final String userEmail =
        user?.email ?? "Misafir"; // Kullanıcı giriş yaptıysa e-posta gösterir

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF7F00FF), Color(0xFFE100FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 🔹 Üst karşılama alanı
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Hoş geldin 👋",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            userEmail,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.2),
                        ),
                        padding: const EdgeInsets.all(10),
                        child: const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // 🔹 Ana başlık
                  const Text(
                    "Keşfet!",
                    style: TextStyle(
                      fontSize: 36, // 🔸 Büyütüldü ama taşmaz
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Bilim dünyasında eğlenceli bir yolculuğa hazır mısın?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // 🕹️ Oyun Kartı
                  _menuCard(
                    context,
                    title: "Oyun",
                    subtitle: "Bilim insanlarını eğlenceli şekilde öğren!",
                    iconPath: "assets/images/game-control.png",
                    color: const Color(0xFF8E2DE2),
                    page: const Oyun(title: ""),
                  ),

                  // 🌍 Harita Kartı
                  _menuCard(
                    context,
                    title: "Harita",
                    subtitle: "Bilim insanlarının izlerini keşfet!",
                    iconPath: "assets/images/global.png",
                    color: const Color(0xFF4A00E0),
                    page: const Harita(title: ""),
                  ),

                  // 👩‍🔬 Biyografi Kartı
                  _menuCard(
                    context,
                    title: "Biyografi",
                    subtitle: "Türk ve Müslüman bilim insanlarını tanı!",
                    iconPath: "assets/images/research.png",
                    color: const Color(0xFF6A0DAD),
                    page: Kategori(title: ""),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 🔹 Profesyonel kart tasarımı
  Widget _menuCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String iconPath,
    required Color color,
    required Widget page,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => page));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 25),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            // 🔹 Görsel
            Container(
              width: 85,
              height: 85,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Image.asset(iconPath, fit: BoxFit.contain),
              ),
            ),
            const SizedBox(width: 20),

            // 🔹 Metinler
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),

            // 🔹 Ok ikonu
            Icon(
              Icons.arrow_forward_ios,
              color: color,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
