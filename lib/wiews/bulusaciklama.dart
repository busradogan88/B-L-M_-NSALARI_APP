import 'package:flutter/material.dart';

class BulusAciklama extends StatelessWidget {
  final String ad;             // Başlık
  final String aciklama;       // Açıklama metni
  final String? img;           // Opsiyonel görsel yolu (assets)

  const BulusAciklama({
    super.key,
    required this.ad,
    required this.aciklama,
    this.img,
  });

  @override
  Widget build(BuildContext context) {
    const Color g1 = Color(0xFF7F00FF);
    const Color g2 = Color(0xFFE100FF);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          ad,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: g2,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [g1, g2],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Opsiyonel görsel
                  if (img != null && img!.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        img!,
                        width: 220,
                        height: 220,
                        fit: BoxFit.cover,
                      ),
                    ),
                  if (img != null && img!.isNotEmpty) const SizedBox(height: 20),

                  // Açıklama kartı
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 12,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Text(
                      aciklama.isEmpty
                          ? 'Bu buluş için açıklama henüz eklenmemiş.'
                          : aciklama,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        height: 1.5,
                        color: Colors.black87,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Sadece görsel "Sesli Dinle" butonu (şimdilik işlevsiz)
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('Sesli okuma özelliği yakında eklenecek!'),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black87,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 12,
                      ),
                      elevation: 3,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.volume_up),
                        SizedBox(width: 10),
                        Text(
                          'Sesli Dinle',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
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
