import 'package:flutter/material.dart';
import 'siralibiliminsani.dart';

class Kategori extends StatelessWidget {
  final String title;
  const Kategori({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> kategoriler = [
      {"ad": "Fizik", "resim": "assets/images/atom.png"},
      {"ad": "Coğrafya", "resim": "assets/images/globe.png"},
      {"ad": "Tıp", "resim": "assets/images/dna.png"},
      {"ad": "Astronomi", "resim": "assets/images/astronomy.png"},
      {"ad": "Felsefe", "resim": "assets/images/thinking.png"},
      {"ad": "Kimya", "resim": "assets/images/laboratory.png"},
      {"ad": "Biyoloji", "resim": "assets/images/lab.png"},
      {"ad": "Matematik", "resim": "assets/images/mathematics.png"},
    ];

    return Scaffold(
      extendBodyBehindAppBar: true, // 🔹 Arka planın AppBar’ın altına geçmesini sağlar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Kategoriler",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF7F00FF), Color(0xFFE100FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),

              // 🔹 Beyaz alt alan (kategoriler)
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  child: GridView.builder(
                    itemCount: kategoriler.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // 2 sütun
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.9,
                    ),
                    itemBuilder: (context, index) {
                      final kategori = kategoriler[index];
                      return _kategoriKart(
                        context,
                        kategori["ad"]!,
                        kategori["resim"]!,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 Kategori Kartı
  Widget _kategoriKart(BuildContext context, String ad, String resimYolu) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => Siralibiliminsani(kategori: ad),
          ),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: const Color(0xFF8E2DE2).withOpacity(0.2),
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: const Color(0xFF8E2DE2).withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image.asset(resimYolu, fit: BoxFit.contain),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              ad,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF4A00E0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
