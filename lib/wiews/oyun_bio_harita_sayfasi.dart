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
              child: Stack(
                children: [
                  // Arka planda hafif dekoratif ikonlar
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Opacity(
                      opacity: 0.15,
                      child: Icon(
                        Icons.auto_awesome,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 0,
                    child: Opacity(
                      opacity: 0.12,
                      child: Icon(
                        Icons.science,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  // Asıl içerik
                  Column(
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
                                  fontSize: 30,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  letterSpacing: 1.1,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black26,
                                      offset: Offset(1, 2),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 6),
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
                          fontSize: 40,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 1.6,
                          shadows: [
                            Shadow(
                              color: Colors.black26,
                              offset: Offset(1, 3),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Ayraç çizgi
                      Container(
                        width: 70,
                        height: 3,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),

                      const SizedBox(height: 12),

                      const Text(
                        "Bilim dünyasında eğlenceli bir yolculuğa hazır mısın?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 40),

                      // 👩‍🔬 Biyografi Kartı (EN ÜST)
                      _AnimatedMenuCard(
                        title: "Biyografi",
                        subtitle: "Türk ve Müslüman bilim insanlarını tanı!",
                        iconPath: "assets/images/research.png",
                        color: const Color(0xFF6A0DAD),
                        page: Kategori(title: ""),
                      ),

                      // 🌍 Harita Kartı
                      _AnimatedMenuCard(
                        title: "Harita",
                        subtitle: "Bilim insanlarının izlerini keşfet!",
                        iconPath: "assets/images/global.png",
                        color: const Color(0xFF4A00E0),
                        page: const Harita(title: ""),
                      ),

                      // 🕹️ Oyun Kartı (EN ALTA)
                      _AnimatedMenuCard(
                        title: "Oyun",
                        subtitle: "Bilim insanlarını eğlenceli şekilde öğren!",
                        iconPath: "assets/images/game-control.png",
                        color: const Color(0xFF8E2DE2),
                        page: const Oyun(title: ""),
                      ),
                    ],
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

// 🔹 Animasyonlu kart bileşeni
class _AnimatedMenuCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final String iconPath;
  final Color color;
  final Widget page;

  const _AnimatedMenuCard({
    required this.title,
    required this.subtitle,
    required this.iconPath,
    required this.color,
    required this.page,
  });

  @override
  State<_AnimatedMenuCard> createState() => _AnimatedMenuCardState();
}

class _AnimatedMenuCardState extends State<_AnimatedMenuCard> {
  double _scale = 1.0;

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _scale = 0.97;
    });
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _scale = 1.0;
    });
  }

  void _onTapCancel() {
    setState(() {
      _scale = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: (details) {
        _onTapUp(details);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => widget.page),
        );
      },
      onTapCancel: _onTapCancel,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
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
                  color: widget.color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Image.asset(widget.iconPath, fit: BoxFit.contain),
                ),
              ),
              const SizedBox(width: 20),

              // 🔹 Metinler
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: widget.color,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.subtitle,
                      style: const TextStyle(
                        fontSize: 17, // hafif büyütülmüş açıklama
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),

              // 🔹 Ok ikonu
              Icon(
                Icons.arrow_forward_ios,
                color: widget.color,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
