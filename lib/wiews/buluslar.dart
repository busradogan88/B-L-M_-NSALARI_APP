import 'package:flutter/material.dart';
import 'bulusaciklama.dart'; // 🔹 yeni dosyayı ekle

class Buluslar extends StatelessWidget {
  final String kategori;
  const Buluslar({super.key, required this.kategori});

  String _norm(String s) => s
      .trim()
      .toLowerCase()
      .replaceAll('ı', 'i')
      .replaceAll('İ', 'i')
      .replaceAll('ş', 's')
      .replaceAll('Ş', 's')
      .replaceAll('ğ', 'g')
      .replaceAll('Ğ', 'g')
      .replaceAll('ö', 'o')
      .replaceAll('Ö', 'o')
      .replaceAll('ü', 'u')
      .replaceAll('Ü', 'u')
      .replaceAll('ç', 'c')
      .replaceAll('Ç', 'c');

  String _titleCase(String s) {
    if (s.isEmpty) return s;
    final lower = s.toLowerCase();
    return lower[0].toUpperCase() + lower.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    final key = _norm(kategori);

    final Map<String, IconData> ikonlar = {
      "fizik": Icons.bolt,
      "tip": Icons.healing,
      "astronomi": Icons.star,
      "kimya": Icons.science,
      "matematik": Icons.calculate,
      "cografya": Icons.public,
      "felsefe": Icons.psychology,
      "biyoloji": Icons.biotech,
    };

    // 🔹 Buluş listesi + açıklama metinleri
    final Map<String, List<Map<String, String>>> buluslarByKey = {
      "fizik": [
        {"ad": "Kuantum Teorisi", "aciklama": "Maddenin en küçük düzeydeki davranışlarını açıklar."},
        {"ad": "Manyetizma", "aciklama": "Mıknatısların ve manyetik alanların etkilerini inceler."},
        {"ad": "Işık Hızı Deneyi", "aciklama": "Işığın sabit hızla yayıldığını kanıtlayan deneylerdir."},
      ],
      "tip": [
        {"ad": "Tıp Ansiklopedisi", "aciklama": "Tıbbi bilgilerin derlendiği kapsamlı bir eserdir."},
        {"ad": "Bulaşıcı Hastalıklar Teorisi", "aciklama": "Hastalıkların mikroorganizmalar yoluyla yayıldığını açıklar."},
      ],
      "astronomi": [
        {"ad": "Güneş Saati", "aciklama": "Güneşin gölgesini kullanarak zamanı ölçen araçtır."},
        {"ad": "Yıldız Haritaları", "aciklama": "Gökyüzündeki yıldızların konumlarını gösteren haritalardır."},
      ],
      "kimya": [
        {"ad": "Asit-Baz Teorisi", "aciklama": "Asit ve bazların etkileşimini açıklar."},
        {"ad": "Damıtma Yöntemi", "aciklama": "Sıvı karışımların ayrıştırılmasında kullanılan yöntemdir."},
      ],
      "matematik": [
        {"ad": "Cebir Kuralları", "aciklama": "Matematiksel işlemlerin soyut temellerini tanımlar."},
        {"ad": "Logaritma Sistemi", "aciklama": "Üstel ifadeleri basitleştirmek için kullanılır."},
      ],
      "cografya": [
        {"ad": "Harita Çizimi", "aciklama": "Dünya yüzeyinin ölçekli bir şekilde gösterilmesi yöntemidir."},
        {"ad": "Denizcilik Yöntemleri", "aciklama": "Navigasyon ve coğrafi konum belirleme teknikleridir."},
      ],
      "felsefe": [
        {"ad": "Bilgi Kuramı", "aciklama": "Bilginin doğasını ve sınırlarını inceler."},
        {"ad": "Mantık Bilimi", "aciklama": "Doğru düşünme kurallarını araştırır."},
      ],
      "biyoloji": [
        {"ad": "Organizma Sınıflandırması", "aciklama": "Canlıların sistematik olarak gruplandırılmasıdır."},
        {"ad": "Hücre Keşfi", "aciklama": "Canlıların temel yapı taşı olan hücrenin bulunmasıdır."},
      ],
    };

    final IconData ikon = ikonlar[key] ?? Icons.lightbulb;
    final List<Map<String, String>> liste = buluslarByKey[key] ?? [
      {"ad": "Henüz eklenmemiş.", "aciklama": "Bu kategoriye ait buluş bilgileri yakında eklenecek."}
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("${_titleCase(kategori)} Buluşları"),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF7F00FF), Color(0xFFE100FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: liste.length,
          itemBuilder: (context, index) {
            final bulus = liste[index];
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              color: Colors.white,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
                leading: Icon(ikon, color: Colors.deepPurple),
                title: Text(
                  bulus["ad"] ?? "",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 18),
                // 🔹 TIKLAMA YÖNLENDİRMESİ
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BulusAciklama(
                        ad: bulus["ad"] ?? "",
                        aciklama: bulus["aciklama"] ?? "",
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
