import 'package:flutter/material.dart';
import '../oyunlar/quiz/lib/quiz.dart' as quiz;
import '../oyunlar/bulmaca/lib/bulmaca_main.dart' as bulmaca;
import '../oyunlar/kart_eslestirme/lib/kart_eslestirme_oyun.dart' as kart;
import '../oyunlar/ben_kimim/lib/benkimim.dart' as benkimim;


// ✅ Diğer oyunlar için de aynı mantıkla import yapabilirsin (yoksa şimdilik kapalı kalsın)
// import '../oyunlar/ben_kimim/lib/benkimim_main.dart' as benkimim;

class Oyun extends StatelessWidget {
  final String title;
  const Oyun({super.key, required this.title});

  static const Color _g1 = Color(0xFF7F00FF);
  static const Color _g2 = Color(0xFFE100FF);
  static const Color _accent = Color(0xFF6A0DAD);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          title.isEmpty ? "OYUNLAR" : title,
          style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [_g1, _g2],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 12,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 6),

                      // Başlık/etiket
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: const LinearGradient(
                            colors: [_g1, _g2],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: const Text(
                          "OYUN KATEGORİLERİ",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 2,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      // Üst ikon
                      Center(
                        child: Image.asset(
                          'assets/images/game-control.png',
                          width: 110,
                          height: 110,
                        ),
                      ),

                      const SizedBox(height: 16),

                      const Text(
                        "Bir oyun seç",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: _accent,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        "Bilim insanlarını oyunlarla keşfet!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.5,
                          color: Colors.black54,
                        ),
                      ),

                      const SizedBox(height: 18),

                      // ✅ 2x2 grid
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 1.05,
                        children: [
                          _GameCard(
                            title: "Bulmaca",
                            subtitle: "Kelime / ipucu",
                            icon: Icons.extension_outlined,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const bulmaca.BulmacaSayfasi(),
                                ),
                              );
                            },
                          ),

                          _GameCard(
                            title: "Bilgi Yarışması",
                            subtitle: "Test & hızlı soru",
                            icon: Icons.quiz_outlined,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const quiz.QuizPage(),
                                ),
                              );
                            },
                          ),

                          _GameCard(
                            title: "Kart Eşleştirme",
                            subtitle: "Hafıza oyunu",
                            icon: Icons.grid_view_rounded,
                            onTap: () {
                              // ✅ ARTIK BOŞ SAYFA YOK → GERÇEK OYUNA GİDİYOR
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const kart.KartEslestirmeOyunSayfasi(),
                                ),
                              );
                            },
                          ),

                          _GameCard(
                            title: "Ben Kimim?",
                            subtitle: "İpucundan tahmin",
                            icon: Icons.face_retouching_natural,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const BenKimimSayfasi(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      // Bilgilendirme kutusu
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: _accent.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: _accent.withValues(alpha: 0.18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GameCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  static const Color _g1 = Color(0xFF7F00FF);
  static const Color _g2 = Color(0xFFE100FF);

  const _GameCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: const LinearGradient(
            colors: [_g1, _g2],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.25),
                ),
              ),
              child: Icon(icon, color: Colors.white, size: 30),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ✅ ŞİMDİLİK BOŞ SAYFALAR (sen gerçek sayfaları ekleyince kaldırabiliriz)
class BenKimimSayfasi extends StatelessWidget {
  const BenKimimSayfasi({super.key});
  @override
  Widget build(BuildContext context) {
    return const _BosSayfaBasligi(baslik: "Ben Kimim?");
  }
}

class _BosSayfaBasligi extends StatelessWidget {
  final String baslik;
  const _BosSayfaBasligi({required this.baslik});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(baslik)),
      body: const Center(
        child: Text(
          "Bu oyun sayfası henüz bağlanmadı.",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
