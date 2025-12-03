import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// 👇 BUNU EKLE (dosya yolunu senin projene göre ayarla)
import 'package:flutter_application_1/wiews/biliminsani.dart';

/// 1️⃣ Bilim insanı konum modeli
class BilimInsaniKonum {
  final String id;
  final String isim;
  final String kisaBilgi;
  final double latitude;
  final double longitude;
  final String tur; // "Doğum yeri" / "Çalışma yeri" gibi

  BilimInsaniKonum({
    required this.id,
    required this.isim,
    required this.kisaBilgi,
    required this.latitude,
    required this.longitude,
    required this.tur,
  });
}

/// 2️⃣ Harita sayfası (Stateful olmalı)
class Harita extends StatefulWidget {
  final String title;
  const Harita({super.key, required this.title});

  @override
  State<Harita> createState() => _HaritaState();
}

class _HaritaState extends State<Harita> {
  GoogleMapController? _mapController;

  /// 3️⃣ Bilim insanı konumları
  final List<BilimInsaniKonum> konumlar = [
    // İBN-İ SİNA
    BilimInsaniKonum(
      id: "ibn_sina_dogum",
      isim: "İbn-i Sina",
      kisaBilgi: "Ünlü bir hekim ve filozof. Buhara’da doğmuştur.",
      latitude: 39.7737,
      longitude: 64.4286,
      tur: "Doğum yeri",
    ),
    BilimInsaniKonum(
      id: "ibn_sina_calisma",
      isim: "İbn-i Sina",
      kisaBilgi:
          "Tıp alanında önemli eserler yazdı. İsfahan civarında çalıştı.",
      latitude: 32.6546,
      longitude: 51.6680,
      tur: "Çalışma bölgesi",
    ),

    // 1️⃣ EL-BATTÂNÎ – Harran (Şanlıurfa)
    BilimInsaniKonum(
      id: "battani_dogum",
      isim: "El-Battânî",
      kisaBilgi:
          "Astronomi alanında önemli gözlemler yaptı. Harran’da doğduğu kabul edilir.",
      latitude: 36.8600,
      longitude: 39.0300,
      tur: "Doğum yeri (Harran)",
    ),

    // 2️⃣ ALİ KUŞÇU – Semerkant
    BilimInsaniKonum(
      id: "ali_kuscu_dogum",
      isim: "Ali Kuşçu",
      kisaBilgi:
          "Osmanlı’da astronomi ve matematik alanında çalışmalar yaptı. Semerkant’ta doğmuştur.",
      latitude: 39.6542,
      longitude: 66.9597,
      tur: "Doğum yeri (Semerkant)",
    ),

    // 3️⃣ TAKİYÜDDİN – İstanbul’da rasathane
    BilimInsaniKonum(
      id: "takiyuddin_calisma",
      isim: "Takiyüddin",
      kisaBilgi:
          "İstanbul’da rasathane kurarak gökbilimi alanında önemli gözlemler yaptı.",
      latitude: 41.0082,
      longitude: 28.9784,
      tur: "Çalışma yeri (İstanbul)",
    ),

    // 4️⃣ EL-CAHIZ – Basra
    BilimInsaniKonum(
      id: "el_cahiz_dogum",
      isim: "El-Cahız",
      kisaBilgi:
          "Basra’da doğmuş, edebiyat ve doğa gözlemleriyle tanınan bir düşünürdür.",
      latitude: 30.5085,
      longitude: 47.7804,
      tur: "Doğum yeri (Basra)",
    ),

    // 5️⃣ İBN BAYTAR – Malaga
    BilimInsaniKonum(
      id: "ibn_baytar_dogum",
      isim: "İbn Baytar",
      kisaBilgi:
          "Bitkiler ve tıp alanında önemli eserler yazmış bir botanikçidir. Malaga’da doğmuştur.",
      latitude: 36.7213,
      longitude: -4.4214,
      tur: "Doğum yeri (Malaga)",
    ),

    // 6️⃣ KÂTİP ÇELEBİ – İstanbul
    BilimInsaniKonum(
      id: "katip_celebi_dogum",
      isim: "Kâtib Çelebi",
      kisaBilgi:
          "Osmanlı’da coğrafya ve tarih alanında önemli eserler yazmıştır.",
      latitude: 41.0082,
      longitude: 28.9784,
      tur: "Doğum yeri / Çalışma (İstanbul)",
    ),

    // 7️⃣ PİRİ REİS – Gelibolu
    BilimInsaniKonum(
      id: "piri_reis_dogum",
      isim: "Piri Reis",
      kisaBilgi:
          "Ünlü dünya haritasını çizen Osmanlı denizcisidir. Gelibolu’da doğmuştur.",
      latitude: 40.4100,
      longitude: 26.6700,
      tur: "Doğum yeri (Gelibolu)",
    ),

    // 8️⃣ FARABİ – Farab/Otrar
    BilimInsaniKonum(
      id: "farabi_dogum",
      isim: "Farabi",
      kisaBilgi:
          "Mantık ve felsefe alanında büyük katkılar sunmuştur. Farab (Otrar) bölgesinde doğmuştur.",
      latitude: 43.0000,
      longitude: 68.0000,
      tur: "Doğum yeri (Farab)",
    ),

    // 9️⃣ İBN RÜŞD – Kurtuba
    BilimInsaniKonum(
      id: "ibn_rusd_dogum",
      isim: "İbn Rüşd",
      kisaBilgi:
          "Endülüs’te yaşamış, felsefe ve tıp alanında önemli bir alimdir.",
      latitude: 37.8882,
      longitude: -4.7794,
      tur: "Doğum yeri (Kurtuba)",
    ),

    // 🔟 CEZERÎ – Cizre
    BilimInsaniKonum(
      id: "cezri_dogum",
      isim: "El-Cezerî",
      kisaBilgi:
          "Sibernetik ve mekanik düzenekler üzerine çalışmış, ‘robotik’in öncülerindendir.",
      latitude: 37.3270,
      longitude: 42.1900,
      tur: "Doğum yeri (Cizre)",
    ),

    // 1️⃣1️⃣ İBN HEYSEM – Kahire
    BilimInsaniKonum(
      id: "ibn_heysem_calisma",
      isim: "İbn Heysem",
      kisaBilgi:
          "Optik biliminin kurucularından kabul edilir, Kahire’de uzun süre çalışmalar yapmıştır.",
      latitude: 30.0444,
      longitude: 31.2357,
      tur: "Çalışma yeri (Kahire)",
    ),

    // 1️⃣2️⃣ CABİR B. HAYYAN – Kufe
    BilimInsaniKonum(
      id: "cabir_hayyan_dogum",
      isim: "Cabir b. Hayyan",
      kisaBilgi:
          "Kimyanın öncülerindendir, deneysel yöntemleriyle tanınır. Kufe’de yaşamıştır.",
      latitude: 32.0346,
      longitude: 44.4056,
      tur: "Yaşadığı yer (Kufe)",
    ),

    // 1️⃣3️⃣ EBÛ BEKİR ER-RÂZÎ – Rey
    BilimInsaniKonum(
      id: "ebu_bekir_razi_dogum",
      isim: "Ebû Bekir er-Râzî",
      kisaBilgi:
          "Tıp ve kimya alanında önemli çalışmalar yapmıştır. Rey şehrinde doğmuştur.",
      latitude: 35.6000,
      longitude: 51.4400,
      tur: "Doğum yeri (Rey)",
    ),

    // 1️⃣4️⃣ HAREZMÎ – Harezm bölgesi
    BilimInsaniKonum(
      id: "harezmi_dogum",
      isim: "Harezmi",
      kisaBilgi:
          "Cebirin kurucularındandır, sayı sistemleri üzerine çalışmıştır. Harezm bölgesinde doğmuştur.",
      latitude: 41.5500,
      longitude: 60.6300,
      tur: "Doğum yeri (Harezm)",
    ),

    // 1️⃣5️⃣ ÖMER HAYYAM – Nişabur
    BilimInsaniKonum(
      id: "omer_hayyam_dogum",
      isim: "Ömer Hayyam",
      kisaBilgi:
          "Şair, matematikçi ve astronomdur. Nişabur’da doğmuştur.",
      latitude: 36.2140,
      longitude: 58.7960,
      tur: "Doğum yeri (Nişabur)",
    ),

    // 1️⃣6️⃣ EBÛL-KASIM ZEHRÂVÎ – Kurtuba
    BilimInsaniKonum(
      id: "zehravi_dogum",
      isim: "Ebü’l-Kasım Zehravî",
      kisaBilgi:
          "Cerrahinin öncülerinden sayılır, ameliyat aletleri geliştirmiştir.",
      latitude: 37.8882,
      longitude: -4.7794,
      tur: "Doğum/Çalışma (Endülüs, Kurtuba)",
    ),

    // 1️⃣7️⃣ İBN NEFİS – Şam
    BilimInsaniKonum(
      id: "ibn_nefis_calisma",
      isim: "İbn Nefis",
      kisaBilgi:
          "Küçük kan dolaşımını keşfetmesiyle tanınan bir tıp alimidir. Şam’da doğmuş, Kahire’de çalışmıştır.",
      latitude: 33.5138,
      longitude: 36.2765,
      tur: "Doğum yeri (Şam)",
    ),
  ];

  /// Marker setini oluşturan fonksiyon
  Set<Marker> _buildMarkers() {
    return konumlar.map((k) {
      return Marker(
        markerId: MarkerId(k.id),
        position: LatLng(k.latitude, k.longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueViolet,
        ),
        onTap: () => _showBilimInsaniCard(k),
        infoWindow: InfoWindow(
          title: "🧠 ${k.isim}",
          snippet: k.tur,
        ),
      );
    }).toSet();
  }

  /// Marker'a tıklayınca açılan alt kart (BottomSheet)
  void _showBilimInsaniCard(BilimInsaniKonum k) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Text(
                "🧠 ${k.isim}",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                k.tur,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                k.kisaBilgi,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 12),
              // 👇 Burada artık "Daha fazlasını gör" butonu YOK
            ],
          ),
        );
      },
    );
  }

  /// 6️⃣ Ekranın genel tasarımı
  @override
  Widget build(BuildContext context) {
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
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                const Text(
                  "Bilim İnsanları Haritası 🌍",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  "Haritada dolaş, bilim insanlarının doğduğu ve çalıştığı yerleri keşfet!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: GoogleMap(
                      initialCameraPosition: const CameraPosition(
                        target: LatLng(39.0, 35.0), // Türkiye civarı
                        zoom: 4.5,
                      ),
                      markers: _buildMarkers(),
                      onMapCreated: (controller) {
                        _mapController = controller;
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
